Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbXFLRwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbXFLRwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 13:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXFLRw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 13:52:28 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:49025 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbXFLRw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 13:52:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=afqdAIkdRcGMNc0MzfSJB348nIdG9XIv0bfEQZtmtNZpHt5wq66qpLwdHrDFn3UHgacVKlUNjKTDtJ0if1TuCix/RQymaJoJV1oc24GEoYBxQWd0xZ8unNhwCjwRvex87dQOufM9Nvds2kRVy0/3F65o5puXmFm1x5NoGByOpbY=
Date: Tue, 12 Jun 2007 19:52:46 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
Message-ID: <20070612175246.GA5864@dreamland.darkstar.lan>
References: <20070603213432.GA3075@dreamland.darkstar.lan> <4663DCE9.3000107@qumranet.com> <20070604202248.GA18668@dreamland.darkstar.lan> <46647B3E.2090205@qumranet.com> <20070604212207.GA22365@dreamland.darkstar.lan> <46651069.5040003@qumranet.com> <68676e00706071216i4bd051c5hb1c114f3c13ab97f@mail.gmail.com> <466BED18.5040708@qumranet.com> <68676e00706101354n5fe7e1a9y12cb690cae2924e3@mail.gmail.com> <466CFD6D.2080201@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <466CFD6D.2080201@qumranet.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Mon, Jun 11, 2007 at 10:44:45AM +0300, Avi Kivity ha scritto: 
> Luca wrote:
> >>
> >>I've managed to reproduce this on kvm-21 (it takes many boots for this
> >>to happen, but it does eventually).
> >
> >Hum, any clue on the cause? 
> 
> From what I've seen, it's the new Linux clocksource code.
> 
> >Should I test older versions?
> 
> They're unlikely to be better.  Instead, it would be best to see what 
> the guest is doing.

RCU is not working. Network initialization hangs because it happens to
be the first RCU user.
The guest is stuck waiting for RCU syncronization:

[    4.992207]  [<c04321c5>] synchronize_rcu+0x4e/0x80
[    4.994379]  [<c0431db5>] wakeme_after_rcu+0x0/0x8
[    4.996521]  [<c0599ad1>] synchronize_net+0x64/0x8c
[    4.998678]  [<c05d70e0>] inet_register_protosw+0xef/0x151
[    5.000984]  [<c072d79e>] inet_init+0x1cd/0x498

wait_for_completion() in synchronize_rcu() calls schedule() and the
completion is never signaled (wakeme_after_rcu is never called).
The completion AFAICS would be signaled via rcu_process_callbacks(),
which is called in tasklet context.
Scheduler and completion are working fine since they're used in other
part of the kernel without problems.

To recap:

i686 F7 kernel: always works.

i586 F7 kernel: sometime hangs due to RCU problems. When it does work
it's because the LAPIC is disabled on boot:

Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 25745109
... PM timer delta = 0
..... delta 25745109
..... mult: 1105912110
..... calibration result: 4119217
..... CPU clock speed is 8794.0417 MHz.
..... host bus clock speed is 4119.0217 MHz.
... verify APIC timer
... jiffies delta = 103
APIC timer disabled due to verification failure.

When it doesn't work LAPIC passes the test:

[    1.304717] Using local APIC timer interrupts.
[    1.304719] calibrating APIC timer ...
[    1.718823] ... lapic delta = 25251444
[    1.720582] ... PM timer delta = 0
[    1.722219] ..... delta 25251444
[    1.723827] ..... mult: 1084706136
[    1.725470] ..... calibration result: 4040231
[    1.727374] ..... CPU clock speed is 8625.0780 MHz.
[    1.729396] ..... host bus clock speed is 4040.0231 MHz.
[    1.731540] ... verify APIC timer
[    2.158342] ... jiffies delta = 102
[    2.160035] ... jiffies result ok

i586 F7 kernel, with 'nolapic': always works.

Luca
-- 
Sbagliare è umano, ma per incasinare davvero le cose serve un computer.
