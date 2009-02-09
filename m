Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbZBIT7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbZBIT7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbZBIT66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:58:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:55350 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbZBIT65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:58:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=Zw0ZFvUuNXgjapXbBhrYJ9Wn6i03eHGyjrBIsyyJuf+mgB/2VM4/vWpREj7Thl0rJO
         oeALPzz2RRs8Hk8CaGyVePgE5nnEC3UV76BP/xHezzbpFo7zha7/c7x7/QOqrNV+E91l
         dW6v58i5r7+6Ol7b4gPLHGpYnSF9LAKf0kS+0=
Date: Mon, 9 Feb 2009 21:58:49 +0200
From: Pekka Paalanen <pq@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, "Vegard Nossum" <vegard.nossum@gmail.com>,
       Stuart Bennett <stuart@freedesktop.org>
Subject: testing pmdval/pteval page presence bit
Message-ID: <20090209215849.5a788261@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This question is related to mmiotrace which toggles the page presence
bit to trigger page faults on ioremapped regions. Page faults are used
to trace MMIO reads and writes of proprietary drivers.

I understood that large pages use pmd's instead of pte's. If there is a
union like this:

+	union {
+		pmdval_t pmdval;
+		pteval_t pteval;
+	} saved;	/* stored value prior to arming */

and it is being assigned the proper content, as in the following:

+static int clear_page_present(struct kmmio_fault_page *f, bool clear)
 {
 	pteval_t pteval;
 	pmdval_t pmdval;
 	unsigned int level;
 	pmd_t *pmd;
+	pte_t *pte = lookup_address(f->page, &level);
 
 	if (!pte) {
+		pr_err("kmmio: no pte for page 0x%08lx\n", f->page);
 		return -1;
 	}
 
 	switch (level) {
 	case PG_LEVEL_2M:
 		pmd = (pmd_t *)pte;
+		if (clear) {
+			f->saved.pmdval = pmd_val(*pmd);
+			pmdval = f->saved.pmdval & ~_PAGE_PRESENT;
+		} else
+			pmdval = f->saved.pmdval;
 		set_pmd(pmd, __pmd(pmdval));
 		break;
 
 	case PG_LEVEL_4K:
+		if (clear) {
+			f->saved.pteval = pte_val(*pte);
+			pteval = f->saved.pteval & ~_PAGE_PRESENT;
+		} else
+			pteval = f->saved.pteval;
 		set_pte_atomic(pte, __pte(pteval));
 		break;


Then regardless of was it pmdval or pteval being set, the test

	if (!(faultpage->saved.pteval & _PAGE_PRESENT))

should be ok. But is it?
Can large page (pmd) presence be handled just like a normal page (pte)?


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
