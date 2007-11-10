Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbXKJWaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbXKJWaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 17:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbXKJWaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 17:30:00 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:58860 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbXKJWaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 17:30:00 -0500
Date: Sat, 10 Nov 2007 23:31:39 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config targets
Message-ID: <20071110223139.GA13815@uranus.ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org> <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org> <20071110141619.b5b7348d.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071110141619.b5b7348d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 02:16:19PM -0800, Randy Dunlap wrote:
> On Sat, 10 Nov 2007 21:43:26 +0100 Sam Ravnborg wrote:
> 
> > The variable K64BIT can now be used to select the
> > value of CONFIG_64BIT.
> > 
> > This is for example useful for powerpc to generate
> > allmodconfig for both bit sizes - like this:
> > make ARCH=powerpc K64BIT=y
> > make ARCH=powerpc K64BIT=n
> > 
> > To use this the Kconfig file must use "64BIT" as the
> > config value to select between 32 and 64 bit.
> > 
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > ---
> >  scripts/kconfig/conf.c      |    1 +
> >  scripts/kconfig/confdata.c  |   27 +++++++++++++++++++++++++++
> >  scripts/kconfig/lkc_proto.h |    1 +
> >  3 files changed, 29 insertions(+), 0 deletions(-)
> > 
> > diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
> > index a38787a..c6bee85 100644
> > --- a/scripts/kconfig/conf.c
> > +++ b/scripts/kconfig/conf.c
> > @@ -591,6 +591,7 @@ int main(int ac, char **av)
> >  			conf_read_simple(name, S_DEF_USER);
> >  		else if (!stat("all.config", &tmpstat))
> >  			conf_read_simple("all.config", S_DEF_USER);
> > +		conf_set_env_sym("K64BIT", "64BIT", S_DEF_USER);
> >  		break;
> >  	default:
> >  		break;
> > diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> > index e0f402f..0cb7555 100644
> > --- a/scripts/kconfig/confdata.c
> > +++ b/scripts/kconfig/confdata.c
> > @@ -145,6 +145,33 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
> >  	return 0;
> >  }
> >  
> > +/* Read an environment variable and assign the vaule to the symbol */
> 
>                                                   value
> 
> > +int conf_set_env_sym(const char *env, const char *symname, int def)
> > +{
> > +	struct symbol *sym;
> > +	char *p;
> > +	int def_flags;
> > +
> > +	p = getenv(env);
> > +	if (p) {
> > +		char warning[100];
> > +		sprintf(warning, "Environment variable (%s = \"%s\")", env, p);
> > +		conf_filename = warning;
> 
> What's with <warning> and <conf_filename> here?  I don't see how
> they are used in this function or in the caller of this function.

Added to allow conf_warning to print out something usefull.
Like in the following example:

make K64BIT=randy allnoconfig

Environment variable (K64BIT = "randy"):0:warning: symbol value 'randy' invalid for 64BIT


This could look better - but I preferred this version for the
less readable:
(null):0:warning: symbol value 'randy' invalid for 64BIT

Thanks for the other inputs. I am correcting them in
my local patch-set. Before resubmit I willawait further comments.

	Sam
