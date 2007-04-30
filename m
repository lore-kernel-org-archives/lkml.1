Return-Path: <linux-kernel-owner+w=401wt.eu-S1423160AbXD3I5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423160AbXD3I5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 04:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423161AbXD3I5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 04:57:16 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:40487 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423160AbXD3I5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 04:57:15 -0400
Date: Mon, 30 Apr 2007 10:56:20 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same
 time?
In-Reply-To: <Pine.LNX.4.64.0704300445460.17536@localhost.localdomain>
Message-ID: <Pine.LNX.4.61.0704301048390.22744@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0704280937060.24917@localhost.localdomain>
 <20070430001311.84d0291f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704300445460.17536@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 30 2007 04:46, Robert P. J. Day wrote:
>> >
>> >   i'd always assumed that the type flags of GFP_ATOMIC and GFP_KERNEL
>> > were mutually exclusive when it came to calling kmalloc(), at least
>> > based on everything i'd read.  so i'm not sure how to interpret the
>> > following:
>> >
>> > drivers/scsi/aic7xxx_old.c:  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
>> > drivers/message/i2o/device.c:   resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);
>> >
>> >   clarification?
>>
>> GFP_ATOMIC implies that the memory comes from the zones which
>> GFP_KERNEL also uses.  So the above usage of GFP_KERNEL is redundant
>> and should be removed.
>
>hang on ... based on an email i just got, is that reference to
>GFP_KERNEL "redundant" or "conflicting"?  big difference there.  and
>is the proper fix to remove "GFP_KERNEL" in both cases?

include/linux/gfp.h:
#define GFP_ATOMIC (__GFP_HIGH)
#define GFP_KERNEL (__GFP_WAIT | __GFP_IO | __GFP_FS)

So combining GFP_ATOMIC with GFP_KERNEL gives you
"allow io, allow fs, allow waiting, and use emergency pools when it's getting
tight"
which to me looks like a valid, but probably unwanted combination.
Perhaps this could be shuffled a little to make such combinations
less likely, by moving this around as follows:

Index: linux-2.6.21/include/linux/gfp.h
===================================================================
--- linux-2.6.21.orig/include/linux/gfp.h
+++ linux-2.6.21/include/linux/gfp.h
@@ -34,7 +34,7 @@ struct vm_area_struct;
  * __GFP_MOVABLE: Flag that this page will be movable by the page migration
  * mechanism or reclaimed
  */
-#define __GFP_WAIT	((__force gfp_t)0x10u)	/* Can wait and reschedule? */
+#define __GFP_NOWAIT	((__force gfp_t)0x10u)	/* Do not wait or reschedule */
 #define __GFP_HIGH	((__force gfp_t)0x20u)	/* Should access emergency pools? */
 #define __GFP_IO	((__force gfp_t)0x40u)	/* Can start physical IO? */
 #define __GFP_FS	((__force gfp_t)0x80u)	/* Can call down to low-level FS? */
@@ -68,14 +68,14 @@ struct vm_area_struct;
 /* This equals 0, but use constants in case they ever change */
 #define GFP_NOWAIT	(GFP_ATOMIC & ~__GFP_HIGH)
 /* GFP_ATOMIC means both !wait (__GFP_WAIT not set) and use emergency pool */
-#define GFP_ATOMIC	(__GFP_HIGH)
-#define GFP_NOIO	(__GFP_WAIT)
-#define GFP_NOFS	(__GFP_WAIT | __GFP_IO)
-#define GFP_KERNEL	(__GFP_WAIT | __GFP_IO | __GFP_FS)
-#define GFP_USER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
-#define GFP_HIGHUSER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL | \
+#define GFP_ATOMIC	(__GFP_NOWAIT | __GFP_HIGH)
+#define GFP_NOIO	0
+#define GFP_NOFS	(__GFP_IO)
+#define GFP_KERNEL	(__GFP_IO | __GFP_FS)
+#define GFP_USER	(__GFP_IO | __GFP_FS | __GFP_HARDWALL)
+#define GFP_HIGHUSER	(__GFP_IO | __GFP_FS | __GFP_HARDWALL | \
 			 __GFP_HIGHMEM)
-#define GFP_HIGH_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
+#define GFP_HIGH_MOVABLE	(__GFP_IO | __GFP_FS | \
 				 __GFP_HARDWALL | __GFP_HIGHMEM | \
 				 __GFP_MOVABLE)
 

Then a line like

  if ((flags & (GFP_ATOMIC | GFP_KERNEL)) == (GFP_ATOMIC | GFP_KERNEL))
	BUG();

could work.

Might have more implications. (And definitely, some more kernel code
would need to be fixed up.)


Jan
-- 
