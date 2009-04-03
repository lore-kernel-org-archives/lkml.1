Return-Path: <linux-kernel-owner+w=401wt.eu-S1760733AbZDCM10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733AbZDCM10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 08:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbZDCM1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 08:27:18 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33664 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394AbZDCM1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 08:27:17 -0400
Date: Fri, 3 Apr 2009 14:27:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Alan D. Brunelle" <alan.brunelle@hp.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] blktrace: fix a bug in blk_msg_write()
Message-ID: <20090403122714.GT5178@kernel.dk>
References: <49D5BB56.7000807@cn.fujitsu.com> <20090403111741.GB31399@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403111741.GB31399@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03 2009, Ingo Molnar wrote:
> 
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > This is another long-standing bug.
> >
> > ================
> >
> >
> >  (console 1)
> >  # echo -n 'a' > /sys/kernel/debug/block/sda/msg
> >  (console 2)
> >  # blktrace -d /dev/sda -a pc -o - | blkparse -i -
> >   8,0    0        0     0.000000000     0  m   N a??????????????????@??????
> >
> > We should terminate the msg buffer with '\0'.
> >
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> >  kernel/trace/blktrace.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> > index c0ef70d..2bf341f 100644
> > --- a/kernel/trace/blktrace.c
> > +++ b/kernel/trace/blktrace.c
> > @@ -327,10 +327,10 @@ static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
> >  	char *msg;
> >  	struct blk_trace *bt;
> >
> > -	if (count > BLK_TN_MAX_MSG)
> > +	if (count >= BLK_TN_MAX_MSG)
> >  		return -EINVAL;
> >
> > -	msg = kmalloc(count, GFP_KERNEL);
> > +	msg = kmalloc(count + 1, GFP_KERNEL);
> >  	if (msg == NULL)
> >  		return -ENOMEM;
> >
> > @@ -338,6 +338,7 @@ static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
> >  		kfree(msg);
> >  		return -EFAULT;
> >  	}
> > +	msg[count] = '\0';
> >
> >  	bt = filp->private_data;
> >  	__trace_note_message(bt, "%s", msg);
> 
> Nice fix!
> 
> Jens, do you ack this and should i add a Cc: <stable@kernel.org>
> backporting tag?
> 
> This fix applies fine to v2.6.29 after:
> 
>    sed 's/kernel\/trace\/blktrace.c/block\/blktrace.c'

This is identical to the following patch from Carl Henrik Lunde, which
he just ported to -tip. It has existed before, as a patch to 2.6.29-git,
but was unfortunately dropped.

So is this a coincidence? If not, Carl Henrik Lunde should be credited.

>From f116bce73e04d01614fd28ea678e0953cc321155 Mon Sep 17 00:00:00 2001
From: Carl Henrik Lunde <chlunde@ping.uio.no>
Date: Wed, 25 Mar 2009 14:23:16 +0100
Subject: [PATCH] blktrace: NUL-terminate user space messages

Make sure messages from user space are NUL-terminated strings,
otherwise we could dump random memory to the block trace file.
Additionally, I've limited the message to BLK_TN_MAX_MSG-1 characters,
because the last character would be stripped by vscnprintf anyway.

Signed-off-by: Carl Henrik Lunde <chlunde@ping.uio.no>
---
 kernel/trace/blktrace.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index d43cdac..75eb345 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -311,10 +311,10 @@ static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
 	char *msg;
 	struct blk_trace *bt;
 
-	if (count > BLK_TN_MAX_MSG)
+	if (count > BLK_TN_MAX_MSG - 1)
 		return -EINVAL;
 
-	msg = kmalloc(count, GFP_KERNEL);
+	msg = kmalloc(count + 1, GFP_KERNEL);
 	if (msg == NULL)
 		return -ENOMEM;
 
@@ -323,6 +323,7 @@ static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
 		return -EFAULT;
 	}
 
+	msg[count] = '\0';
 	bt = filp->private_data;
 	__trace_note_message(bt, "%s", msg);
 	kfree(msg);
-- 
1.6.2.rc0.90.g0753

> 
> 	Ingo

-- 
Jens Axboe

