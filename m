Return-Path: <linux-kernel-owner+w=401wt.eu-S1765153AbYDXPbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765153AbYDXPbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762750AbYDXPVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:21:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762739AbYDXPVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:21:19 -0400
Date: Thu, 24 Apr 2008 08:16:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [git patch] free_irq() fixes
In-Reply-To: <481066C1.1030805@garzik.org>
Message-ID: <alpine.LFD.1.10.0804240806500.2779@woody.linux-foundation.org>
References: <20080422221733.GA16260@havoc.gtf.org> <alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org> <480E6DE5.6010103@garzik.org> <alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org> <480E796E.4070001@garzik.org>
 <alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org> <20080423000529.GG28933@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org> <480F3ECC.1090809@keyaccess.nl> <480FEC1B.6040102@garzik.org>
 <alpine.LFD.1.10.0804231914270.2779@woody.linux-foundation.org> <m1od7zkd2s.fsf@frodo.ebiederm.org> <481066C1.1030805@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Apr 2008, Jeff Garzik wrote:
> 
> Honestly, one thing I was thinking was perhaps a change from
> 
> 	irqreturn_t foo_handler(int irq, void *dev_id)
> to
> 	irqreturn_t foo_handler(struct irq_info *ii, void *dev_id)
> 
> which would IMO make the first parameter useful again, by enabling passing of
> information like MSI message info, or more flexible platform-specific irq info
> that a platform driver may want.  Or direct access to irq_desc or irq_chip
> info.

So I *really* hate that idea. It's much *much* worse than what we have 
now.

Why?

The absolutely _only_ piece of reliably information we have that is 
architecture- and irq-controller neutral is the exact information we pass 
in to "request_irq()". That is: irq number, the name, and the device 
cookie thing. Nothing more.

And of the three things, they have the following pattern:

 - "irq number" is some random cookie, but it is a cookie that the 
   *system* forces on the driver, and that is totally independent of how 
   the irq is delivered or what kind of irq it is (device, system, PCI, 
   ISA, whatever). The driver doesn't get to choose it, but the system and 
   the driver have to agree on it some way (ie regardless of whether it's 
   a PCI driver or a Super-Integrated-bus-of-year-2025, the driver will 
   have to get it from some system resource, ie the pci_dev or whatever)

   IOW, the irq number *does* have meaning, but it is very much by design 
   something that is _purely_ a cookie. You cannot look into it - it's not 
   a pointer to any data.

 - "the name". There really is no point to passing this around, because 
   it's purely for show, and purely so that the generic irq layer can tell 
   the user something in /proc/irq etc. Passing it back to the driver 
   would be entirely pointless, because it is designed purely to be a 
   driver->system informational thing.

 - the "device cookie". This is the thing that the system itself doesn't 
   care about, and is _entirely_ under control of the driver, so the 
   driver can pass its own interrupt controller some helpful instance 
   pointers.

So of the three, "device cookie" is the one that we absolutely have to 
have. The irq number is not necessary, but it does actually have some 
meaning especially for legacy devices (eg ISA), and it is at least 
_sensible_ to pass around (ie it has no downsides, and it's not 
fundamentally broken). And the name would be just stupid.

EVERYTHING else would be architecture-specific. And that is exactly what 
we do not want. EVER. 

Passing in some context that contains bus information is absolutely the 
*last* thing we want. We do not want to have irq handlers that know about 
the interrupt controller details. 

			Linus
