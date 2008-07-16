Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbYGPQCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbYGPQCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbYGPQC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:02:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:8428 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbYGPQC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:02:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lBg+pUAD/wNuUChBDiwiibo2RkOEmSb1R98jFTMiTjQERZQ1jEDfrFy8oLc+jvnVeU
         f82C2IOZtNpbLGPVSZ+zqGNTy0BbqOxI7Z5eOY2f9wu9d0lBsVB6MpaoCtLgEgXlUmEG
         TM0vWpT7PW11ZoO4cD+PLA6KSna/hyVRWUTRQ=
Date: Wed, 16 Jul 2008 19:59:47 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] proc: fix /proc/*/pagemap some more
Message-ID: <20080716155947.GA4809@martell.zuzino.mipt.ru>
References: <20080716152025.GA23096@alice> <20080716153628.GA5795@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716153628.GA5795@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 07:36:28PM +0400, Alexey Dobriyan wrote:
> On Wed, Jul 16, 2008 at 05:20:25PM +0200, Eric Sesterhenn wrote:
> > with current -git a "cat /proc/4260/pagemap"
> > gives me the following oops:
> 
> reproduced

Oh, wow!

[PATCH] proc: fix /proc/*/pagemap some more

struct pagemap_walk was placed on stack, some hooks are initialized, the rest
(->pgd_entry, ->pud_entry, ->pte_entry) are valid but junk.

Reported by Eric Sesterhenn.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -636,7 +636,7 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	struct pagemapread pm;
 	int pagecount;
 	int ret = -ESRCH;
-	struct mm_walk pagemap_walk;
+	struct mm_walk pagemap_walk = {};
 	unsigned long src;
 	unsigned long svpfn;
 	unsigned long start_vaddr;

