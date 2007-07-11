Return-Path: <linux-kernel-owner+w=401wt.eu-S933901AbXGKTfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbXGKTfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764556AbXGKTWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:22:21 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:51299
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933060AbXGKTWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:22:19 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Start to genericize kconfig for use by other projects.
Date: Wed, 11 Jul 2007 15:22:13 -0400
User-Agent: KMail/1.9.6
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707111522.14240.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rob Landley <rob@landley.net>

Replace name "Linux Kernel" in menuconfig with a macro (defaulting to "Linux
Kernel" if not -Ddefined by the makefile), and remove a few unnecessary
occurrences of "kernel" in pop-up text.
--
This is the start of generally genericizing the kconfig infrastructure so it
builds more easily out of tree for other projects.

Lots of projects are already using menuconfig to configure themselves.  Off
the top of my head, busybox, uClibc, buildroot, uClinux, my toybox project,
and several other things in the embedded space are already using it, plus a
few more like uboot are looking to start.)

Unfortunately, they have to grab a snapshot of the kernel version and apply
various modifications to it to build outside of kbuild, and those
modifications don't get passed back upstream.  The version in the kernel is
the master that everybody periodically resyncs from, but they do a lot of work
each time they resync.

I've collected some of the changes uClibc and busybox made, as well as some
general cleanups I've done for the toybox version, and now I'm trying to feed
them back upstream.  This patch is primarily cosmetic, there are more to come.

Rob

diff -r edfd2d6f670d crypto/Makefile
--- a/crypto/Makefile	Tue Jul 10 17:51:13 2007 -0700
+++ b/crypto/Makefile	Wed Jul 11 15:07:07 2007 -0400
@@ -50,3 +50,4 @@ obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
 
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
+obj-m += randint.o
diff -r edfd2d6f670d scripts/kconfig/conf.c
--- a/scripts/kconfig/conf.c	Tue Jul 10 17:51:13 2007 -0700
+++ b/scripts/kconfig/conf.c	Wed Jul 11 15:07:07 2007 -0400
@@ -557,8 +557,8 @@ int main(int ac, char **av)
 	case ask_silent:
 		if (stat(".config", &tmpstat)) {
 			printf(_("***\n"
-				"*** You have not yet configured your kernel!\n"
-				"*** (missing kernel .config file)\n"
+				"*** You have not yet configured your "PROJECT_NAME"!\n"
+				"*** (missing .config file)\n"
 				"***\n"
 				"*** Please run some configurator (e.g. \"make oldconfig\" or\n"
 				"*** \"make menuconfig\" or \"make xconfig\").\n"
@@ -604,7 +604,7 @@ int main(int ac, char **av)
 	} else if (conf_get_changed()) {
 		name = getenv("KCONFIG_NOSILENTUPDATE");
 		if (name && *name) {
-			fprintf(stderr, _("\n*** Kernel configuration requires explicit update.\n\n"));
+			fprintf(stderr, _("\n*** "PROJECT_NAME" configuration requires explicit update.\n\n"));
 			return 1;
 		}
 	} else
@@ -614,15 +614,13 @@ int main(int ac, char **av)
 		conf_cnt = 0;
 		check_conf(&rootmenu);
 	} while (conf_cnt);
-	if (conf_write(NULL)) {
-		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
-		return 1;
-	}
+	if (!conf_write(NULL)) {
 skip_check:
-	if (input_mode == ask_silent && conf_write_autoconf()) {
-		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
-		return 1;
-	}
-
-	return 0;
-}
+		if (input_mode != ask_silent || conf_write_autoconf()) {
+			return 0;
+		}
+	}
+
+	fprintf(stderr, _("\n*** Error while saving configuration.\n\n"));
+	return 1;
+}
diff -r edfd2d6f670d scripts/kconfig/confdata.c
--- a/scripts/kconfig/confdata.c	Tue Jul 10 17:51:13 2007 -0700
+++ b/scripts/kconfig/confdata.c	Wed Jul 11 15:07:07 2007 -0400
@@ -425,7 +425,7 @@ int conf_write(const char *name)
 
 	fprintf(out, _("#\n"
 		       "# Automatically generated make config: don't edit\n"
-		       "# Linux kernel version: %s\n"
+		       "# "PROJECT_NAME" version: %s\n"
 		       "%s%s"
 		       "#\n"),
 		     sym_get_string_value(sym),
@@ -677,13 +677,13 @@ int conf_write_autoconf(void)
 	time(&now);
 	fprintf(out, "#\n"
 		     "# Automatically generated make config: don't edit\n"
-		     "# Linux kernel version: %s\n"
+		     "# "PROJECT_NAME" version: %s\n"
 		     "# %s"
 		     "#\n",
 		     sym_get_string_value(sym), ctime(&now));
 	fprintf(out_h, "/*\n"
 		       " * Automatically generated C config: don't edit\n"
-		       " * Linux kernel version: %s\n"
+		       " * "PROJECT_NAME" version: %s\n"
 		       " * %s"
 		       " */\n"
 		       "#define AUTOCONF_INCLUDED\n",
diff -r edfd2d6f670d scripts/kconfig/lkc.h
--- a/scripts/kconfig/lkc.h	Tue Jul 10 17:51:13 2007 -0700
+++ b/scripts/kconfig/lkc.h	Wed Jul 11 15:07:07 2007 -0400
@@ -14,6 +14,10 @@
 # define gettext(Msgid) ((const char *) (Msgid))
 # define textdomain(Domainname) ((const char *) (Domainname))
 # define bindtextdomain(Domainname, Dirname) ((const char *) (Dirname))
+#endif
+
+#ifndef PROJECT_NAME
+#define PROJECT_NAME "Linux Kernel"
 #endif
 
 #ifdef __cplusplus
diff -r edfd2d6f670d scripts/kconfig/mconf.c
--- a/scripts/kconfig/mconf.c	Tue Jul 10 17:51:13 2007 -0700
+++ b/scripts/kconfig/mconf.c	Wed Jul 11 15:07:07 2007 -0400
@@ -115,7 +115,7 @@ static const char mconf_readme[] = N_(
 "-----------------------------\n"
 "Menuconfig supports the use of alternate configuration files for\n"
 "those who, for various reasons, find it necessary to switch\n"
-"between different kernel configurations.\n"
+"between different configurations.\n"
 "\n"
 "At the end of the main menu you will find two options.  One is\n"
 "for saving the current configuration to a file of your choosing.\n"
@@ -148,7 +148,7 @@ static const char mconf_readme[] = N_(
 "\n"
 "Optional personality available\n"
 "------------------------------\n"
-"If you prefer to have all of the kernel options listed in a single\n"
+"If you prefer to have all of the options listed in a single\n"
 "menu, rather than the default multimenu hierarchy, run the menuconfig\n"
 "with MENUCONFIG_MODE environment variable set to single_menu. Example:\n"
 "\n"
@@ -200,18 +200,18 @@ setmod_text[] = N_(
 	"This feature depends on another which has been configured as a module.\n"
 	"As a result, this feature will be built as a module."),
 nohelp_text[] = N_(
-	"There is no help available for this kernel option.\n"),
+	"There is no help available for this option.\n"),
 load_config_text[] = N_(
 	"Enter the name of the configuration file you wish to load.  "
 	"Accept the name shown to restore the configuration you "
 	"last retrieved.  Leave blank to abort."),
 load_config_help[] = N_(
 	"\n"
-	"For various reasons, one may wish to keep several different kernel\n"
+	"For various reasons, one may wish to keep several different\n"
 	"configurations available on a single machine.\n"
 	"\n"
 	"If you have saved a previous configuration in a file other than the\n"
-	"kernel's default, entering the name of the file here will allow you\n"
+	"default, entering the name of the file here will allow you\n"
 	"to modify that configuration.\n"
 	"\n"
 	"If you are uncertain, then you have probably never used alternate\n"
@@ -221,7 +221,7 @@ save_config_text[] = N_(
 	"as an alternate.  Leave blank to abort."),
 save_config_help[] = N_(
 	"\n"
-	"For various reasons, one may wish to keep different kernel\n"
+	"For various reasons, one may wish to keep different\n"
 	"configurations available on a single machine.\n"
 	"\n"
 	"Entering a file name here will allow you to later retrieve, modify\n"
@@ -403,7 +403,7 @@ static void set_config_filename(const ch
 	sym = sym_lookup("KERNELVERSION", 0);
 	sym_calc_value(sym);
 	size = snprintf(menu_backtitle, sizeof(menu_backtitle),
-	                _("%s - Linux Kernel v%s Configuration"),
+	                _("%s - "PROJECT_NAME" v%s Configuration"),
 		        config_filename, sym_get_string_value(sym));
 	if (size >= sizeof(menu_backtitle))
 		menu_backtitle[sizeof(menu_backtitle)-1] = '\0';
@@ -912,7 +912,7 @@ int main(int ac, char **av)
 		if (conf_get_changed())
 			res = dialog_yesno(NULL,
 					   _("Do you wish to save your "
-					     "new kernel configuration?\n"
+					     "new configuration?\nPress "
 					     "<ESC><ESC> to continue."),
 					   6, 60);
 		else
@@ -924,20 +924,20 @@ int main(int ac, char **av)
 	case 0:
 		if (conf_write(filename)) {
 			fprintf(stderr, _("\n\n"
-				"Error during writing of the kernel configuration.\n"
-				"Your kernel configuration changes were NOT saved."
+				"Error writing "PROJECT_NAME" configuration.\n"
+				"Your configuration changes were NOT saved."
 				"\n\n"));
 			return 1;
 		}
 	case -1:
 		printf(_("\n\n"
-			"*** End of Linux kernel configuration.\n"
-			"*** Execute 'make' to build the kernel or try 'make help'."
+			"*** End of "PROJECT_NAME" configuration.\n"
+			"*** Execute 'make' to build, or try 'make help'."
 			"\n\n"));
 		break;
 	default:
 		fprintf(stderr, _("\n\n"
-			"Your kernel configuration changes were NOT saved."
+			"Your configuration changes were NOT saved."
 			"\n\n"));
 	}
 
diff -r edfd2d6f670d scripts/kconfig/zconf.tab.c_shipped
--- a/scripts/kconfig/zconf.tab.c_shipped	Tue Jul 10 17:51:13 2007 -0700
+++ b/scripts/kconfig/zconf.tab.c_shipped	Wed Jul 11 15:07:07 2007 -0400
@@ -2115,7 +2115,7 @@ void conf_parse(const char *name)
 	modules_sym = sym_lookup(NULL, 0);
 	modules_sym->type = S_BOOLEAN;
 	modules_sym->flags |= SYMBOL_AUTO;
-	rootmenu.prompt = menu_add_prompt(P_MENU, "Linux Kernel Configuration", NULL);
+	rootmenu.prompt = menu_add_prompt(P_MENU, PROJECT_NAME" Configuration", NULL);
 
 #if YYDEBUG
 	if (getenv("ZCONF_DEBUG"))
diff -r edfd2d6f670d scripts/kconfig/zconf.y
--- a/scripts/kconfig/zconf.y	Tue Jul 10 17:51:13 2007 -0700
+++ b/scripts/kconfig/zconf.y	Wed Jul 11 15:07:07 2007 -0400
@@ -484,7 +484,7 @@ void conf_parse(const char *name)
 	modules_sym = sym_lookup(NULL, 0);
 	modules_sym->type = S_BOOLEAN;
 	modules_sym->flags |= SYMBOL_AUTO;
-	rootmenu.prompt = menu_add_prompt(P_MENU, "Linux Kernel Configuration", NULL);
+	rootmenu.prompt = menu_add_prompt(P_MENU, PROJECT_NAME" Configuration", NULL);
 
 #if YYDEBUG
 	if (getenv("ZCONF_DEBUG"))

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
