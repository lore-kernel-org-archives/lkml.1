Return-Path: <linux-kernel-owner+w=401wt.eu-S1763297AbYD0XOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763297AbYD0XOy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYD0XOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:14:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35782 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYD0XOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:14:45 -0400
Date: Sun, 27 Apr 2008 16:14:15 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Miller <davem@davemloft.net>,
       James.Bottomley@HansenPartnership.com, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
Message-ID: <20080427161415.5507a78b@laptopd505.fenrus.org>
In-Reply-To: <481505ED.4050008@garzik.org>
References: <20080427214837.GA11631@elte.hu>
	<1209335660.3801.79.camel@localhost.localdomain>
	<4815009C.2010809@garzik.org>
	<20080427.154620.177583216.davem@davemloft.net>
	<481503ED.8060107@garzik.org>
	<481504BA.4090402@zytor.com>
	<481505ED.4050008@garzik.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008 19:02:05 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> H. Peter Anvin wrote:
> > Jeff Garzik wrote:
> >>
> >> Understood.
> >>
> >> I guess I am more annoyed that this stealth semantics change
> >> appears to have broken everything that depends on pci_iomap(),
> >> including 90%+ of all libata drivers, unless I am missing
> >> something.
> >>
> >> That one piece of code (pci_iomap) was correct under the old 
> >> semantics, on x86 and elsewhere.  It's tested and working nicely,
> >> and depended upon by many drivers.
> >>
> > 
> > That one piece of code has had no effective change.  Under both the
> > old and the new code, both branches functionally because
> > ioremap_nocache(), in one case because of MTRR and in one case
> > because of PAT.
> 
> OK good...  libata uses it for controller registers exclusively, so
> that should be fine from an operational standpoint.
> 
> at the very least I 
> could have pointed out that lib/iomap.c wanted an update, and the 2.5
> yo discussion could have resurfaced.
> 

btw as a technical point: ioremap_cached() isn't guaranteed to give you cached memory.
In fact, on a PC, if you use ioremap_cached() on PCI bars, you will STILL get uncached
access, just because right now, it's not possible to give a cached mapping out!

We might want to try to change that in the future (by rewriting the MTRRs), but 
that would need a LOT of auditing of ioremap (ab)users to make sure they actually
mean "cached" when they ask for cached (pci_iomap... I'm not convinced it's users 
really can deal with cached) and it also will take a LOT of testing.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
