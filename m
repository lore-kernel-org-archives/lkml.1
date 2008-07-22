Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYGVPQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYGVPQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 11:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbYGVPQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 11:16:45 -0400
Received: from namei.org ([69.55.235.186]:41372 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750794AbYGVPQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 11:16:44 -0400
Date: Wed, 23 Jul 2008 01:08:51 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       zohar@us.ibm.com, debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com
Subject: Re: [Patch 5/5]integrity: IMA as an integrity service provider
In-Reply-To: <1216331646.3747.24.camel@localhost.localdomain>
Message-ID: <Xine.LNX.4.64.0807230104380.7346@us.intercode.com.au>
References: <20080707192529.489789904@linux.vnet.ibm.com> 
 <1215467789.27626.3.camel@localhost.localdomain> 
 <Xine.LNX.4.64.0807160910470.8360@us.intercode.com.au> 
 <1216238733.5886.30.camel@localhost.localdomain> 
 <Xine.LNX.4.64.0807170947470.3212@us.intercode.com.au>
 <1216331646.3747.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've applied these patches to:
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#devel

which will go into linux-next in about a week.

I fixed up a couple of outstanding issues with atomic vs. atomic_long (see 
the patch below).

Please test.

----

commit fe2e6187810af248f910f1ca498fe03b54cade2e
Author: James Morris <jmorris@namei.org>
Date:   Tue Jul 22 10:43:04 2008 -0400

    integrity: fix up some atomic vs. atomic_long issues
    
    Ensure atomic_long_t is used correctly throughout the
    integrity code.
    
    Signed-off-by: James Morris <jmorris@namei.org>

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index de982c6..986bfb1 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -98,7 +98,7 @@ void ima_template_show(struct seq_file *m, void *e,
 extern spinlock_t ima_queue_lock;
 
 struct ima_h_table {
-	atomic_t len;		/* number of stored measurements in the list */
+	atomic_long_t len;	/* number of stored measurements in the list */
 	atomic_long_t violations;
 	unsigned int max_htable_size;
 	struct hlist_head queue[IMA_MEASURE_HTABLE_SIZE];
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index fa3cdb0..781460f 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -28,7 +28,7 @@ static ssize_t ima_show_htable_value(char __user *buf, size_t count,
 	char tmpbuf[TMPBUFLEN];
 	ssize_t len;
 
-	len = scnprintf(tmpbuf, TMPBUFLEN, "%i\n", atomic_read(val));
+	len = scnprintf(tmpbuf, TMPBUFLEN, "%li\n", atomic_long_read(val));
 	return simple_read_from_buffer(buf, count, ppos, tmpbuf, len);
 }
 
diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index e09ddb9..1cb4f03 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -106,7 +106,7 @@ int ima_add_measure_entry(struct ima_measure_entry *entry, int violation)
 	INIT_LIST_HEAD(&qe->later);
 	list_add_tail_rcu(&qe->later, &ima_measurements);
 
-	atomic_inc(&ima_htable.len);
+	atomic_long_inc(&ima_htable.len);
 	if (ima_add_digest_entry(entry)) {
 		error = -ENOMEM;
 		goto out;
