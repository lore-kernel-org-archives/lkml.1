Return-Path: <linux-kernel-owner+w=401wt.eu-S932372AbYBGRWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbYBGRWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbYBGRWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:22:44 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:39549 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693AbYBGRWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:22:43 -0500
Message-ID: <47AB3E5A.4060107@qualcomm.com>
Date: Thu, 07 Feb 2008 09:22:34 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] CPU isolation extensions
References: <47AA9807.7090402@qualcomm.com> <20080206215805.17a0c919.akpm@linux-foundation.org>
In-Reply-To: <20080206215805.17a0c919.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 06 Feb 2008 21:32:55 -0800 Max Krasnyansky <maxk@qualcomm.com> wrote:
> 
>> Linus, please pull CPU isolation extensions from
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/maxk/cpuisol-2.6.git for-linus
> 
> The feature as a whole seems useful, and I don't actually oppose the merge
> based on what I see here.  
Awesome :) I think it's get more and more useful as people will start trying
to figure out what the heck there is supposed to do with the spare CPU cores.
I mean pretty soon most machines will have 4 cores and some will have 8.
One way to use those cores is the "dedicated engine" model.  

> As long as you're really sure that cpusets are
> inappropriate (and bear in mind that Paul has a track record of being wrong
> on this :)).
I'll cover this in a separate email with more details.
  
> But I see a few glitches
Good catches. Thanks for reviewing.

> - There are two separate and identical implementations of
>   cpu_unusable(cpu).  Please do it once, in a header, preferably with C
>   function, not macros.

Those are local versions that depend whether a feature is enabled or not.
If CONFIG_CPUISOL_WORKQUEUE is disabled we want to cpu_unusable()
in the workqueue.c to be a noop, and if it's enabled that macro resolve to 
cpu_isolated(). 
Same thing for the stopmachine.c. If CONFIG_CPUISOL_STOPMACHIN is disabled
cpu_unusable() is a noop. 
In other words cpu_isolated() is the one common macro that subsystem may
want to stub out. 
Do you see another way of doing this ?

> - The Kconfig help is a bit scraggly:
> 
> +config CPUISOL_STOPMACHINE
> +	bool "Do not halt isolated CPUs with Stop Machine (HIGHLY EXPERIMENTAL)"
> +	depends on CPUISOL && STOP_MACHINE && EXPERIMENTAL
> +	help
> +          If this option is enabled kernel will not halt isolated CPUs when Stop Machine
> 
> "the kernel"
> 
> text is too wide
Got it. Will fix asap.
 
> +          is triggered.
> +          Stop Machine is currently only used by the module insertion and removal logic.
> +          Please note that at this point this feature is highly experimental and maybe
> +          dangerous. It is not known to really brake anything but can potentially 
> +          introduce an instability.
> 
> s/maybe/may be/
> s/brake/break/

Man, the typos are killing me :). Will fix.

> Neither this text, nor the changelog nor the code comments tell us what the
> potential instability with stopmachine *is*?  Or maybe I missed it.
That's the thing, we don't really know :). In real life does not seem to be a problem at all.
As I mentioned in prev emails. We've been running all kinds of machines with this enabled,
and inserting all kinds of modules left and right. Never seen any crashes or anything.
But the fact that stopmachine is supposed to halt all cpus during module insertion/removal
seems to imply that something bad may happen if some cpus are not halted. It may very well
turnout that it's no longer needed because our locking and refcounting handles this just fine.
I mean ideally we should not have to halt the entire box, it causes terrible latencies.
 
> - Adding new sysfs files without updating Documentation/ABI/ makes Greg cry.
Oh, did not know that. Will fix.

> 
> - Why is cpu_isolated_map exported to modules?  Just for api consistency, it appears?
Yes. For consistency. We'd want cpu_isolated() to work everywhere.
 
> pre-existing problems:
> 
> - isolated_cpu_setup() has an on-stack array of NR_CPUS integers.  This
>   will consume 4k of stack on ia64 (at least).  We'll just squeak through
>   for a ittle while, but this needs to be fixed.  Just move it into
>   __initdata.
Will do.
 
> - isolated_cpu_setup() expects that the user can provide an up-to-1024
>   character kernel boot parameter.  Is this reasonable given cpu command
>   line limits, and given that NR_CPUS will surely grow beyond 1024 in the
>   future?
I'm thinking that is reasonable for now.

I'll fix and resend the patches asap.

Thanx
Max
