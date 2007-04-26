Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbXDZLRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbXDZLRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 07:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbXDZLRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 07:17:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54901 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754555AbXDZLRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 07:17:11 -0400
Date: Thu, 26 Apr 2007 13:16:45 +0200
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
Message-ID: <20070426111645.GR17387@elf.ucw.cz>
References: <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <1177582633.6814.29.camel@johannes.berg> <20070426103051.GP17387@elf.ucw.cz> <20070426104052.GA19072@elf.ucw.cz> <1177585897.6814.49.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177585897.6814.49.camel@johannes.berg>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Does this seem to help?
> 
> No idea, I haven't actually tried it yet, last time I tried uswsusp on
> my 32/32 machine it didn't work due to endian problems that were
> supposed to be resolved but I haven't had a chance to pick all the bits
> together that you need.

This one should prevent ioctl numbers changing, too.

diff --git a/kernel/power/power.h b/kernel/power/power.h
index eb461b8..a18b85a 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -114,23 +114,23 @@ extern int snapshot_image_loaded(struct 
  * SNAPSHOT_SET_SWAP_AREA ioctl
  */
 struct resume_swap_area {
-	loff_t offset;
+	u_int64_t offset;
 	u_int32_t dev;
 } __attribute__((packed));
 
 #define SNAPSHOT_IOC_MAGIC	'3'
 #define SNAPSHOT_FREEZE			_IO(SNAPSHOT_IOC_MAGIC, 1)
 #define SNAPSHOT_UNFREEZE		_IO(SNAPSHOT_IOC_MAGIC, 2)
-#define SNAPSHOT_ATOMIC_SNAPSHOT	_IOW(SNAPSHOT_IOC_MAGIC, 3, void *)
+#define SNAPSHOT_ATOMIC_SNAPSHOT	_IOW(SNAPSHOT_IOC_MAGIC, 3, u32) /* void * */
 #define SNAPSHOT_ATOMIC_RESTORE		_IO(SNAPSHOT_IOC_MAGIC, 4)
 #define SNAPSHOT_FREE			_IO(SNAPSHOT_IOC_MAGIC, 5)
-#define SNAPSHOT_SET_IMAGE_SIZE		_IOW(SNAPSHOT_IOC_MAGIC, 6, unsigned long)
-#define SNAPSHOT_AVAIL_SWAP		_IOR(SNAPSHOT_IOC_MAGIC, 7, void *)
-#define SNAPSHOT_GET_SWAP_PAGE		_IOR(SNAPSHOT_IOC_MAGIC, 8, void *)
+#define SNAPSHOT_SET_IMAGE_SIZE		_IOW(SNAPSHOT_IOC_MAGIC, 6, u32) /* unsigned long */
+#define SNAPSHOT_AVAIL_SWAP		_IOR(SNAPSHOT_IOC_MAGIC, 7, u32) /* void * */
+#define SNAPSHOT_GET_SWAP_PAGE		_IOR(SNAPSHOT_IOC_MAGIC, 8, u32) /* void * */
 #define SNAPSHOT_FREE_SWAP_PAGES	_IO(SNAPSHOT_IOC_MAGIC, 9)
-#define SNAPSHOT_SET_SWAP_FILE		_IOW(SNAPSHOT_IOC_MAGIC, 10, unsigned int)
+#define SNAPSHOT_SET_SWAP_FILE		_IOW(SNAPSHOT_IOC_MAGIC, 10, u32) /* unsigned int */
 #define SNAPSHOT_S2RAM			_IO(SNAPSHOT_IOC_MAGIC, 11)
-#define SNAPSHOT_PMOPS			_IOW(SNAPSHOT_IOC_MAGIC, 12, unsigned int)
+#define SNAPSHOT_PMOPS			_IOW(SNAPSHOT_IOC_MAGIC, 12, u32) /* unsigned int */
 #define SNAPSHOT_SET_SWAP_AREA		_IOW(SNAPSHOT_IOC_MAGIC, 13, \
 							struct resume_swap_area)
 #define SNAPSHOT_IOC_MAXNR	13
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
