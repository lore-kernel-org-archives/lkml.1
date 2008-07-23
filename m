Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbYGWXhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbYGWXhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 19:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbYGWXhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:37:36 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:38172 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755049AbYGWXhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:37:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iwDuFdReT+yrOs9BEj8j4hxWYbIZMX+uHNif6OW4UrwNTnyyP+tF8Hm8u/ufkVvNfEfAUfbM1wikNP/kkFYmUK69Je8MX3Vwyigbb6F+EuGf9IHKCG8IPvHXrhkWz3pF9g7l1oa+F7zKG6ODzCLjkyY/h4G95dx9EGNLz2zoSVw=  ;
X-YMail-OSG: f8BZCqUVM1np9PeC2jAkAE4INquXmMsTzsEoTTiP5QVo.FrOgfYHcFuQD20WhJ_IjLpuEU0HoMBdGnQ3xlT9EJEy3hk7Vz.5_HK_evycEy4YtgXq.slgzlB1knzCmCo-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [USB boot crash, -git] ecm_do_notify(), list_add corruption. prev->next should be next (ffff88003b8f82f8)
Date: Wed, 23 Jul 2008 16:37:32 -0700
User-Agent: KMail/1.9.9
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20080721223038.GA2051@suse.de> <20080722134042.GA14315@elte.hu>
In-Reply-To: <20080722134042.GA14315@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807231637.33009.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008, Ingo Molnar wrote:
> 
> hi Greg, David,
> 
> -tip randconfig boot testing just found this USB boot crash regression:

Which I can reproduce with "dummy_hcd" (an emulator) but not
using a real peripheral controller driver ... using i386,
not x86_64 as you did, fwiw.

So far, the fingers point at dummy_hcd... the merge doesn't
seem to have had problems, and the gadget driver had been
tested with four different peripheral controller drivers
(pre-merge).

I'll give it a look on something with a serial console ... doing
it on a PC is useless, since the list debug stuff does a BUG()
which renders the machine unusable even if I could read more than
20 lines of data on the screen.  :(

 
> dummy_udc dummy_udc: enabled ep-a (ep1in-bulk) maxpacket 512
> dummy_udc dummy_udc: enabled ep-b (ep2out-bulk) maxpacket 512

Was that all that it told you about?  If it was telling you it
enabled those two, it *should* have previously told you it was
enabling ep-c and ep-d (also maxpacket 512) also ep-e and ep-f
(maxpacket 16 and 8, respectively, I'd think).

What it was doing here:  The host side enumerated this (emulated)
device, activated altsetting with data (and hence ep-a and ep-b),
and the peripheral side then issued a link state notification.

But the link state notification (probably using ep-e) message
couldn't be queued (list_add_tail) because of this oopsing:


> usb0: qlen 10
> g_cdc gadget: notify connect false
> list_add corruption. prev->next should be next (ffff88003b8f82f8), but was ffff88003b8f8e80. (prev=ffff88003b8f8e80).

Now, prev->next == prev is expected here:  that list of messages
should be empty.

What's wrong is that head->prev != head, meaning something
trashed a dummy_hcd data structure.


> ------------[ cut here ]------------
> kernel BUG at lib/list_debug.c:33!
> invalid opcode: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
> 	...
> Call Trace:
>  <IRQ>  [<ffffffff8073de15>] dummy_queue+0xd5/0x1d0
>  [<ffffffff8073f3b6>] ecm_do_notify+0x116/0x1f0

I tried this on the "real hardware" (net2280) being emulated
in this case by this "dummy" driver, and it works just fine
with list debugging enabled.  And I've used it with three
other flavors of "real hardware" (though not yet with the
latest kernel GIT), so I suspect it'll continue to work there.


My first reaction is to think this must be an issue with the
"dummy_hcd" code, since that's actually the proximate location
of the oops.  I sanity checked the relevant ECM logic, and
it looks OK at first glance.  (As I'd expect, since it already
worked with four different controller drivers!)


>  [<ffffffff8073f4a5>] ecm_notify+0x15/0x20
>  [<ffffffff8073f851>] ecm_set_alt+0x111/0x1d0
>  [<ffffffff807418d7>] composite_setup+0x127/0x900
>  [<ffffffff80261136>] ? lock_release_holdtime+0x66/0x80
>  [<ffffffff8073d31b>] ? dummy_timer+0x65b/0xac0
>  [<ffffffff8073ccc0>] ? dummy_timer+0x0/0xac0
>  [<ffffffff8073d334>] dummy_timer+0x674/0xac0
>  [<ffffffff8073ccc0>] ? dummy_timer+0x0/0xac0
>  [<ffffffff80248c7b>] run_timer_softirq+0x1db/0x250
>  [<ffffffff80244936>] __do_softirq+0x66/0xd0
>  [<ffffffff8020ce8c>] call_softirq+0x1c/0x30
>  [<ffffffff8020f7a5>] do_softirq+0x45/0x80
>  [<ffffffff802447d5>] irq_exit+0xa5/0xb0
>  [<ffffffff8021ce0d>] smp_apic_timer_interrupt+0x8d/0xd0
>  [<ffffffff8020c8d6>] apic_timer_interrupt+0x66/0x70
>  	...
> Kernel panic - not syncing: Fatal exception in interrupt
> Pid: 0, comm: swapper Tainted: G      D   2.6.26-tip-06162-g2ef4b1e-dirty #13411
>     
> With this config:
>     
>    http://redhat.com/~mingo/misc/config-Tue_Jul_22_13_44_45_CEST_2008.bad
>     
> i tried to do a blind revert of da741b8c5 ("usb ethernet gadget: split 
> CDC Ethernet function") where this crash originates from - but the 
> resulting kernel would not build. (it has followup dependencies)

Right.  These updates are arguably overdue:  factoring the
individual functions out from each other.  The Ethernet gadget
code had three (!) separate protocol stacks, each of which now
lives in its own file as does the core they shared.

So reverting them would be the wrong solution in any case.

- Dave
