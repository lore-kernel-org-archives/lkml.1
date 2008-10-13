Return-Path: <linux-kernel-owner+w=401wt.eu-S1758374AbYJMPER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374AbYJMPER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 11:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbYJMPD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 11:03:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755197AbYJMPD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 11:03:57 -0400
Date: Mon, 13 Oct 2008 08:03:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: GIT head no longer boots on x86-64
In-Reply-To: <20081013143502.01f3f526@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0810130752020.3288@nehalem.linux-foundation.org>
References: <20081013112024.0183f982@lxorguk.ukuu.org.uk> <1223895414-19793-1-git-send-email-jirislaby@gmail.com> <20081013143502.01f3f526@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Oct 2008, Alan Cox wrote:

> On Mon, 13 Oct 2008 12:56:54 +0200
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
> > Could you try the debug patch below to see what address is text_poke trying
> > to translate?
> 
> BUG? vmalloc_to_page (from text_poke+0x30/0x14a): ffffffffa01e40b1

Hmm. Last page of code being fixed up, perhaps?

Does this fix it?

(Totally untested. Of course.)

			Linus

---
 arch/x86/kernel/alternative.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index fb04e49..f4a8870 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -498,23 +498,22 @@ void *text_poke_early(void *addr, const void *opcode, size_t len)
  */
 void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 {
-	unsigned long flags;
+	unsigned long flags, offset;
 	char *vaddr;
-	int nr_pages = 2;
 	struct page *pages[2];
-	int i;
+	int i, nr_pages;
 
+	offset = (unsigned long) addr & ~PAGE_MASK;
+	nr_pages = (offset + len) > PAGE_SIZE ? 2 : 1;
 	if (!core_kernel_text((unsigned long)addr)) {
 		pages[0] = vmalloc_to_page(addr);
-		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
+		pages[1] = vmalloc_to_page(addr + len - 1);
 	} else {
 		pages[0] = virt_to_page(addr);
 		WARN_ON(!PageReserved(pages[0]));
-		pages[1] = virt_to_page(addr + PAGE_SIZE);
+		pages[1] = pages[0]+1;
 	}
 	BUG_ON(!pages[0]);
-	if (!pages[1])
-		nr_pages = 1;
 	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
 	BUG_ON(!vaddr);
 	local_irq_save(flags);
