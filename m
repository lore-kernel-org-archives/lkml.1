Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbYEFDaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbYEFDaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 23:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYEFDaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 23:30:10 -0400
Received: from barikada.upol.cz ([158.194.242.200]:37783 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbYEFDaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 23:30:08 -0400
Date: Tue, 6 May 2008 05:51:08 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Sergio Luis <sergio@uece.br>,
       Parag Warudkar <parag.warudkar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "akpm@osdl.org" <akpm@osdl.org>, Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Dave Jones <davej@redhat.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] kconfig: add support for stdin (make K=- ...)
Message-ID: <20080506035108.GD24008@flower.upol.cz>
References: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com> <20080504092417.GA3425@elte.hu> <82e4877d0805050814j721ae522k84384df48c9f4336@mail.gmail.com> <20080505171501.GA22332@elte.hu> <20080505182427.GA2025@uranus.ravnborg.org> <ce0170d90805051136w2f016c15p575623d33c220ddf@mail.gmail.com> <20080505184538.GE22332@elte.hu> <20080505194929.GA8868@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505194929.GA8868@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg @ Mon, May 05, 2008 at 09:49:29PM +0200:
[]
> > i think the 'natural' script behavior would be for this to do the right 
> > thing:
> > 
> >    zcat /proc/config.gz | make K=- alldefconfig
> > 
> > or something like that - so that it can be scripted in a pipe.
> 
> I like this ;-)
> So I implemented support for stdin - see attached.
> It is also in kbuild.git.

Isn't /dev/stdin (or link to /proc) supported everywhere already?

> +	if (strcmp(config_file, "-")) {

full strcmp() for just one symbol?

> +		if (config_file && stat(config_file, &tmpstat)) {
> +			fprintf(stderr, _("%s: failed to open %s\n"),
> +			        av[0], config_file);
> +			exit(1);
> +		}
> +		config_filename = config_file;
> +	} else {
> +		config_filename = "stdin";
>  	}
> +
>  	if (config_file && conf_read_simple(config_file, S_DEF_USER)) {
>  		fprintf(stderr, _("%s: failed to read %s\n"),
> -		        av[0], config_file);
> +		        av[0], config_filename);
>  		exit(1);
>  	}
>  	if (config_file) {
>  		printf("#\n");
> -		printf(_("# configuration is based on '%s'\n"), config_file);
> +		printf(_("# configuration is based on '%s'\n"),
> +		       config_filename);
>  	}
>  	/* generate the config */
>  	do {
> diff --git a/scripts/kconfig/lex.zconf.c_shipped b/scripts/kconfig/lex.zconf.c_shipped
> index 6a61cee..7bd00d3 100644
> --- a/scripts/kconfig/lex.zconf.c_shipped
> +++ b/scripts/kconfig/lex.zconf.c_shipped
> @@ -2268,13 +2268,17 @@ FILE *zconf_fopen(const char *name)
>  	char *env, fullname[PATH_MAX+1];
>  	FILE *f;
>  
> -	f = fopen(name, "r");
> -	if (!f && name != NULL && name[0] != '/') {
> -		env = getenv(SRCTREE);
> -		if (env) {
> -			sprintf(fullname, "%s/%s", env, name);
> -			f = fopen(fullname, "r");
> +	if (strcmp(name, "-")) {
> +		f = fopen(name, "r");
> +		if (!f && name != NULL && name[0] != '/') {
> +			env = getenv(SRCTREE);
> +			if (env) {
> +				sprintf(fullname, "%s/%s", env, name);
> +				f = fopen(fullname, "r");
> +			}
>  		}
> +	} else {
> +		f = stdin;
>  	}
>  	return f;
>  }
> diff --git a/scripts/kconfig/zconf.l b/scripts/kconfig/zconf.l
> index 4cea5c8..a268d88 100644
> --- a/scripts/kconfig/zconf.l
> +++ b/scripts/kconfig/zconf.l
> @@ -269,13 +269,17 @@ FILE *zconf_fopen(const char *name)
>  	char *env, fullname[PATH_MAX+1];
>  	FILE *f;
>  
> -	f = fopen(name, "r");
> -	if (!f && name != NULL && name[0] != '/') {
> -		env = getenv(SRCTREE);
> -		if (env) {
> -			sprintf(fullname, "%s/%s", env, name);
> -			f = fopen(fullname, "r");
> +	if (strcmp(name, "-")) {
> +		f = fopen(name, "r");
> +		if (!f && name != NULL && name[0] != '/') {
> +			env = getenv(SRCTREE);
> +			if (env) {
> +				sprintf(fullname, "%s/%s", env, name);
> +				f = fopen(fullname, "r");
> +			}
>  		}
> +	} else {
> +		f = stdin;
>  	}
>  	return f;

rather big diffstat for almost nothing. Userspacy?
____
