Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbZAETnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbZAETnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZAETnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:43:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35038 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbZAETnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:43:01 -0500
Date: Mon, 5 Jan 2009 14:42:59 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>
Subject: [PATCH] sparc: make proces_ver_nack a bit more readable
In-Reply-To: <alpine.DEB.1.10.0901051428370.27085@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0901051437490.27085@gandalf.stny.rr.com>
References: <20090105181922.GA25622@uranus.ravnborg.org> <alpine.DEB.1.10.0901051428370.27085@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: clean up

The code in process_ver_nack is a little obfuscated. This change
makes it a bit more readable by humans. It removes the complex
if statement and replaces it with a cleaner flow of control.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/arch/sparc/kernel/ldc.c b/arch/sparc/kernel/ldc.c
index d689823..6ce5d25 100644
--- a/arch/sparc/kernel/ldc.c
+++ b/arch/sparc/kernel/ldc.c
@@ -625,22 +625,23 @@ static int process_ver_ack(struct ldc_channel *lp, struct ldc_version *vp)
 static int process_ver_nack(struct ldc_channel *lp, struct ldc_version *vp)
 {
 	struct ldc_version *vap;
+	struct ldc_packet *p;
+	unsigned long new_tail;
 
-	if ((vp->major == 0 && vp->minor == 0) ||
-	    !(vap = find_by_major(vp->major))) {
+	if (vp->major == 0 && vp->minor == 0)
+		return ldc_abort(lp);
+
+	vap = find_by_major(vp->major);
+	if (!vap)
 		return ldc_abort(lp);
-	} else {
-		struct ldc_packet *p;
-		unsigned long new_tail;
 
-		p = handshake_compose_ctrl(lp, LDC_INFO, LDC_VERS,
+	p = handshake_compose_ctrl(lp, LDC_INFO, LDC_VERS,
 					   vap, sizeof(*vap),
 					   &new_tail);
-		if (p)
-			return send_tx_packet(lp, p, new_tail);
-		else
-			return ldc_abort(lp);
-	}
+	if (!p)
+		return ldc_abort(lp);
+
+	return send_tx_packet(lp, p, new_tail);
 }
 
 static int process_version(struct ldc_channel *lp,


