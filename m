Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbZLWQc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbZLWQc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 11:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756465AbZLWQcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 11:32:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751221AbZLWQcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 11:32:25 -0500
Date: Wed, 23 Dec 2009 08:31:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mark Hounschell <markh@compro.net>
cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, Alain Knaff <alain@knaff.lu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28 (Was:
 Re: Cannot format floppies under kernel 2.6.*?)
In-Reply-To: <4B32386B.2060509@compro.net>
Message-ID: <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain>
References: <4AFB3962.2020106@ntlworld.com> <4B2B4485.6000305@cfl.rr.com>  <4B2B5F86.1090403@cfl.rr.com>  <alpine.LFD.2.00.0912180716400.3712@localhost.localdomain>  <4B2B9F9F.7040802@compro.net>  <alpine.LFD.2.00.0912180734220.3712@localhost.localdomain> 
 <4B2BE05B.9050006@compro.net>  <alpine.LFD.2.00.0912181213540.3712@localhost.localdomain>  <4B30E1B4.7000702@compro.net>  <alpine.LFD.2.00.0912220922250.31313@localhost.localdomain>  <4B310879.9050701@compro.net> <1261525076.16916.4.camel@localhost.localdo
 main> <4B3162BC.9000508@cfl.rr.com> <4B3214EC.6020308@compro.net> <6598A4E21F1DB24D80BF72956484F59802EFD1C6@orsmsx001.amr.corp.intel.com> <4B32386B.2060509@compro.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Dec 2009, Mark Hounschell wrote:
> > 
> > Hmm. Looks like hpet2 is still getting used instead of local APIC 
> > timer in .28 case.
> > 
> > I was expecting some low number in hpet2 and local timer on all CPU to 
> > be around the same value. Above shows CPU 0 is depending on hpet2 for 
> > some reason even with idle=halt. Can you send the output of below two 
> > in case of .28 /proc/timer_list
> 
> Attached.

Oh wow.

That's crazy:

	Tick Device: mode:     1
	Per CPU device: 0
	Clock Event Device: hpet2
	 max_delta_ns:   2147483647
	 min_delta_ns:   5000
	 mult:           61510047
	 shift:          32
	 mode:           3
	 next_event:     123991000000 nsecs
	 set_next_event: hpet_msi_next_event
	 set_mode:       hpet_msi_set_mode
	 event_handler:  hrtimer_interrupt
	
	Tick Device: mode:     1
	Per CPU device: 1
	Clock Event Device: lapic
	 max_delta_ns:   670831998
	 min_delta_ns:   1199
	 mult:           53707624
	 shift:          32
	 mode:           3
	 next_event:     123991125000 nsecs
	 set_next_event: lapic_next_event
	 set_mode:       lapic_timer_setup
	 event_handler:  hrtimer_interrupt

	...

It's not using the lapic for CPU0. 

Using the HPET as a per-cpu timer is some crazy sh*t, since it's pretty 
expensive to reprogram (compared to the local apic). And having different 
timers for different CPU's is just odd.

The fact that the timer subsystem can do this and it all (mostly) works at 
all is nice and impressive, but doesn't make it any less crazy ;)

That said, none of this seems to explain why DMA/fdformat doesn't work.

			Linus
