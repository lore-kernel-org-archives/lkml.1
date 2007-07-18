Return-Path: <linux-kernel-owner+w=401wt.eu-S933750AbXGRQxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750AbXGRQxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbXGRQw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:52:58 -0400
Received: from mis011-1.exch011.intermedia.net ([64.78.21.128]:34000 "EHLO
	mis011-1.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278AbXGRQw6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:52:58 -0400
X-Greylist: delayed 973 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jul 2007 12:52:57 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [RFC] Deferred interrupt handling.
Date: Wed, 18 Jul 2007 09:36:39 -0700
Message-ID: <64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net>
In-Reply-To: <20070718123040.615795b7@the-village.bc.nu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [RFC] Deferred interrupt handling.
Thread-Index: AcfJLieG+NZC5IVUTXOEodgBKgotFwAKNtOg
References: <005901c7c921$79c006c0$6d401440$@com> <20070718123040.615795b7@the-village.bc.nu>
From: "Dor Laor" <dor.laor@qumranet.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Or Sagi" <ors@tutis.com>
Cc: <kvm-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Jul 2007 16:36:44.0078 (UTC) FILETIME=[D37C9CE0:01C7C959]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> In particular, this requires interrupt handling to be done by the
>guest --
>> The host shouldn't load the corresponding device driver or otherwise
>access
>> the device. Since the host kernel is not aware of the device
semantics
>it
>> cannot acknowledge the interrupt at the device level.
>
>Tricky indeed.
>
>> As far as the host kernel is concerned the VM is a user level
process.
>We
>> require the ability to forward interrupt handling to such entities.
>The
>> current kernel interrupt handling path doesn't allow deferring
>interrupt
>> handling _and_ acknowledgement.
>
>We don't support this model at all, and it doesn't appear to work
>anyway.
>
>> 0. Adding an IRQ_DEFERRED mechanism to the interrupt handling path.
>ISRs
>> returning IRQ_DEFERRED will keep the interrupt masked until future
>> acknowledge.
>
>Deadlock. If you get an IRQ for a guest and you block the IRQ until the
>guest handles it you may (eg if the IRQ is shared) get priority
>inversion
>with another interrupt source on the same line the guest requires first
>(eg disks and other I/O)

What if we will force the specific device to the end of the list. Once
IRQ_NONE was returned by the other devices, we will mask the irq,
forward the irq to the guest, issue a timer for 1msec. Motivation:
1msec is long enough for the guest to ack the irq + host unmask the irq
+
cancell the timer. (ping round-trip for a guest is about 100msec)
If the timer poped, it will unmask irqs + run over the device list to
check
whether one of them has a pending irq.

This will solve the deadlock possiblity in a small price of potential
latency.

...

>> Any ideas ? Thoughts ?
>
>Mask the interrupt in the main kernel, pass an event of some kind to
the
>guest. You can describe most devices from guest to kernel in a safe
form
>as
>
>device, bar, offset, register size, mask, bits to set, bits to clear
>
>(or bits to test when deciding if it is the irq source)
>

The problem is that each device has its own bits and it cannot be a
general solution.
Except that the device driver inside the guest should be changed because
the host already
disabled the irq/status for them.


I know the above solution in not neat but we do want to contribute it.
Any other ideas are welcome,
10x, Dor.
