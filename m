Return-Path: <linux-kernel-owner+w=401wt.eu-S1759146AbYGCM2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbYGCM2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757322AbYGCM1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:27:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:55439 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317AbYGCM1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:27:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: michaele@au1.ibm.com
Subject: Re: Multiple MSI
Date: Thu, 3 Jul 2008 11:10:29 +0200
User-Agent: KMail/1.9.9
Cc: benh@kernel.crashing.org, Matthew Wilcox <matthew@wil.cx>,
       linux-pci@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       linux-kernel@vger.kernel.org
References: <20080703024445.GA14894@parisc-linux.org> <1215060119.21182.77.camel@pasglop> <1215067484.17950.35.camel@localhost>
In-Reply-To: <1215067484.17950.35.camel@localhost>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807031110.30072.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+t5auUcCQLkZVmG4Jq1c96PsYnzV+YjbRqIKt
 C9zG7VA75zkYZaQm5ThuutnLgb1T9uwHoIpLJZMZaUwOPJ9BTo
 LOgws3zIlRk6fWu5mf25Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 July 2008, Michael Ellerman wrote:
> On Thu, 2008-07-03 at 14:41 +1000, Benjamin Herrenschmidt wrote:
> > On Wed, 2008-07-02 at 21:59 -0600, Matthew Wilcox wrote:
> > > 
> > > 
> > > This is true and worth considering carefully.  Are IRQ numbers a scarce
> > > resource on PowerPC?  They are considerably less scarce than interrupt
> > > vectors are on x86-64.  How hard is it to make IRQ numbers an abundent
> > > resource?  Is it simply a question of increasing NR_IRQS?
> > 
> > Yes, indeed, they aren't really scarce... actually less than the
> > underlying HW vectors in most cases, so it isn't a big issue to add some
> > kind of constraint to the allocator.
> 
> Not scarce, but increasing NR_IRQS makes some static arrays bigger,
> which is not so nice.

Some years ago, we had discussions about getting rid of IRQ numbers
altogether, or at least the requirement to have device drivers know
about them. Does anyone remember what happened to that idea?

I think the concept was that you pass around struct irq_desc pointers
that may or may not be dynamically allocated by the interrupt controller
code.

Another simplification that should really help here is encapsulating
request_irq() per subsystem so that you can do something like

int my_irq(struct pci_dev *dev);
err = pci_request_irq(pci_dev, &my_irq, IRQF_SHARED);

Most PCI drivers should be trivial to convert to this model. If you want
to have multiple MSI/MSI-X interrupts for one PCI device with this model,
you'd need to introduce the number back as an offset, I guess.

	Arnd <><
