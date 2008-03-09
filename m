Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbYCIV3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbYCIV3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 17:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYCIV3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 17:29:00 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:47822 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbYCIV3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 17:29:00 -0400
Date: Mon, 10 Mar 2008 00:28:26 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 9/6] signals: fold sig_ignored() into prepare_signal()
Message-ID: <20080309212826.GA2013@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(the last one on this)

Now that prepare_signal() returns int it can absorb the sig_ignored() check
to avoid the code duplication.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~9_PS_CK_IGNORED	2008-03-09 23:07:26.000000000 +0300
+++ 25/kernel/signal.c	2008-03-10 00:11:50.000000000 +0300
@@ -645,7 +645,7 @@ static int prepare_signal(int sig, struc
 		}
 	}
 
-	return 1;
+	return !sig_ignored(p, sig);
 }
 
 /*
@@ -763,7 +763,7 @@ static int send_signal(int sig, struct s
 	 * exactly one non-rt signal, so that we can get more
 	 * detailed information about the cause of the signal.
 	 */
-	if (sig_ignored(t, sig) || legacy_queue(pending, sig))
+	if (legacy_queue(pending, sig))
 		return 0;
 
 	/*
@@ -1253,9 +1253,6 @@ int send_sigqueue(struct sigqueue *q, st
 	if (!likely(prepare_signal(sig, t)))
 		goto out;
 
-	if (sig_ignored(t, sig))
-		goto out;
-
 	ret = 0;
 	if (unlikely(!list_empty(&q->list))) {
 		/*

