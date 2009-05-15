Return-Path: <linux-kernel-owner+w=401wt.eu-S1762915AbZEOPTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762915AbZEOPTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 11:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757628AbZEOPTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 11:19:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:34251 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbZEOPTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 11:19:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=mJEevxvL1AaadbBqdPN+B8nJ3u6um3KHidVAyYTKZlxiorKjK6kbf7Vf+SwT+3UvJP
         164HEW9Xfy7pboIZlCd7GhL46pUHMJ5Twah4bSldFXioXVhfx1kotbFk+QukaUIB/ShP
         /iOo0txXf7UGLV8K6bW+H5dZKFwoW+AgveivE=
Message-ID: <4A0D87F7.8090401@gmail.com>
Date: Sat, 16 May 2009 00:19:19 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Pete Zaitcev <zaitcev@redhat.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Eric Moore <Eric.Moore@lsi.com>, "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH block#for-2.6.31 3/3] bio: always copy back data for copied
 kernel requests
References: <4A0D86DB.9000203@kernel.org> <4A0D87D2.7090806@gmail.com>
In-Reply-To: <4A0D87D2.7090806@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a read bio_copy_kern() request fails, the content of the bounce
buffer is not copied back.  However, as request failure doesn't
necessarily mean complete failure, the buffer state can be useful.
This behavior is also inconsistent with the user map counterpart and
causes the subtle difference between bounced and unbounced IO causes
confusion.

This patch makes bio_copy_kern_endio() ignore @err and always copy
back data on request completion.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 fs/bio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: block/fs/bio.c
===================================================================
--- block.orig/fs/bio.c
+++ block/fs/bio.c
@@ -1198,7 +1198,7 @@ static void bio_copy_kern_endio(struct b
 		char *addr = page_address(bvec->bv_page);
 		int len = bmd->iovecs[i].bv_len;
 
-		if (read && !err)
+		if (read)
 			memcpy(p, addr, len);
 
 		__free_page(bvec->bv_page);
