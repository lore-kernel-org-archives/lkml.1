Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbXKACqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbXKACqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 22:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbXKACq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 22:46:27 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:45876 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541AbXKACq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 22:46:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HANLaKEdMQWvU/2dsb2JhbACBWw
Date: Wed, 31 Oct 2007 22:46:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com
Subject: Re: [PATCH] markers: modpost
Message-ID: <20071101024622.GA3343@Krystal>
References: <200709192132.00873.vda.linux@googlemail.com> <20070921125819.GA13129@Krystal> <20070921133006.GF8964@redhat.com> <20070921133820.GD13129@Krystal> <20071015194120.GA22562@redhat.com> <20071015231209.GA18994@Krystal> <20071015235033.321E84D0389@magilla.localdomain> <20071025191722.GA6114@Krystal> <20071026142810.GA14814@redhat.com> <20071101010624.54D8D4D04AE@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071101010624.54D8D4D04AE@magilla.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:38:41 up 94 days,  2:57,  2 users,  load average: 0.36, 0.43, 0.39
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Roland McGrath (roland@redhat.com) wrote:
> 
> This adds some new magic in the MODPOST phase for CONFIG_MARKERS.
> Analogous to the Module.symvers file, the build will now write a
> Module.markers file when CONFIG_MARKERS=y is set.  This file lists
> the name, defining module, and format string of each marker,
> separated by \t characters.  This simple text file can be used by
> offline build procedures for instrumentation code, analogous to
> how System.map and Module.symvers can be useful to have for
> kernels other than the one you are running right now.
> 
> The method of extracting the strings is somewhat crude, but is very
> simple and should work fine in practice for the foreseeable future.
> 

Hi Roland,

I'm ok with the idea of extracting such information, but I doubt one can
assume the strings will always be layed out in the same order in the
__markers_strings section. We also shouldn't assume that a marker name
will be a neighbor of its format string.

If we want to do it safely, I think we should iterate from
__start___markers to __stop___markers symbols of vmlinux and get the
pointers to the name/format string pairs.

The same can then be done with modules using the __markers section.

Or maybe is there some reason not to do that ?

Mathieu


> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  scripts/Makefile.modpost |   11 +++
>  scripts/mod/modpost.c    |  174 +++++++++++++++++++++++++++++++++++++++++++++-
>  scripts/mod/modpost.h    |    3 +
>  3 files changed, 187 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> index d988f5d..6321870 100644
> --- a/scripts/Makefile.modpost
> +++ b/scripts/Makefile.modpost
> @@ -13,6 +13,7 @@
>  # 2) modpost is then used to
>  # 3)  create one <module>.mod.c file pr. module
>  # 4)  create one Module.symvers file with CRC for all exported symbols
> +# 4a) [CONFIG_MARKERS] create one Module.markers file listing defined markers
>  # 5) compile all <module>.mod.c files
>  # 6) final link of the module to a <module.ko> file
>  
> @@ -45,6 +46,10 @@ include scripts/Makefile.lib
>  
>  kernelsymfile := $(objtree)/Module.symvers
>  modulesymfile := $(firstword $(KBUILD_EXTMOD))/Module.symvers
> +kernelmarkersfile := $(objtree)/Module.markers
> +modulemarkersfile := $(firstword $(KBUILD_EXTMOD))/Module.markers
> +
> +markersfile = $(if $(KBUILD_EXTMOD),$(modulemarkersfile),$(kernelmarkersfile))
>  
>  # Step 1), find all modules listed in $(MODVERDIR)/
>  __modules := $(sort $(shell grep -h '\.ko' /dev/null $(wildcard $(MODVERDIR)/*.mod)))
> @@ -62,6 +67,8 @@ modpost = scripts/mod/modpost                    \
>   $(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile)   \
>   $(if $(KBUILD_EXTMOD),-I $(modulesymfile))      \
>   $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
> + $(if $(CONFIG_MARKERS),-K $(kernelmarkersfile)) \
> + $(if $(CONFIG_MARKERS),-M $(markersfile))	 \
>   $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
>  
>  quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
> @@ -81,6 +88,10 @@ vmlinux.o: FORCE
>  $(symverfile):         __modpost ;
>  $(modules:.ko=.mod.c): __modpost ;
>  
> +ifdef CONFIG_MARKERS
> +$(markersfile):	       __modpost ;
> +endif
> +
>  
>  # Step 5), compile all *.mod.c files
>  
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 93ac52a..df80bfc 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -11,6 +11,8 @@
>   * Usage: modpost vmlinux module1.o module2.o ...
>   */
>  
> +#define _GNU_SOURCE
> +#include <stdio.h>
>  #include <ctype.h>
>  #include "modpost.h"
>  #include "../../include/linux/license.h"
> @@ -424,6 +426,8 @@ static int parse_elf(struct elf_info *info, const char *filename)
>  			info->export_unused_gpl_sec = i;
>  		else if (strcmp(secname, "__ksymtab_gpl_future") == 0)
>  			info->export_gpl_future_sec = i;
> +		else if (strcmp(secname, "__markers_strings") == 0)
> +			info->markers_strings_sec = i;
>  
>  		if (sechdrs[i].sh_type != SHT_SYMTAB)
>  			continue;
> @@ -1249,6 +1253,73 @@ static int exit_section_ref_ok(const char *name)
>  	return 0;
>  }
>  
> +static size_t strlen_with_padding(const char *start, const char *limit)
> +{
> +	const char *p = memchr(start, '\0', limit - start);
> +	if (p == NULL)
> +		return 0;
> +	do
> +		++p;
> +	while (p < limit && *p == '\0');
> +	return p - start;
> +}
> +
> +static void get_markers(struct elf_info *info, struct module *mod)
> +{
> +	const Elf_Shdr *sh = &info->sechdrs[info->markers_strings_sec];
> +	const char *strings;
> +	const char *strings_end;
> +	const char *p;
> +	size_t n, i;
> +
> +	if (!info->markers_strings_sec)
> +		return;
> +
> +	strings = (const char *) info->hdr + sh->sh_offset;
> +	strings_end = strings + sh->sh_size;
> +
> +	/*
> +	 * First count the strings.  They come in pairs of name, format.
> +	 */
> +	for (n = 0, p = strings; p < strings_end; ++n) {
> +		size_t len = strlen_with_padding(p, strings_end);
> +		if (len == 0)
> +			break;
> +		p += len;
> +	}
> +	if (n % 2 != 0 || p != strings_end) {
> +		warn("%s.ko has bad __markers_strings, ignoring it\n",
> +		     mod->name);
> +		return;
> +	}
> +
> +	if (n == 0)
> +		return;
> +
> +	/*
> +	 * Now collect each pair into a formatted line for the output.
> +	 * Lines look like:
> +	 *	marker_name	vmlinux	marker %s format %d
> +	 * The format string after the second \t can use whitespace.
> +	 */
> +	mod->markers = NOFAIL(malloc(sizeof mod->markers[0] * n / 2));
> +	mod->nmarkers = n / 2;
> +
> +	p = strings;
> +	for (i = 0; i < n; i += 2) {
> +		const char *name, *fmt;
> +		name = p;
> +		p += strlen_with_padding(p, strings_end);
> +		fmt = p;
> +		p += strlen_with_padding(p, strings_end);
> +
> +		mod->markers[i / 2] = NULL;
> +		asprintf(&mod->markers[i / 2], "%s\t%s\t%s\n",
> +			 name, mod->name, fmt);
> +		NOFAIL(mod->markers[i / 2]);
> +	}
> +}
> +
>  static void read_symbols(char *modname)
>  {
>  	const char *symname;
> @@ -1301,6 +1372,8 @@ static void read_symbols(char *modname)
>  		get_src_version(modname, mod->srcversion,
>  				sizeof(mod->srcversion)-1);
>  
> +	get_markers(&info, mod);
> +
>  	parse_elf_finish(&info);
>  
>  	/* Our trick to get versioning for struct_module - it's
> @@ -1649,6 +1722,91 @@ static void write_dump(const char *fname)
>  	write_if_changed(&buf, fname);
>  }
>  
> +static void add_marker(struct module *mod, const char *name, const char *fmt)
> +{
> +	char *line = NULL;
> +	asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt);
> +	NOFAIL(line);
> +
> +	mod->markers = NOFAIL(realloc(mod->markers, ((mod->nmarkers + 1) *
> +						     sizeof mod->markers[0])));
> +	mod->markers[mod->nmarkers++] = line;
> +}
> +
> +static void read_markers(const char *fname)
> +{
> +	unsigned long size, pos = 0;
> +	void *file = grab_file(fname, &size);
> +	char *line;
> +
> +        if (!file)
> +		/* No old markers, silently ignore */
> +		return;
> +
> +	while ((line = get_next_line(&pos, file, size))) {
> +		char *marker, *modname, *fmt;
> +		struct module *mod;
> +
> +		marker = line;
> +		if (!(modname = strchr(marker, '\t')))
> +			goto fail;
> +		*modname++ = '\0';
> +		if (!(fmt = strchr(modname, '\t')))
> +			goto fail;
> +		*fmt++ = '\0';
> +		if (*marker == '\0' || *modname == '\0')
> +			goto fail;
> +
> +		if (!(mod = find_module(modname))) {
> +			if (is_vmlinux(modname)) {
> +				have_vmlinux = 1;
> +			}
> +			mod = new_module(NOFAIL(strdup(modname)));
> +			mod->skip = 1;
> +		}
> +
> +		add_marker(mod, marker, fmt);
> +	}
> +	return;
> +fail:
> +	fatal("parse error in markers list file\n");
> +}
> +
> +static int compare_strings(const void *a, const void *b)
> +{
> +	return strcmp(*(const char **) a, *(const char **) b);
> +}
> +
> +static void write_markers(const char *fname)
> +{
> +	struct buffer buf = { };
> +	struct module *mod;
> +	size_t i;
> +
> +	for (mod = modules; mod; mod = mod->next)
> +		if ((!external_module || !mod->skip) && mod->markers != NULL) {
> +			/*
> +			 * Sort the strings so we can skip duplicates when
> +			 * we write them out.
> +			 */
> +			qsort(mod->markers, mod->nmarkers,
> +			      sizeof mod->markers[0], &compare_strings);
> +			for (i = 0; i < mod->nmarkers; ++i) {
> +				char *line = mod->markers[i];
> +				buf_write(&buf, line, strlen(line));
> +				while (i + 1 < mod->nmarkers &&
> +				       !strcmp(mod->markers[i],
> +					       mod->markers[i + 1]))
> +					free(mod->markers[i++]);
> +				free(mod->markers[i]);
> +			}
> +			free(mod->markers);
> +			mod->markers = NULL;
> +		}
> +
> +	write_if_changed(&buf, fname);
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	struct module *mod;
> @@ -1656,10 +1814,12 @@ int main(int argc, char **argv)
>  	char fname[SZ];
>  	char *kernel_read = NULL, *module_read = NULL;
>  	char *dump_write = NULL;
> +	char *markers_read = NULL;
> +	char *markers_write = NULL;
>  	int opt;
>  	int err;
>  
> -	while ((opt = getopt(argc, argv, "i:I:mso:aw")) != -1) {
> +	while ((opt = getopt(argc, argv, "i:I:mso:awM:K:")) != -1) {
>  		switch(opt) {
>  			case 'i':
>  				kernel_read = optarg;
> @@ -1683,6 +1843,12 @@ int main(int argc, char **argv)
>  			case 'w':
>  				warn_unresolved = 1;
>  				break;
> +			case 'M':
> +				markers_write = optarg;
> +				break;
> +			case 'K':
> +				markers_read = optarg;
> +				break;
>  			default:
>  				exit(1);
>  		}
> @@ -1724,5 +1890,11 @@ int main(int argc, char **argv)
>  	if (dump_write)
>  		write_dump(dump_write);
>  
> +	if (markers_read)
> +		read_markers(markers_read);
> +
> +	if (markers_write)
> +		write_markers(markers_write);
> +
>  	return err;
>  }
> diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
> index 0ffed17..175301a 100644
> --- a/scripts/mod/modpost.h
> +++ b/scripts/mod/modpost.h
> @@ -110,6 +110,8 @@ struct module {
>  	int has_init;
>  	int has_cleanup;
>  	struct buffer dev_table_buf;
> +	char **markers;
> +	size_t nmarkers;
>  	char	     srcversion[25];
>  };
>  
> @@ -124,6 +126,7 @@ struct elf_info {
>  	Elf_Section  export_gpl_sec;
>  	Elf_Section  export_unused_gpl_sec;
>  	Elf_Section  export_gpl_future_sec;
> +	Elf_Section  markers_strings_sec;
>  	const char   *strtab;
>  	char	     *modinfo;
>  	unsigned int modinfo_len;

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
