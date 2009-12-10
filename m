Return-Path: <linux-kernel-owner+w=401wt.eu-S1761638AbZLJTjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761638AbZLJTjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761435AbZLJTj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:39:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59783 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004AbZLJTj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:39:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Thu, 10 Dec 2009 20:40:10 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912100018.19723.rjw@sisk.pl> <alpine.LFD.2.00.0912091835280.3560@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912091835280.3560@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912102040.11063.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 December 2009, Linus Torvalds wrote:
> 
> On Thu, 10 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > Completions it is, then.
> 
> What was so hard with the "Try the simple one first" to understand? You 
> had a simpler working patch, why are you making this more complex one 
> without ever having had any problems with the simpler one?

OK, why don't you just say you won't merge anything that doesn't use rwsems
(although you said before that completions would be fine with you)?  That would
make things clear, but also it would mean we gave up handling the off-tree
dependencies in general.

> Btw, your 'atomic_set()' with errors is pure voodoo programming. That's 
> not how atomics work. They do SMP-atomic addition etc, the 'atomic_set()' 
> and 'atomic_read()' things are not in any way more atomic than any other 
> access.
>
> They are meant for racy reads (atomic_read()) and for initializations 
> (atomic_set()), and the way you use them that 'atomic' part is entirely 
> pointless, because it really isn't anything different from an 'int', 
> except that it may be very very expensive on some architectures due to 
> hashed spinlocks etc.
> 
> So stop this overdesign thing. Start simple. If you _ever_ see real 
> problems, that's when you add stuff. As it is, any time you add 
> complexity, you just add bugs.

OK, so that need not be atomic.
 
> > +/**
> > + * dpm_synchronize - Wait for PM callbacks of all devices to complete.
> > + */
> > +static void dpm_synchronize(void)
> > +{
> > +	struct device *dev;
> > +
> > +	async_synchronize_full();
> > +
> > +	mutex_lock(&dpm_list_mtx);
> > +	list_for_each_entry(dev, &dpm_list, power.entry)
> > +		INIT_COMPLETION(dev->power.completion);
> > +	mutex_unlock(&dpm_list_mtx);
> > +}
> 
> And this, for example, is pretty disgusting. Not only is that 
> INIT_COMPLETION purely brought on by the whole problem with completions 
> (they are fundamentally one-shot, but you want to use them over and over

Actually, twice.  However, since I don't want to do any async handling in the
_noirq phases any more, I can get rid of this whole function.  Thanks for
pointing that out to me.

Rafael
