Return-Path: <linux-kernel-owner+w=401wt.eu-S1761243AbXHUAi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243AbXHUAi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 20:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbXHUAir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 20:38:47 -0400
Received: from mail.queued.net ([207.210.101.209]:2596 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbXHUAiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 20:38:46 -0400
Date: Mon, 20 Aug 2007 20:40:20 -0400
From: Andres Salomon <dilinger@queued.net>
To: kbuild-devel@lists.sourceforge.net
Cc: akpm@linux-foundation.org, zippel@linux-m68k.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] kconfig: add *_silentdefconfig feature for config targets
Message-Id: <20070820204020.7cde776e.dilinger@queued.net>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Being able to run 'silentoldconfig' with an existing .config has been
immensely useful, especially for automated builds.  If the kernel code
changes in an incompatible manner without the associated .config being
updated, the build will fail and call attention to the need for an update.

AFAICT, there is nothing similar when using *_defconfig; one must copy
a .config manually, and then run silentoldconfig.  Simply running the
associated _defconfig will quietly update the config (which may silently
drop config options).  This patch adds a *_silentdefconfig target, with
semantics similar to silentoldconfig.  It will take the defconfig from
arch/$(ARCH)/configs/$x_defconfig, check for changes, and if there are
none, write out a .config.  If there have been changes and stdin is
valid, it will prompt for updates.  If there have been changes and
stdin is not valid, it will bail out with an error.

A few things to note:
  - Using getopt() in scripts/kconfig/conf.c would likely simplify things,
    but that's a much larger patch.  Is there a reason we don't use it?
  - To make it truly silent, I had to change conf_write() to accept an
    additional arg.  The alternative is to not have conf_write spit out
    any information when it writes a file.  Personally, I don't see the need
    for it to spit out information, but I figured I'd take the more cautious
    route.  If folks don't care, I can update this patch to remove it.
  - We seem to switch between using _() and not using it for strings; I'm
    assuming that we don't actually care about i18n in conf.c, and that the
    _() stuff was just copied from elsewhere.  If that's not the case, I
    can update the patch to wrap strings properly.

Comments/suggestions/critique welcome.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---

 Makefile                    |    2 ++
 scripts/kconfig/Makefile    |    3 +++
 scripts/kconfig/conf.c      |   40 +++++++++++++++++++++++++++++++++-------
 scripts/kconfig/confdata.c  |    9 +++++----
 scripts/kconfig/gconf.c     |    4 ++--
 scripts/kconfig/lkc_proto.h |    2 +-
 scripts/kconfig/mconf.c     |    4 ++--
 scripts/kconfig/qconf.cc    |    6 +++---
 8 files changed, 51 insertions(+), 19 deletions(-)

diff --git a/Makefile b/Makefile
index 91759a6..d4b35f7 100644
--- a/Makefile
+++ b/Makefile
@@ -1164,6 +1164,8 @@ help:
 	@$(if $(boards), \
 		$(foreach b, $(boards), \
 		printf "  %-24s - Build for %s\\n" $(b) $(subst _defconfig,,$(b));) \
+		$(foreach b, $(boards), \
+		printf "  %-24s - Quiet build for %s\\n" $(subst _defconfig,_silentdefconfig,$(b)) $(subst _defconfig,,$(b));) \
 		echo '')
 
 	@echo  '  make V=0|1 [targets] 0 => quiet build (default), 1 => verbose build'
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 8986a48..44845bd 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -67,6 +67,9 @@ endif
 %_defconfig: $(obj)/conf
 	$(Q)$< -D arch/$(ARCH)/configs/$@ arch/$(ARCH)/Kconfig
 
+%_silentdefconfig: $(obj)/conf
+	$(Q)$< -S arch/$(ARCH)/configs/$(subst _silentdefconfig,_defconfig,$@) arch/$(ARCH)/Kconfig
+
 # Help text used by make help
 help:
 	@echo  '  config	  - Update current config utilising a line-oriented program'
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 8be6a42..fecf5f8 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -22,6 +22,7 @@ enum {
 	ask_new,
 	ask_silent,
 	set_default,
+	set_silentdefault,
 	set_yes,
 	set_mod,
 	set_no,
@@ -64,10 +65,11 @@ static void strip(char *str)
 
 static void check_stdin(void)
 {
-	if (!valid_stdin && input_mode == ask_silent) {
+	if (!valid_stdin && (input_mode == ask_silent ||
+			input_mode == set_silentdefault)) {
 		printf(_("aborted!\n\n"));
 		printf(_("Console input/output is redirected. "));
-		printf(_("Run 'make oldconfig' to update configuration.\n\n"));
+		printf(_("Configuration file needs to be updated.\n\n"));
 		exit(1);
 	}
 }
@@ -102,6 +104,7 @@ static void conf_askvalue(struct symbol *sym, const char *def)
 		break;
 	case ask_new:
 	case ask_silent:
+	case set_silentdefault:
 		if (sym_has_value(sym)) {
 			printf("%s\n", def);
 			return;
@@ -349,6 +352,7 @@ static int conf_choice(struct menu *menu)
 		switch (input_mode) {
 		case ask_new:
 		case ask_silent:
+		case set_silentdefault:
 			if (!is_new) {
 				cnt = def;
 				printf("%d\n", cnt);
@@ -420,7 +424,9 @@ static void conf(struct menu *menu)
 
 		switch (prop->type) {
 		case P_MENU:
-			if (input_mode == ask_silent && rootEntry != menu) {
+			if ((input_mode == ask_silent ||
+					input_mode == set_silentdefault) &&
+					rootEntry != menu) {
 				check_conf(menu);
 				return;
 			}
@@ -504,6 +510,16 @@ int main(int ac, char **av)
 			input_mode = ask_silent;
 			valid_stdin = isatty(0) && isatty(1) && isatty(2);
 			break;
+		case 'S':
+			input_mode = set_silentdefault;
+			valid_stdin = isatty(0) && isatty(1) && isatty(2);
+			defconfig_file = av[i++];
+			if (!defconfig_file) {
+				printf("%s: No default config file specified\n",
+					av[0]);
+				exit(1);
+			}
+			break;
 		case 'd':
 			input_mode = set_default;
 			break;
@@ -553,6 +569,14 @@ int main(int ac, char **av)
 			exit(1);
 		}
 		break;
+	case set_silentdefault:
+		if (conf_read(defconfig_file)) {
+			printf("***\n"
+				"*** Can't find default configuration \"%s\"!\n"
+				"***\n", defconfig_file);
+			exit(1);
+		}
+		break;
 	case ask_silent:
 		if (stat(".config", &tmpstat)) {
 			printf(_("***\n"
@@ -593,7 +617,7 @@ int main(int ac, char **av)
 		break;
 	}
 
-	if (input_mode != ask_silent) {
+	if (input_mode != ask_silent && input_mode != set_silentdefault) {
 		rootEntry = &rootmenu;
 		conf(&rootmenu);
 		if (input_mode == ask_all) {
@@ -606,19 +630,21 @@ int main(int ac, char **av)
 			fprintf(stderr, _("\n*** Kernel configuration requires explicit update.\n\n"));
 			return 1;
 		}
-	} else
+	} else if (input_mode != set_silentdefault)
 		goto skip_check;
 
 	do {
 		conf_cnt = 0;
 		check_conf(&rootmenu);
 	} while (conf_cnt);
-	if (conf_write(NULL)) {
+	if (conf_write(NULL, input_mode == ask_silent ||
+			input_mode == set_silentdefault)) {
 		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
 		return 1;
 	}
 skip_check:
-	if (input_mode == ask_silent && conf_write_autoconf()) {
+	if ((input_mode == ask_silent || input_mode == set_silentdefault) &&
+			conf_write_autoconf()) {
 		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
 		return 1;
 	}
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index b2913e9..5d80e85 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -384,7 +384,7 @@ int conf_read(const char *name)
 	return 0;
 }
 
-int conf_write(const char *name)
+int conf_write(const char *name, int quiet)
 {
 	FILE *out;
 	struct symbol *sym;
@@ -539,9 +539,10 @@ int conf_write(const char *name)
 			return 1;
 	}
 
-	printf(_("#\n"
-		 "# configuration written to %s\n"
-		 "#\n"), newname);
+	if (!quiet)
+		printf("#\n"
+			"# configuration written to %s\n"
+			"#\n", newname);
 
 	sym_set_change_count(0);
 
diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 262908c..6b883dd 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -621,7 +621,7 @@ void on_load1_activate(GtkMenuItem * menuitem, gpointer user_data)
 
 void on_save_activate(GtkMenuItem * menuitem, gpointer user_data)
 {
-	if (conf_write(NULL))
+	if (conf_write(NULL, 0))
 		text_insert_msg(_("Error"), _("Unable to save configuration !"));
 }
 
@@ -634,7 +634,7 @@ store_filename(GtkFileSelection * file_selector, gpointer user_data)
 	fn = gtk_file_selection_get_filename(GTK_FILE_SELECTION
 					     (user_data));
 
-	if (conf_write(fn))
+	if (conf_write(fn, 0))
 		text_insert_msg(_("Error"), _("Unable to save configuration !"));
 
 	gtk_widget_destroy(GTK_WIDGET(user_data));
diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
index 4d09f6d..be29e28 100644
--- a/scripts/kconfig/lkc_proto.h
+++ b/scripts/kconfig/lkc_proto.h
@@ -3,7 +3,7 @@
 P(conf_parse,void,(const char *name));
 P(conf_read,int,(const char *name));
 P(conf_read_simple,int,(const char *name, int));
-P(conf_write,int,(const char *name));
+P(conf_write,int,(const char *name, int));
 P(conf_write_autoconf,int,(void));
 P(conf_get_changed,bool,(void));
 P(conf_set_changed_callback, void,(void (*fn)(void)));
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index bc5854e..1f67b18 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -869,7 +869,7 @@ static void conf_save(void)
 		case 0:
 			if (!dialog_input_result[0])
 				return;
-			if (!conf_write(dialog_input_result)) {
+			if (!conf_write(dialog_input_result, 0)) {
 				set_config_filename(dialog_input_result);
 				return;
 			}
@@ -929,7 +929,7 @@ int main(int ac, char **av)
 
 	switch (res) {
 	case 0:
-		if (conf_write(filename)) {
+		if (conf_write(filename, 0)) {
 			fprintf(stderr, _("\n\n"
 				"Error during writing of the kernel configuration.\n"
 				"Your kernel configuration changes were NOT saved."
diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index e4eeb59..22f3278 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1454,7 +1454,7 @@ void ConfigMainWindow::loadConfig(void)
 
 void ConfigMainWindow::saveConfig(void)
 {
-	if (conf_write(NULL))
+	if (conf_write(NULL, 0))
 		QMessageBox::information(this, "qconf", "Unable to save configuration!");
 }
 
@@ -1463,7 +1463,7 @@ void ConfigMainWindow::saveConfigAs(void)
 	QString s = QFileDialog::getSaveFileName(".config", NULL, this);
 	if (s.isNull())
 		return;
-	if (conf_write(QFile::encodeName(s)))
+	if (conf_write(QFile::encodeName(s), 0))
 		QMessageBox::information(this, "qconf", "Unable to save configuration!");
 }
 
@@ -1615,7 +1615,7 @@ void ConfigMainWindow::closeEvent(QCloseEvent* e)
 	mb.setButtonText(QMessageBox::Cancel, "Cancel Exit");
 	switch (mb.exec()) {
 	case QMessageBox::Yes:
-		conf_write(NULL);
+		conf_write(NULL, 0);
 	case QMessageBox::No:
 		e->accept();
 		break;
