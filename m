Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbYJRTLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbYJRTLR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYJRTEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:04:08 -0400
Received: from ns2.suse.de ([195.135.220.15]:47485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbYJRTEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:04:07 -0400
Date: Sat, 18 Oct 2008 11:47:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Cox <alan@rehat.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 03/26] x86, early_ioremap: fix fencepost error
Message-ID: <20081018184730.GD301@suse.de>
References: <20081018183853.004667035@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-early_ioremap-fix-fencepost-error.patch"
In-Reply-To: <20081018184708.GA301@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Alan Cox <alan@redhat.com>

commit c613ec1a7ff3714da11c7c48a13bab03beb5c376 upstream

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
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/ioremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -582,7 +582,7 @@ void __init *early_ioremap(unsigned long
 	 */
 	offset = phys_addr & ~PAGE_MASK;
 	phys_addr &= PAGE_MASK;
-	size = PAGE_ALIGN(last_addr) - phys_addr;
+	size = PAGE_ALIGN(last_addr + 1) - phys_addr;
 
 	/*
 	 * Mappings have to fit in the FIX_BTMAP area.

-- 
