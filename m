Return-Path: <linux-kernel-owner+w=401wt.eu-S1422730AbXBAJkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422730AbXBAJkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 04:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422724AbXBAJjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 04:39:37 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:35817 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422715AbXBAJjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 04:39:12 -0500
Date: Thu, 1 Feb 2007 10:30:11 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-aio <linux-aio@kvack.org>,
       Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Badari Pulavarty <pbadari@us.ibm.com>,
       Benjamin LaHaise <bcrl@linux.intel.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>
Subject: [PATCH -mm 3/7][AIO] - Fix access_ok() checks
Message-ID: <20070201103011.69ebafc8@frecb000686>
In-Reply-To: <20070201102252.240130c6@frecb000686>
References: <20070201102252.240130c6@frecb000686>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 01/02/2007 10:40:01,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 01/02/2007 10:40:08,
	Serialize complete at 01/02/2007 10:40:08
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sébastien Dugué <sebastien.dugue@bull.net>

                   Fix access_ok() checks in sys_io_submit() and 
                            compat_sys_io_submit()


  sys_io_submit() and compat_sys_io_submit() check for the number of
requests (nr) being positive, but the following access_ok() call uses
nr * sizeof(ptr) which can overlow to a negative number.

  Just make sure that nr * sizeof(ptr) is positive in the first place.


 aio.c    |    2 +-
 compat.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Signed-off-by: Sébastien Dugué <sebastien.dugue@bull.net>

Index: linux-2.6.20-rc6-mm3/fs/aio.c
===================================================================
--- linux-2.6.20-rc6-mm3.orig/fs/aio.c	2007-01-30 11:28:56.000000000 +0100
+++ linux-2.6.20-rc6-mm3/fs/aio.c	2007-01-30 11:32:42.000000000 +0100
@@ -1630,7 +1630,7 @@ asmlinkage long sys_io_submit(aio_contex
 	long ret = 0;
 	int i;
 
-	if (unlikely(nr < 0))
+	if (unlikely((nr*sizeof(*iocbpp)) < 0))
 		return -EINVAL;
 
 	if (unlikely(!access_ok(VERIFY_READ, iocbpp, (nr*sizeof(*iocbpp)))))
Index: linux-2.6.20-rc6-mm3/fs/compat.c
===================================================================
--- linux-2.6.20-rc6-mm3.orig/fs/compat.c	2007-01-30 11:30:29.000000000 +0100
+++ linux-2.6.20-rc6-mm3/fs/compat.c	2007-01-30 11:31:55.000000000 +0100
@@ -651,7 +651,7 @@ compat_sys_io_submit(aio_context_t ctx_i
 	long ret = 0;
 	int i;
 
-	if (unlikely(nr < 0))
+	if (unlikely((nr * sizeof(u32)) < 0))
 		return -EINVAL;
 
 	if (unlikely(!access_ok(VERIFY_READ, iocb, (nr * sizeof(u32)))))
