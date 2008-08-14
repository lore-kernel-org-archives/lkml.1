Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbYHNVYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbYHNVYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 17:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYHNVYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 17:24:33 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:55819 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYHNVYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 17:24:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=T2pZ4y7iwiWWulv1xZyRRAiitssPbti485v9klURNZabqBM8PuTgCTQ71EkIH+n22T
         bNqLqjhvKuDXDDnaCy903sn8/Qqt3RVwm/IY52EBZXikv/qILdFgEDjJbm1A4KS94EeX
         FrerTP+ZSu7OiZvAZTjHD+uF7ctMbFrkG0GKs=
Message-ID: <86802c440808141424u3284f862gcd81e3cc585ddac4@mail.gmail.com>
Date: Thu, 14 Aug 2008 14:24:31 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 00/53] dyn_array/nr_irqs/sparse_irq support v10
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <86802c440808141342k6cb0dc59ud067018b0a171232@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080814132638.GA18743@elte.hu>
	 <86802c440808141201o2c66236cwbc5ce37f9675504d@mail.gmail.com>
	 <m1ljyzcqg4.fsf@frodo.ebiederm.org>
	 <86802c440808141342k6cb0dc59ud067018b0a171232@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find something interesting:

found new irq_cfg for irq 20
 0 add_pin_to_irq: irq 20 --> apic 0 pin 20
assign_irq_vector: irq 20 vector 0x59 cpu  5
IOAPIC[0]: Set routing entry (0-20 -> 0x59 -> IRQ 20 Mode:1 Active:1)
found new irq_desc for irq 20
pci 0000:00:02.1: PCI INT B -> Link[LUS2] -> GSI 20 (level, low) -> IRQ 20

IO APIC #0......
.... register #00: 00000000
.......    : physical APIC id: 00
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00170011
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
...
 14 09  1    1    0   1   0    0    0    59
...

ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
do_IRQ: cannot handle IRQ -1 vector 0x59 cpu 0
------------[ cut here ]------------
Kernel BUG at 40206b11 [verbose debug info unavailable]
invalid opcode: 0000 [#1] SMP
Modules linked in:

Pid: 70, comm: kasyncinit Not tainted (2.6.27-rc3-tip-00191-g98ccb89-dirty #23)
EIP: 0060:[<40206b11>] EFLAGS: 00010092 CPU: 0
EIP is at do_IRQ+0x6b/0xae
EAX: 00000032 EBX: 00001d28 ECX: 00003434 EDX: 00000046
ESI: 00000000 EDI: 00000059 EBP: c7a37d3c ESP: c7a37d14
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kasyncinit (pid: 70, ti=c7a36000 task=c79c9860 task.ti=c7a36000)
Stack: 40a74317 40814ea0 ffffffff 00000059 00000000 00000000 ffffffff c421bd20
       c7a37d9c c7a37dac c7a37d7c 4020555f c421bd20 00000000 c421bd20 c7a37d9c
       c7a37dac c7a37d7c 40b717f8 0000007b 0000007b 000000d8 ffffffa6 4080db6c
Call Trace:
 [<4020555f>] ? common_interrupt+0x23/0x28


it is on 16cores system with 32bit bigsmp, so it is using phy_flat
cpu 5 has apicid 9, and ioapic reg setting right with Dmod= 0 ( phys)

but io_apic controller deliver that interrupt to cpu0 (with apicid =
4) instead of cpu 5 (with apic id = 9)

look at the 64 bit, TARGET_CPUS for phys_flat is cpu_online_map

and 32bit bigsmp TARGET_CPUS is only one cpu set and rotating with online cpu...

Change 32bit bigsmp TARGE_CPUS ?

YH
