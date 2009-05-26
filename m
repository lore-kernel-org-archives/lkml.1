Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbZEZIL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbZEZIL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 04:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZEZILO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 04:11:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37006 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbZEZILM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 04:11:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] kmod: Release sub_info on cred allocation failure.
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       David Howells <dhowells@redhat.com>
Date: Tue, 26 May 2009 09:11:03 +0100
Message-ID: <20090526081103.9132.98194.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

call_usermodehelper_setup() forgot to kfree(sub_info)
when prepare_usermodehelper_creds() failed.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/kmod.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/kernel/kmod.c b/kernel/kmod.c
index b750675..7e95bed 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -370,8 +370,10 @@ struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
 	sub_info->argv = argv;
 	sub_info->envp = envp;
 	sub_info->cred = prepare_usermodehelper_creds();
-	if (!sub_info->cred)
+	if (!sub_info->cred) {
+		kfree(sub_info);
 		return NULL;
+	}
 
   out:
 	return sub_info;

