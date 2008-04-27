Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbYD0ESw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbYD0ESw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 00:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYD0ESl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 00:18:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:10942 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYD0ESk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 00:18:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:message-id;
        b=XEqf1WUZ/rm4CLkC7kNg1dD9YR4HxO1nQqT+KtWf+yYXZs0PZwx7rsDWyFv99ZOXOUBFruraGs+YAbpJjyfi4DQYB11vphwn8Be3vJHw2Q+DEFCPL++KKV3JAwKRLiDK7UHajGrGiswhvZmEoO+ICBETPiEXNm9PstbHo5/NjOA=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>, Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH] vfs: reduce stack usage by shrinking struct kiocb
Date: Sun, 27 Apr 2008 06:17:36 +0200
User-Agent: KMail/1.8.2
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-aio@kvack.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_g5/EI0ZahsCaZ9p"
Message-Id: <200804270617.36629.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_g5/EI0ZahsCaZ9p
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Al, Benjamin, David,

struct kiocb is placed on stack by, for example, do_sync_write().
Eventually it contributes to xfs writeout path's stack usage, among others.
This is *the* path which causes 4k stack overflows on i386 with xfs.

This patch trivially reorders fields of this structure,
and makes some of them smaller.

Reordering helps 64-bit architectures:
int, void*, int, void* - bad,
int, int, void*, void* - better.

These fields are made smaller:
ki_flags: long -> short: possible values are 0,1,2, so short is enough.
ki_nr_segs: ulong -> uint: nobody uses 4 billion element writev's
                           (and it would not work anyway)
ki_cur_seg: same

For 32bit x86, it makes this struct only 4 bytes smaller.
This isn't much, but it helps not only xfs, but all filesystems.

For 64-bit case savings are a bit more significant,
as ulong -> uint actually makes a difference, and reordering
of 64-bit fields eliminates some padding.

Only compile tested. Observed stack reductions on 32 bits:

-sock_recvmsg [vmlinux]:                        196
-sock_sendmsg [vmlinux]:                        196
+sock_recvmsg [vmlinux]:                        192
+sock_sendmsg [vmlinux]:                        192
-do_sync_write [vmlinux]:                       140
-do_sync_read [vmlinux]:                        140
+do_sync_write [vmlinux]:                       136
+do_sync_read [vmlinux]:                        136
-do_sync_readv_writev [vmlinux]:                132
+do_sync_readv_writev [vmlinux]:                128

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_g5/EI0ZahsCaZ9p
Content-Type: text/x-diff;
  charset="us-ascii";
  name="stk4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="stk4.diff"

diff -urpN linux-2.6-xfs1/include/linux/aio.h linux-2.6-xfs1.stk4/include/linux/aio.h
--- linux-2.6-xfs1/include/linux/aio.h	2008-03-30 03:27:54.000000000 +0200
+++ linux-2.6-xfs1.stk4/include/linux/aio.h	2008-04-27 05:47:09.000000000 +0200
@@ -86,7 +86,8 @@ struct kioctx;
  */
 struct kiocb {
 	struct list_head	ki_run_list;
-	unsigned long		ki_flags;
+	unsigned short		ki_flags; /* range: 0..2 */
+	unsigned short		ki_opcode;
 	int			ki_users;
 	unsigned		ki_key;		/* id of this request */
 
@@ -102,23 +103,22 @@ struct kiocb {
 	} ki_obj;
 
 	__u64			ki_user_data;	/* user's data for completion */
-	wait_queue_t		ki_wait;
 	loff_t			ki_pos;
+	wait_queue_t		ki_wait;
 
 	void			*private;
 	/* State that we remember to be able to restart/retry  */
-	unsigned short		ki_opcode;
+	/*unsigned short	ki_opcode; - moved up for denser packing */
 	size_t			ki_nbytes; 	/* copy of iocb->aio_nbytes */
-	char 			__user *ki_buf;	/* remaining iocb->aio_buf */
 	size_t			ki_left; 	/* remaining bytes */
+	unsigned		ki_nr_segs;
+	unsigned		ki_cur_seg;
 	struct iovec		ki_inline_vec;	/* inline vector */
+	char 			__user *ki_buf;	/* remaining iocb->aio_buf */
  	struct iovec		*ki_iovec;
- 	unsigned long		ki_nr_segs;
- 	unsigned long		ki_cur_seg;
 
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
-
 	/*
 	 * If the aio_resfd field of the userspace iocb is not zero,
 	 * this is the underlying file* to deliver event to.

--Boundary-00=_g5/EI0ZahsCaZ9p--
