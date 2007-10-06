Return-Path: <linux-kernel-owner+w=401wt.eu-S1764250AbXJFQ0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764250AbXJFQ0v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 12:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760238AbXJFQ0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 12:26:42 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:25169 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbXJFQ0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 12:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Sh7kJCvVEdpUf+LMBC/V2xmHluCYY5I+JQRlfwTqkOva5NJx2aWg09BCUMCauMslGoO4i5yrQ8/J0CAXFh1LgEb7if7YS6SfNyDLHbmfuq4U9Gzx1YxdH/SJJBtJ+1CurfGTZQVCcprkP4fZDYbKNj0nBPlNPmDsJJHVgxJrCR4=
Message-ID: <3d0408630710060926g7c2bad34je881b01a0cfecf72@mail.gmail.com>
Date: Sun, 7 Oct 2007 00:26:37 +0800
From: "Yan Zheng" <yanzheng@21cn.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH]AIO: fix cleanup in io_submit_one(...)
In-Reply-To: <3d0408630710060924l348462e4k67d462f5e85079a6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d0408630710060924l348462e4k67d462f5e85079a6@mail.gmail.com>
X-Google-Sender-Auth: 55412c356e8549d5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When IOCB_FLAG_RESFD flag is set and iocb->aio_resfd is incorrect,
statement 'goto out_put_req' is executed. At label 'out_put_req',
aio_put_req(..) is called, which requires 'req->ki_filp' set.

Regards

Signed-off-by: Yan Zheng<yanzheng@21cn.com>
----
diff -ur linux-2.6.23-rc9/fs/aio.c linux/fs/aio.c
--- linux-2.6.23-rc9/fs/aio.c   2007-07-09 07:32:17.000000000 +0800
+++ linux/fs/aio.c      2007-10-07 00:05:10.000000000 +0800
@@ -1562,6 +1562,7 @@
                fput(file);
                return -EAGAIN;
        }
+       req->ki_filp = file;
        if (iocb->aio_flags & IOCB_FLAG_RESFD) {
                /*
                 * If the IOCB_FLAG_RESFD flag of aio_flags is set, get an
@@ -1576,7 +1577,6 @@
                }
        }

-       req->ki_filp = file;
        ret = put_user(req->ki_key, &user_iocb->aio_key);
        if (unlikely(ret)) {
                dprintk("EFAULT: aio_key\n");
