Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbZHNMVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbZHNMVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbZHNMVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:21:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50877 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbZHNMVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:21:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH 1/6] new kfifo API v0.3 - Code reorganization and move out spinlock
Date: Fri, 14 Aug 2009 14:21:09 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
References: <1250250189.19690.92.camel@wall-e>
In-Reply-To: <1250250189.19690.92.camel@wall-e>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908141421.09157.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/CplAFbBZn6uvKYOIRJei11V3DW2sf/9msqpH
 amQ34hvQl3mgFtNXANyPc4kH5S0c9iF8eAZAKFuPh+g+Ny1rdi
 P+/qzhGStGNdZdaP490hg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch contents look good, but you still need to work on the
changelog, see Documentation/SubmittingPatches. Sorry for the
nitpicking, but I think it's important that you understand the
rules.

On Friday 14 August 2009, Stefani Seibold wrote:
> This is patch 1/6 of the new kfifo API:

This line is useless as a changeset comment, it should be implied
by the one-line summary. Regarding your summary, it reads

[PATCH 1/6] new kfifo API v0.3 - Code reorganization and move out spinlock

where it should be

[PATCH 1/6] kfifo: move struct kfifo in place, move out spinlock

It does raise the question why the two things are in one patch,
and I admit that I misread your patch the last time, or I would
have recommended splitting it in two. I guess it won't hurt too
much to have them together. At least it saves you from patches
all those files an extra time.

Regarding the submission, Amerigo correctly pointed out that
the mails should be in a single email thread, normally by
making all the patches a reply to the [PATCH 0/X] mail.
git-format-patch, git-send-email and quilt mail have options
to do that automatically.

>  Remove spinlock
>  Change kfifo_put() into kfifo_put_locked() which requires an additional spinlock argument 
>  Change kfifo_get() into kfifo_get_locked() which requires an additional spinlock argument
>  Make kfifo itself a member of the using data structure
>  kfifo_init() and kfifo_alloc() requieres now a kfifo-pointer argument and does not 
>  longer allocated a kfifo structure

The changelog describes *what* you do, which can be seen from the
patch. Instead, it should say *why* you do it, as I mentioned before.

E.g. the first line 'Remove spinlock' will make every reader wonder
if that's really safe, and why it was there in the first place.

How about this changelog:

[PATCH] kfifo: move struct kfifo in place, move out spinlock

This patch improves three areas of the simple kernel FIFO
implementation:

1. Since most users want to have the kfifo as part of another
object, reorganize the code to allow including struct kfifo
in another data structure. This requires changing the kfifo_alloc
and kfifo_init prototypes so that we pass an existing kfifo
pointer into them. This patch changes the implemenation and
all existing users.

2. Move the pointer to the spinlock out of struct kfifo. Most
users in tree do not actually use a spinlock, so the few
exceptions now have to call kfifo_{get,put}_locked, which takes
an extra argument to a spinlock.

3. Improve the prototypes of kfifo_get and kfifo_put to make
the kerneldoc annotations more readable.

>  Lockless kfifo_len()
>  Fix "char *buffer" in prototypes into "from" respectively "to" to express the direction  
>  Fix current user of the old kfifo API
>
>  drivers/char/nozomi.c                       |   21 +++---
>  drivers/char/sonypi.c                       |   49 +++++++--------
>  drivers/infiniband/hw/cxgb3/cxio_hal.h      |    9 +-

There is a line with '---' missing between the changelog and the
diffstat. It's required for git-am and other tools so that the
diffstat does not get into the history.

>+/**
>+ * __kfifo_len - returns the number of bytes available in the FIFO
>+ * @fifo: the fifo to be used.
>+ */
>+static inline unsigned int __kfifo_len(struct kfifo *fifo)
>+{
>+       register unsigned int   out;
>+
>+       out = fifo->out;
>+       barrier();
>+       return fifo->in - out;
>+}

This use of 'barrier()' is bogus. The plain barrier() only
prevents gcc from reordering the object code, but in order to
protect you from concurrent accesses on SMP systems, you really
need 'smp_rmb()'. OTOH, I don't think that any barrier actually
helps here, and that the old code was fine as well. Your change
doesn't hurt, but it looks confusing.

	Arnd <><
