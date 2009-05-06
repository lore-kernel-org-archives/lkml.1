Return-Path: <linux-kernel-owner+w=401wt.eu-S1762140AbZEFV7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762140AbZEFV7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761404AbZEFVyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:32 -0400
Received: from kroah.org ([198.145.64.141]:57003 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760832AbZEFVy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:57 2009
Message-Id: <20090506214757.027833877@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 13/58] virtio-rng: Remove false BUG for spurious callbacks
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=virtio-rng-remove-false-bug-for-spurious-callbacks.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

upstream commit: e5b89542ea18020961882228c26db3ba87f6e608

The virtio-rng drivers checks for spurious callbacks. Since
callbacks can be implemented via shared interrupts (e.g. PCI) this
could lead to guest kernel oopses with lots of virtio devices.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/char/hw_random/virtio-rng.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -37,9 +37,9 @@ static void random_recv_done(struct virt
 {
 	int len;
 
-	/* We never get spurious callbacks. */
+	/* We can get spurious callbacks, e.g. shared IRQs + virtio_pci. */
 	if (!vq->vq_ops->get_buf(vq, &len))
-		BUG();
+		return;
 
 	data_left = len / sizeof(random_data[0]);
 	complete(&have_data);


