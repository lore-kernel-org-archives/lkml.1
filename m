Return-Path: <linux-kernel-owner+w=401wt.eu-S933822AbZHGU1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822AbZHGU1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933709AbZHGU1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:27:20 -0400
Received: from www84.your-server.de ([213.133.104.84]:44470 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933783AbZHGU1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:27:13 -0400
Subject: [PATCH] Fix proc_file_write missing ppos update
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 22:27:10 +0200
Message-Id: <1249676830.27640.16.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following fix a long standing issue in the proc_file_write function,
which doesn't update the ppos file position pointer.

This prevent the usage of multiple sequently writes on an opened proc
file, because it is impossible to distinguish these due the offset is
always 0.

Signed-off-by: Stefani Seibold <stefani@seibold.net>

 generic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.31-rc4.orig/fs/proc/generic.c	2009-08-07 22:05:57.000000000 +0200
+++ linux-2.6.30-rc4/fs/proc/generic.c	2009-08-07 22:06:22.000000000 +0200
@@ -219,9 +219,10 @@
 		pde->pde_users++;
 		spin_unlock(&pde->pde_unload_lock);
 
-		/* FIXME: does this routine need ppos?  probably... */
 		rv = pde->write_proc(file, buffer, count, pde->data);
 		pde_users_dec(pde);
+		if (rv > 0)
+			*ppos += rv;
 	}
 	return rv;
 }


