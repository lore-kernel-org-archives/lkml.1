Return-Path: <linux-kernel-owner+w=401wt.eu-S935873AbYD1VpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935873AbYD1VpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933398AbYD1Voz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:44:55 -0400
Received: from mail.queued.net ([207.210.101.209]:1269 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933360AbYD1Voy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:44:54 -0400
Date: Mon, 28 Apr 2008 17:48:06 -0400
From: Andres Salomon <dilinger@queued.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 4/4] kconfig: add *_silentdefconfig feature for config
 targets
Message-ID: <20080428174806.37f03c44@ephemeral>
In-Reply-To: <20080428213437.GA24202@uranus.ravnborg.org>
References: <20080425223530.10b9d50d@ephemeral>
	<20080427204744.GA444@uranus.ravnborg.org>
	<20080427214339.48bc2ed8@ephemeral>
	<20080428213437.GA24202@uranus.ravnborg.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 23:34:37 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> > > 
> > > And I see why you went for the name *_silentdefconfig
> > > But in reality what we want to say is that we want to
> > > interactively apply the _defconfig.
> > 
> > Do I?  I'm not sure what you mean by "interactively apply".  I want
> > to non-interactively apply the defconfig, and fail if prompting is
> > required (rather than just choosing default values).
> I mean exactly the behaviour you ask for.
> 
> > Sounds like you're saying that you want:
> > 
> > make oldconfig V=1   (chatty, prompt if possible or fail)
> > make oldconfig V=0   (silentoldconfig, prompt if possible or fail)
> > 
> > make defconfig V=1   (chatty, use defaults)
> > make defconfig V=0   (silent, use defaults)
> > 
> > make i386_oldconfig V=1 (chatty, prompt if possible or fail)
> > make i386_oldconfig V=0 (silent, prompt if possible or fail)
> > 
> > make i386_defconfig V=1 (chatty, use defaults)
> > make i386_defconfig V=0 (silent, use defaults)
> > 
> > Does that sound right?  Would using the build system's verbose variable
> > work?  If so, what should the default be?
> 
> V= shall not be used for this. I will try to cook up something.

Ok.

> 
> > > > 
> > > > diff --git a/Makefile b/Makefile
> > > > index e77149e..c264f7f 100644
> > > > --- a/Makefile
> > > > +++ b/Makefile
> > > > @@ -1225,6 +1225,10 @@ help:
> > > >  		$(foreach b, $(boards), \
> > > >  		printf "  %-24s - Build for %s\\n" $(b) $(subst _defconfig,,$(b));) \
> > > >  		echo '')
> > > > +	@$(if $(boards), \
> > > > +		$(foreach b, $(boards), \
> > > > +		printf "  %-24s - Quiet Build for %s\\n" $(subst _defconfig,_silentdefconfig,$(b)) $(subst _defconfig,,$(b));) \
> > > > +		echo '')
> > > This is the first time we use printf in the top-level Makefile.
> > > Most likely because I never use printf in my shell scripts
> > > so I guess this is not a problem.
> > 
> > 
> > Eh?  There's already a printf, this just adds an additional printf.
> I'm blind and you are right.
> 
> > > > --- a/scripts/kconfig/conf.c
> > > > +++ b/scripts/kconfig/conf.c
> > > > @@ -558,7 +558,8 @@ int main(int ac, char **av)
> > > >  		}
> > > >  		break;
> > > >  	case ask_new:
> > > > -		if (silent_mode && stat(".config", &tmpstat)) {
> > > > +		if (!defconfig_file && silent_mode &&
> > > > +				stat(".config", &tmpstat)) {
> > > 
> > > This belong in a preparation patch. We should handle this
> > > also if we do not do so from the Makefile.
> > 
> > I'm not sure what you mean.  This isn't really preparation for this patch;
> > it's just ensuring that we can use '-o' and '-D' together without
> > running a check for .config.  Basically, if '-o' is specified but '-D'
> > is not, check for .config (and fail if it doesn't exist.  If '-o' and '-D'
> > are both specified, we don't care about .config.
> 
> OK - but then it really does not belong in this patch.

I can break it into a separate patch, then.  Should I do so now, or wait?


> 
> > 
> > > 
> > > >  			printf(_("***\n"
> > > >  				"*** You have not yet configured your kernel!\n"
> > > >  				"*** (missing kernel .config file)\n"
> > > > @@ -570,7 +571,15 @@ int main(int ac, char **av)
> > > >  		}
> > > >  		/* fall through */
> > > >  	case ask_all:
> > > > -		conf_read(NULL);
> > > > +		if (defconfig_file) {
> > > > +			if (conf_read(defconfig_file)) {
> > > > +				printf(_("***\n*** Can't find default "
> > > > +					 "configuration \"%s\"!\n***\n"),
> > > > +					 defconfig_file);
> > > > +				exit(1);
> > > > +			}
> > > > +		} else
> > > > +			conf_read(NULL);
> > > 
> > > Does conf_read() fail if we use the NULL argument?
> > > I assume not so the above code can be simplified and
> > > should also be in the same preparational patch as the change above.
> > 
> > I don't believe it fails, it uses a default config name.  I'm not sure
> > if it fails if _that_ file isn't found, though.  I can't make much
> > sense of the symbol stuff..
> Thought we could simplify the code if defconfig_file is by default NULL.
> Then we can drop the else.

Ok.

> 
> I will try to get back to you on this later. The patches are anyway
> too late for this merge window.


Ok, sure.  I guess just let me know when you come up w/ an idea for
what it should be named, and I can update patches accordingly..



> 
> 	Sam
