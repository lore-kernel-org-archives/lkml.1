Return-Path: <linux-kernel-owner+w=401wt.eu-S933029AbXBEShx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029AbXBEShx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932588AbXBEShw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:37:52 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:33292 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933035AbXBEShu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:37:50 -0500
Subject: [PATCH]Add memory barrier before clear bit in unlock_buffer()
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Andrew Morton <akpm@osdl.org>
Cc: Andreas Gruenbacher <agruen@suse.de>,
       "Paul E. McKenney" <paulmck@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <200702050032.06905.agruen@suse.de>
References: <200702021923.02491.agruen@suse.de>
	 <200702050032.06905.agruen@suse.de>
Content-Type: text/plain
Organization: IBM LTC
Date: Mon, 05 Feb 2007 10:37:46 -0800
Message-Id: <1170700667.3815.14.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We are runnin SDET benchmark and saw double free issue for ext3 extended
attributes block, which complains the same xattr block already being
freed (in ext3_xattr_release_block()). The problem could also been
triggered by multiple threads loop untar/rm a kernel tree.

The race is caused by missing a memory barrier at unlock_buffer() before
the lock bit being cleared, resulting in possible concurrent
h_refcounter update. That causes a reference counter leak, then later
leads to the double free that we have seen.

Inside unlock_buffer(), there is a memory barrier is placed *after* the
lock bit is being cleared, however, there is no memory barrier *before*
the bit is cleared. On some arch the h_refcount update instruction and
the clear bit instruction could be reordered, thus leave the critical
section re-entered.

The race is like this: For example, if the h_refcount is initialized as
1,

cpu 0:                                   cpu1
--------------------------------------   -----------------------------------
lock_buffer() /* test_and_set_bit */
clear_buffer_locked(bh);             
                                        lock_buffer() /* test_and_set_bit */
h_refcount = h_refcount+1; /* = 2*/     h_refcount = h_refcount + 1; /*= 2 */
                                        clear_buffer_locked(bh);
....                                    ......

We lost a h_refcount here. We need a memory barrier before the buffer head lock
bit being cleared to force the order of the two writes.  Please apply.

Signed-Off-By: Mingming Cao <cmm@us.ibm.com>


--- linux/fs/buffer.c.orig	2007-02-04 11:37:50.000000000 -0600
+++ linux/fs/buffer.c	2007-02-04 11:38:14.000000000 -0600
@@ -77,6 +77,7 @@
 
 void fastcall unlock_buffer(struct buffer_head *bh)
 {
+	smp_mb__before_clear_bit();
 	clear_buffer_locked(bh);
 	smp_mb__after_clear_bit();
 	wake_up_bit(&bh->b_state, BH_Lock);


