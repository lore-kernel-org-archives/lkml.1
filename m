Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbYHaP0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbYHaP0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 11:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbYHaPZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 11:25:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:15483 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbYHaPZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 11:25:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HxB4uJn761nmfe9tJu5Nk3L2/EyehS8/AuaJe4ih9dO+LJLYY3/FxixRFb9ltftwIR
         5XOQDYVAoQFDo7dRsmPX1qz7R5RvpMNXvk2h3itVDo1CDOWSx4ghhOSKoVmo6bpUPR7G
         SNeiX+aWK0gLW39cmCxHn740Ef7blVsTBqCfw=
Date: Sun, 31 Aug 2008 19:25:49 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Oeser <ioe-lkml@rameria.de>,
       bfields@fieldses.org, neilb@suse.de
Subject: [PATCH] sunrpc - fixup userspace buffer possible overrun v3
Message-ID: <20080831152549.GD2884@lenovo>
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

Ingo Oeser suggested to use simple_read_from_buffer() here.

The conclusion is that proc_do_xprt doesn't check for userside buffer
size indeed so fix this by using Ingo's suggestion.

Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Oeser <ioe-lkml@rameria.de>
---

Index: linux-2.6.git/net/sunrpc/sysctl.c
===================================================================
--- linux-2.6.git.orig/net/sunrpc/sysctl.c	2008-08-31 18:58:50.000000000 +0400
+++ linux-2.6.git/net/sunrpc/sysctl.c	2008-08-31 19:15:57.000000000 +0400
@@ -60,23 +60,27 @@ static int proc_do_xprt(ctl_table *table
 			void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	char tmpbuf[256];
-	int len;
+	size_t len;
+	ssize_t ret;
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
-			return -EFAULT;
+		ret = simple_read_from_buffer(buffer, *lenp, ppos,
+						tmpbuf, len);
+		if (ret >= 0) {
+			*lenp = ret;
+			ret = 0;
+		}
+		return ret;
 	}
-	*lenp -= len;
-	*ppos += len;
+
 	return 0;
 }
 
