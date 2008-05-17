Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbYEQT1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbYEQT1B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 15:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbYEQT0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 15:26:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49431 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbYEQT0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 15:26:53 -0400
Date: Sat, 17 May 2008 12:26:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "koos vriezen" <koos.vriezen@gmail.com>
Cc: linux-kernel@vger.kernel.org, mchehab@infradead.org
Subject: Re: mplayer v4l hangs in 2.6.25.2/4    (likely regression)
Message-ID: <20080517122640.2d15aeed@infradead.org>
In-Reply-To: <d4e708d60805171211q1a1966a3i78dc3dc98d275dd1@mail.gmail.com>
References: <d4e708d60805170954n6b2044c7h306bc6cb76bf798d@mail.gmail.com>
	<20080517111639.21a3e177@infradead.org>
	<d4e708d60805171211q1a1966a3i78dc3dc98d275dd1@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008 21:11:35 +0200
"koos vriezen" <koos.vriezen@gmail.com> wrote:

> 2008/5/17 Arjan van de Ven <arjan@infradead.org>:
> 
> > Is it possible for you to enable lockdep (CONFIG_PROVE_LOCKING)?
> > With that on, the kernel will print nicely which locks are being
> > waited on, and if there's a deadlock, it'll print that too.
> > Speaking of that, since this looks like a mutex related issue, it's
> > worth enabling CONFIG_DEBUG_MUTEXES as well.... more debug checks
> > in this area. If you also enable CONFIG_FRAME_POINTER then the
> > backtrace will get better too (but it's not totally required, just
> > easier for diagnostics)
> 
> See attachments.
> FWIW, while mplayer is hanging, I can use another Xvideo based tv
> player.

excellent, you caught a real deadlock.

in drivers/media/bt8xx/bttv-driver.c the code looks like this:

static int vidiocgmbuf(struct file *file, void *priv, struct video_mbuf *mbuf)
{
        int retval;
        unsigned int i;
        struct bttv_fh *fh = priv;

        mutex_lock(&fh->cap.vb_lock);
        retval = videobuf_mmap_setup(&fh->cap, gbuffers, gbufsize,
                                     V4L2_MEMORY_MMAP);



and videobuf_mmap_setup is in drivers/media/videobuf-core.c:


int videobuf_mmap_setup(struct videobuf_queue *q,
                        unsigned int bcount, unsigned int bsize,
                        enum v4l2_memory memory)
{
        int ret;
        mutex_lock(&q->vb_lock);

so.. bttv first takes "fh->cap.vb_lock" in vidiocgmbuf, then calls videobuf_mmap_setup(), and the first thing that does
is to also take fh->cap.vb_lock!  This isn't even an ABBA deadlock, but a straight AA deadlock :)

According to git-blame, this code last got changed by Mauro (added to CC) with this commit:

commit 64f9477f95bf5d4ba49dc3988d47a15bc06bb5da
Author: Mauro Carvalho Chehab <mchehab@infradead.org>
Date:   Thu Jan 31 13:57:53 2008 -0300

    V4L/DVB (7121): Renames videobuf lock to vb_lock
    
    This helps to identify where vb_lock is being used, and find missusages of the
    locks.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>




Just for history purposes, below is the full lockdep message:



[ INFO: possible recursive locking detected ]
2.6.25.4 #6
---------------------------------------------
mplayer/3454 is trying to acquire lock:
 (&q->vb_lock){--..}, at: [<ffffffff880d52f0>] videobuf_mmap_setup+0x1d/0x42 [videobuf_core]

but task is already holding lock:
 (&q->vb_lock){--..}, at: [<ffffffff88139dbc>] vidiocgmbuf+0x1e/0xac [bttv]

other info that might help us debug this:
1 lock held by mplayer/3454:
 #0:  (&q->vb_lock){--..}, at: [<ffffffff88139dbc>] vidiocgmbuf+0x1e/0xac [bttv]

stack backtrace:
Pid: 3454, comm: mplayer Not tainted 2.6.25.4 #6

Call Trace:
 [<ffffffff8024df94>] __lock_acquire+0x8b7/0xc60
 [<ffffffff880d52f0>] ? :videobuf_core:videobuf_mmap_setup+0x1d/0x42
 [<ffffffff8024e72d>] lock_acquire+0x55/0x6e
 [<ffffffff880d52f0>] ? :videobuf_core:videobuf_mmap_setup+0x1d/0x42
 [<ffffffff804c5790>] mutex_lock_nested+0xd9/0x255
 [<ffffffff880d52f0>] :videobuf_core:videobuf_mmap_setup+0x1d/0x42
 [<ffffffff88139dd5>] :bttv:vidiocgmbuf+0x37/0xac
 [<ffffffff88106997>] :videodev:__video_do_ioctl+0xb2/0x2e16
 [<ffffffff804c7048>] ? _spin_unlock_irq+0x2b/0x31
 [<ffffffff80286355>] ? __kmalloc+0xbd/0xe7
 [<ffffffff8024d25d>] ? trace_hardirqs_on+0xf1/0x115
 [<ffffffff88109934>] ? :videodev:video_ioctl2+0xe0/0x259
 [<ffffffff88109a0c>] :videodev:video_ioctl2+0x1b8/0x259
 [<ffffffff804c7048>] ? _spin_unlock_irq+0x2b/0x31
 [<ffffffff8024d25d>] ? trace_hardirqs_on+0xf1/0x115
 [<ffffffff804c7048>] ? _spin_unlock_irq+0x2b/0x31
 [<ffffffff80295b1a>] vfs_ioctl+0x5e/0x77
