Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbZFZOfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbZFZOfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbZFZOfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:35:19 -0400
Received: from mail.open.by ([193.232.92.17]:59948 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbZFZOfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:35:18 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8845 [Jun 25 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Fri, 26 Jun 2009 17:36:52 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] kobject_set_name_vargs memory leak
Message-ID: <20090626143652.GB6281@localdomain.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
I suppose this patch fixes memory leak in kobject.c
Correct me if I'm wrong.
Thanks.
-----------

Fix memory leak when kobject_set_name_vargs returns -ENOMEM.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
---
diff --git a/lib/kobject.c b/lib/kobject.c
index b512b74..922cd8c 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -222,8 +222,10 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 		return 0;
 
 	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
-	if (!kobj->name)
+	if (!kobj->name) {
+		kfree(old_name);
 		return -ENOMEM;
+	}
 
 	/* ewww... some of these buggers have '/' in the name ... */
 	while ((s = strchr(kobj->name, '/')))
