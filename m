Return-Path: <linux-kernel-owner+w=401wt.eu-S1161705AbXEAK0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161705AbXEAK0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161706AbXEAK0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:26:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161686AbXEAK0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:26:05 -0400
Subject: [DLM] Fix dlm_lowcoms_stop hang [28/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Josef Bacik <jwhiter@redhat.com>,
       Patrick Caulfield <pcaulfie@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:21:30 +0100
Message-Id: <1178014890.5462.186.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2439fe50724e8693e8b933b3f8125d870bfbdb25 Mon Sep 17 00:00:00 2001
From: Josef Bacik <jwhiter@redhat.com>
Date: Thu, 19 Apr 2007 17:59:05 -0400
Subject: [PATCH] [DLM] Fix dlm_lowcoms_stop hang

When you attempt to release a lockspace in DLM, it will hang trying to down a
semaphore that has already been downed.  The attached patch fixes the problem.

Signed-off-by: Josef Bacik <jwhiter@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Patrick Caulfield <pcaulfie@redhat.com>

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 76399b7..2b32f3c 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1407,7 +1407,7 @@ void dlm_lowcomms_stop(void)
 	clean_writequeues();
 
 	for (i = 0; i < max_nodeid; i++) {
-		con = nodeid2con(i, 0);
+		con = __nodeid2con(i, 0);
 		if (con) {
 			close_connection(con, true);
 			if (con->othercon)
-- 
1.5.1.2



