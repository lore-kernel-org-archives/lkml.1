Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbZLJCwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbZLJCwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 21:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757843AbZLJCwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 21:52:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756418AbZLJCwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 21:52:37 -0500
Date: Wed, 9 Dec 2009 18:51:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912100018.19723.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912091835280.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912100018.19723.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Dec 2009, Rafael J. Wysocki wrote:
> 
> Completions it is, then.

What was so hard with the "Try the simple one first" to understand? You 
had a simpler working patch, why are you making this more complex one 
without ever having had any problems with the simpler one?

Btw, your 'atomic_set()' with errors is pure voodoo programming. That's 
not how atomics work. They do SMP-atomic addition etc, the 'atomic_set()' 
and 'atomic_read()' things are not in any way more atomic than any other 
access.

They are meant for racy reads (atomic_read()) and for initializations 
(atomic_set()), and the way you use them that 'atomic' part is entirely 
pointless, because it really isn't anything different from an 'int', 
except that it may be very very expensive on some architectures due to 
hashed spinlocks etc.

So stop this overdesign thing. Start simple. If you _ever_ see real 
problems, that's when you add stuff. As it is, any time you add 
complexity, you just add bugs.



> +/**
> + * dpm_synchronize - Wait for PM callbacks of all devices to complete.
> + */
> +static void dpm_synchronize(void)
> +{
> +	struct device *dev;
> +
> +	async_synchronize_full();
> +
> +	mutex_lock(&dpm_list_mtx);
> +	list_for_each_entry(dev, &dpm_list, power.entry)
> +		INIT_COMPLETION(dev->power.completion);
> +	mutex_unlock(&dpm_list_mtx);
> +}

And this, for example, is pretty disgusting. Not only is that 
INIT_COMPLETION purely brought on by the whole problem with completions 
(they are fundamentally one-shot, but you want to use them over and over 
so you need to re-initialize them: a nice lock wouldn't have that problem 
to begin with), but the comment isn't even accurate. Sure, it waits for 
any async jobs, but that's the _least_ of what the function actually does, 
so the comment is actively misleading, isn't it?

		Linus
