Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbYE2VHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbYE2VHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYE2VHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:07:45 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:38380 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYE2VHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:07:44 -0400
Date: Thu, 29 May 2008 21:54:50 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: hans-christoph.rohland@sap.com, leg@google.com, pbadari@us.ibm.com,
       harvey.harrison@gmail.com, zach.brown@oracle.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] generic_file_aio_read cleanups
In-Reply-To: <Pine.LNX.4.64.0805291912490.553@blonde.site>
Message-ID: <Pine.LNX.4.64.0805292148220.29474@blonde.site>
References: <Pine.LNX.4.64.0805290007320.7969@blonde.site>
 <20080528165815.f4e4982c.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0805291912490.553@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As akpm points out, there's really no need for generic_file_aio_read to
make a special case of count 0: just loop through nr_segs doing nothing.
And as Harvey Harrison points out, there's no need to reset retval to 0
where it's already 0.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Setting count (or ocount) to 0 before calling generic_segment_checks is
unnecessary too; but reluctantly I'll leave that removal to someone with
a wider range of gcc versions to hand - 4.1.2 and 4.2.1 don't warn about
it, but perhaps others do - I forget which are the warniest versions.

 mm/filemap.c |   44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

--- 2.6.26-rc4/mm/filemap.c	2008-05-19 11:19:03.000000000 +0100
+++ linux/mm/filemap.c	2008-05-29 21:31:55.000000000 +0100
@@ -1199,7 +1199,6 @@ generic_file_aio_read(struct kiocb *iocb
 
 		mapping = filp->f_mapping;
 		inode = mapping->host;
-		retval = 0;
 		if (!count)
 			goto out; /* skip atime */
 		size = i_size_read(inode);
@@ -1208,33 +1207,30 @@ generic_file_aio_read(struct kiocb *iocb
 						iov, pos, nr_segs);
 			if (retval > 0)
 				*ppos = pos + retval;
-		}
-		if (likely(retval != 0)) {
-			file_accessed(filp);
-			goto out;
+			if (retval) {
+				file_accessed(filp);
+				goto out;
+			}
 		}
 	}
 
-	retval = 0;
-	if (count) {
-		for (seg = 0; seg < nr_segs; seg++) {
-			read_descriptor_t desc;
-
-			desc.written = 0;
-			desc.arg.buf = iov[seg].iov_base;
-			desc.count = iov[seg].iov_len;
-			if (desc.count == 0)
-				continue;
-			desc.error = 0;
-			do_generic_file_read(filp,ppos,&desc,file_read_actor);
-			retval += desc.written;
-			if (desc.error) {
-				retval = retval ?: desc.error;
-				break;
-			}
-			if (desc.count > 0)
-				break;
+	for (seg = 0; seg < nr_segs; seg++) {
+		read_descriptor_t desc;
+
+		desc.written = 0;
+		desc.arg.buf = iov[seg].iov_base;
+		desc.count = iov[seg].iov_len;
+		if (desc.count == 0)
+			continue;
+		desc.error = 0;
+		do_generic_file_read(filp, ppos, &desc, file_read_actor);
+		retval += desc.written;
+		if (desc.error) {
+			retval = retval ?: desc.error;
+			break;
 		}
+		if (desc.count > 0)
+			break;
 	}
 out:
 	return retval;
