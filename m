Return-Path: <linux-kernel-owner+w=401wt.eu-S1757750AbZCaTVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbZCaTVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbZCaTU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:20:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34046 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbZCaTUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:20:55 -0400
Message-ID: <49D26CFE.1060700@redhat.com>
Date: Tue, 31 Mar 2009 22:20:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, anthony@codemonkey.ws, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 15/17] kvm: add dynamic IRQ support
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <20090331184405.28333.59205.stgit@dev.haskins.net>
In-Reply-To: <20090331184405.28333.59205.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> This patch provides the ability to dynamically declare and map an
> interrupt-request handle to an x86 8-bit vector.
>
> Problem Statement: Emulated devices (such as PCI, ISA, etc) have
> interrupt routing done via standard PC mechanisms (MP-table, ACPI,
> etc).  However, we also want to support a new class of devices
> which exist in a new virtualized namespace and therefore should
> not try to piggyback on these emulated mechanisms.  Rather, we
> create a way to dynamically register interrupt resources that
> acts indepent of the emulated counterpart.
>
> On x86, a simplistic view of the interrupt model is that each core
> has a local-APIC which can recieve messages from APIC-compliant
> routing devices (such as IO-APIC and MSI) regarding details about
> an interrupt (such as which vector to raise).  These routing devices
> are controlled by the OS so they may translate a physical event
> (such as "e1000: raise an RX interrupt") to a logical destination
> (such as "inject IDT vector 46 on core 3").  A dynirq is a virtual
> implementation of such a router (think of it as a virtual-MSI, but
> without the coupling to an existing standard, such as PCI).
>
> The model is simple: A guest OS can allocate the mapping of "IRQ"
> handle to "vector/core" in any way it sees fit, and provide this
> information to the dynirq module running in the host.  The assigned
> IRQ then becomes the sole handle needed to inject an IDT vector
> to the guest from a host.  A host entity that wishes to raise an
> interrupt simple needs to call kvm_inject_dynirq(irq) and the routing
> is performed transparently.
>   

A major disadvantage of dynirq is that it will only work on guests which 
have been ported to it.  So this will only be useful on newer Linux, and 
will likely never work with Windows guests.

Why is having an emulated PCI device so bad?  We found that it has 
several advantages:
 - works with all guests
 - supports hotplug/hotunplug, udev, sysfs, module autoloading, ...
 - supported in all OSes
 - someone else maintains it

See also the kvm irq routing work, merged into 2.6.30, which does a 
small part of what you're describing (the "sole handle" part, specifically).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

