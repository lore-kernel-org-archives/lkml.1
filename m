Return-Path: <linux-kernel-owner+w=401wt.eu-S1761542AbXEJM6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761542AbXEJM6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbXEJM6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:58:35 -0400
Received: from smtp.boksi.fi ([195.10.143.42]:52942 "EHLO smtp1.boksi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbXEJM6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:58:34 -0400
Date: Thu, 10 May 2007 15:58:32 +0300
From: Mika Kukkonen <mikukkon@miku.homelinux.net>
To: akpm@google.com, ashwin.chaugule@celunite.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix bug in mm/thrash.c function grab_swap_token()
Message-ID: <20070510125832.GA16461@srv1-m700-lanp.koti>
Reply-To: mikukkon@iki.fi
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following bug was uncovered by compiling with '-W' flag:

  CC      mm/thrash.o
mm/thrash.c: In function ‘grab_swap_token’:
mm/thrash.c:52: warning: comparison of unsigned expression < 0 is always false

Field token_priority is unsigned, so decrementing first and the checking
is not a good plan. Attached patch (compile tested) reverses the order.

Btw, I'm not sure if likely() makes any sense in this new situation.

Signed-off-by: Mika Kukkonen <mikukkon@iki.fi>

diff --git a/mm/thrash.c b/mm/thrash.c
index 9ef9071..c4c5205 100644
--- a/mm/thrash.c
+++ b/mm/thrash.c
@@ -48,9 +48,8 @@ void grab_swap_token(void)
 		if (current_interval < current->mm->last_interval)
 			current->mm->token_priority++;
 		else {
-			current->mm->token_priority--;
-			if (unlikely(current->mm->token_priority < 0))
-				current->mm->token_priority = 0;
+			if (likely(current->mm->token_priority > 0))
+				current->mm->token_priority--;
 		}
 		/* Check if we deserve the token */
 		if (current->mm->token_priority >

