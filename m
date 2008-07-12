Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYGLVeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYGLVeH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 17:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYGLVda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 17:33:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:45306 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbYGLVd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 17:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Y/2eHHf/w+Zqm13S6/qiRvMNre0PrEr5pU+wfvCN6TbBZ+ZRROytOrq0ZwJTcVyVSz
         fCR4sLq2PZs9Tv711ZoyJjA1jIXltHFf75WfNQPXxEMa/2fUWzG7oWj4LLl1hxWrhewb
         vjNPc2Q7KELlBDmiIavDRggdv3L16g/r1LZ04=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: max_low_pfn_mapped fix #3
Date: Sat, 12 Jul 2008 14:32:45 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807092017.51004.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com>
In-Reply-To: <200807102038.26591.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807121432.45759.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


try to merge the range with same page size in init_memory_mapping

so when GBpages is not there, we could do 2M pages at same time.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/mm/init_64.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -763,6 +763,20 @@ unsigned long __init_refok init_memory_m
 	end_pfn = end>>PAGE_SHIFT;
 	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 
+	/* try to merge same page size and continuous */
+	for (i = 0; nr_range > 1 && i < nr_range - 1; i++) {
+		unsigned long old_start;
+		if (mr[i].end != mr[i+1].start ||
+		    mr[i].page_size_mask != mr[i+1].page_size_mask)
+			continue;
+		/* move it */
+		old_start = mr[i].start;
+		memmove(&mr[i], &mr[i+1],
+			 (nr_range - 1 - i) * sizeof (struct map_range));
+		mr[i].start = old_start;
+		nr_range--;
+	}
+
 	for (i = 0; i < nr_range; i++)
 		printk(KERN_DEBUG " %010lx - %010lx page %s\n",
 				mr[i].start, mr[i].end,
