Return-Path: <linux-kernel-owner+w=401wt.eu-S1422924AbXCGR0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422924AbXCGR0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965632AbXCGRZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:25:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43742 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422906AbXCGRSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:18:09 -0500
Message-Id: <20070307171631.420556680@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:12:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, npiggin@suse.de,
       cmm@us.ibm.com
Subject: [patch 089/101] buffer: memorder fix
Content-Disposition: inline; filename=buffer-memorder-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Nick Piggin <npiggin@suse.de>

unlock_buffer(), like unlock_page(), must not clear the lock without
ensuring that the critical section is closed.


Mingming later sent the same patch, saying:

We are running SDET benchmark and saw double free issue for ext3 extended
attributes block, which complains the same xattr block already being freed (in
ext3_xattr_release_block()).  The problem could also been triggered by
multiple threads loop untar/rm a kernel tree.

The race is caused by missing a memory barrier at unlock_buffer() before the
lock bit being cleared, resulting in possible concurrent h_refcounter update. 
That causes a reference counter leak, then later leads to the double free that
we have seen.

Inside unlock_buffer(), there is a memory barrier is placed *after* the lock
bit is being cleared, however, there is no memory barrier *before* the bit is
cleared.  On some arch the h_refcount update instruction and the clear bit
instruction could be reordered, thus leave the critical section re-entered.

The race is like this: For example, if the h_refcount is initialized as 1,

cpu 0:                                   cpu1
--------------------------------------   -----------------------------------
lock_buffer() /* test_and_set_bit */
clear_buffer_locked(bh);             
                                        lock_buffer() /* test_and_set_bit */
h_refcount = h_refcount+1; /* = 2*/     h_refcount = h_refcount + 1; /*= 2 */
                                        clear_buffer_locked(bh);
....                                    ......


We lost a h_refcount here.  We need a memory barrier before the buffer head
lock bit being cleared to force the order of the two writes.  Please apply.


Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/buffer.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.20.1.orig/fs/buffer.c
+++ linux-2.6.20.1/fs/buffer.c
@@ -78,6 +78,7 @@ EXPORT_SYMBOL(__lock_buffer);
 
 void fastcall unlock_buffer(struct buffer_head *bh)
 {
+	smp_mb__before_clear_bit();
 	clear_buffer_locked(bh);
 	smp_mb__after_clear_bit();
 	wake_up_bit(&bh->b_state, BH_Lock);

--
