Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZIXDwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZIXDwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 23:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZIXDwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 23:52:09 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39213 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbZIXDwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 23:52:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Sep 2009 12:50:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: ngupta@vflare.org
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH RFC 1/2] Add notifiers for various swap events
Message-Id: <20090924125000.d734a7b1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4ABAE340.7010403@vflare.org>
References: <1253540040-24860-1-git-send-email-ngupta@vflare.org>
	<20090924104708.4f54ce4e.kamezawa.hiroyu@jp.fujitsu.com>
	<4ABAE340.7010403@vflare.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 08:40:56 +0530
Nitin Gupta <ngupta@vflare.org> wrote:

> On 09/24/2009 07:17 AM, KAMEZAWA Hiroyuki wrote:
> > On Mon, 21 Sep 2009 19:03:59 +0530
> > Nitin Gupta <ngupta@vflare.org> wrote:
> > 
> >> Add notifiers for following swap events:
> >>  - Swapon
> >>  - Swapoff
> >>  - When a swap slot is freed
> >>
> >> This is required for ramzswap module which implements RAM based block
> >> devices to be used as swap disks. These devices require a notification
> >> on these events to function properly (as shown in patch 2/2).
> >>
> >> Currently, I'm not sure if any of these event notifiers have any other
> >> users. However, adding ramzswap specific hooks instead of this generic
> >> approach resulted in a bad/hacky code.
> >>
> > Hmm ? if it's not necessary to make ramzswap as module, for-ramzswap-only
> > code is much easier to read..
> >
> 
> The patches posted earlier (v3 patches) inserts special hooks for swap slot
> free event only. In this version, the callback is set when we get first R/W request.
> Actually ramzswap needs callback for swapon/swapoff too but I just didn't do it.
> 
> Then Pekka posted test patch that allows setting this callback during swapon
> itself. Looking that all these patches, I realized its already too messy even
> if we just make everything ramzswap specific.
> Just FYI, Pekka's test patch:
> http://patchwork.kernel.org/patch/48472/
> 
> Then I added this generic notifier interface which, compared to earlier version,
> looks much cleaner. The code to add these notifiers is also very small.
>  
ya, yes. the patch itsels seems clean.

> > 
> > 
> >> For SWAP_EVENT_SLOT_FREE, callbacks are made under swap_lock. Currently, this
> >> is not a problem since ramzswap is the only user and the callback it registers
> >> can be safely made under this lock. However, if this event finds more users,
> >> we might have to work on reducing contention on this lock.
> >>
> >> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> >>
> > 
> > In general, notifier chain codes allowed to return NOTIFY_BAD.
> > But this patch just assumes all chains should return NOTIFY_OK or
> > just ignore return code.
> > 
> > That's not good as generic interface, I think.
> 
> 
> What action we can take here if the notifier_call_chain() returns an error (apart
> from maybe printing an error)? Perhaps we can add a warning in case of swapon/off
> events but not in case of swap slot free event which is called under swap_lock.
> 
If return code is ignored, please add commentary at least.

I wonder I may able to move memcg's swap_cgroup code for swapon/swapoff onto this
notifier. (swap_cgroup_swapon/swap_cgroup_swapoff) But it seems not.
sorry for bothering you.

Thanks,
-Kame


> 
> 
> Thanks,
> Nitin
> 

