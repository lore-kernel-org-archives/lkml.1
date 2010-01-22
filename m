Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480Ab0AVVXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab0AVVXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 16:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337Ab0AVVXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 16:23:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41048 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217Ab0AVVXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 16:23:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] PM: disable nonboot cpus before suspending devices
Date: Fri, 22 Jan 2010 22:24:37 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <alpine.LFD.2.00.1001221841490.2266@localhost> <201001222148.23945.rjw@sisk.pl>
In-Reply-To: <201001222148.23945.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001222224.37748.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 January 2010, Rafael J. Wysocki wrote:
> On Friday 22 January 2010, Sebastian Ott wrote:
> > hi Rafael,
> > 
> > on s390 we have a reproduceable testcase where, after all devices were
> > suspended, a memory allocation results in disk IO. I know that this is
> > similar to the current discussion about magically changing the gpf mask,
> > but in our case the related allocation is triggered not by a device driver
> > but directly by hibernation_snapshot. The call chain looks like this:
> > 
> > STACK:
> >  0 schedule+1796 [0x5a7af0]
> >  1 io_schedule+98 [0x5a82ce]
> >  2 sync_page_killable+4 [0x1ec424]
> >  3 __wait_on_bit+204 [0x5a8bc4]
> >  4 add_to_page_cache_locked+2 [0x1ec766]
> >  5 shrink_page_list+2372 [0x1fc5b0]
> >  6 shrink_list+2496 [0x1fd02c]
> >  7 shrink_zone+932 [0x1fd3e0]
> >  8 try_to_free_pages+668 [0x1fe4bc]
> >  9 __alloc_pages_nodemask+1346 [0x1f5056]
> > 10 __get_free_pages+76 [0x1f52dc]
> > 11 __build_sched_domains+60 [0x144f98]
> > 12 partition_sched_domains+696 [0x145dcc]
> > 13 update_sched_domains+100 [0x146104]
> > 14 notifier_call_chain+166 [0x5ae112]
> > 15 raw_notifier_call_chain+44 [0x1800c4]
> > 16 _cpu_down+586 [0x59f212]
> > 17 disable_nonboot_cpus+354 [0x155ad2]
> > 18 hibernation_snapshot+324 [0x1a7938]
> > 19 hibernate+304 [0x1a7bcc]
> > 20 state_store+130 [0x1a645e]
> > 21 sysfs_write_file+264 [0x2b551c]
> > 22 vfs_write+190 [0x23f98a]
> > 23 sys_write+100 [0x23fb50]
> > 24 sysc_noemu+16 [0x118ff6]
> > 
> > a possible fix would be to call disable_nonboot_cpus before suspending the
> > devices..
> 
> This is going against the changes attempting to speed-up suspend and resume,
> such as the asynchronous suspend/resume patchset, so I don't agree with it.

In fact there's more to it.

enable_nonboot_cpus() has to be called before suspend_ops->wake() (and
analogously for hibernation), because of some ACPI-related ordering constraints
(calling them in the reverse orther leads to _serious_ problems during resume).

In turn, suspend_ops->wake() should be called before we resume devices, for
similar reasons.

So, your patch really would break things.

Rafael
