Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0BVP2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 10:28:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42498 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab0BVP2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 10:28:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=njJbY1V95ThV/eKX9cz1lQE8yuLzG9craGFUkCIMShGuz1jz02XOGbITc/x7myitKp
         MBAo/Ggw3vtYT6qIs6Ao4xvv4EV4LUezGWXMIAale+Mi0Al84PVSSVenerwI6IGK8aFD
         ULCSNZtlYTBP5ZgTotDhNroxDtujVsi0MspzM=
MIME-Version: 1.0
Date: Mon, 22 Feb 2010 20:49:59 +0530
Message-ID: <f5a7b3811002220719i52750eddm16508f3d2f9b56f9@mail.gmail.com>
Subject: Warning fix: __raw_spin_lock incompatible pointer type
From: naresh kamboju <naresh.kernel@gmail.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have noticed below warning after enabling CONFIG_LTT_RELAY_LOCKED=y

And after the changes w.r.t http://lkml.org/lkml/2010/2/22/100


 CC      ltt/ltt-relay-locked.o
In file included from ltt/ltt-relay-locked.c:56:
ltt/ltt-relay-locked.h: In function 'ltt_reserve_slot':
ltt/ltt-relay-locked.h:249: warning: passing argument 1 of
'__raw_spin_lock' from incompatible pointer type
ltt/ltt-relay-locked.h:257: warning: passing argument 1 of
'__raw_spin_unlock' from incompatible pointer type
ltt/ltt-relay-locked.h: In function 'ltt_commit_slot':
ltt/ltt-relay-locked.h:364: warning: passing argument 1 of
'__raw_spin_unlock' from incompatible pointer type
ltt/ltt-relay-locked.c: In function 'get_subbuf':
ltt/ltt-relay-locked.c:238: warning: passing argument 1 of
'__raw_spin_lock' from incompatible pointer type
ltt/ltt-relay-locked.c:252: warning: passing argument 1 of
'__raw_spin_unlock' from incompatible pointer type
ltt/ltt-relay-locked.c:263: warning: passing argument 1 of
'__raw_spin_unlock' from incompatible pointer type
ltt/ltt-relay-locked.c:272: warning: passing argument 1 of
'__raw_spin_unlock' from incompatible pointer type
:
:
ltt/ltt-relay-locked.c: In function 'ltt_relay_create_buffer':
ltt/ltt-relay-locked.c:846: warning: missing braces around initializer
ltt/ltt-relay-locked.c:846: warning: (near initialization for
'(anonymous).raw_lock')
:
:


After my work around I have found warning cause and fixed.

---
 ltt/ltt-relay-locked.c |    2  1 +     1 -     0 !
 ltt/ltt-relay-locked.h |    2  1 +     1 -     0 !
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: b/ltt/ltt-relay-locked.h
===================================================================
--- a/ltt/ltt-relay-locked.h
+++ b/ltt/ltt-relay-locked.h
@@ -69,7 +69,7 @@ struct ltt_channel_buf_struct {
        long offset;                    /* Current offset in the buffer */
        long *commit_count;             /* Commit count per sub-buffer */
        unsigned long irqflags;         /* IRQ flags saved by reserve */
-       raw_spinlock_t lock;            /* Spinlock protecting buffer */
+       __raw_spinlock_t lock;          /* Spinlock protecting buffer */
        /* End of first 32 bytes cacheline */
 #ifdef CONFIG_LTT_VMCORE
        long *commit_seq;               /* Consecutive commits */
Index: b/ltt/ltt-relay-locked.c
===================================================================
--- a/ltt/ltt-relay-locked.c
+++ b/ltt/ltt-relay-locked.c
@@ -843,7 +843,7 @@ static int ltt_relay_create_buffer(struc
        RCHAN_SB_CLEAR_NOREF(buf->rchan_wsb[0].pages);
        ltt_buffer_begin(buf, trace->start_tsc, 0);
        ltt_buf->commit_count[0] += ltt_subbuffer_header_size();
-       ltt_buf->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+       ltt_buf->lock = (__raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
        ltt_buf->rbuf = buf;

        return 0;


Kernel: 2.6.29-RT
LTTng: 0.158
ARCH: ARM (SMP)

Please review the patch and provide your comments.

Best regards
Naresh Kamboju
