Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab0CBVQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 16:16:22 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35472 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab0CBVQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 16:16:21 -0500
Date: Tue, 2 Mar 2010 21:16:04 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: Memory management woes - order 1 allocation failures
Message-ID: <20100302211603.GD11355@csn.ul.ie>
References: <alpine.DEB.2.00.1002261042020.7719@router.home> <84144f021002260917q61f7c255rf994425f3a613819@mail.gmail.com> <20100301103546.DD86.A69D9226@jp.fujitsu.com> <20100302172606.GA11355@csn.ul.ie> <20100302183451.75d44f03@lxorguk.ukuu.org.uk> <20100302191110.GB11355@csn.ul.ie> <20100302192942.GA2953@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <20100302192942.GA2953@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline

On Tue, Mar 02, 2010 at 11:29:42AM -0800, Greg KH wrote:
> On Tue, Mar 02, 2010 at 07:11:10PM +0000, Mel Gorman wrote:
> > On Tue, Mar 02, 2010 at 06:34:51PM +0000, Alan Cox wrote:
> > > > For reasons that are not particularly clear to me, tty_buffer_alloc() is
> > > > called far more frequently in 2.6.33 than in 2.6.24. I instrumented the
> > > > function to print out the size of the buffers allocated, booted under
> > > > qemu and would just "cat /bin/ls" to see what buffers were allocated.
> > > > 2.6.33 allocates loads, including high-order allocations. 2.6.24
> > > > appeared to allocate once and keep silent.
> > > 
> > > The pty layer is using them now and didn't before. That will massively
> > > distort your numhers.
> > > 
> > 
> > That makes perfect sense. It explains why only one allocation showed up
> > because it must belong to the tty attached to the serial console.
> > 
> > Thanks Alan.
> > 
> > > > While there have been snags recently with respect to high-order
> > > > allocation failures in recent kernels, this might be one of the cases
> > > > where it's due to subsystems requesting high-order allocations more.
> > > 
> > > The pty code certainly triggered more such allocations. I've sent Greg
> > > patches to make the tty buffering layer allocate sensible sizes as it
> > > doesn't need multiple page allocations in the first place.
> > > 
> > 
> > Greg, what's the story with these patches?
> 
> They are in -next and will go to Linus later on today for .34.
> 

So, Greg pointed me at the patch in question in linux-next
[c9cf55b: tty: Keep the default buffering to sub-page units]
It's attached for convenience.

However, this patch on its own does not appear to be enough. When rebased to
.33, it's still possible for the TTY layer to require order-1 allocations so
I doubt it would fix Frans's on its own. The problem is that TTY_BUFFER_PAGE
is taking struct tty_buffer into account but not the additional padding
added by tty_buffer_find().

As it's not clear why "Round the buffer size out" is required, I took a
simple approach and adjusted TTY_BUFFER_PAGE rather than being clever in
tty_buffer.c. This keeps the allocation sizes below a page but could it be done
better or did I miss another patch in linux-next that makes this unnecessary?

==== CUT HERE ===
tty: Take a 256 byte padding into account when buffering below sub-page units

The TTY layer takes some care to ensure that only sub-page allocations
are made with interrupts disabled. It does this by setting a goal of
"TTY_BUFFER_PAGE" to allocate. Unfortunately, while TTY_BUFFER_PAGE takes the
size of tty_buffer into account, it fails to account that tty_buffer_find()
rounds the buffer size out to the next 256 byte boundary before adding on
the size of the tty_buffer.

This patch adjusts the TTY_BUFFER_PAGE calculation to take into account the
size of the tty_buffer and the padding. Once applied, tty_buffer_alloc()
should not require high-order allocations.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 include/linux/tty.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index d96e588..8fe018b 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -70,12 +70,13 @@ struct tty_buffer {
 
 /*
  * We default to dicing tty buffer allocations to this many characters
- * in order to avoid multiple page allocations. We assume tty_buffer itself
- * is under 256 bytes. See tty_buffer_find for the allocation logic this
- * must match
+ * in order to avoid multiple page allocations. We know the size of
+ * tty_buffer itself but it must also be taken into account that the
+ * the buffer is 256 byte aligned. See tty_buffer_find for the allocation
+ * logic this must match
  */
 
-#define TTY_BUFFER_PAGE		((PAGE_SIZE  - 256) / 2)
+#define TTY_BUFFER_PAGE	(((PAGE_SIZE - sizeof(struct tty_buffer)) / 2) & ~0xFF)
 
 
 struct tty_bufhead {

--AhhlLboLdkugWU4S
Content-Type: text/x-diff; charset=iso-8859-15
Content-Disposition: attachment; filename="tty-keep-the-default-buffering-to-sub-page-units.patch"

>From 96a421002f897237bcc44efd909dd58aa759319c Mon Sep 17 00:00:00 2001
From: Alan Cox <alan@linux.intel.com>
Date: Thu, 18 Feb 2010 16:43:47 +0000
Subject: [PATCH] tty: Keep the default buffering to sub-page units

We allocate during interrupts so while our buffering is normally diced up
small anyway on some hardware at speed we can pressure the VM excessively
for page pairs. We don't really need big buffers to be linear so don't try
so hard.

In order to make this work well we will tidy up excess callers to request_room,
which cannot itself enforce this break up.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index 66fa4e1..f27c4d6 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -247,7 +247,8 @@ int tty_insert_flip_string(struct tty_struct *tty, const unsigned char *chars,
 {
 	int copied = 0;
 	do {
-		int space = tty_buffer_request_room(tty, size - copied);
+		int goal = min(size - copied, TTY_BUFFER_PAGE);
+		int space = tty_buffer_request_room(tty, goal);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
 		if (unlikely(space == 0))
@@ -283,7 +284,8 @@ int tty_insert_flip_string_flags(struct tty_struct *tty,
 {
 	int copied = 0;
 	do {
-		int space = tty_buffer_request_room(tty, size - copied);
+		int goal = min(size - copied, TTY_BUFFER_PAGE);
+		int space = tty_buffer_request_room(tty, goal);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
 		if (unlikely(space == 0))
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 6abfcf5..d96e588 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -68,6 +68,16 @@ struct tty_buffer {
 	unsigned long data[0];
 };
 
+/*
+ * We default to dicing tty buffer allocations to this many characters
+ * in order to avoid multiple page allocations. We assume tty_buffer itself
+ * is under 256 bytes. See tty_buffer_find for the allocation logic this
+ * must match
+ */
+
+#define TTY_BUFFER_PAGE		((PAGE_SIZE  - 256) / 2)
+
+
 struct tty_bufhead {
 	struct delayed_work work;
 	spinlock_t lock;

--AhhlLboLdkugWU4S--
