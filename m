Return-Path: <linux-kernel-owner+w=401wt.eu-S934946AbZJNQr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934946AbZJNQr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934918AbZJNQr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:47:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932324AbZJNQr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:47:56 -0400
Date: Wed, 14 Oct 2009 09:38:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Oleg Nesterov <oleg@redhat.com>
cc: Paul Fulghum <paulkf@microgate.com>, Boyan <btanastasov@yahoo.co.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       "OGAWA Hirofumi \"" <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <alpine.LFD.2.01.0910140804180.6146@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0910140925440.6146@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
 <4AD3F769.5080405@gmail.com> <alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net> <4AD437F9.9020708@yahoo.co.uk> <alpine.LFD.2.01.0910130745550.3438@localhost.localdomain> <4AD4DE4C.4010402@yahoo.co.uk> <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
 <4AD4F548.2030506@microgate.com> <alpine.LFD.2.01.0910131514100.3404@localhost.localdomain> <1255478932.19056.24.camel@localhost.localdomain> <4AD51D6B.7010509@microgate.com> <alpine.LFD.2.01.0910131744590.3404@localhost.localdomain>
 <20091014125846.1a3c8d40@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0910140804180.6146@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Oct 2009, Linus Torvalds wrote:
> 
> But it's certainly true that it just never happened before. At least for 
> the !low_latency case, I'm not so sure about the low_latency=1 case, but I 
> haven't checked either - it would depend on any higher-level 
> serialization.

Btw, we _could_ try to solve this by adding some workqueue function to 
"run delayed work now", and then always doing the 'flush_to_ldisc()' 
through the workqueue logic.

So this is an "alternate patch": instead of making flush_to_ldisc() be 
safe to re-enter, we try to make sure it's always called through the whole 
workqueue logic and thus serialized by that.

Of course, keventd itself is multi-threaded, so I'm not entirely sure even 
-that- guarantees that one 'flush_to_ldisc()' couldn't be pending on one 
CPU while it is then scheduled and then run on another CPU concurrently 
too. The WORK_STRUCT_PENDING bit guarantees exclusion from the lists and 
from being pending, but the work might be both pending and _running_ at 
the same time, afaik.

I'm adding Oleg to the Cc, because he's the workqueue-master. Oleg?

The patch below is - surprise, surprise - entirely untested. I'm not sure 
my 'flush_delayed_work()' implementation is entirely kosher. But it looks 
like it might work, and it did compile for me (technically this is on top 
of my flush_to_ldisc() patch, but they should be independent of each 
other).

			Linus

---
 drivers/char/tty_buffer.c |    2 +-
 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |   18 ++++++++++++++++++
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index 0296612..66fa4e1 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -468,7 +468,7 @@ static void flush_to_ldisc(struct work_struct *work)
  */
 void tty_flush_to_ldisc(struct tty_struct *tty)
 {
-	flush_to_ldisc(&tty->buf.work.work);
+	flush_delayed_work(&tty->buf.work);
 }
 
 /**
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 7ef0c7b..cf24c20 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -207,6 +207,7 @@ extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 
 extern void flush_workqueue(struct workqueue_struct *wq);
 extern void flush_scheduled_work(void);
+extern void flush_delayed_work(struct delayed_work *work);
 
 extern int schedule_work(struct work_struct *work);
 extern int schedule_work_on(int cpu, struct work_struct *work);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index addfe2d..ccefe57 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -640,6 +640,24 @@ int schedule_delayed_work(struct delayed_work *dwork,
 EXPORT_SYMBOL(schedule_delayed_work);
 
 /**
+ * flush_delayed_work - block until a dwork_struct's callback has terminated
+ * @dwork: the delayed work which is to be flushed
+ *
+ * Any timeout is cancelled, and any pending work is run immediately.
+ */
+void flush_delayed_work(struct delayed_work *dwork)
+{
+	if (del_timer(&dwork->timer)) {
+		struct cpu_workqueue_struct *cwq;
+		cwq = wq_per_cpu(keventd_wq, get_cpu());
+		__queue_work(cwq, &dwork->work);
+		put_cpu();
+	}
+	flush_work(&dwork->work);
+}
+EXPORT_SYMBOL(flush_delayed_work);
+
+/**
  * schedule_delayed_work_on - queue work in global workqueue on CPU after delay
  * @cpu: cpu to use
  * @dwork: job to be done
