Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbYHaKIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbYHaKIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 06:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbYHaKIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 06:08:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:45497 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbYHaKIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 06:08:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ueP96oGbhuR7qEsJR9iob73YH3OpWIHZR8QiHJFi4FbrEeSoG1JaEZdFXSOBR/yHru
         DRPpzfhxnB4KDpQnXAANYcVjiuZ2h+nRa+5uVXQSR1RynS/2kGrCePyWd2R+uQ3eQEw3
         OR6zpMK6GCjus8VNLwQE45N4L2NAT7x8BWEJM=
Date: Sun, 31 Aug 2008 14:08:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, bfields@fieldses.org,
       neilb@suse.de
Subject: [PATCH] sunrpc - fixup userspace buffer possible overrun v2
Message-ID: <20080831100806.GD7391@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum reported
----------------------
> I noticed that something weird is going on with /proc/sys/sunrpc/transports.
> This file is generated in net/sunrpc/sysctl.c, function proc_do_xprt(). When
> I "cat" this file, I get the expected output:
>    $ cat /proc/sys/sunrpc/transports
>    tcp 1048576
>    udp 32768

> But I think that it does not check the length of the buffer supplied by
> userspace to read(). With my original program, I found that the stack was
> being overwritten by the characters above, even when the length given to
> read() was just 1.

David Wagner added (among other things) that copy_to_user could be
probably used here.

The conclusion is that proc_do_xprt doesn't check for userside buffer
size indeed so fix. Also set lenp to number of bytes were really written.

Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
CC: David Wagner <daw@cs.berkeley.edu>
---

Please review.

Index: linux-2.6.git/net/sunrpc/sysctl.c
===================================================================
--- linux-2.6.git.orig/net/sunrpc/sysctl.c	2008-08-31 13:43:46.000000000 +0400
+++ linux-2.6.git/net/sunrpc/sysctl.c	2008-08-31 13:58:14.000000000 +0400
@@ -60,23 +60,26 @@ static int proc_do_xprt(ctl_table *table
 			void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	char tmpbuf[256];
-	int len;
+	size_t len;
+
 	if ((*ppos && !write) || !*lenp) {
 		*lenp = 0;
 		return 0;
 	}
+
 	if (write)
 		return -EINVAL;
 	else {
 		len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
-		if (!access_ok(VERIFY_WRITE, buffer, len))
-			return -EFAULT;
-
-		if (__copy_to_user(buffer, tmpbuf, len))
+		if (len > *lenp)
+			len = *lenp;
+		if (copy_to_user(buffer, tmpbuf, len))
 			return -EFAULT;
 	}
-	*lenp -= len;
+
+	*lenp = len;
 	*ppos += len;
+
 	return 0;
 }
 
