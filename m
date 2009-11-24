Return-Path: <linux-kernel-owner+w=401wt.eu-S934222AbZKXWCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934222AbZKXWCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 17:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934057AbZKXWCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 17:02:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934033AbZKXWCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 17:02:11 -0500
Message-ID: <4B0C57EA.1030400@suse.cz>
Date: Tue, 24 Nov 2009 23:02:18 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bernhard Kaindl <bernhard.kaindl@gmx.net>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH 1/4] Support loading and saving custom remarks for config
 symbols
References: <cover.1256767265.git.aragorn@Anduril.ringwar.org> <b106dec1237ab723ae6a2404d42601bf20704bf3.1256767265.git.aragorn@Anduril.ringwar.org>
In-Reply-To: <b106dec1237ab723ae6a2404d42601bf20704bf3.1256767265.git.aragorn@Anduril.ringwar.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added Roman Zippel (maintainer of kconfig) to CC, the whole thread is
at http://thread.gmane.org/gmane.linux.kbuild.devel/4039)

Bernhard Kaindl wrote:
> Add the infrastructure to load and save remarks for config symbols
> to the kconfig library functions conf_read() and conf_write()

First of all, I think this is a great idea, a mechanism to attach user
comments to config options in .config would be really helpful, esp. for
people maintaining distribution configs.


> This
>  - adds sym->remark
>  - extends conf_read() to call conf_read_remarks()
>  - adds conf_read_remarks() which:
>    -> reads remarks from a file and
>    -> stores them in sym->remark
>  - extends conf_write() to save each sym->remark so that
>    conf_read_remarks() will be able to reread them
> 
> To not keep any additional file when no remarks exist, and to stay completely
> out of the way when this feature is not used, conf_write() does not keep
> empty remarks files, so anyone not using this code will see no changes.
> 
> The filename of the remarks file is derived from the used config file
> name and path by appending "-remarks" to the config file name. So the
> default remarks file would be ".config-remarks".

This is not really obvious if you are viewing the .config directly,
though. What about storing the remarks in the .config itself? E.g. if a
symbol is directly preceded by a line that starts with '#', contains
some non-whitespace characters (to skip comments comming from Kconfig
files) and does not look like "# CONFIG_FOO=[ym]" or " CONFIG_FOO is not
set", interpret that line as remark for the next symbol:

#
# File systems
#
# CONFIG_EXT2_FS is not set
# this line is a remark, the lines above are not
CONFIG_EXT3_FS=y

The write operation would just print the remark before each symbol. Sure
there would be false matches sometimes, but I think people would
appreciate that their inline comments survive make oldconfig.

What do you think? I'll try creating a patch tomorrow.

Michal


> This code supports one-line remarks without newlines. The changes to
> the tools (menuconfig, xconfig, config) also only support one-line
> remarks as they use the existing UI functions for editing strings.
> 
> Signed-off-by: Bernhard Kaindl <bernhard.kaindl@gmx.net>
> ---
>  scripts/kconfig/confdata.c |   45 +++++++++++++++++++++++++++++++++++++++++--
>  scripts/kconfig/expr.h     |    1 +
>  2 files changed, 43 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index 797a741..eee2b60 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -152,6 +152,30 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
>  	return 0;
>  }
>  
> +/**
> + * Read remarks from -remarks file:
> + */
> +void conf_read_remarks(const char *remfile)
> +{
> +	FILE *in;
> +	char line[1024], *p, *p2;
> +	struct symbol *sym;
> +
> +	sprintf(line, "%s-remarks", remfile ? remfile : conf_get_configname());
> +	if (!(in = zconf_fopen(line)))
> +		return;
> +	while (fgets(line, sizeof(line), in)) {
> +		if (!(p = strchr(line, ' '))) /* ' ' is our delimiter        */
> +			continue;	      /* skip lines without one      */
> +		*p++ = '\0';		      /* put a \0 there, advance     */
> +		if ((p2 = strchr(p, '\n')))   /* look for \n after remark    */
> +			*p2 = '\0';	      /* remove it, no \n in remarks */
> +		if ((sym = sym_find(line)))   /* find the matching sym       */
> +			sym->remark = strdup(p); /* and register the remark  */
> +	}
> +	fclose(in);
> +}
> +
>  int conf_read_simple(const char *name, int def)
>  {
>  	FILE *in = NULL;
> @@ -393,16 +417,18 @@ int conf_read(const char *name)
>  
>  	sym_add_change_count(conf_warnings || conf_unsaved);
>  
> +	conf_read_remarks(name);
>  	return 0;
>  }
>  
>  int conf_write(const char *name)
>  {
> -	FILE *out;
> +	FILE *out, *rem;
> +	struct stat sb;
>  	struct symbol *sym;
>  	struct menu *menu;
>  	const char *basename;
> -	char dirname[128], tmpname[128], newname[128];
> +	char dirname[128], tmpname[128], newname[128], tmprem[128], newrem[128];
>  	int type, l;
>  	const char *str;
>  	time_t now;
> @@ -432,15 +458,19 @@ int conf_write(const char *name)
>  		basename = conf_get_configname();
>  
>  	sprintf(newname, "%s%s", dirname, basename);
> +	sprintf(newrem, "%s%s-remarks", dirname, basename);
>  	env = getenv("KCONFIG_OVERWRITECONFIG");
>  	if (!env || !*env) {
>  		sprintf(tmpname, "%s.tmpconfig.%d", dirname, (int)getpid());
>  		out = fopen(tmpname, "w");
> +		sprintf(tmprem, "%s.tmpconfig-remarks.%d", dirname, (int)getpid());
> +		rem = fopen(tmprem, "w");
>  	} else {
>  		*tmpname = 0;
>  		out = fopen(newname, "w");
> +		rem = fopen(newrem, "w");
>  	}
> -	if (!out)
> +	if (!out || !rem)
>  		return 1;
>  
>  	sym = sym_lookup("KERNELVERSION", 0);
> @@ -528,6 +558,8 @@ int conf_write(const char *name)
>  		}
>  
>  	next:
> +		if (sym && sym->remark)
> +			fprintf(rem, "%s %s\n", sym->name, sym->remark);
>  		if (menu->list) {
>  			menu = menu->list;
>  			continue;
> @@ -542,6 +574,7 @@ int conf_write(const char *name)
>  		}
>  	}
>  	fclose(out);
> +	fclose(rem);
>  
>  	if (*tmpname) {
>  		strcat(dirname, basename);
> @@ -549,7 +582,13 @@ int conf_write(const char *name)
>  		rename(newname, dirname);
>  		if (rename(tmpname, newname))
>  			return 1;
> +		sprintf(dirname, "%s.old", newrem);
> +		rename(newrem, dirname);
> +		if (rename(tmprem, newrem)) 
> +			conf_warning("moving %s to %s failed!", tmprem, newrem);
>  	}
> +	if (!stat(newrem, &sb) && !sb.st_size)
> +		unlink(newrem);
>  
>  	printf(_("#\n"
>  		 "# configuration written to %s\n"
> diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
> index 6408fef..217e8cb 100644
> --- a/scripts/kconfig/expr.h
> +++ b/scripts/kconfig/expr.h
> @@ -77,6 +77,7 @@ enum {
>  struct symbol {
>  	struct symbol *next;
>  	char *name;
> +	char *remark;
>  	enum symbol_type type;
>  	struct symbol_value curr;
>  	struct symbol_value def[S_DEF_COUNT];

