Return-Path: <linux-kernel-owner+w=401wt.eu-S1758381AbYGAJaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381AbYGAJaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbYGAJ3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:29:15 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:58789
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758666AbYGAJ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:29:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADSWaUjLO9AP/2dsb2JhbACyBw
X-IronPort-AV: E=Sophos;i="4.27,730,1204470000"; 
   d="scan'208";a="242140637"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 4/5] autofs4 - check kernel communication pipe is valid for
	write
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 01 Jul 2008 17:26:15 +0800
Message-ID: <20080701092613.12041.19457.stgit@raven.themaw.net>
In-Reply-To: <20080701092548.12041.69868.stgit@raven.themaw.net>
References: <20080701092548.12041.69868.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible for an autofs mount to become catatonic (and for the
daemon communication pipe to become NULL) after a wait has been
initiallized but before the request has been sent to the daemon. We
need to check for this before sending the request packet.

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/waitq.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)


diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index f8dee31..aa7b526 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -99,6 +99,7 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 		union autofs_packet_union v4_pkt;
 		union autofs_v5_packet_union v5_pkt;
 	} pkt;
+	struct file *pipe = NULL;
 	size_t pktsz;
 
 	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d",
@@ -164,8 +165,19 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 		return;
 	}
 
-	if (autofs4_write(sbi->pipe, &pkt, pktsz))
-		autofs4_catatonic_mode(sbi);
+	/* Check if we have become catatonic */
+	mutex_lock(&sbi->wq_mutex);
+	if (!sbi->catatonic) {
+		pipe = sbi->pipe;
+		get_file(pipe);
+	}
+	mutex_unlock(&sbi->wq_mutex);
+
+	if (pipe) {
+		if (autofs4_write(pipe, &pkt, pktsz))
+			autofs4_catatonic_mode(sbi);
+		fput(pipe);
+	}
 }
 
 static int autofs4_getpath(struct autofs_sb_info *sbi,
