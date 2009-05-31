Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbZEaB6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbZEaB6Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 21:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbZEaB6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 21:58:04 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:58887 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZEaB6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 21:58:03 -0400
Date: Sat, 30 May 2009 18:55:37 -0700
From: "Larry H." <research@subreption.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@osdl.org>
Subject: [PATCH] Use kzfree in tty buffer management to enforce data
	sanitization
Message-ID: <20090531015537.GA8941@oblivion.subreption.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] Use kzfree in tty buffer management to enforce data sanitization

This patch replaces the kfree() calls within the tty buffer management API
with kzfree(), to enforce sanitization of the buffer contents.

It also takes care of handling buffers larger than PAGE_SIZE, which are
allocated via the page allocator directly.

This prevents such information from persisting on memory, potentially
leaking sensitive data like access credentials, or being leaked to other
kernel users after re-allocation of the memory by the LIFO allocators.

This patch doesn't affect fastpaths.

Signed-off-by: Larry Highsmith <research@subreption.com>

Index: linux-2.6/drivers/char/tty_audit.c
===================================================================
--- linux-2.6.orig/drivers/char/tty_audit.c
+++ linux-2.6/drivers/char/tty_audit.c
@@ -54,10 +54,12 @@ err:
 static void tty_audit_buf_free(struct tty_audit_buf *buf)
 {
 	WARN_ON(buf->valid != 0);
-	if (PAGE_SIZE != N_TTY_BUF_SIZE)
-		kfree(buf->data);
-	else
+	if (PAGE_SIZE != N_TTY_BUF_SIZE) {
+		kzfree(buf->data);
+	} else {
+		memset(buf->data, 0, PAGE_SIZE);
 		free_page((unsigned long)buf->data);
+	}
 	kfree(buf);
 }
 
