Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbZGOQjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbZGOQjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 12:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932172AbZGOQjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 12:39:09 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:40811 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbZGOQjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 12:39:06 -0400
Subject: Re: [PATCH] kbuild: generate modules.builtin
From: Scott James Remnant <scott@ubuntu.com>
To: Michal Marek <mmarek@suse.cz>, linux-modules@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090703144547.GA20980@sepie.suse.cz>
References: <20090526152540.GA28341@sepie.suse.cz>
	 <20090703144547.GA20980@sepie.suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TGkrf8iHb02+PnoSId4V"
Date: Wed, 15 Jul 2009 17:39:14 +0100
Message-Id: <1247675954.3968.140.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TGkrf8iHb02+PnoSId4V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Still would definitely like - adding linux-modules to the Cc

On Fri, 2009-07-03 at 16:45 +0200, Michal Marek wrote:

> On Tue, May 26, 2009 at 05:25:40PM +0200, Michal Marek wrote:
> > Known issues (found when comparing results with allyesconfig and
> > allmodconfig):
> >  * ALSA makefiles do some substitutions on the CONFIG_*
> >    variables sometimes, which breaks the logic if the alsa modules are
> >    built-in. Patch sent to alsa-devel.
> >  * samples/kobject/*.o could be compiled built-in, but doesn't show up
> >    in modules.builtin (and not even in vmlinux.o). Patch sent to Greg t=
o
> >    make it module-only.
>=20
> These two are merged already.
>=20
>=20
> >  * net/{8021q/vlan_core,ethernet/pe2,ipv6/inet6_hashtables}.o are alway=
s
> >    built-in, even though the corresponding config option is tristate:
> >    obj-$(subst m,y,$(CONFIG_IPX)) +=3D pe2.o
> >    The result is that modules.builtin can contain three built-in
> >    "modules" that can't possibly exist as modules. No fix for this so f=
ar,
> >    as it is not a big issue IMO.
>=20
> I hope this one is not a problem.
>=20
> I rebased the patch on top of current kbuild-next.git. What do you think
> about it? Do you agree on the modules.builtin file name and format? I'd
> like to add support for this to module-init-tools.
>=20
>=20
> Subject: [PATCH] kbuild: generate modules.builtin
>=20
> To make it easier for tools like mkinitrd to detect whether a needed
> module is missing or whether it is compiled into the kernel, install a
> modules.builtin file listing all modules built into the kernel. This is
> done by generating an alternate config file with all tristate =3Dy option=
s
> set to =3DY and reading the makefiles with this config included. The buil=
t
> in modules then appear in obj-Y.
>=20
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  .gitignore                  |    1 +
>  Makefile                    |   14 +++++++++---
>  scripts/Kbuild.include      |    6 +++++
>  scripts/Makefile.lib        |    5 +++-
>  scripts/Makefile.modbuiltin |   48 +++++++++++++++++++++++++++++++++++++=
++++++
>  scripts/kconfig/confdata.c  |   48 ++++++++++++++++++++++++++++++++++++-=
-----
>  6 files changed, 110 insertions(+), 12 deletions(-)
>  create mode 100644 scripts/Makefile.modbuiltin
>=20
> diff --git a/.gitignore b/.gitignore
> index cecb3b0..d8c1e79 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -22,6 +22,7 @@
>  *.lst
>  *.symtypes
>  *.order
> +modules.builtin
>  *.elf
>  *.bin
>  *.gz
> diff --git a/Makefile b/Makefile
> index 46e1c9d..c59e167 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -871,6 +871,9 @@ $(sort $(vmlinux-init) $(vmlinux-main)) $(vmlinux-lds=
): $(vmlinux-dirs) ;
>  PHONY +=3D $(vmlinux-dirs)
>  $(vmlinux-dirs): prepare scripts
>  	$(Q)$(MAKE) $(build)=3D$@
> +ifdef CONFIG_MODULES
> +	$(Q)$(MAKE) $(modbuiltin)=3D$@
> +endif
> =20
>  # Build the kernel release string
>  #
> @@ -1126,6 +1129,7 @@ all: modules
>  PHONY +=3D modules
>  modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux)
>  	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=3D$(objtree)/%/modules.order) >=
 $(objtree)/modules.order
> +	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=3D$(objtree)/%/modules.builtin)=
 > $(objtree)/modules.builtin
>  	@$(kecho) '  Building modules, stage 2.';
>  	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
>  	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=3Dfirmware __fw_m=
odbuild
> @@ -1154,7 +1158,7 @@ _modinst_:
>  		rm -f $(MODLIB)/build ; \
>  		ln -s $(objtree) $(MODLIB)/build ; \
>  	fi
> -	@cp -f $(objtree)/modules.order $(MODLIB)/
> +	@cp -f $(objtree)/modules.{order,builtin} $(MODLIB)/
>  	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
> =20
>  # This depmod is only for convenience to give the initial
> @@ -1217,8 +1221,9 @@ clean: archclean $(clean-dirs)
>  		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
>  		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
>  		-o -name '*.symtypes' -o -name 'modules.order' \
> -		-o -name 'Module.markers' -o -name '.tmp_*.o.*' \
> -		-o -name '*.gcno' \) -type f -print | xargs rm -f
> +		-o -name 'modules.builtin' -o -name 'Module.markers' \
> +		-o -name '.tmp_*.o.*' -o -name '*.gcno' \) \
> +		-type f -print | xargs rm -f
> =20
>  # mrproper - Delete all generated files, including .config
>  #
> @@ -1416,7 +1421,8 @@ $(clean-dirs):
>  clean:	rm-dirs :=3D $(MODVERDIR)
>  clean: rm-files :=3D $(KBUILD_EXTMOD)/Module.symvers \
>                     $(KBUILD_EXTMOD)/Module.markers \
> -                   $(KBUILD_EXTMOD)/modules.order
> +                   $(KBUILD_EXTMOD)/modules.order \
> +                   $(KBUILD_EXTMOD)/modules.builtin
>  clean: $(clean-dirs)
>  	$(call cmd,rmdirs)
>  	$(call cmd,rmfiles)
> diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
> index c29be8f..1cded3b 100644
> --- a/scripts/Kbuild.include
> +++ b/scripts/Kbuild.include
> @@ -143,6 +143,12 @@ ld-option =3D $(call try-run,\
>  # $(Q)$(MAKE) $(build)=3Ddir
>  build :=3D -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
> =20
> +###
> +# Shorthand for $(Q)$(MAKE) -f scripts/Makefile.modbuiltin obj=3D
> +# Usage:
> +# $(Q)$(MAKE) $(modbuiltin)=3Ddir
> +modbuiltin :=3D -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.modbu=
iltin obj
> +
>  # Prefix -I with $(srctree) if it is not an absolute path.
>  # skip if -I has no parameter
>  addtree =3D $(if $(patsubst -I%,%,$(1)), \
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 7a77787..3525b29 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -37,6 +37,8 @@ modorder	:=3D $(patsubst %/,%/modules.order, $(filter %=
/, $(obj-y)) $(obj-m:.o=3D.ko
> =20
>  __subdir-y	:=3D $(patsubst %/,%,$(filter %/, $(obj-y)))
>  subdir-y	+=3D $(__subdir-y)
> +__subdir-Y	:=3D $(patsubst %/,%,$(filter %/, $(obj-Y)))
> +subdir-Y	+=3D $(__subdir-Y)
>  __subdir-m	:=3D $(patsubst %/,%,$(filter %/, $(obj-m)))
>  subdir-m	+=3D $(__subdir-m)
>  obj-y		:=3D $(patsubst %/, %/built-in.o, $(obj-y))
> @@ -44,7 +46,7 @@ obj-m		:=3D $(filter-out %/, $(obj-m))
> =20
>  # Subdirectories we need to descend into
> =20
> -subdir-ym	:=3D $(sort $(subdir-y) $(subdir-m))
> +subdir-ym	:=3D $(sort $(subdir-y) $(subdir-Y) $(subdir-m))
> =20
>  # if $(foo-objs) exists, foo.o is a composite object=20
>  multi-used-y :=3D $(sort $(foreach m,$(obj-y), $(if $(strip $($(m:.o=3D-=
objs)) $($(m:.o=3D-y))), $(m))))
> @@ -76,6 +78,7 @@ always		:=3D $(addprefix $(obj)/,$(always))
>  targets		:=3D $(addprefix $(obj)/,$(targets))
>  modorder	:=3D $(addprefix $(obj)/,$(modorder))
>  obj-y		:=3D $(addprefix $(obj)/,$(obj-y))
> +obj-Y		:=3D $(addprefix $(obj)/,$(obj-Y))
>  obj-m		:=3D $(addprefix $(obj)/,$(obj-m))
>  lib-y		:=3D $(addprefix $(obj)/,$(lib-y))
>  subdir-obj-y	:=3D $(addprefix $(obj)/,$(subdir-obj-y))
> diff --git a/scripts/Makefile.modbuiltin b/scripts/Makefile.modbuiltin
> new file mode 100644
> index 0000000..55e1885
> --- /dev/null
> +++ b/scripts/Makefile.modbuiltin
> @@ -0,0 +1,48 @@
> +# =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> +# Generating modules.builtin
> +# =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> +
> +src :=3D $(obj)
> +
> +PHONY :=3D __modbuiltin
> +__modbuiltin:
> +
> +# Read auto2.conf which sets tristate variables to 'Y' instead of 'y'
> +# That way, we get the list of built-in modules in obj-Y
> +-include include/config/auto2.conf
> +
> +include scripts/Kbuild.include
> +
> +# The filename Kbuild has precedence over Makefile
> +kbuild-dir :=3D $(if $(filter /%,$(src)),$(src),$(srctree)/$(src))
> +kbuild-file :=3D $(if $(wildcard $(kbuild-dir)/Kbuild),$(kbuild-dir)/Kbu=
ild,$(kbuild-dir)/Makefile)
> +include $(kbuild-file)
> +
> +include scripts/Makefile.lib
> +
> +modbuiltin-subdirs :=3D $(patsubst %,%/modules.builtin, $(subdir-ym))
> +modbuiltin-mods    :=3D $(filter %.ko, $(obj-Y:.o=3D.ko))
> +modbuiltin-target  :=3D $(obj)/modules.builtin
> +
> +__modbuiltin: $(modbuiltin-target) $(subdir-ym)
> +	@:
> +
> +modbuiltin-cmds =3D						\
> +	for m in $(modbuiltin-mods); do echo kernel/$$m; done;	\
> +	cat /dev/null $(modbuiltin-subdirs);
> +
> +$(modbuiltin-target): $(subdir-ym)
> +	$(Q)($(modbuiltin-cmds)) > $@
> +
> +# Descending
> +# ----------------------------------------------------------------------=
-----
> +
> +PHONY +=3D $(subdir-ym)
> +$(subdir-ym):
> +	$(Q)$(MAKE) $(modbuiltin)=3D$@
> +
> +
> +# Declare the contents of the .PHONY variable as phony.  We keep that
> +# information in a variable se we can use it in if_changed and friends.
> +
> +.PHONY: $(PHONY)
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index a04da34..8e2c166 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -672,12 +672,27 @@ out:
>  	return res;
>  }
> =20
> +int fprintf2(FILE *f1, FILE *f2, const char *fmt, ...)
> +{
> +	va_list ap;
> +	int res;
> +
> +	va_start(ap, fmt);
> +	vfprintf(f1, fmt, ap);
> +	va_end(ap);
> +	va_start(ap, fmt);
> +	res =3D vfprintf(f2, fmt, ap);
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
> =20
> @@ -692,16 +707,23 @@ int conf_write_autoconf(void)
>  	if (!out)
>  		return 1;
> =20
> +	out2 =3D fopen(".tmpconfig2", "w");
> +	if (!out2) {
> +		fclose(out);
> +		return 1;
> +	}
> +
>  	out_h =3D fopen(".tmpconfig.h", "w");
>  	if (!out_h) {
>  		fclose(out);
> +		fclose(out2);
>  		return 1;
>  	}
> =20
>  	sym =3D sym_lookup("KERNELVERSION", 0);
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
> -				fprintf(out, "CONFIG_%s=3Dm\n", sym->name);
> +				fprintf2(out, out2, "CONFIG_%s=3Dm\n",
> +						sym->name);
>  				fprintf(out_h, "#define CONFIG_%s_MODULE 1\n", sym->name);
>  				break;
>  			case yes:
>  				fprintf(out, "CONFIG_%s=3Dy\n", sym->name);
> +				fprintf(out2, "CONFIG_%s=3D%c\n", sym->name,
> +					sym->type =3D=3D S_BOOLEAN ? 'y' : 'Y');
>  				fprintf(out_h, "#define CONFIG_%s 1\n", sym->name);
>  				break;
>  			}
>  			break;
>  		case S_STRING:
>  			str =3D sym_get_string_value(sym);
> -			fprintf(out, "CONFIG_%s=3D\"", sym->name);
> +			fprintf2(out, out2, "CONFIG_%s=3D\"", sym->name);
>  			fprintf(out_h, "#define CONFIG_%s \"", sym->name);
>  			while (1) {
>  				l =3D strcspn(str, "\"\\");
>  				if (l) {
>  					fwrite(str, l, 1, out);
> +					fwrite(str, l, 1, out2);
>  					fwrite(str, l, 1, out_h);
>  					str +=3D l;
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
>  			str =3D sym_get_string_value(sym);
>  			if (str[0] !=3D '0' || (str[1] !=3D 'x' && str[1] !=3D 'X')) {
> -				fprintf(out, "CONFIG_%s=3D%s\n", sym->name, str);
> +				fprintf2(out, out2, "CONFIG_%s=3D%s\n",
> +						sym->name, str);
>  				fprintf(out_h, "#define CONFIG_%s 0x%s\n", sym->name, str);
>  				break;
>  			}
>  		case S_INT:
>  			str =3D sym_get_string_value(sym);
> -			fprintf(out, "CONFIG_%s=3D%s\n", sym->name, str);
> +			fprintf2(out, out2, "CONFIG_%s=3D%s\n", sym->name, str);
>  			fprintf(out_h, "#define CONFIG_%s %s\n", sym->name, str);
>  			break;
>  		default:
> @@ -772,6 +800,7 @@ int conf_write_autoconf(void)
>  		}
>  	}
>  	fclose(out);
> +	fclose(out2);
>  	fclose(out_h);
> =20
>  	name =3D getenv("KCONFIG_AUTOHEADER");
> @@ -779,6 +808,11 @@ int conf_write_autoconf(void)
>  		name =3D "include/linux/autoconf.h";
>  	if (rename(".tmpconfig.h", name))
>  		return 1;
> +	name =3D getenv("KCONFIG_AUTOCONFIG2");
> +	if (!name)
> +		name =3D "include/config/auto2.conf";
> +	if (rename(".tmpconfig2", name))
> +		return 1;
>  	name =3D conf_get_autoconfig_name();
>  	/*
>  	 * This must be the last step, kbuild has a dependency on auto.conf
--=20
Scott James Remnant
scott@ubuntu.com

--=-TGkrf8iHb02+PnoSId4V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpeBjEACgkQSnQiFMl4yK69iQCfSoPFFrYBXcsHGqWxP4sVZ53s
ipgAoI2UdRc7txhtFvsC4zj0WLxSXLwv
=EsGU
-----END PGP SIGNATURE-----

--=-TGkrf8iHb02+PnoSId4V--

