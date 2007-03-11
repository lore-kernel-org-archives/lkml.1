Return-Path: <linux-kernel-owner+w=401wt.eu-S932569AbXCKTuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbXCKTuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932704AbXCKTuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:50:10 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33259 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932569AbXCKTuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:50:08 -0400
Date: Sun, 11 Mar 2007 20:50:33 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
Message-ID: <20070311195033.GA3302@uranus.ravnborg.org>
References: <20070310160614.GB10230@cvg> <Pine.LNX.4.61.0703101724160.8799@yvahk01.tjqt.qr> <20070310194617.2aef1006@localhost> <Pine.LNX.4.61.0703101747530.8799@yvahk01.tjqt.qr> <20070310175058.GA19878@cvg> <Pine.LNX.4.61.0703101906070.8799@yvahk01.tjqt.qr> <20070310212730.GA2577@uranus.ravnborg.org> <Pine.LNX.4.61.0703102234210.26332@yvahk01.tjqt.qr> <20070310224534.GA3150@uranus.ravnborg.org> <20070311100723.GA10359@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311100723.GA10359@cvg>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2007 at 01:07:23PM +0300, Cyrill Gorcunov wrote:
> [Sam Ravnborg - Sat, Mar 10, 2007 at 11:45:34PM +0100]
> | On Sat, Mar 10, 2007 at 10:34:41PM +0100, Jan Engelhardt wrote:
> | > 
> | > On Mar 10 2007 22:27, Sam Ravnborg wrote:
> | > >On Sat, Mar 10, 2007 at 07:23:41PM +0100, Jan Engelhardt wrote:
> | > >> 
> | > >> Whether the 'working config file path' should change when you do
> | > >> 'Save as Alternate' or not, is a menuconfig axiom. Ask Sam Ravnborg
> | > >> if you want it changed :-)
> | > >
> | > >Current behaviour is not logical but on the other hand I do not
> | > >see a big need to make it so.
> | > >It seems that people very seldom uses "save alternate" anyway.
> | > >
> | > >But patches are welcome.
> | > 
> | > ^_^ The patch has already been posted, has not it?
> | No.
> | Either we keep current behaviour or we change to the "normal"
> | behaviour with a "Save as..." as know from all other programs.
> | 
> | 	Sam
> | 
> 
> Hi Sam,
> 
> here is a patch for menuconfig that shows current configuration
> file. So I think menuconfig does its work well but the only
> thing we need is to show location of an _active_ configuration.
> 
> Any comments are welcome (and you may swear at me too :)
I would rather avoid adding the extra lines. In the
'office-suite' fashion I have cooked up a patch that specify
the filename as part of the windows title.

To make the conversion we should consider renaming from
current "Load alternate" to "Open config file..."
and likewise "Save alternate" to "Save config file as..."

Comments?

	Sam

diff --git a/scripts/kconfig/lxdialog/dialog.h b/scripts/kconfig/lxdialog/dialog.h
index fd695e1..7e17eba 100644
--- a/scripts/kconfig/lxdialog/dialog.h
+++ b/scripts/kconfig/lxdialog/dialog.h
@@ -188,6 +188,7 @@ int on_key_esc(WINDOW *win);
 int on_key_resize(void);
 
 void init_dialog(const char *backtitle);
+void set_dialog_backtitle(const char *backtitle);
 void reset_dialog(void);
 void end_dialog(void);
 void attr_clear(WINDOW * win, int height, int width, chtype attr);
diff --git a/scripts/kconfig/lxdialog/util.c b/scripts/kconfig/lxdialog/util.c
index d54440f..549373b 100644
--- a/scripts/kconfig/lxdialog/util.c
+++ b/scripts/kconfig/lxdialog/util.c
@@ -272,6 +272,11 @@ void init_dialog(const char *backtitle)
 	color_setup(getenv("MENUCONFIG_COLOR"));
 }
 
+void set_dialog_backtitle(const char *backtitle)
+{
+	dlg.backtitle = backtitle;
+}
+
 void reset_dialog(void)
 {
 	initscr();		/* Init curses */
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 3f9a132..327fc9a 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -26,7 +26,6 @@
 #include "lkc.h"
 #include "lxdialog/dialog.h"
 
-static char menu_backtitle[128];
 static const char mconf_readme[] = N_(
 "Overview\n"
 "--------\n"
@@ -271,7 +270,6 @@ search_help[] = N_(
 	"          USB$ => find all CONFIG_ symbols ending with USB\n"
 	"\n");
 
-static char filename[PATH_MAX+1] = ".config";
 static int indent;
 static struct termios ios_org;
 static int rows = 0, cols = 0;
@@ -395,6 +393,28 @@ static struct gstr get_relations_str(struct symbol **sym_arr)
 	return res;
 }
 
+static char filename[PATH_MAX+1];
+static void set_config_filename(const char *config_filename)
+{
+	static char menu_backtitle[128];
+	int size;
+	struct symbol *sym;
+
+	sym = sym_lookup("KERNELVERSION", 0);
+	sym_calc_value(sym);
+	size = snprintf(menu_backtitle, sizeof(menu_backtitle),
+	                _("%s - Linux Kernel v%s Configuration"),
+		        config_filename, sym_get_string_value(sym));
+	if (size >= sizeof(menu_backtitle))
+		menu_backtitle[sizeof(menu_backtitle)-1] = '\0';
+	set_dialog_backtitle(menu_backtitle);
+
+	size = snprintf(filename, sizeof(filename), "%s", config_filename);
+	if (size >= sizeof(filename))
+		filename[sizeof(filename)-1] = '\0';
+}
+
+
 static void search_conf(void)
 {
 	struct symbol **sym_arr;
@@ -816,8 +836,10 @@ static void conf_load(void)
 		case 0:
 			if (!dialog_input_result[0])
 				return;
-			if (!conf_read(dialog_input_result))
+			if (!conf_read(dialog_input_result)) {
+				set_config_filename(dialog_input_result);
 				return;
+			}
 			show_textbox(NULL, _("File does not exist!"), 5, 38);
 			break;
 		case 1:
@@ -840,8 +862,10 @@ static void conf_save(void)
 		case 0:
 			if (!dialog_input_result[0])
 				return;
-			if (!conf_write(dialog_input_result))
+			if (!conf_write(dialog_input_result)) {
+				set_config_filename(dialog_input_result);
 				return;
+			}
 			show_textbox(NULL, _("Can't create file!  Probably a nonexistent directory."), 5, 60);
 			break;
 		case 1:
@@ -860,7 +884,6 @@ static void conf_cleanup(void)
 
 int main(int ac, char **av)
 {
-	struct symbol *sym;
 	char *mode;
 	int res;
 
@@ -871,11 +894,6 @@ int main(int ac, char **av)
 	conf_parse(av[1]);
 	conf_read(NULL);
 
-	sym = sym_lookup("KERNELVERSION", 0);
-	sym_calc_value(sym);
-	sprintf(menu_backtitle, _("Linux Kernel v%s Configuration"),
-		sym_get_string_value(sym));
-
 	mode = getenv("MENUCONFIG_MODE");
 	if (mode) {
 		if (!strcasecmp(mode, "single_menu"))
@@ -886,7 +904,8 @@ int main(int ac, char **av)
 	atexit(conf_cleanup);
 	init_wsize();
 	reset_dialog();
-	init_dialog(menu_backtitle);
+	init_dialog(NULL);
+	set_config_filename(".config");
 	do {
 		conf(&rootmenu);
 		dialog_clear();
@@ -903,7 +922,7 @@ int main(int ac, char **av)
 
 	switch (res) {
 	case 0:
-		if (conf_write(NULL)) {
+		if (conf_write(filename)) {
 			fprintf(stderr, _("\n\n"
 				"Error during writing of the kernel configuration.\n"
 				"Your kernel configuration changes were NOT saved."
