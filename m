Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbXJIRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbXJIRTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbXJIRTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 13:19:09 -0400
Received: from barikada.upol.cz ([158.194.242.200]:46665 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbXJIRTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 13:19:08 -0400
Date: Tue, 9 Oct 2007 19:33:17 +0200
To: "LKML (Cc removed)" <linux-kernel@vger.kernel.org>
Subject: coding for optimizations (Re: [PATCH 1/2] i386: mce cleanup part1: functional change)
Message-ID: <20071009173317.GD22435@flower.upol.cz>
References: <11919341961890-git-send-email-joerg.roedel@amd.com> <11919341961530-git-send-email-joerg.roedel@amd.com> <E1IfHZg-0003dp-FA@flower> <20071009160605.GC13205@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009160605.GC13205@amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 06:06:05PM +0200, Joerg Roedel wrote:
> > >  void mcheck_init(struct cpuinfo_x86 *c)
> > >  {
> > > +	uint32_t mca, mce;
> > > +
> > >  	if (mce_disabled==1)
> > >  		return;
> > >  
> > > +	mca = cpu_has(c, X86_FEATURE_MCA);
> > > +	mce = cpu_has(c, X86_FEATURE_MCE);
> > > +
> > > +	if (!mca || !mce) {
> > > +		printk(KERN_INFO "CPU%i: No machine check support available\n",
> > > +			smp_processor_id());
> > > +		return;
> > > +	}
> > > +
> > 
> > cpu_has() returns int,
> > but would it be better to have something like
> > 
> >   	if (!mce_disabled &&
> > 	    !(c->x86_capability & (X86_FEATURE_MCA | X86_FEATURE_MCE)) {
> > 		printk(KERN_INFO "CPU%i: No machine check support available\n",
> > 			smp_processor_id());
> 
> This looks complicated and is harder to read. Its exactly the purpose of the
> cpu_has() macro to avoid such constructs.
> 
> > 		return;
> > 	} else
> > 		return;
> 
> Return unconditionaly here?

Kind of typo.

Due to arch code, i think, it must be coded in non-gcc optimistic way. As
practice and Linus shows, gcc's optimizations sometimes produce very
unexpected results. People do spaghetti-like coding, without thinking
about text size / run time.

Compile time payment was noted by Andrew many years ago:

"As you know, I'd be more concerned about moves to drop support for the
older and much faster gcc versions.  If you're not using egcs-1.1.2,
you're already a very patient person." <http://lkml.org/lkml/2001/12/29/163>

So, i actually wanted to write this:

	if (!mce_disabled) {
	if (!(c->x86_capability & (X86_FEATURE_MCA | X86_FEATURE_MCE)) {
		printk(KERN_INFO "CPU%i: No machine check support available\n",
 			smp_processor_id());
		return;
	}
	/* function code */
	}

(ugly, because `mce_disabled == 1' check is even in gcc is likely by
default). But changed my mind, due to violation of the coding style.
Of course this my be no appropriate at all, but i'd like to bring
this, if anyone would be like to discuss this.
____
