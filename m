Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbYGZHVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbYGZHVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 03:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbYGZHVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 03:21:39 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:58239 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYGZHVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 03:21:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HqEO2nLl5Jd2ULvxXiWyfC1kedhts5rvMdsKB6QrYY/W1Wv7ga2FtWkvNUwUW79oNL
         ecXbtdj/Ow2wsUiC7JsEMDEcVbe6GkIlawfZ00FyuUI+9q0zmuHli2tykcqfhgnh4FA/
         PKpltSO92sJ26oOqFBp3qHtxaZ68ihJy1eDSM=
Date: Sat, 26 Jul 2008 11:21:37 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] proc: switch inode number allocation to IDA
Message-ID: <20080726072137.GB5115@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc doesn't use "associate pointer with id" feature of IDR, so switch
to IDA.

NOTE, NOTE, NOTE:
	Do not apply if release_inode_number() still mantions MAX_ID_MASK!

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/generic.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -300,7 +300,7 @@ out:
 	return rtn;
 }
 
-static DEFINE_IDR(proc_inum_idr);
+static DEFINE_IDA(proc_inum_ida);
 static DEFINE_SPINLOCK(proc_inum_lock); /* protects the above */
 
 #define PROC_DYNAMIC_FIRST 0xF0000000U
@@ -315,11 +315,11 @@ static unsigned int get_inode_number(void)
 	int error;
 
 retry:
-	if (idr_pre_get(&proc_inum_idr, GFP_KERNEL) == 0)
+	if (ida_pre_get(&proc_inum_ida, GFP_KERNEL) == 0)
 		return 0;
 
 	spin_lock(&proc_inum_lock);
-	error = idr_get_new(&proc_inum_idr, NULL, &i);
+	error = ida_get_new(&proc_inum_ida, &i);
 	spin_unlock(&proc_inum_lock);
 	if (error == -EAGAIN)
 		goto retry;
@@ -328,7 +328,7 @@ retry:
 
 	if (i > UINT_MAX - PROC_DYNAMIC_FIRST) {
 		spin_lock(&proc_inum_lock);
-		idr_remove(&proc_inum_idr, i);
+		ida_remove(&proc_inum_ida, i);
 		spin_unlock(&proc_inum_lock);
 	}
 	return PROC_DYNAMIC_FIRST + i;
@@ -337,7 +337,7 @@ retry:
 static void release_inode_number(unsigned int inum)
 {
 	spin_lock(&proc_inum_lock);
-	idr_remove(&proc_inum_idr, inum - PROC_DYNAMIC_FIRST);
+	ida_remove(&proc_inum_ida, inum - PROC_DYNAMIC_FIRST);
 	spin_unlock(&proc_inum_lock);
 }
 
-- 
1.5.4.5


