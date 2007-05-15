Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbXEOUiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbXEOUiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 16:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbXEOUik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 16:38:40 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40165 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064AbXEOUij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 16:38:39 -0400
Date: Tue, 15 May 2007 22:39:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PowerPC64 symbols start with '.'
Message-ID: <20070515203935.GB22966@uranus.ravnborg.org>
References: <20070511154501.1961fb92.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511154501.1961fb92.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 03:45:01PM +1000, Stephen Rothwell wrote:
> which we want to skip during modpost processing.  We need this to make
> some of the whitelisting work.

I have a popwerpc64 crosscompiler and would like to reproduce
this bug.
It is gcc 4.1.0 build with Dan Kegel's crosstool.

What config shall I use to try it out.
Can you please supply the exact warning message too.

Thanks,
	Sam

> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  scripts/mod/modpost.c |   18 +++++++++++++++++-
>  1 files changed, 17 insertions(+), 1 deletions(-)
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 113dc77..748b058 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -164,7 +164,13 @@ static inline unsigned int tdb_hash(const char *name)
>  static struct symbol *alloc_symbol(const char *name, unsigned int weak,
>  				   struct symbol *next)
>  {
> -	struct symbol *s = NOFAIL(malloc(sizeof(*s) + strlen(name) + 1));
> +	struct symbol *s;
> +
> +	/* For our purposes, .foo matches foo.  PPC64 needs this. */
> +	if (name[0] == '.')
> +		name++;
> +
> +	s = NOFAIL(malloc(sizeof(*s) + strlen(name) + 1));
>  
>  	memset(s, 0, sizeof(*s));
>  	strcpy(s->name, name);
> @@ -180,6 +186,10 @@ static struct symbol *new_symbol(const char *name, struct module *module,
>  	unsigned int hash;
>  	struct symbol *new;
>  
> +	/* For our purposes, .foo matches foo.  PPC64 needs this. */
> +	if (name[0] == '.')
> +		name++;
> +
>  	hash = tdb_hash(name) % SYMBOL_HASH_SIZE;
>  	new = symbolhash[hash] = alloc_symbol(name, 0, symbolhash[hash]);
>  	new->module = module;
> @@ -684,6 +694,12 @@ static int secref_whitelist(const char *modname, const char *tosec,
>  		NULL
>  	};
>  
> +	/* For our purposes, .foo matches foo.  PPC64 needs this. */
> +	if (atsym[0] == '.')
> +		atsym++;
> +	if (refsymname[0] == '.')
> +		refsymname++;
> +
>  	/* Check for pattern 1 */
>  	if (strcmp(tosec, ".init.data") != 0)
>  		f1 = 0;
> -- 
> 1.5.1.4
> 
