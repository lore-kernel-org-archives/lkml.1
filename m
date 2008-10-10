Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbYJJJrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbYJJJrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbYJJJrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 05:47:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46213 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753904AbYJJJrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 05:47:05 -0400
Date: Fri, 10 Oct 2008 10:46:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>, stable@kernel.org, torvalds@osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] early_ioremap has a fencepost error
Message-ID: <20081010104645.139704c0@lxorguk.ukuu.org.uk>
In-Reply-To: <20081010093901.GC13996@elte.hu>
References: <E1Klq8Z-0003Vd-L6@closure.thunk.org>
	<20081003195436.GA13506@Krystal>
	<20081004152456.GB23398@mit.edu>
	<20081006040820.GB26148@kroah.com>
	<20081010093901.GC13996@elte.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can we get this into 2.6.27.x at some point as its a regression and a
crash on boot for some users moving from 2.6.26

--

early_ioremap: fix fencepost error

From: Alan Cox <alan@redhat.com>

The x86 implementation of early_ioremap has an off by one error. If we get
an object which ends on the first byte of a page we undermap by one page and
this causes a crash on boot with the ASUS P5QL whose DMI table happens to fit
this alignment.

The size computation is currently

	last_addr = phys_addr + size - 1;
	npages = (PAGE_ALIGN(last_addr) - phys_addr)

(Consider a request for 1 byte at alignment 0...)

Closes #11693

Debugging work by Ian Campbell/Felix Geyer

Signed-off-by: Alan Cox <alan@rehat.com>
---

 arch/x86/mm/ioremap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index d4b6e6a..d0975fc 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -595,7 +595,7 @@ void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
 	 */
 	offset = phys_addr & ~PAGE_MASK;
 	phys_addr &= PAGE_MASK;
-	size = PAGE_ALIGN(last_addr) - phys_addr;
+	size = PAGE_ALIGN(last_addr + 1) - phys_addr;
 
 	/*
 	 * Mappings have to fit in the FIX_BTMAP area.

