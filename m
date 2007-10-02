Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbXJBEej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbXJBEej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 00:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbXJBEeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 00:34:31 -0400
Received: from 1wt.eu ([62.212.114.60]:2759 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbXJBEeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 00:34:31 -0400
Date: Tue, 2 Oct 2007 06:34:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch and kernel/sched.c
Message-ID: <20071002043408.GM10199@1wt.eu>
References: <20070928105345.GC18163@shadowen.org> <20071001064448.GA4239@elte.hu> <20071001003007.4e90143b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001003007.4e90143b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 12:30:07AM -0700, Andrew Morton wrote:
> On Mon, 1 Oct 2007 08:44:48 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > (lkml Cc:-ed - this might be of interest to others too)
> > 
> > * Andy Whitcroft <apw@shadowen.org> wrote:
> > 
> > > WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> > > #411: FILE: home/apw/git/linux-2.6/kernel/sched.c:408:
> > > +EXPORT_SYMBOL_GPL(cpu_clock);
> > 
> > yes, this is a legit warning and i fix it every time i see it. (I cannot 
> > fix this one now because mainline does not have an EXPORT_SYMBOL_GPL for 
> > cpu_clock(), it's added in -mm? But i cannot find it in mm either. I'll 
> > fix it once i find the patch :)
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/broken-out/make-rcutorture-rng-use-temporal-entropy.patch
> 
> > > WARNING: printk() should include KERN_ facility level
> > > #4838: FILE: home/apw/git/linux-2.6/kernel/sched.c:4835:
> > > +	printk("%-13.13s %c", p->comm,
> > > 
> > > WARNING: printk() should include KERN_ facility level
> > > #5622: FILE: home/apw/git/linux-2.6/kernel/sched.c:5619:
> > > +				printk("\n");
> > > 
> > > WARNING: printk() should include KERN_ facility level
> > > #5633: FILE: home/apw/git/linux-2.6/kernel/sched.c:5630:
> > > +				printk("\n");
> > > 
> > > WARNING: printk() should include KERN_ facility level
> > > #5640: FILE: home/apw/git/linux-2.6/kernel/sched.c:5637:
> > > +			printk(" %s", str);
> > > 
> > > These are actually only in debug code and so are unimportant, but 
> > > technically they are wrong.  This check is a very difficult one in the 
> > > face of these constructs.  But in this case I think it has got the 
> > > report right.
> > 
> > this is actually a false positive - as the debug code constructs a 
> > printk output _without_ \n. So the script should check whether there's 
> > any \n in the printk string - if there is none, do not emit a warning. 
> > (if you implement that then i think it can remain a warning and does not 
> > need to move to CHECK.)
> 
> Yeah, it does that sometimes.  I don't think it's fixable within the scope
> of checkpatch.  It needs to check whether some preceding printk which might
> not even be in the patch has a \n:
> 
> 	printk(KERN_ERR "foo");
> 	<100 lines of whatever>
> +	printk("bar\n");
> 
> we're screwed...

Well, I think that we could do something like this :

#define KERN_CONT ""
...
	printk(KERN_ERR "foo");
	<100 lines of whatever>
	printk(KERN_CONT "bar\n");

It would indicate the author's *intent* which is to continue a line which
has already been started. It would both permit us to remove false positives
from automated scripts, and to read the code more easily. And this is not a
big constaint for the author, given that such constructs are quite rare.

Regards,
Willy

