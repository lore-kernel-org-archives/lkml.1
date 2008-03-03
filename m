Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYCCIrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYCCIrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 03:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYCCIq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 03:46:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59086 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbYCCIq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 03:46:57 -0500
Date: Mon, 3 Mar 2008 09:46:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stuart Bennett <sb476@cam.ac.uk>, Len Brown <lenb@kernel.org>,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
Message-ID: <20080303084611.GA15943@elte.hu>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7553D.5040601@free.fr> <47C0BDE2.4020402@googlemail.com> <47C0DB7D.70407@linux.intel.com> <47C2ED51.4000105@googlemail.com> <47C344E5.5050205@linux.intel.com> <20080302155348.GA74305@gandalf.sssup.it> <47CADC9D.9090403@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CADC9D.9090403@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> looks good to me; Ingo please apply (Note: if no legit users show up I 
> want to just remove support for mapping ram altogether in 2.6.26 or 
> so)

well upstream doesnt have the warning anymore, i queued up the patch 
below into x86.git#testing.

	Ingo

-------------------->
Subject: x86: warn about RAM pages in ioremap()
From: Ingo Molnar <mingo@elte.hu>
Date: Mon Mar 03 09:37:41 CET 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/ioremap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-x86.q/arch/x86/mm/ioremap.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/ioremap.c
+++ linux-x86.q/arch/x86/mm/ioremap.c
@@ -149,9 +149,11 @@ static void __iomem *__ioremap(unsigned 
 	for (pfn = phys_addr >> PAGE_SHIFT;
 				(pfn << PAGE_SHIFT) < last_addr; pfn++) {
 
-		if (page_is_ram(pfn) && pfn_valid(pfn) &&
-		    !PageReserved(pfn_to_page(pfn)))
+		int is_ram = page_is_ram(pfn);
+
+		if (is_ram && pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)))
 			return NULL;
+		WARN_ON_ONCE(is_ram);
 	}
 
 	switch (mode) {
