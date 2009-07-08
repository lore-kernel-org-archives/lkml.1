Return-Path: <linux-kernel-owner+w=401wt.eu-S1759010AbZGHWz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbZGHWz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757190AbZGHWzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:55:13 -0400
Received: from mail.easycrypt.de ([84.200.20.67]:35887 "EHLO mail.easycrypt.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbZGHWzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:55:13 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jul 2009 18:55:12 EDT
Message-ID: <4A55222E.5030405@easycrypt.de>
Date: Thu, 09 Jul 2009 00:48:14 +0200
From: Timm Korte <korte-kernel@easycrypt.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; de; rv:1.8.1.22) Gecko/20090605 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: "impossible" spinlock "wrong CPU" problem with custom device driver
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to understand a spinlog bug in a kernel module (device driver).
I have a spinlock that is uses in the actual hardware interrupt handler
as well as in a seperate kernel thread doing the real work via a work
queue. The first one uses the spinlock with spin_lock() and
spin_unlock(), while the thread uses spin_lock_irqsave() and
spin_unlock_irqrestore().
On rare occasions (can't reproduce on purpose), i get a spinlog debug
message about wrong cpu on _raw_spin_unlock when called from the kernel
thread.

This is the source (for the kernel_thread) that runs into the problem:

static int my_irqthread_function(void *ptr) {
  struct my_dev *mydev = ptr;

  daemonize(MY_NAME "%02x", mydev->mynum);
  allow_signal(SIGTERM);
  while (!wait_event_interruptible(mydev->irqthread_wait,
atomic_read(&mydev->irqthread_pending_count))) {
    do {
      uint8_t my_irq_pending = 0;
      unsigned long iflags;

      spin_lock_irqsave(&mydev->irq_pending_lock, iflags);
      my_irq_pending = mydev->irq_pending;
      mydev->irq_pending = 0;
      spin_unlock_irqrestore(&mydev->irq_pending_lock, iflags);

      // handle irqs
      if (my_irq_pending & INT_IPAC1) {
         my_handle_interrupt(&mydev->mydev[IPAC1]);
      }
...
      // continue if the pending count still is != 0 after decrementing
    } while (!atomic_dec_and_test(&mydev->irqthread_pending_count));
  }

  mydev->irqthread = 0;
  complete_and_exit(&mydev->irqthread_exit, 0);
}

The error (SPIN_BUG with kernel panic on my SMP box) happens on the
"spin_unlock_irqrestore(&mydev->irq_pending_lock, iflags);" - but i
really can't figure out, how the thread could be moved to another cpu,
while holding the lock and only doing two assignment operations.

The only thing i could think of, is that it might have something to do
with the enabled sigterm signal - even though the module wasn't being
unloaded at the time the bug occured.

System is FC4 based with a 2.6.17 kernel (can't change).

So I'm sort of out of ideas and hope someone here has an idea, what
might have gone wrong here.

Timm
