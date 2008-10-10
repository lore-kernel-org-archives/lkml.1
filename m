Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbYJJKWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbYJJKWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYJJKVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:21:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37592 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbYJJKVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:21:53 -0400
Date: Fri, 10 Oct 2008 12:21:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, stable@kernel.org, torvalds@osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH RESEND] early_ioremap has a fencepost error
Message-ID: <20081010102128.GA22856@elte.hu>
References: <E1Klq8Z-0003Vd-L6@closure.thunk.org> <20081003195436.GA13506@Krystal> <20081004152456.GB23398@mit.edu> <20081006040820.GB26148@kroah.com> <20081010093901.GC13996@elte.hu> <20081010104645.139704c0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010104645.139704c0@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Can we get this into 2.6.27.x at some point as its a regression and a 
> crash on boot for some users moving from 2.6.26

yes, have your fix patch from yesterday in tip/x86/urgent already, with 
a stable@kernel.org tag included as well - see below. Thanks Alan!

	Ingo

-------------->
>From dd5698f42a5f2b494c3e811598403f105b00f4f2 Mon Sep 17 00:00:00 2001
From: Alan Cox <alan@redhat.com>
Date: Fri, 10 Oct 2008 10:46:45 +0100
Subject: [PATCH] x86, early_ioremap: fix fencepost error

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
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
