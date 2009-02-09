Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbZBIRvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbZBIRvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbZBIRvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:51:04 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:24632 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbZBIRvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:51:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Um1eJ8ldDKdw7xt5TtrnNO9/zyuGKTkPPmzkhdXBQEOQY82shhAbNuHoGFH/we0LHu
         iK2xpP3pEz6zaIA9GM+9hqBEC/zi+tMVwoY7nFSl7Jy7HTUOCtJ30ITW9WssB9YDJ6BE
         brCXsMI/ogDHeeXalCsr3PhzJNTBRlQN5hN3U=
Date: Mon, 9 Feb 2009 11:50:50 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH 5/6] module: make modversion_info contain a pointer,
	not an array.
Message-ID: <20090209175050.GB9486@mediacenter>
References: <200901290005.52819.rusty@rustcorp.com.au> <20090205160128.GA9486@mediacenter> <200902071254.28824.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902071254.28824.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 12:54:28PM +1030, Rusty Russell wrote:
> On Friday 06 February 2009 02:31:28 Shawn Bohrer wrote:
> > On Thu, Jan 29, 2009 at 12:05:52AM +1030, Rusty Russell wrote:
> > > With allmodconfig (minus non-building modules) on 32-bit x86:
> > > Total size of modules before: 60009790 bytes
> > > Total size of modules after: 55927866 bytes
> > > 
> > > Saving 7% of module size for CONFIG_MODVERSIONS=y; and these sections
> > > are kept resident as well.
> > > 
> > > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > > ---
> > >  include/linux/module.h |    4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/include/linux/module.h b/include/linux/module.h
> > > --- a/include/linux/module.h
> > > +++ b/include/linux/module.h
> > > @@ -37,10 +37,12 @@ struct kernel_symbol
> > >  	const char *name;
> > >  };
> > >  
> > > +/* This is put in the __versions section of a module to indicate the version
> > > + * it expects for unknown symbols. */
> > >  struct modversion_info
> > >  {
> > >  	unsigned long crc;
> > > -	char name[MODULE_NAME_LEN];
> > > +	char *name;
> > >  };
> > 
> > Hey Rusty thanks for the change, but I just got around to testing this
> > and I have a few observations/questions.  First this breaks:
> > 
> > modprobe --dump-modversions foo.ko
> 
> Hmm, that's an argument not to make this change.  Really, other than disk
> space benefit we get all the benefits from just dropping the 
> __versions section once loaded.
> 
> > I actually don't care, but just happened to stumble upon it when I also
> > noticed that your changes seemed to be working a little too well.  I
> > currently happen to be building my modules out of order for example
> > module B depends on symbols from module A, but I build module B first.
> > This means that the exported symbols are not in the Module.symvers file
> > when module B is compiled.  I would expect module B to fail to load yet
> > with your patches it magically works and I don't see any errors in the
> > logs.
> 
> Interesting.  What is the value of /proc/sys/kernel/tainted?

It is 3 in both cases (built in the correct and incorrect order).  If
I'm reading this correctly that means my module is proprietary and was
force loaded.  It is proprietary, but was not literally force loaded.
I'm guessing since the modversions information is wrong it sets the
force loaded bit.  I have no idea why the force loaded bit is set even
when things are built in the correct order.

Of course this made me dig a little deeper, and I think I may have been
fighting a regression all along, or possibly I'm missing a kernel config
option.  My real problem is that on openSUSE 11.1 (2.6.27) I was trying
to load my module and modprobe returned:

FATAL: Error inserting foo: Invalid module format

running dmesg I saw the kernel print:

foo: no symbol version for struct_module

After some digging I realized I wasn't building with modversion support
and that led to the long symbol name problem.  I originally believed
that openSUSE 11.1 turned on CONFIG_MODVERSIONS and previous versions
did not have it enabled.  After taking a closer look at openSUSE 10.3
(2.6.22) I found it did have CONFIG_MODVERSIONS=y and that modprobing my
module succeeds but the kernel does print:

foo: no version for "stuct_module" found: kernel tainted

This also results in a taint flag of 3.  So I'm thinking the regression
here is that somewhere between 2.6.25 (I know openSUSE 11 worked too)
and 2.6.27 the kernel stopped allowing modules to load if they didn't
build with modversion support and the kernel was built with
CONFIG_MODVERSIONS=y.

> And anyway, what was the symbol name which is over 56 characters long which
> started this?

Yeah, that is an interesting question isn't it?  Let me just say that
namespaces and name mangling make it really easy to have names longer
than 56 characters.

I actually don't care at all about modversions.  I also don't care if it
taints the kernel, I really just want the modules to load.

--
Shawn
