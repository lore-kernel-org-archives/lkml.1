Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbYHaJhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbYHaJhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 05:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230AbYHaJhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 05:37:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:37901 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077AbYHaJhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 05:37:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=W/I2uL0YLjfh4EUYN+e9Pwh2h26vqoR+YY4OtAA5h4RF8UpKgN3HW1ok8Fpnum5+HJ
         iezuA4NDS/e+FUIiESYHnbJyvIhTZsMwrswL6olVJWg9l3VC5BeQ72y1AXmINy1sq1Bk
         HGGPU1lgsQgFe96xrS7rI/SymxeH+cIj3pkbs=
Date: Sun, 31 Aug 2008 13:37:05 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: bfields@fieldses.org, neilb@suse.de, daw@cs.berkeley.edu,
       David Miller <davem@davemloft.net>
Subject: [PATCH] sunrpc - fixup user buffer overrun on 'transports'
	statistics
Message-ID: <20080831093705.GB7391@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum at Sat, 30 Aug 2008 20:44:22 +0200
------------------------------------------------
> I noticed that something weird is going on with /proc/sys/sunrpc/transports.
> This file is generated in net/sunrpc/sysctl.c, function proc_do_xprt(). When
> I "cat" this file, I get the expected output:
>
>    $ cat /proc/sys/sunrpc/transports
>    tcp 1048576
>    udp 32768

> But I think that it does not check the length of the buffer supplied by
> userspace to read(). With my original program, I found that the stack was
> being overwritten by the characters above, even when the length given to
> read() was just 1.

David Wagner <daw@cs.berkeley.edu> Sat, 30 Aug 2008 22:55:51 +0000 (UTC)
------------------------------------------------------------------------
>
> 4. Is proc_dostring() relevant here?
>

proc_do_xprt doesn't check for userside buffer size indeed so
we better to use proc_dostring.

Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
CC: David Wagner <daw@cs.berkeley.edu>
---

Please check, I don't have sunrpc on my machine built.

Index: linux-2.6.git/net/sunrpc/sysctl.c
===================================================================
--- linux-2.6.git.orig/net/sunrpc/sysctl.c	2008-07-20 11:40:14.000000000 +0400
+++ linux-2.6.git/net/sunrpc/sysctl.c	2008-08-31 13:22:16.000000000 +0400
@@ -39,6 +39,7 @@ EXPORT_SYMBOL_GPL(nlm_debug);
 
 static struct ctl_table_header *sunrpc_table_header;
 static ctl_table		sunrpc_table[];
+static char sunrpc_transport_stat[256];
 
 void
 rpc_register_sysctl(void)
@@ -56,30 +57,6 @@ rpc_unregister_sysctl(void)
 	}
 }
 
-static int proc_do_xprt(ctl_table *table, int write, struct file *file,
-			void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	char tmpbuf[256];
-	int len;
-	if ((*ppos && !write) || !*lenp) {
-		*lenp = 0;
-		return 0;
-	}
-	if (write)
-		return -EINVAL;
-	else {
-		len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
-		if (!access_ok(VERIFY_WRITE, buffer, len))
-			return -EFAULT;
-
-		if (__copy_to_user(buffer, tmpbuf, len))
-			return -EFAULT;
-	}
-	*lenp -= len;
-	*ppos += len;
-	return 0;
-}
-
 static int
 proc_dodebug(ctl_table *table, int write, struct file *file,
 				void __user *buffer, size_t *lenp, loff_t *ppos)
@@ -174,9 +151,11 @@ static ctl_table debug_table[] = {
 	},
 	{
 		.procname	= "transports",
-		.maxlen		= 256,
+		.data		= &sunrpc_transport_stat,
+		.maxlen		= sizeof(sunrpc_transport_stat),
 		.mode		= 0444,
-		.proc_handler	= &proc_do_xprt,
+		.proc_handler	= &proc_dostring,
+		.strategy	= &sysctl_string
 	},
 	{ .ctl_name = 0 }
 };
