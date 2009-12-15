Return-Path: <linux-kernel-owner+w=401wt.eu-S934078AbZLOWfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078AbZLOWfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934059AbZLOWfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:35:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933763AbZLOWfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:35:31 -0500
Date: Tue, 15 Dec 2009 14:34:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-kernel@vger.kernel.org, rubini@gnudd.com, gregkh@suse.de
Subject: Re: [PATCH 3/3] misc: use a proper range for minor number dynamic
 allocation
Message-Id: <20091215143446.8b6a7e57.akpm@linux-foundation.org>
In-Reply-To: <20091111153632.944a255c.akpm@linux-foundation.org>
References: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com>
	<1257813017-28598-2-git-send-email-cascardo@holoscopio.com>
	<1257813017-28598-3-git-send-email-cascardo@holoscopio.com>
	<4AF8B4FF.9050405@zytor.com>
	<20091111153632.944a255c.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 15:36:32 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 09 Nov 2009 16:34:07 -0800
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > On 11/09/2009 04:30 PM, Thadeu Lima de Souza Cascardo wrote:
> > > The current dynamic allocation of minor number for misc devices has some
> > > drawbacks.
> > > 
> > > First of all, the range for dynamic numbers include some statically
> > > allocated numbers. It goes from 63 to 0, and we have numbers in the
> > > range from 1 to 15 already allocated. Although, it gives priority to the
> > > higher and not allocated numbers, we may end up in a situation where we
> > > must reject registering a driver which got a static number because a
> > > driver got its number with dynamic allocation. Considering fs/dlm/user.c
> > > allocates as many misc devices as lockspaces are created, and that we
> > > have more than 50 users around, it's not unreasonable to reach that
> > > situation.
> > > 
> > > The proposed solution uses the not yet reserved range from 64 to 127. If
> > > more devices are needed, we may push 64 to 16.
> > > 
> > 
> > Again, why not push these up above 256?
> > 
> 
> I merged this patch, but made a note-to-self that there are remaining
> open issues..

And nothing else happened.  Can we revisit this please?




From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

The current dynamic allocation of minor number for misc devices has some
drawbacks.

First of all, the range for dynamic numbers include some statically
allocated numbers.  It goes from 63 to 0, and we have numbers in the range
from 1 to 15 already allocated.  Although, it gives priority to the higher
and not allocated numbers, we may end up in a situation where we must
reject registering a driver which got a static number because a driver got
its number with dynamic allocation.  Considering fs/dlm/user.c allocates
as many misc devices as lockspaces are created, and that we have more than
50 users around, it's not unreasonable to reach that situation.

The proposed solution uses the not yet reserved range from 64 to 127.  If
more devices are needed, we may push 64 to 16.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/misc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/char/misc.c~drivers-char-miscc-use-a-proper-range-for-minor-number-dynamic-allocation drivers/char/misc.c
--- a/drivers/char/misc.c~drivers-char-miscc-use-a-proper-range-for-minor-number-dynamic-allocation
+++ a/drivers/char/misc.c
@@ -59,6 +59,7 @@ static DEFINE_MUTEX(misc_mtx);
 /*
  * Assigned numbers, used for dynamic minors
  */
+#define DYNAMIC_MINOR_BASE 64
 #define DYNAMIC_MINORS 64 /* like dynamic majors */
 static DECLARE_BITMAP(misc_minors, DYNAMIC_MINORS);
 
@@ -201,7 +202,7 @@ int misc_register(struct miscdevice * mi
 			mutex_unlock(&misc_mtx);
 			return -EBUSY;
 		}
-		misc->minor = DYNAMIC_MINORS - i - 1;
+		misc->minor = DYNAMIC_MINOR_BASE + i;
 		set_bit(i, misc_minors);
 	}
 
@@ -210,7 +211,7 @@ int misc_register(struct miscdevice * mi
 	misc->this_device = device_create(misc_class, misc->parent, dev,
 					  misc, "%s", misc->name);
 	if (IS_ERR(misc->this_device)) {
-		int i = DYNAMIC_MINORS - misc->minor - 1;
+		int i = misc->minor - DYNAMIC_MINOR_BASE;
 		if (i < DYNAMIC_MINORS && i >= 0)
 			clear_bit(i, misc_minors);
 		err = PTR_ERR(misc->this_device);
@@ -239,7 +240,7 @@ int misc_register(struct miscdevice * mi
 
 int misc_deregister(struct miscdevice *misc)
 {
-	int i = DYNAMIC_MINORS - misc->minor - 1;
+	int i = misc->minor - DYNAMIC_MINOR_BASE;
 
 	if (list_empty(&misc->list))
 		return -EINVAL;
_

