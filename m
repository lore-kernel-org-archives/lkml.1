Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab0CBWYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:24:39 -0500
Received: from gir.skynet.ie ([193.1.99.77]:54549 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927Ab0CBWYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:24:36 -0500
Date: Tue, 2 Mar 2010 22:24:19 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] tty: Take a 256 byte padding into account when buffering
	below sub-page units
Message-ID: <20100302222419.GE11355@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(applies on top of linux-next, depends on "tty: Keep the default buffering to sub-page units")

The TTY layer takes some care to ensure that only sub-page allocations
are made with interrupts disabled. It does this by setting a goal of
"TTY_BUFFER_PAGE" to allocate. Unfortunately, while TTY_BUFFER_PAGE takes the
size of tty_buffer into account, it fails to account that tty_buffer_find()
rounds the buffer size out to the next 256 byte boundary before adding on
the size of the tty_buffer.

This patch adjusts the TTY_BUFFER_PAGE calculation to take into account the
size of the tty_buffer and the padding. Once applied, tty_buffer_alloc()
should not require high-order allocations.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 include/linux/tty.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index d96e588..8fe018b 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -70,12 +70,13 @@ struct tty_buffer {
 
 /*
  * We default to dicing tty buffer allocations to this many characters
- * in order to avoid multiple page allocations. We assume tty_buffer itself
- * is under 256 bytes. See tty_buffer_find for the allocation logic this
- * must match
+ * in order to avoid multiple page allocations. We know the size of
+ * tty_buffer itself but it must also be taken into account that the
+ * the buffer is 256 byte aligned. See tty_buffer_find for the allocation
+ * logic this must match
  */
 
-#define TTY_BUFFER_PAGE		((PAGE_SIZE  - 256) / 2)
+#define TTY_BUFFER_PAGE	(((PAGE_SIZE - sizeof(struct tty_buffer)) / 2) & ~0xFF)
 
 
 struct tty_bufhead {
