Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbYKNBQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbYKNBQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbYKNBQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:16:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:33049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbYKNBQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:16:16 -0500
Date: Fri, 14 Nov 2008 02:16:10 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] x86: optimise page fault path a little
Message-ID: <20081114011610.GA5063@wotan.suse.de>
References: <20081113072821.GB2946@wotan.suse.de> <20081113074109.GB1723@elte.hu> <20081113075022.GC2946@wotan.suse.de> <20081113160633.GA13095@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113160633.GA13095@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 05:06:33PM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > > 32-bit should use oops_begin() too. Solves the previous comment as 
> > > well.
> > > 
> > > > +#ifdef CONFIG_X86_32
> > > > +	die("Oops", regs, error_code);
> > > > +	bust_spinlocks(0);
> > > > +	do_exit(SIGKILL);
> > > > +#else
> > > > +	if (__die("Oops", regs, error_code))
> > > > +		regs = NULL;
> > > > +	/* Executive summary in case the body of the oops scrolled away */
> > > > +	printk(KERN_EMERG "CR2: %016lx\n", address);
> > > > +	oops_end(flags, regs, SIGKILL);
> > > > +#endif
> > > 
> > > this difference seems unnecessary too - 32-bit should use oops_end() 
> > > too.
> > 
> > Probably all 3 good comments, but I didn't want to be tempted into 
> > changing behaviour (modulo adding bugs). Easy to merge them up in a 
> > subsequent patch, however...
> 
> please do feel tempted to clean this code up - and if it changes 
> behavior, split it up into smaller steps. The patch is already quite 
> large with a flux of 430 lines:
> 
>  1 file changed, 251 insertions(+), 188 deletions(-)
> 
> ... your primary goal is faster code, we also want cleaner code. I 
> think we can meet in the middle, have faster _and_ cleaner code, and 
> it's a done deal ;)

I might. But the flux is "supposed" to just be moving things around so
it compiles better. Any behaviour change should be a bug.

So I definitely won't add any of these types of cleanups in the same
patch. And with or without cleanups, the patch should stand on its own
to get merged -- if it's good, it's good; if not, not :)
 
That, and, I don't really know the subtlties of this code or what
made it so tricky that such a cleanup wasn't done when merging the
two files.
