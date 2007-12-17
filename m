Return-Path: <linux-kernel-owner+w=401wt.eu-S936506AbXLQWG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936506AbXLQWG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761497AbXLQWGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:06:47 -0500
Received: from www.tglx.de ([62.245.132.106]:51658 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761180AbXLQWGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:06:46 -0500
Date: Mon, 17 Dec 2007 23:05:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Parag Warudkar <parag.warudkar@gmail.com>
cc: Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
In-Reply-To: <82e4877d0712170508r69189409l803c8f490e65925d@mail.gmail.com>
Message-ID: <alpine.LFD.0.99999.0712172208500.3670@localhost.localdomain>
References: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>  <alpine.LFD.0.99999.0712101117300.11977@localhost.localdomain>  <82e4877d0712102049g4830a573n86b7f72f31a42f11@mail.gmail.com>  <200712141817.47581.lenb@kernel.org> 
 <82e4877d0712141651j3965fd85ged2cefed5336e1ef@mail.gmail.com>  <alpine.LFD.0.99999.0712150907180.6933@localhost.localdomain>  <Pine.LNX.4.64.0712151340060.3807@mini.warudkars.net>  <Pine.LNX.4.64.0712160015020.7320@mini.warudkars.net> 
 <82e4877d0712160543t2c7a03b1qb5c77ea6af59b5dd@mail.gmail.com>  <alpine.LFD.0.99999.0712170904120.3670@localhost.localdomain> <82e4877d0712170508r69189409l803c8f490e65925d@mail.gmail.com>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007, Parag Warudkar wrote:
> On Dec 17, 2007 3:05 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Sigh. You did not have the debug patch applied anymore, which printks
> > the timer_list data ? Can you apply it again and provide the output
> > please ?
> >
> 
> This keeps getting more and more weird - This time I was running with
> CONFIG_CPU_IDLE=N and I have ton of soft lockups after 14hr uptime.

It's more than weird.
 
> now at 39080147128907 nsecs

>   .idle_entrytime : 39080384013047 nsecs

The time, when we entered idle on CPU#0 is in the future. 

>   .tick_stopped   : 0

But the tick is not stopped, that means CPU#0 has work to do

On CPU#1 idle entry just happened:

>   .idle_entrytime : 39079996603653 nsecs

> now at 40490254040892 nsecs

>   .idle_entrytime : 40490492012833 nsecs

Again, idle_entry on CPU#0 is in the future.

On CPU#1 the idle entry was at: 
>   .idle_entrytime : 40489996578090 nsecs

which means: 0.257462802 sec. ago

> now at 40700144217096 nsecs

Aarg. On CPU#0 this is consistently in the future:

>   .idle_entrytime : 40700372012887 nsecs

I'm really confused.

>   .idle_entrytime : 40699996620694 nsecs
>   .idle_sleeptime : 40540536046589 nsecs
>   .last_jiffies   : 10100000
>   .next_jiffies   : 10100467
>   .idle_expires   : 40701864000000 nsecs
> jiffies: 10100158
> 
> 
> Tick Device: mode:     1
> Clock Event Device: hpet
>  max_delta_ns:   2147483647
>  min_delta_ns:   3352
>  mult:           61496110
>  shift:          32
>  mode:           3
>  next_event:     40700692000000 nsecs
>  set_next_event: hpet_legacy_next_event
>  set_mode:       hpet_legacy_set_mode
>  event_handler:  tick_handle_oneshot_broadcast
> tick_broadcast_mask: 00000003

Here is the next inconsistent data:

> tick_broadcast_oneshot_mask: 00000003

CPU#1 just woke up. That means the broadcast oneshot mask must be
cleared for CPU#1.

Some real strange thing is going on in your box.

I try to come up with some more debug patches tomorrow.

      tglx
