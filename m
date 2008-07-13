Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbYGMQ2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbYGMQ2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 12:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYGMQ2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 12:28:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:55185 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbYGMQ2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 12:28:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,354,1212390000"; 
   d="scan'208";a="595648057"
Date: Sun, 13 Jul 2008 09:28:05 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too
Message-ID: <20080713162804.GI1678@linux-os.sc.intel.com>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807092017.51004.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com> <200807111841.55403.yhlu.kernel@gmail.com> <20080713010843.GD1678@linux-os.sc.intel.com> <86802c440807121904m1516b47am22a384a1e5868f68@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807121904m1516b47am22a384a1e5868f68@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2008 at 07:04:44PM -0700, Yinghai Lu wrote:
> On Sat, Jul 12, 2008 at 6:08 PM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
> > Yinghai,
> >
> > We can now cleanup ack_APIC_irq() to use the native_apic_mem_write()
> > for both 32bit and 64bit
> 
> apic_write_around(), in case 32bit not have CONFIG_X86_GOOD_APIC?
> or let 64 bit use that apic_write_around()?

hmm, yes this gets complicated.

Reason why I used native_apic_mem_write() in 64bit is, ack_APIC_irq()
is in the fast path (intr) and we are already sure (through irq_chip's) that
this ack is indeed for xapic. So instead of using function pointer, I directly
used the native access.

As we are now implementing apic ops for 32bit aswell, I though we should
also use the native access for perf reason. 

So we should probably have native_apic_mem_write_around() and use that
in ack_APIC_irq() and for good apic it is native_apic_mem_write()
and for !CONFIG_X86_GOOD_APIC, it is native_apic_mem_write_atomic()

> 
> >
> > And also arch/x86/kernel/ipi.c can also use native_apic_mem_write()
> > similar to include/asm-x86/ipi.h
> 
> should remove duplicated functions in ipi.c

yes, if there are no differences.

BTW, as I mentioned in another thread, we need to take care of the paravirt
(lguest, vmi, xen etc) cases aswell.

thanks,
suresh
