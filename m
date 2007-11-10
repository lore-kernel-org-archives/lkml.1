Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbXKJWRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbXKJWRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 17:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbXKJWRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 17:17:41 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:57282 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbXKJWRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 17:17:41 -0500
Date: Sat, 10 Nov 2007 14:16:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config
 targets
Message-Id: <20071110141619.b5b7348d.randy.dunlap@oracle.com>
In-Reply-To: <11947274091127-git-send-email-sam@ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org>
	<11947274093185-git-send-email-sam@ravnborg.org>
	<11947274091127-git-send-email-sam@ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2007 21:43:26 +0100 Sam Ravnborg wrote:

> The variable K64BIT can now be used to select the
> value of CONFIG_64BIT.
> 
> This is for example useful for powerpc to generate
> allmodconfig for both bit sizes - like this:
> make ARCH=powerpc K64BIT=y
> make ARCH=powerpc K64BIT=n
> 
> To use this the Kconfig file must use "64BIT" as the
> config value to select between 32 and 64 bit.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  scripts/kconfig/conf.c      |    1 +
>  scripts/kconfig/confdata.c  |   27 +++++++++++++++++++++++++++
>  scripts/kconfig/lkc_proto.h |    1 +
>  3 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
> index a38787a..c6bee85 100644
> --- a/scripts/kconfig/conf.c
> +++ b/scripts/kconfig/conf.c
> @@ -591,6 +591,7 @@ int main(int ac, char **av)
>  			conf_read_simple(name, S_DEF_USER);
>  		else if (!stat("all.config", &tmpstat))
>  			conf_read_simple("all.config", S_DEF_USER);
> +		conf_set_env_sym("K64BIT", "64BIT", S_DEF_USER);
>  		break;
>  	default:
>  		break;
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index e0f402f..0cb7555 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -145,6 +145,33 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
>  	return 0;
>  }
>  
> +/* Read an environment variable and assign the vaule to the symbol */

                                                  value

> +int conf_set_env_sym(const char *env, const char *symname, int def)
> +{
> +	struct symbol *sym;
> +	char *p;
> +	int def_flags;
> +
> +	p = getenv(env);
> +	if (p) {
> +		char warning[100];
> +		sprintf(warning, "Environment variable (%s = \"%s\")", env, p);
> +		conf_filename = warning;

What's with <warning> and <conf_filename> here?  I don't see how
they are used in this function or in the caller of this function.

> +		def_flags = SYMBOL_DEF << def;
> +		if (def == S_DEF_USER) {
> +			sym = sym_find(symname);
> +			if (!sym)
> +				return 1;
> +		} else {
> +			sym = sym_lookup(symname, 0);
> +			if (sym->type == S_UNKNOWN)
> +				sym->type = S_OTHER;
> +		}
> +		conf_set_sym_val(sym, def, def_flags, p);
> +	}
> +	return 0;
> +}
> +
>  int conf_read_simple(const char *name, int def)
>  {
>  	FILE *in = NULL;

---
~Randy
