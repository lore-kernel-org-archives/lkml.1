Return-Path: <linux-kernel-owner+w=401wt.eu-S933587AbXGLSod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587AbXGLSod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 14:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbXGLSoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 14:44:23 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:37919
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756594AbXGLSoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 14:44:21 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] Start to genericize kconfig for use by other projects.
Date: Thu, 12 Jul 2007 14:44:18 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
References: <200707111522.14240.rob@landley.net> <Pine.LNX.4.64.0707121820110.1817@scrub.home>
In-Reply-To: <Pine.LNX.4.64.0707121820110.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707121444.18599.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 July 2007 12:28:39 pm Roman Zippel wrote:
> Hi,
>
> On Wed, 11 Jul 2007, Rob Landley wrote:
> > Replace name "Linux Kernel" in menuconfig with a macro (defaulting to
> > "Linux Kernel" if not -Ddefined by the makefile), and remove a few
> > unnecessary occurrences of "kernel" in pop-up text.
>
> Could you drop the PROJECT_NAME changes for now? The rest looks fine.
> I would prefer if the project would be settable via Kconfig.

Are projects likely to grab a common kconfig binary externally, rather
than build their own?  Where exactly is the benefit, here?

> If you want to play with it add this to Kconfig:
>
> config PROJECT_NAME
> 	string
> 	default "Linux kernel"
>
> and at the end of conf_parse() you can lookup, calculate and cache the
> value.

Except that conf_parse() uses PROJECT_NAME halfway through.
How do I handle that one?

Here's a patch with all the uses of PROJECT_NAME converted to
project_name, and with all the ones but the conf_parse() one
converted to an %s with project-name in the printf argument list. 

If you know how to fix up conf_parse(), the #define can be yanked from
lkc.h and replaced with a global variable...

diff -r edfd2d6f670d scripts/kconfig/conf.c
--- a/scripts/kconfig/conf.c	Tue Jul 10 17:51:13 2007 -0700
+++ b/scripts/kconfig/conf.c	Thu Jul 12 14:39:30 2007 -0400
@@ -557,12 +557,12 @@ int main(int ac, char **av)
 	case ask_silent:
 		if (stat(".config", &tmpstat)) {
 			printf(_("***\n"
-				"*** You have not yet configured your kernel!\n"
-				"*** (missing kernel .config file)\n"
+				"*** You have not yet configured your %s!\n"
+				"*** (missing .config file)\n"
 				"***\n"
 				"*** Please run some configurator (e.g. \"make oldconfig\" or\n"
 				"*** \"make menuconfig\" or \"make xconfig\").\n"
-				"***\n"));
+				"***\n"), project_name);
 			exit(1);
 		}
 	case ask_all:
@@ -604,7 +604,7 @@ int main(int ac, char **av)
 	} else if (conf_get_changed()) {
 		name = getenv("KCONFIG_NOSILENTUPDATE");
 		if (name && *name) {
-			fprintf(stderr, _("\n*** Kernel configuration requires explicit update.\n\n"));
+			fprintf(stderr, _("\n*** %s configuration requires explicit update.\n\n"), project_name);
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
+++ b/scripts/kconfig/confdata.c	Thu Jul 12 14:39:30 2007 -0400
@@ -425,9 +425,10 @@ int conf_write(const char *name)
 
 	fprintf(out, _("#\n"
 		       "# Automatically generated make config: don't edit\n"
-		       "# Linux kernel version: %s\n"
+		       "# %s version: %s\n"
 		       "%s%s"
 		       "#\n"),
+		     project_name,
 		     sym_get_string_value(sym),
 		     use_timestamp ? "# " : "",
 		     use_timestamp ? ctime(&now) : "");
@@ -677,17 +678,17 @@ int conf_write_autoconf(void)
 	time(&now);
 	fprintf(out, "#\n"
 		     "# Automatically generated make config: don't edit\n"
-		     "# Linux kernel version: %s\n"
+		     "# %s version: %s\n"
 		     "# %s"
 		     "#\n",
-		     sym_get_string_value(sym), ctime(&now));
+		     project_name, sym_get_string_value(sym), ctime(&now));
 	fprintf(out_h, "/*\n"
 		       " * Automatically generated C config: don't edit\n"
-		       " * Linux kernel version: %s\n"
+		       " * %s version: %s\n"
 		       " * %s"
 		       " */\n"
 		       "#define AUTOCONF_INCLUDED\n",
-		       sym_get_string_value(sym), ctime(&now));
+		       project_name, sym_get_string_value(sym), ctime(&now));
 
 	for_all_symbols(i, sym) {
 		sym_calc_value(sym);
diff -r edfd2d6f670d scripts/kconfig/lkc.h
--- a/scripts/kconfig/lkc.h	Tue Jul 10 17:51:13 2007 -0700
+++ b/scripts/kconfig/lkc.h	Thu Jul 12 14:39:30 2007 -0400
@@ -14,6 +14,10 @@
 # define gettext(Msgid) ((const char *) (Msgid))
 # define textdomain(Domainname) ((const char *) (Domainname))
 # define bindtextdomain(Domainname, Dirname) ((const char *) (Dirname))
+#endif
+
+#ifndef project_name
+#define project_name "Linux Kernel"
 #endif
 
 #ifdef __cplusplus
diff -r edfd2d6f670d scripts/kconfig/mconf.c
--- a/scripts/kconfig/mconf.c	Tue Jul 10 17:51:13 2007 -0700
+++ b/scripts/kconfig/mconf.c	Thu Jul 12 14:39:30 2007 -0400
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
@@ -403,8 +403,8 @@ static void set_config_filename(const ch
 	sym = sym_lookup("KERNELVERSION", 0);
 	sym_calc_value(sym);
 	size = snprintf(menu_backtitle, sizeof(menu_backtitle),
-	                _("%s - Linux Kernel v%s Configuration"),
-		        config_filename, sym_get_string_value(sym));
+	                _("%s - %s v%s Configuration"),
+		        config_filename, project_name, sym_get_string_value(sym));
 	if (size >= sizeof(menu_backtitle))
 		menu_backtitle[sizeof(menu_backtitle)-1] = '\0';
 	set_dialog_backtitle(menu_backtitle);
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
-				"\n\n"));
+				"Error writing %s configuration.\n"
+				"Your configuration changes were NOT saved."
+				"\n\n"), project_name);
 			return 1;
 		}
 	case -1:
 		printf(_("\n\n"
-			"*** End of Linux kernel configuration.\n"
-			"*** Execute 'make' to build the kernel or try 'make help'."
-			"\n\n"));
+			"*** End of %s configuration.\n"
+			"*** Execute 'make' to build, or try 'make help'."
+			"\n\n"), project_name);
 		break;
 	default:
 		fprintf(stderr, _("\n\n"
-			"Your kernel configuration changes were NOT saved."
+			"Your configuration changes were NOT saved."
 			"\n\n"));
 	}
 
diff -r edfd2d6f670d scripts/kconfig/zconf.tab.c_shipped
--- a/scripts/kconfig/zconf.tab.c_shipped	Tue Jul 10 17:51:13 2007 -0700
+++ b/scripts/kconfig/zconf.tab.c_shipped	Thu Jul 12 14:39:30 2007 -0400
@@ -2115,7 +2115,7 @@ void conf_parse(const char *name)
 	modules_sym = sym_lookup(NULL, 0);
 	modules_sym->type = S_BOOLEAN;
 	modules_sym->flags |= SYMBOL_AUTO;
-	rootmenu.prompt = menu_add_prompt(P_MENU, "Linux Kernel Configuration", NULL);
+	rootmenu.prompt = menu_add_prompt(P_MENU, project_name" Configuration", NULL);
 
 #if YYDEBUG
 	if (getenv("ZCONF_DEBUG"))
diff -r edfd2d6f670d scripts/kconfig/zconf.y
--- a/scripts/kconfig/zconf.y	Tue Jul 10 17:51:13 2007 -0700
+++ b/scripts/kconfig/zconf.y	Thu Jul 12 14:39:30 2007 -0400
@@ -484,7 +484,7 @@ void conf_parse(const char *name)
 	modules_sym = sym_lookup(NULL, 0);
 	modules_sym->type = S_BOOLEAN;
 	modules_sym->flags |= SYMBOL_AUTO;
-	rootmenu.prompt = menu_add_prompt(P_MENU, "Linux Kernel Configuration", NULL);
+	rootmenu.prompt = menu_add_prompt(P_MENU, project_name" Configuration", NULL);
 
 #if YYDEBUG
 	if (getenv("ZCONF_DEBUG"))


> bye, Roman



-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
