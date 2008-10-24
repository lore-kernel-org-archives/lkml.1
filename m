Return-Path: <linux-kernel-owner+w=401wt.eu-S1757826AbYJXEtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826AbYJXEtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYJXEjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:44 -0400
Received: from kroah.org ([198.145.64.141]:51882 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752584AbYJXEj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:27 -0400
Date: Thu, 23 Oct 2008 21:34:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 20/27] hvc_console: Fix free_irq in spinlocked section
Message-ID: <20081024043457.GU30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hvc_console-fix-free_irq-in-spinlocked-section.patch"
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Christian Borntraeger <borntraeger@de.ibm.com>

commit eef2622a9fcfa964073333ea72c7c9cd20ad45e6 upstream

hvc_console: Fix free_irq in spinlocked section

    commit 611e097d7707741a336a0677d9d69bec40f29f3d
    Author: Christian Borntraeger <borntraeger@de.ibm.com>
    hvc_console: rework setup to replace irq functions with callbacks
    introduced a spinlock recursion problem. The notifier_del is
    called with a lock held, and in turns calls free_irq which then
    complains when manipulating procfs. This fixes it by moving the
    call to the notifier to outside of the locked section.

Signed-off-by: Christian Borntraeger<borntraeger@de.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/hvc_console.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -367,13 +367,13 @@ static void hvc_close(struct tty_struct 
 	spin_lock_irqsave(&hp->lock, flags);
 
 	if (--hp->count == 0) {
-		if (hp->ops->notifier_del)
-			hp->ops->notifier_del(hp, hp->data);
-
 		/* We are done with the tty pointer now. */
 		hp->tty = NULL;
 		spin_unlock_irqrestore(&hp->lock, flags);
 
+		if (hp->ops->notifier_del)
+			hp->ops->notifier_del(hp, hp->data);
+
 		/*
 		 * Chain calls chars_in_buffer() and returns immediately if
 		 * there is no buffered data otherwise sleeps on a wait queue
@@ -416,11 +416,11 @@ static void hvc_hangup(struct tty_struct
 	hp->n_outbuf = 0;
 	hp->tty = NULL;
 
+	spin_unlock_irqrestore(&hp->lock, flags);
+
 	if (hp->ops->notifier_del)
 			hp->ops->notifier_del(hp, hp->data);
 
-	spin_unlock_irqrestore(&hp->lock, flags);
-
 	while(temp_open_count) {
 		--temp_open_count;
 		kref_put(&hp->kref, destroy_hvc_struct);

-- 
