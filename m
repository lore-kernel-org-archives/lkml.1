Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbZITN25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbZITN25 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 09:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbZITN24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 09:28:56 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:60553 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbZITN2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 09:28:55 -0400
Date: Sun, 20 Sep 2009 15:28:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: akpm@linux-foundation.org, Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, mmarek@suse.cz, JBeulich@novell.com,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Feedback on "kbuild: generate modules.builtin"
Message-ID: <20090920132856.GA26845@merkur.ravnborg.org>
References: <200909181949.n8IJnT4R019097@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909181949.n8IJnT4R019097@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 12:49:29PM -0700, akpm@linux-foundation.org wrote:
> From: Michal Marek <mmarek@suse.cz>
> 
> To make it easier for tools like mkinitrd to detect whether a needed
> module is missing or whether it is compiled into the kernel, install a
> modules.builtin file listing all modules built into the kernel.  This is
> done by generating an alternate config file with all tristate =y options
> set to =Y and reading the makefiles with this config included.  The built
> in modules then appear in obj-Y.

Hi Michael.

[Added Steven on cc: as he had done some kconfig
 hacking lately].

Got some time (finally) to look at this.
I understand the functionality and I have myself had the need
to see builtin modules.

As for the implmentation I have a few comments.

General comments:
1) Update to documentation is missing.
   AUTOCONFIG2 needs documentation  (kconfig.txt)
   modules.builtin needs documetnation (kbuild.txt)

   The latter is thin at the moment but thats not
   any excuse.

2) auto2.conf is a full copy of auto.conf with
   a tristate symbols equals 'y' set to 'Y'.
   iI suggest to make it a list of tristate symbols.
   You can then do something like this:
   
      include auto.conf
      y := Y
      include tristate-symbols.conf
      y := y

This make it more general and you do not
have two almost identical files produced.

Some specific comments below.

	Sam


> diff -puN Makefile~kbuild-generate-modulesbuiltin Makefile
> --- a/Makefile~kbuild-generate-modulesbuiltin
> +++ a/Makefile
> @@ -871,6 +871,9 @@ $(sort $(vmlinux-init) $(vmlinux-main)) 
>  PHONY += $(vmlinux-dirs)
>  $(vmlinux-dirs): prepare scripts
>  	$(Q)$(MAKE) $(build)=$@
> +ifdef CONFIG_MODULES
> +	$(Q)$(MAKE) $(modbuiltin)=$@
> +endif

The other stuff we run after a completed build is the
target vmlinux: just above.
If there is no good reason not to do so please move
it so we keep all these post processing steps in one place.


>  	fi
> -	@cp -f $(objtree)/modules.order $(MODLIB)/
> +	@cp -f $(objtree)/modules.{order,builtin} $(MODLIB)/
I assume this works with any shell?

> diff -puN scripts/Makefile.lib~kbuild-generate-modulesbuiltin scripts/Makefile.lib
> --- a/scripts/Makefile.lib~kbuild-generate-modulesbuiltin
> +++ a/scripts/Makefile.lib
> @@ -37,6 +37,8 @@ modorder	:= $(patsubst %/,%/modules.orde
>  
>  __subdir-y	:= $(patsubst %/,%,$(filter %/, $(obj-y)))
>  subdir-y	+= $(__subdir-y)
> +__subdir-Y	:= $(patsubst %/,%,$(filter %/, $(obj-Y)))
> +subdir-Y	+= $(__subdir-Y)

This is only used by Makefile.modbuiltin - move it there.

>  __subdir-m	:= $(patsubst %/,%,$(filter %/, $(obj-m)))
>  subdir-m	+= $(__subdir-m)
>  obj-y		:= $(patsubst %/, %/built-in.o, $(obj-y))
> @@ -44,7 +46,7 @@ obj-m		:= $(filter-out %/, $(obj-m))
>  
>  # Subdirectories we need to descend into
>  
> -subdir-ym	:= $(sort $(subdir-y) $(subdir-m))
> +subdir-ym	:= $(sort $(subdir-y) $(subdir-Y) $(subdir-m))
>  
This is only used by Makefile.modbuiltin - move it there.

(Makefile.lib is messy and need so love one day. No need to add
more to the mess).

>  # if $(foo-objs) exists, foo.o is a composite object 
>  multi-used-y := $(sort $(foreach m,$(obj-y), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y))), $(m))))
> @@ -76,6 +78,7 @@ always		:= $(addprefix $(obj)/,$(always)
>  targets		:= $(addprefix $(obj)/,$(targets))
>  modorder	:= $(addprefix $(obj)/,$(modorder))
>  obj-y		:= $(addprefix $(obj)/,$(obj-y))
> +obj-Y		:= $(addprefix $(obj)/,$(obj-Y))

ditto.

>  obj-m		:= $(addprefix $(obj)/,$(obj-m))
>  lib-y		:= $(addprefix $(obj)/,$(lib-y))
>  subdir-obj-y	:= $(addprefix $(obj)/,$(subdir-obj-y))
> diff -puN /dev/null scripts/Makefile.modbuiltin
> --- /dev/null
> +++ a/scripts/Makefile.modbuiltin
> @@ -0,0 +1,48 @@
> +# ==========================================================================
> +# Generating modules.builtin
> +# ==========================================================================
> +
> +src := $(obj)
> +
> +PHONY := __modbuiltin
> +__modbuiltin:
> +
> +# Read auto2.conf which sets tristate variables to 'Y' instead of 'y'
> +# That way, we get the list of built-in modules in obj-Y
> +-include include/config/auto2.conf
> +
> +include scripts/Kbuild.include
> +
> +# The filename Kbuild has precedence over Makefile
> +kbuild-dir := $(if $(filter /%,$(src)),$(src),$(srctree)/$(src))
> +kbuild-file := $(if $(wildcard $(kbuild-dir)/Kbuild),$(kbuild-dir)/Kbuild,$(kbuild-dir)/Makefile)
> +include $(kbuild-file)
> +
> +include scripts/Makefile.lib
> +
> +modbuiltin-subdirs := $(patsubst %,%/modules.builtin, $(subdir-ym))
> +modbuiltin-mods    := $(filter %.ko, $(obj-Y:.o=.ko))
> +modbuiltin-target  := $(obj)/modules.builtin
> +
> +__modbuiltin: $(modbuiltin-target) $(subdir-ym)
> +	@:
> +
> +modbuiltin-cmds =						\
> +	for m in $(modbuiltin-mods); do echo kernel/$$m; done;	\
> +	cat /dev/null $(modbuiltin-subdirs);
> +
> +$(modbuiltin-target): $(subdir-ym)
> +	$(Q)($(modbuiltin-cmds)) > $@

As Jan aleady noted in a follow-up patch "FORCE" is missing.


> +
> +# Descending
> +# ---------------------------------------------------------------------------
> +
> +PHONY += $(subdir-ym)
> +$(subdir-ym):
> +	$(Q)$(MAKE) $(modbuiltin)=$@
> +
> +
> +# Declare the contents of the .PHONY variable as phony.  We keep that
> +# information in a variable se we can use it in if_changed and friends.
> +
> +.PHONY: $(PHONY)

Well - except that I do not see any of these used.
Keep like the above as this is what we do in other places.

> diff -puN scripts/kconfig/confdata.c~kbuild-generate-modulesbuiltin scripts/kconfig/confdata.c
> --- a/scripts/kconfig/confdata.c~kbuild-generate-modulesbuiltin
> +++ a/scripts/kconfig/confdata.c
> @@ -672,12 +672,27 @@ out:
>  	return res;
>  }
>  
> +int fprintf2(FILE *f1, FILE *f2, const char *fmt, ...)
> +{
> +	va_list ap;
> +	int res;
> +
> +	va_start(ap, fmt);
> +	vfprintf(f1, fmt, ap);
> +	va_end(ap);
> +	va_start(ap, fmt);
> +	res = vfprintf(f2, fmt, ap);
> +	va_end(ap);
> +
> +	return res;
> +}
> +
>  int conf_write_autoconf(void)
>  {
>  	struct symbol *sym;
>  	const char *str;
>  	const char *name;
> -	FILE *out, *out_h;
> +	FILE *out, *out2, *out_h;
>  	time_t now;
>  	int i, l;
>  
> @@ -692,16 +707,23 @@ int conf_write_autoconf(void)
>  	if (!out)
>  		return 1;
>  
> +	out2 = fopen(".tmpconfig2", "w");
> +	if (!out2) {
> +		fclose(out);
> +		return 1;
> +	}
> +
>  	out_h = fopen(".tmpconfig.h", "w");
>  	if (!out_h) {
>  		fclose(out);
> +		fclose(out2);
>  		return 1;
>  	}
>  
>  	sym = sym_lookup("KERNELVERSION", 0);
>  	sym_calc_value(sym);
>  	time(&now);
> -	fprintf(out, "#\n"
> +	fprintf2(out, out2, "#\n"
>  		     "# Automatically generated make config: don't edit\n"
>  		     "# Linux kernel version: %s\n"
>  		     "# %s"
> @@ -726,45 +748,51 @@ int conf_write_autoconf(void)
>  			case no:
>  				break;
>  			case mod:
> -				fprintf(out, "CONFIG_%s=m\n", sym->name);
> +				fprintf2(out, out2, "CONFIG_%s=m\n",
> +						sym->name);
>  				fprintf(out_h, "#define CONFIG_%s_MODULE 1\n", sym->name);
>  				break;
>  			case yes:
>  				fprintf(out, "CONFIG_%s=y\n", sym->name);
> +				fprintf(out2, "CONFIG_%s=%c\n", sym->name,
> +					sym->type == S_BOOLEAN ? 'y' : 'Y');
>  				fprintf(out_h, "#define CONFIG_%s 1\n", sym->name);
>  				break;
>  			}
>  			break;
>  		case S_STRING:
>  			str = sym_get_string_value(sym);
> -			fprintf(out, "CONFIG_%s=\"", sym->name);
> +			fprintf2(out, out2, "CONFIG_%s=\"", sym->name);
>  			fprintf(out_h, "#define CONFIG_%s \"", sym->name);
>  			while (1) {
>  				l = strcspn(str, "\"\\");
>  				if (l) {
>  					fwrite(str, l, 1, out);
> +					fwrite(str, l, 1, out2);
>  					fwrite(str, l, 1, out_h);
>  					str += l;
>  				}
>  				if (!*str)
>  					break;
> -				fprintf(out, "\\%c", *str);
> +				fprintf2(out, out2, "\\%c", *str);
>  				fprintf(out_h, "\\%c", *str);
>  				str++;
>  			}
>  			fputs("\"\n", out);
> +			fputs("\"\n", out2);
>  			fputs("\"\n", out_h);
>  			break;
>  		case S_HEX:
>  			str = sym_get_string_value(sym);
>  			if (str[0] != '0' || (str[1] != 'x' && str[1] != 'X')) {
> -				fprintf(out, "CONFIG_%s=%s\n", sym->name, str);
> +				fprintf2(out, out2, "CONFIG_%s=%s\n",
> +						sym->name, str);
>  				fprintf(out_h, "#define CONFIG_%s 0x%s\n", sym->name, str);
>  				break;
>  			}
>  		case S_INT:
>  			str = sym_get_string_value(sym);
> -			fprintf(out, "CONFIG_%s=%s\n", sym->name, str);
> +			fprintf2(out, out2, "CONFIG_%s=%s\n", sym->name, str);
>  			fprintf(out_h, "#define CONFIG_%s %s\n", sym->name, str);
>  			break;
>  		default:
> @@ -772,6 +800,7 @@ int conf_write_autoconf(void)
>  		}
>  	}
>  	fclose(out);
> +	fclose(out2);
>  	fclose(out_h);
>  
>  	name = getenv("KCONFIG_AUTOHEADER");
> @@ -779,6 +808,11 @@ int conf_write_autoconf(void)
>  		name = "include/linux/autoconf.h";
>  	if (rename(".tmpconfig.h", name))
>  		return 1;
> +	name = getenv("KCONFIG_AUTOCONFIG2");
> +	if (!name)
> +		name = "include/config/auto2.conf";
> +	if (rename(".tmpconfig2", name))
> +		return 1;
>  	name = conf_get_autoconfig_name();
>  	/*
>  	 * This must be the last step, kbuild has a dependency on auto.conf
> _
> 
