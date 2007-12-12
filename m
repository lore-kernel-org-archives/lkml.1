Return-Path: <linux-kernel-owner+w=401wt.eu-S1760886AbXLLTpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886AbXLLTpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760227AbXLLToy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:44:54 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35488 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760137AbXLLTox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:44:53 -0500
Date: Wed, 12 Dec 2007 20:44:54 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Shane <gnome42@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Adrian Bunk <bunk@kernel.org>, Brandon Philips <brandon@ifup.org>,
       linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>
Subject: [2.6 patch] videobuf-core.c locking fixes
Message-ID: <20071212194454.GF10069@stusta.de>
References: <fa4052ef0712112120l1165af5btc108ea2131760328@mail.gmail.com> <20071212090709.GF14204@stusta.de> <1197457394.4807.40.camel@gaivota> <20071212120308.GG14204@stusta.de> <1197469316.4744.22.camel@gaivota> <fa4052ef0712120837i36cee3elbe0a5170f5904d2f@mail.gmail.com> <fa4052ef0712121057o51230b22ycb79723091438779@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fa4052ef0712121057o51230b22ycb79723091438779@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 01:57:27PM -0500, Shane wrote:
> On Dec 12, 2007 11:37 AM, Shane <gnome42@gmail.com> wrote:
> > On Dec 12, 2007 9:21 AM, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > ...
> > > The proper solution is provided by this changeset:
> > > http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=19fb1457990b6b7e15586ec7331541a184233acc
> >
> > I applied this and it seems fine with a bttv card.
> 
> Ugh, after further testing with a bttv card it seems this is not fine.
> 
> vbi doesn't work anymore and my application gets stuck in a Zombie,
> unkillable, have to reboot state :(
> 
> mythtv    3683     1  -3  2.4  0.0      0     0 ?        Z<l  13:40:35
> 00:00:06 [mythbackend] <defunct>
> 
> Reverting Mauro's patch above does fix the problem.

Thanks for testing, does the patch below fix it?

> Shane

cu
Adrian


<--  snip  -->


After commit 19fb1457990b6b7e15586ec7331541a184233acc the callers in 
videobuf-core.c that already hold the lock must call 
__videobuf_read_start() instead of videobuf_read_start().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/videobuf-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

e1f8b4a49d86746f699919531c17fd154787e308 
diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index 81f77d2..c8a5cb5 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -909,7 +909,7 @@ ssize_t videobuf_read_stream(struct videobuf_queue *q,
 	if (q->streaming)
 		goto done;
 	if (!q->reading) {
-		retval = videobuf_read_start(q);
+		retval = __videobuf_read_start(q);
 		if (retval < 0)
 			goto done;
 	}
@@ -982,7 +982,7 @@ unsigned int videobuf_poll_stream(struct file *file,
 					 struct videobuf_buffer, stream);
 	} else {
 		if (!q->reading)
-			videobuf_read_start(q);
+			__videobuf_read_start(q);
 		if (!q->reading) {
 			rc = POLLERR;
 		} else if (NULL == q->read_buf) {

