Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYJOLwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYJOLwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 07:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYJOLwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 07:52:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48105 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbYJOLwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 07:52:16 -0400
Date: Wed, 15 Oct 2008 13:51:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: GIT head no longer boots on x86-64
Message-ID: <20081015115153.GA16413@elte.hu>
References: <alpine.LFD.2.00.0810130752020.3288@nehalem.linux-foundation.org> <1223910693-28693-1-git-send-email-jirislaby@gmail.com> <20081013164717.7a21084a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081013164717.7a21084a@lxorguk.ukuu.org.uk>
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

> > I guess SMP kernel running on UP? In such a case the module .text
> 
> Yep
> 
> > is patched to use UP locks before the module is added to the modules
> > list and it thinks there are no valid data at that place while
> > patching.
> > 
> > Could you test it? The bug disappeared here in qemu. I've checked
> > callers of the function, and it should not matter for them.
> 
> Seems to do the job.

Queued the fix below up in tip/x86/urgent for a merge to Linus later 
today. Thanks!

	Ingo

------------------>
>From 5870942537422066655816e971629aa729c023d8 Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jirislaby@gmail.com>
Date: Mon, 13 Oct 2008 17:11:33 +0200
Subject: [PATCH] x86: fix CONFIG_DEBUG_VIRTUAL=y boot crash on x86-64

Alan reported a bootup crash in the module loader:

> BUG? vmalloc_to_page (from text_poke+0x30/0x14a): ffffffffa01e40b1

SMP kernel is running on UP, in such a case the module .text
is patched to use UP locks before the module is added to the modules
list and it thinks there are no valid data at that place while
patching.

Also the !is_module_address(addr) test is useless now.

Reported-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Tested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 include/linux/mm.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c61ba10..45772fd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -267,6 +267,10 @@ static inline int is_vmalloc_addr(const void *x)
 #ifdef CONFIG_MMU
 	unsigned long addr = (unsigned long)x;
 
+#ifdef CONFIG_X86_64
+	if (addr >= MODULES_VADDR && addr < MODULES_END)
+		return 1;
+#endif
 	return addr >= VMALLOC_START && addr < VMALLOC_END;
 #else
 	return 0;
