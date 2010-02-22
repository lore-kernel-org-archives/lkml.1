Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab0BVI2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 03:28:52 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:50906 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab0BVI2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 03:28:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=XJbNIwBZVBqzNfQnWOR3QgG6wzLB0jL7cwer4fq6yNuah85idnu58JTwN68xUte6mP
         nubskGWvaooJiB/0I4YEZkTFL9yXbbvUgAnoQUiXIoMX1yhT7SX2YF32zuJUFc8JqRoR
         4KB22LBwkqNNE7EBUT/p2MJj2PnzH1xVDJQrQ=
Date: Mon, 22 Feb 2010 09:28:40 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, tglx@linutronix.de,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-tip-commits@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Aristeu Rozanski <aris@redhat.com>, Doug Thompson <norsk5@yahoo.com>,
       Huang Ying <ying.huang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to
 mce_cpu_specific_poll
Message-ID: <20100222082840.GA3975@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
	linux-kernel@vger.kernel.org, andi@firstfloor.org,
	tglx@linutronix.de, Andreas Herrmann <andreas.herrmann3@amd.com>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	linux-tip-commits@vger.kernel.org,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Fr??d??ric Weisbecker <fweisbec@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Aristeu Rozanski <aris@redhat.com>,
	Doug Thompson <norsk5@yahoo.com>, Huang Ying <ying.huang@intel.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
References: <20100121221711.GA8242@basil.fritz.box>
 <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org>
 <20100123051717.GA26471@elte.hu>
 <20100123075851.GA7098@liondog.tnic>
 <20100123090003.GA20056@elte.hu>
 <20100124100815.GA2895@liondog.tnic>
 <20100216210215.GA9051@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100216210215.GA9051@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, Feb 16, 2010 at 10:02:15PM +0100
Hi,

> I like it.
> 
> You can do it as a 'perf hw' subcommand - or start off a fork as the 'hw' 
> utility, if you'd like to maintain it separately. It would have a daemon 
> component as well, to receive and log hardware events continuously, to 
> trigger policy action, etc.
> 
> I'd suggest you start to do it in small steps, always having something that 
> works - and extend it gradually.

I had the chance to meditate over the weekend a bit more on the whole
RAS thing after rereading all the discussion points more carefully.
Here are some aspects I think are important which I'd like to drop here
rather sooner than later so that we're in sync and don't waste time
implementing the wrong stuff:

* Critical errors: we need to switch to a console and dump decoded error
there at least, before panicking. Nowadays, almost everyone has a camera
with which that information can be extracted from the screen. I'm afraid
we won't be able to send the error over a network since climbing up the
TCP stack takes relatively long and we cannot risk error propagation...?
We could try to do it on a core which is not affected by the error
though as a last step in the sequence...

I think this is much more user-friendly than the current panicking
which is never seen when running X except when the user has a
serial/netconsole sending to some other machine.

All other non-that-critical errors are copied to userspace over a
mmapped buffer and then the uspace daemon is being poked with a uevent
to dump the error/signal over network/parse its contents and do policy
stuff.

* receive commands by syscall, also for hw config: I like the idea
of sending commands to the kernel over a syscall, we can reuse perf
functionality here and make those reused bits generic.

* do not bind to error format etc: not a big fan of slaving to an error
format - just dump error info into the buffer and let userspace format
it. We can do the formatting if we absolutely have to.

* can also configure hw: The tool can also send commands over the
syscall to configure certain aspects of the hardware, like:

- disable L3 cache indices which are faulty
- enable/disable MCE error sources: toggle MCi_CTL, MCi_CTL_MASK bits
- disable whole DIMMs: F2x[1, 0][5C:40][CSEnable]
- control ECC checking
- enable/disable powering down of DRAM regions for power savings
- set memory clock frequency
- some other relevant aspects of hw/CPU configuration

* keep all info in sysfs so that no tool is needed for accessing it,
similar to ftrace: All knobs needed for user interaction should appear
redundantly as sysfs files/dirs so that configuration/query can be done
"by hand" even when the hw tool is missing

* gradually move pieces of RAS code into kernel proper: important
codepaths/aspects from the HW which are being queried often (e.g., DIMM
population and config) should be moved gradually into the kernel proper.


Anyways, this is by all means not complete and still as alpha as it can
be. However, I'd like to discuss it as early as possble and in small,
incremental steps, omitting trial and error as much as possible. So,
feel free to throw all your crazy ideas at me and correct (or kill) all
those crappy points above.

Thanks.

-- 
Regards/Gruss,
    Boris.
