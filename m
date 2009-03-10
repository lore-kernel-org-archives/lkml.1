Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbZCJQA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbZCJQA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbZCJQAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:00:10 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:61776 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbZCJQAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:00:09 -0400
Date: Tue, 10 Mar 2009 11:00:00 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
Message-ID: <20090310110000.24893e0c@thinkcentre.lan>
In-Reply-To: <20090310105702.43eb1402@thinkcentre.lan>
References: <20090305163857.0C18F3FD@kernel>
 <20090310105702.43eb1402@thinkcentre.lan>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Pobox-Relay-ID: 86729BD8-0D8C-11DE-B8C9-CBE7E3B37BAC-04752483!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3695fbda6225d2436e4af67a4bce6984df0891be Mon Sep 17 00:00:00 2001
From: Nathan Lynch <ntl@pobox.com>
Date: Mon, 9 Mar 2009 22:36:40 -0500
Subject: [PATCH] ratelimit files_deny_checkpointing output

Any common distribution's boot sequence causes thousands of
"<something> performed an action that cannot be checkpointed"
messages.  Kernels are known to produce other messages of interest at
times, so ratelimit the output of files_deny_checkpointing.


Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 include/linux/checkpoint.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
index 27366ac..efdb8f0 100644
--- a/include/linux/checkpoint.h
+++ b/include/linux/checkpoint.h
@@ -108,8 +108,10 @@ static inline void __files_deny_checkpointing(const struct task_struct *tsk,
 {
 	if (!test_and_clear_bit(0, &files->may_checkpoint))
 		return;
-	printk(KERN_INFO "%s/%i performed an action that can not be "
-	       "checkpointed at: %s:%d\n", tsk->comm, tsk->pid, file, line);
+	if (printk_ratelimit())
+		printk(KERN_INFO "%s/%i performed an action that can not be "
+				"checkpointed at: %s:%d\n",
+				tsk->comm, tsk->pid, file, line);
 }
 #define files_deny_checkpointing(tsk,f)				\
 	__files_deny_checkpointing(tsk, f, __FILE__, __LINE__)
-- 
1.6.0.6

