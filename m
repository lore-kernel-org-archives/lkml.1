Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261Ab0ATXu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab0ATXu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005Ab0ATXuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:50:52 -0500
Received: from kroah.org ([198.145.64.141]:33639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab0ATXut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:50:49 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/8] nozomi: quick fix for the close/close bug
Date: Wed, 20 Jan 2010 15:49:57 -0800
Message-Id: <1264031403-32239-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100120234759.GC32068@kroah.com>
References: <20100120234759.GC32068@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Nozomi goes wrong if you get the sequence

	open
	open
	close

	[stuff]
	close

which turns out to occur on some ppp type setups.

This is a quick patch up for the problem. It's not really fixing Nozomi
which completely fails to implement tty open/close semantics and all the
other needed stuff. Doing it right is a rather more invasive patch set and
not one that will backport.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/nozomi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 7d73cd4..2ad7d37 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1651,10 +1651,10 @@ static void ntty_close(struct tty_struct *tty, struct file *file)
 
 	dc->open_ttys--;
 	port->count--;
-	tty_port_tty_set(port, NULL);
 
 	if (port->count == 0) {
 		DBG1("close: %d", nport->token_dl);
+		tty_port_tty_set(port, NULL);
 		spin_lock_irqsave(&dc->spin_mutex, flags);
 		dc->last_ier &= ~(nport->token_dl);
 		writew(dc->last_ier, dc->reg_ier);
-- 
1.6.5.7

