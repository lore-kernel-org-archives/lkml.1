Return-Path: <linux-kernel-owner+w=401wt.eu-S1031157AbXDZKl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031157AbXDZKl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031160AbXDZKl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:41:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54730 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031157AbXDZKlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:41:25 -0400
Date: Thu, 26 Apr 2007 12:40:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070426104052.GA19072@elf.ucw.cz>
References: <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <1177582633.6814.29.camel@johannes.berg> <20070426103051.GP17387@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426103051.GP17387@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The interface isn't even 64/32-bit compatible...
> 
> Which parts?
> 
> ioctl(AVAIL_SWAP,
> 	...hmm, is this the one you are complaining about? It returns
> 	loff_t through a pointer.  Maybe there's another interface
> 	that can return available swap, and we should use that,
>	 instead?

loff_t is 64bit on i386, so I do not see immediate problem here, but
maybe we should just explicitely pass u64?

> ioctl(GET_SWAP_PAGE,
> 	returns sector_t through a pointer. NOt sure if that's good
> 	idea, either.

Ok, that's very bad idea, because sector_t can be 32-bit or 64-bit,
depending on CONFIG_LBD. We need to use u64 here.

> ioctl(SET_SWAP_FILE,
> 	does old_decode_dev(arg). Is that ok?
> 
> ioctl(SET_SWAP_AREA,
> 	shares struct resume_swap_area between user and kernel. I
> 	guess that's bad..?

struct resume_swap_area {
        loff_t offset;
        u_int32_t dev;
} __attribute__((packed));

...I guess we should change loff_t -> u64 and problem is solved?

Old_decode_dev takes u16. That sucks for majors/minors > 256, but
fortunately those are not common.

Does this seem to help?
									Pavel

diff --git a/kernel/power/power.h b/kernel/power/power.h
index eb461b8..dc13af5 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -114,7 +114,7 @@ extern int snapshot_image_loaded(struct 
  * SNAPSHOT_SET_SWAP_AREA ioctl
  */
 struct resume_swap_area {
-	loff_t offset;
+	u_int64_t offset;
 	u_int32_t dev;
 } __attribute__((packed));
 
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 558e18e..d0730c1 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -215,8 +215,7 @@ static int snapshot_ioctl(struct inode *
 {
 	int error = 0;
 	struct snapshot_data *data;
-	loff_t avail;
-	sector_t offset;
+	u64 avail, offset;
 
 	if (_IOC_TYPE(cmd) != SNAPSHOT_IOC_MAGIC)
 		return -ENOTTY;
@@ -286,7 +285,7 @@ static int snapshot_ioctl(struct inode *
 	case SNAPSHOT_AVAIL_SWAP:
 		avail = count_swap_pages(data->swap, 1);
 		avail <<= PAGE_SHIFT;
-		error = put_user(avail, (loff_t __user *)arg);
+		error = put_user(avail, (u64 __user *)arg);
 		break;
 
 	case SNAPSHOT_GET_SWAP_PAGE:
@@ -304,7 +303,7 @@ static int snapshot_ioctl(struct inode *
 		offset = alloc_swapdev_block(data->swap, data->bitmap);
 		if (offset) {
 			offset <<= PAGE_SHIFT;
-			error = put_user(offset, (sector_t __user *)arg);
+			error = put_user(offset, (u64 __user *)arg);
 		} else {
 			error = -ENOSPC;
 		}

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
