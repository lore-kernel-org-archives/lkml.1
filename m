Return-Path: <linux-kernel-owner+w=401wt.eu-S1760351AbXGETnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbXGETnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 15:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758302AbXGETm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 15:42:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758137AbXGETm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 15:42:58 -0400
Date: Thu, 5 Jul 2007 15:42:54 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-cifs-client@lists.samba.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] error out if signing was requested, but can't be fulfilled
Message-Id: <20070705154254.5f0f2a65.jlayton@redhat.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if mount with a signing-enabled sec= option (e.g.
sec=ntlmi), the kernel does a warning printk if the server doesn't
support signing, and then proceeds without signatures.

This is probably OK for people that think to look at the ring buffer,
but seems wrong to me. If someone explicitly requests signing, we
should error out if that request can't be satisfied. They can then
reattempt the mount without signing if that's ok.

Is there any reason not to do something like the following patch?

Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 4a2458e..c9cae48 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -650,6 +650,7 @@ signing_check:
 			(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED)) == 0) {
 			cERROR(1,
 				("signing required but server lacks support"));
+			rc = -EOPNOTSUPP;
 		} else
 			server->secMode |= SECMODE_SIGN_REQUIRED;
 	} else {
