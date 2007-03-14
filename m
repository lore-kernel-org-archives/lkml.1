Return-Path: <linux-kernel-owner+w=401wt.eu-S1161217AbXCNMZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161217AbXCNMZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161213AbXCNMZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:25:23 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:37305 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161208AbXCNMZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:25:22 -0400
Message-ID: <45F7E945.10406@sw.ru>
Date: Wed, 14 Mar 2007 15:23:33 +0300
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, Urban Widmark <urban@teststation.com>,
       devel@openvz.org
Subject: [patch 2.6.21-rc3] [smbfs] "double free" memory corruption in smbfs
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

smbfs allocates rq_trans2buffer to handle server's multi transaction2 response
messages. As struct smb_request may be reused, rq_trans2buffer is freed before
each new request. However if last servers's response is not multi but single
trans2 message then new rq_trans2buffer is not allocated but last smb_rput still
tries to free it again.
To prevent this issue rq_trans2buffer pointer should be set to NULL after kfree.

Signed-off-by:	Vasily Averin <vvs@sw.ru>

--- 2.6.21-rc3/fs/smbfs/request.c	2007-03-13 14:22:53.000000000 +0300
+++ 2.6.21-rc3/fs/smbfs/request.c	2007-03-14 11:44:18.000000000 +0300
@@ -181,6 +181,7 @@ static int smb_setup_request(struct smb_
 	req->rq_errno = 0;
 	req->rq_fragment = 0;
 	kfree(req->rq_trans2buffer);
+	req->rq_trans2buffer = NULL;

 	return 0;
 }
