Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbXEXGjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbXEXGjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 02:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbXEXGjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 02:39:07 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33042 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbXEXGjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 02:39:06 -0400
Date: Thu, 24 May 2007 08:40:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>, Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, kbuild-devel@lists.sourceforge.net
Subject: Re: [rfe] easier customization of kconfig for non-Linux projects
Message-ID: <20070524064004.GA28923@uranus.ravnborg.org>
References: <200705240117.39800.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705240117.39800.vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike.

Forwarding this to Roman Zippel which is the kconfig maintainer.

The intent with this is clear but the solution you suggest albeit simple
does not really match where we could end up with kconfig.
Recently Roman added support for options in the kconfig language
and I would assume we could deal with most of this just using options.

One example could be to support options for the mainmenu entrye like this:

mainmenu "Busybow config system"
	option project="Busybox"
	option version="$VERSION"   <= Where '$' signify an environment variable

etc etc.

In this way we could later distribute kconfig as a binary instead
of building it into the source as today.

	Sam

On Thu, May 24, 2007 at 01:17:39AM -0400, Mike Frysinger wrote:
> since kconfig is such a nice build system, more projects other than the Linux
> kernel have started to integrate it (like uClibc and busybox) ... it'd be nice
> if it were easier to customize for each project so that when we pull down the
> latest version, we dont have to go through and tweak all of the strings again.
> what do you think of something like the attached patch ?  i doubt i caught all
> the places that'd need to be changed, but this should give a pretty good
> picture of what we'd like to have.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> --- a/scripts/kconfig/lkc_local.h
> +++ b/scripts/kconfig/lkc_local.h
> @@ -0,0 +1,15 @@
> +/*
> + * Customize kconfig to your project.
> + *
> + * Released under the terms of the GNU GPL v2.0.
> + */
> +
> +#ifndef LKC_LOCAL_H
> +#define LKC_LOCAL_H
> +
> +#define PROJECT           "Linux Kernel"
> +#define PROJECT_INFORMAL  "kernel"
> +#define VERSION_SYMBOL    "KERNELVERSION"
> +#define AUTOCONF_DEFINE   "AUTOCONF_INCLUDED"
> +
> +#endif
> diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
> index 1199baf..a5f5102 100644
> --- a/scripts/kconfig/conf.c
> +++ b/scripts/kconfig/conf.c
> @@ -557,8 +557,8 @@ int main(int ac, char **av)
>  	case ask_silent:
>  		if (stat(".config", &tmpstat)) {
>  			printf(_("***\n"
> -				"*** You have not yet configured your kernel!\n"
> -				"*** (missing kernel .config file)\n"
> +				"*** You have not yet configured your " PROJECT_INFORMAL "!\n"
> +				"*** (missing " PROJECT_INFORMAL " .config file)\n"
>  				"***\n"
>  				"*** Please run some configurator (e.g. \"make oldconfig\" or\n"
>  				"*** \"make menuconfig\" or \"make xconfig\").\n"
> @@ -604,7 +604,7 @@ int main(int ac, char **av)
>  	} else if (conf_get_changed()) {
>  		name = getenv("KCONFIG_NOSILENTUPDATE");
>  		if (name && *name) {
> -			fprintf(stderr, _("\n*** Kernel configuration requires explicit update.\n\n"));
> +			fprintf(stderr, _("\n*** " PROJECT " configuration requires explicit update.\n\n"));
>  			return 1;
>  		}
>  	} else
> @@ -615,12 +615,12 @@ int main(int ac, char **av)
>  		check_conf(&rootmenu);
>  	} while (conf_cnt);
>  	if (conf_write(NULL)) {
> -		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
> +		fprintf(stderr, _("\n*** Error during writing of the " PROJECT_INFORMAL " configuration.\n\n"));
>  		return 1;
>  	}
>  skip_check:
>  	if (input_mode == ask_silent && conf_write_autoconf()) {
> -		fprintf(stderr, _("\n*** Error during writing of the kernel configuration.\n\n"));
> +		fprintf(stderr, _("\n*** Error during writing of the " PROJECT_INFORMAL " configuration.\n\n"));
>  		return 1;
>  	}
>  
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index 664fe29..06366ed 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -416,7 +416,7 @@ int conf_write(const char *name)
>  	if (!out)
>  		return 1;
>  
> -	sym = sym_lookup("KERNELVERSION", 0);
> +	sym = sym_lookup(VERSION_SYMBOL, 0);
>  	sym_calc_value(sym);
>  	time(&now);
>  	env = getenv("KCONFIG_NOTIMESTAMP");
> @@ -425,7 +425,7 @@ int conf_write(const char *name)
>  
>  	fprintf(out, _("#\n"
>  		       "# Automatically generated make config: don't edit\n"
> -		       "# Linux kernel version: %s\n"
> +		       "# " PROJECT " version: %s\n"
>  		       "%s%s"
>  		       "#\n"),
>  		     sym_get_string_value(sym),
> @@ -672,21 +672,21 @@ int conf_write_autoconf(void)
>  		return 1;
>  	}
>  
> -	sym = sym_lookup("KERNELVERSION", 0);
> +	sym = sym_lookup(VERSION_SYMBOL, 0);
>  	sym_calc_value(sym);
>  	time(&now);
>  	fprintf(out, "#\n"
>  		     "# Automatically generated make config: don't edit\n"
> -		     "# Linux kernel version: %s\n"
> +		     "# " PROJECT " version: %s\n"
>  		     "# %s"
>  		     "#\n",
>  		     sym_get_string_value(sym), ctime(&now));
>  	fprintf(out_h, "/*\n"
>  		       " * Automatically generated C config: don't edit\n"
> -		       " * Linux kernel version: %s\n"
> +		       " * " PROJECT " version: %s\n"
>  		       " * %s"
>  		       " */\n"
> -		       "#define AUTOCONF_INCLUDED\n",
> +		       "#define " AUTOCONF_DEFINE "\n",
>  		       sym_get_string_value(sym), ctime(&now));
>  
>  	for_all_symbols(i, sym) {
> diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
> index 61d8166..ba62d64 100644
> --- a/scripts/kconfig/gconf.c
> +++ b/scripts/kconfig/gconf.c
> @@ -271,8 +271,8 @@ void init_main_window(const gchar * glade_file)
>  					  /*"style", PANGO_STYLE_OBLIQUE, */
>  					  NULL);
>  
> -	sprintf(title, _("Linux Kernel v%s Configuration"),
> -		getenv("KERNELVERSION"));
> +	sprintf(title, _(PROJECT " v%s Configuration"),
> +		getenv(VERSION_SYMBOL));
>  	gtk_window_set_title(GTK_WINDOW(main_wnd), title);
>  
>  	gtk_widget_show(main_wnd);
> diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
> index 8a07ee4..e694cda 100644
> --- a/scripts/kconfig/lkc.h
> +++ b/scripts/kconfig/lkc.h
> @@ -6,6 +6,8 @@
>  #ifndef LKC_H
>  #define LKC_H
>  
> +#include "lkc_local.h"
> +
>  #include "expr.h"
>  
>  #ifndef KBUILD_NO_NLS
> diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> index d0e4fa5..344f777 100644
> --- a/scripts/kconfig/mconf.c
> +++ b/scripts/kconfig/mconf.c
> @@ -400,10 +400,10 @@ static void set_config_filename(const char *config_filename)
>  	int size;
>  	struct symbol *sym;
>  
> -	sym = sym_lookup("KERNELVERSION", 0);
> +	sym = sym_lookup(VERSION_SYMBOL, 0);
>  	sym_calc_value(sym);
>  	size = snprintf(menu_backtitle, sizeof(menu_backtitle),
> -	                _("%s - Linux Kernel v%s Configuration"),
> +	                _("%s - " PROJECT " v%s Configuration"),
>  		        config_filename, sym_get_string_value(sym));
>  	if (size >= sizeof(menu_backtitle))
>  		menu_backtitle[sizeof(menu_backtitle)-1] = '\0';
> @@ -931,8 +931,8 @@ int main(int ac, char **av)
>  		}
>  	case -1:
>  		printf(_("\n\n"
> -			"*** End of Linux kernel configuration.\n"
> -			"*** Execute 'make' to build the kernel or try 'make help'."
> +			"*** End of " PROJECT " configuration.\n"
> +			"*** Execute 'make' to build the " PROJECT_INFORMAL " or try 'make help'."
>  			"\n\n"));
>  		break;
>  	default:
> diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
> index c35dcc5..004b7df 100644
> --- a/scripts/kconfig/symbol.c
> +++ b/scripts/kconfig/symbol.c
> @@ -61,10 +61,10 @@ void sym_init(void)
>  	if (p)
>  		sym_add_default(sym, p);
>  
> -	sym = sym_lookup("KERNELVERSION", 0);
> +	sym = sym_lookup(VERSION_SYMBOL, 0);
>  	sym->type = S_STRING;
>  	sym->flags |= SYMBOL_AUTO;
> -	p = getenv("KERNELVERSION");
> +	p = getenv(VERSION_SYMBOL);
>  	if (p)
>  		sym_add_default(sym, p);
>  
