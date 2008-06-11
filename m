Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbYFKKDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbYFKKDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 06:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYFKKCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 06:02:47 -0400
Received: from sacred.ru ([62.205.161.221]:36607 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746AbYFKKCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 06:02:46 -0400
Message-ID: <484FA0B8.2000002@openvz.org>
Date: Wed, 11 Jun 2008 13:54:00 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: autofs mailing list <autofs@linux.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: [PATCH] autofs4: fix 32-bit userspace vs 64-bit kernel communications
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 11 Jun 2008 13:56:19 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

The struct autofs_v5_packet has only one difference between
32-bit and 64-bit versions - on 64-bit gcc aligns its size and
it is 4 bytes larger that it is on 32-bit kernel. This confuses
32-bit user-space daemon, when talking to 64-bit kernel.

This is very critical for containerized setups, when containers
with <different>-bit tolls are used.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index 1e4a539..9855b6e 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -132,6 +132,14 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
 		struct autofs_v5_packet *packet = &pkt.v5_pkt.v5_packet;
 
 		pktsz = sizeof(*packet);
+#if defined(CONFIG_X86_64) && defined(CONFIG_IA32_EMULATION)
+		/*
+		 * On x86_64 autofs_v5_packet struct is padded with 4 bytes
+		 * which breaks 32-bit autofs daemon.
+		 */
+		if (test_thread_flag(TIF_IA32))
+			pktsz -= 4;
+#endif
 
 		packet->wait_queue_token = wq->wait_queue_token;
 		packet->len = wq->len;

