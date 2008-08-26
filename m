Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbYHZO3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbYHZO3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 10:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756354AbYHZO33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 10:29:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:59744 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648AbYHZO33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 10:29:29 -0400
Subject: Re: flag parameters: socket and socketpair
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org, drepper@redhat.com
Cc: sgrubb@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200807242308.m6ON8mRV023925@hera.kernel.org>
References: <200807242308.m6ON8mRV023925@hera.kernel.org>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 15:29:22 +0100
Message-Id: <1219760962.7107.68.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 23:08 +0000, Linux Kernel Mailing List wrote:
> Commit:     a677a039be7243357d93502bff2b40850c942e2d

> diff --git a/include/linux/net.h b/include/linux/net.h
> index 150a48c..8b5383c 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -20,6 +20,7 @@
>  
>  #include <linux/wait.h>
>  #include <linux/socket.h>
> +#include <linux/fcntl.h>       /* For O_CLOEXEC */
>  #include <asm/socket.h>
>  
>  struct poll_table_struct;

Hm. This leads to errors such as the ones shown at
http://koji.fedoraproject.org/koji/getfile?taskID=785282&name=build.log

In file included from /usr/include/asm/fcntl.h:1,
                 from /usr/include/linux/fcntl.h:4,
                 from /usr/include/linux/net.h:23,
                 from gen_tables.c:28:
/usr/include/asm-generic/fcntl.h:120: error: expected specifier-qualifier-list before 'off_t'
/usr/include/asm-generic/fcntl.h:143: error: expected specifier-qualifier-list before 'loff_t'

You don't need to include <linux/fcntl.h> in the !__KERNEL__ case, so
that inclusion should probably live within the existing #ifdef
__KERNEL__, so we don't pull <linux/fcntl.h> in where it's not needed.

-----
Subject: Fix userspace export of <linux/net.h>

Including <linux/fcntl.h> in the user-visible part of this header has
caused build regressions with headers from 2.6.27-rc. Move it down to
the #ifdef __KERNEL__ part, which is the only place it's needed. Move
some other kernel-only things down there too, while we're at it.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/include/linux/net.h b/include/linux/net.h
index 4a9a30f..6dc14a2 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -18,16 +18,9 @@
 #ifndef _LINUX_NET_H
 #define _LINUX_NET_H
 
-#include <linux/wait.h>
 #include <linux/socket.h>
-#include <linux/fcntl.h>	/* For O_CLOEXEC and O_NONBLOCK */
 #include <asm/socket.h>
 
-struct poll_table_struct;
-struct pipe_inode_info;
-struct inode;
-struct net;
-
 #define NPROTO		AF_MAX
 
 #define SYS_SOCKET	1		/* sys_socket(2)		*/
@@ -62,6 +55,13 @@ typedef enum {
 #ifdef __KERNEL__
 #include <linux/stringify.h>
 #include <linux/random.h>
+#include <linux/wait.h>
+#include <linux/fcntl.h>	/* For O_CLOEXEC and O_NONBLOCK */
+
+struct poll_table_struct;
+struct pipe_inode_info;
+struct inode;
+struct net;
 
 #define SOCK_ASYNC_NOSPACE	0
 #define SOCK_ASYNC_WAITDATA	1

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



