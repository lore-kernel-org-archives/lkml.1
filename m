Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbYDYET3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbYDYET3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 00:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYDYETV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 00:19:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49792
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750763AbYDYETV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 00:19:21 -0400
Date: Thu, 24 Apr 2008 21:19:19 -0700 (PDT)
Message-Id: <20080424.211919.151832765.davem@davemloft.net>
To: rdreier@cisco.com
Cc: jeff@garzik.org, ebiederm@xmission.com, torvalds@linux-foundation.org,
       rene.herman@keyaccess.nl, bunk@kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk, tglx@linutronix.de,
       mingo@redhat.com
Subject: Re: MSI, fun for the whole family
From: David Miller <davem@davemloft.net>
In-Reply-To: <adaiqy67fib.fsf@cisco.com>
References: <m11w4u8x1c.fsf@frodo.ebiederm.org>
	<481150EE.3040103@garzik.org>
	<adaiqy67fib.fsf@cisco.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 24 Apr 2008 20:57:48 -0700

> Now, it is true that the kernel could do something crazy and collapse
> all these interrupt vectors into a single "IRQ" and then tell the
> interrupt handler which vector it was by passing some "metadata" in, but
> why not just give each MSI message it's own IRQ?

Actually, it doesn't make any sense to have more MSI, or "MSI queue"
interrupts than you have cpus.

Non-x86 PCI-E controller impelemntations that I am familiar with collect
MSI and MSI-X interrupts into "queues", these queues being non-empty
is what actually triggers an interrupt to the CPU.  And, there are
enough MSI queue instances such that you can direct each one to a
unique cpu.

The MSI queue interrupt simply scans the ring buffer of pending MSI
interrupts and dispatches them to the device.

You can handle PCI-E frabric error messages the same way, and in fact
that's what the controllers I am familiar with do.

A Linux implementation of support for this kind of setup can be seen
in arch/sparc64/kernel/pci_msi.c:sparc64_msiq_interrupt().  It's
very generic and doesn't care whether it's talking to real PCI
controller hardware or a hypervisor based interface.

Besides the obvious extra indirection overhead, our IRQ layer is very
much capable of supporting multi-level dispatch like this correctly.
