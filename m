Return-Path: <linux-kernel-owner+w=401wt.eu-S937240AbXG0PY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937240AbXG0PY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 11:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933819AbXG0PYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 11:24:48 -0400
Received: from [198.99.130.12] ([198.99.130.12]:52440 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933813AbXG0PYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 11:24:47 -0400
Date: Fri, 27 Jul 2007 11:23:44 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
Subject: [PATCH] UML - Console should handle spurious IRQS
Message-ID: <20070727152344.GA6776@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The previous DEBUG_SHIRQ patch missed one case.  The console doesn't
set its host descriptors non-blocking.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/chan_kern.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.21-mm/arch/um/drivers/chan_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/chan_kern.c	2007-07-27 10:52:02.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/chan_kern.c	2007-07-27 11:09:12.000000000 -0400
@@ -157,7 +157,7 @@ static void tty_receive_char(struct tty_
 
 static int open_one_chan(struct chan *chan)
 {
-	int fd;
+	int fd, err;
 
 	if(chan->opened)
 		return 0;
@@ -168,6 +168,13 @@ static int open_one_chan(struct chan *ch
 				     chan->data, &chan->dev);
 	if(fd < 0)
 		return fd;
+
+	err = os_set_fd_block(fd, 0);
+	if (err) {
+		(*chan->ops->close)(fd, chan->data);
+		return err;
+	}
+
 	chan->fd = fd;
 
 	chan->opened = 1;
