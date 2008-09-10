Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbYIJToZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbYIJToZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYIJToQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:44:16 -0400
Received: from gw.goop.org ([64.81.55.164]:58415 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbYIJToQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:44:16 -0400
Message-ID: <48C8238D.4080803@goop.org>
Date: Wed, 10 Sep 2008 12:44:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: TARGET_CPUS in assign_irq_vector
References: <48C6F913.1010509@goop.org>	<86802c440809091554y349366fdu8e4ca59797ab4205@mail.gmail.com>	<48C70ADC.8060004@goop.org>	<86802c440809091726y4db8f85eg2d478b482862c5f9@mail.gmail.com>	<48C719C0.6060201@goop.org> <m1zlmglcsc.fsf@frodo.ebiederm.org>
In-Reply-To: <m1zlmglcsc.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
>   
>> 3) give up because the idea is fundamentally ill-conceived, or 4)
>> something else?
>>     
>
> Yes.
>
> When working with event channels you should not have any
> truck with vectors and you should not call the architecture
> specific do_IRQ().

Hm.  That would work OK for fully paravirtualized domains, which have no
direct access to real hardware in any form (well, there's pci
passthough, but interrupts are all thoroughly massaged into event channels).

But for dom0, the kernel handles interrupts weird hybrid mode.  The
interrupts themselves are delivered via event channels rather than via a
local apic, but the IO APIC is still under the kernel's control, and is
responsible for poking (Xen-allocated) vectors into it.  This only
applies to physical irq event channels; there's no need to have vectors
for purely software event channels like interdomain, IPI and timers. 
This is further complicated by the fact that the dom0 kernel parses the
ACPI and MPTABLES to find out about IO APICs, so the existing APIC
subsystem is already involved.  I need to work out how'd I'd hook all
this together with a minimum of mess.

    J
