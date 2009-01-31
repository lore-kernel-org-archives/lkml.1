Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbZAaUbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbZAaUbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 15:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZAaUbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 15:31:08 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:22488 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbZAaUbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 15:31:06 -0500
Message-ID: <4984B4FC.60107@oracle.com>
Date: Sat, 31 Jan 2009 12:30:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mmotm/fold] sysrq: emergency thaw only if CONFIG_BLOCK enabled
References: <200901310909.n0V99XIZ021497@imap1.linux-foundation.org>
In-Reply-To: <200901310909.n0V99XIZ021497@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4984B4FE.02CF:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

sysrq's new emergency_thaw_all() is only available when CONFIG_BLOCK=y:

drivers/char/sysrq.c:351: error: implicit declaration of function 'emergency_thaw_all'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/char/sysrq.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- mmotm-2009-0131-0108.orig/drivers/char/sysrq.c
+++ mmotm-2009-0131-0108/drivers/char/sysrq.c
@@ -346,6 +346,7 @@ static struct sysrq_key_op sysrq_moom_op
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
 
+#ifdef CONFIG_BLOCK
 static void sysrq_handle_thaw(int key, struct tty_struct *tty)
 {
 	emergency_thaw_all();
@@ -356,6 +357,7 @@ static struct sysrq_key_op sysrq_thaw_op
 	.action_msg	= "Emergency Thaw of all frozen filesystems",
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
+#endif
 
 static void sysrq_handle_kill(int key, struct tty_struct *tty)
 {
@@ -409,7 +411,11 @@ static struct sysrq_key_op *sysrq_key_ta
 	NULL,				/* g */
 	NULL,				/* h - reserved for help */
 	&sysrq_kill_op,			/* i */
+#ifdef CONFIG_BLOCK
 	&sysrq_thaw_op,			/* j */
+#else
+	NULL,				/* j */
+#endif
 	&sysrq_SAK_op,			/* k */
 #ifdef CONFIG_SMP
 	&sysrq_showallcpus_op,		/* l */
