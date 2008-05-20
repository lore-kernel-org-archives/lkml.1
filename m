Return-Path: <linux-kernel-owner+w=401wt.eu-S1763204AbYETXZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763204AbYETXZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 19:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYETXZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 19:25:39 -0400
Received: from vena.lwn.net ([206.168.112.25]:34348 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbYETXZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 19:25:39 -0400
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Wu, Bryan" <Bryan.Wu@analog.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Alexander Viro" <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3, RFC] misc char dev BKL pushdown 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Tue, 20 May 2008 19:01:24 EDT."
             <8bd0f97a0805201601h1b08df6fw3fbf6c58759b07b4@mail.gmail.com> 
Date: Tue, 20 May 2008 17:25:38 -0600
Message-ID: <9968.1211325938@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier.adi@gmail.com> wrote:

> please drop the coreb.c changes from your patch

At a minimum, I would hope such a request would say something like "I've
looked at the driver's locking and am convinced that the BKL is not
needed."  Have you done that?  There is a certain leap of faith involved
in removing that protection from a driver.

I decided to take a quick look...

- You use spin_lock_irq(&coreb_lock) in a number of places, but you do
  not take the lock in the interrupt handler.  You also do not take the
  lock in coreb_write() or coreb_read(), so those can race with the
  interrupt handler, with ioctl(), and with each other.

- coreb_write() and coreb_read() do interruptible waits, but do not
  check to see whether they were interrupted.  They will, in fact,
  continue in their I/O loops after a signal.

- In both functions you have:

	unsigned long p = *ppos;

	if (p + count > coreb_size)
		return -EFAULT;

  that calculation can overflow.

- You also do this:

  static ssize_t coreb_write(struct file *file, const char *buf, size_t count,
	 		     loff_t * ppos)
  /* ... */
  		set_dma_start_addr(CH_MEM_STREAM2_SRC, (unsigned long)buf);

  In other words, the DMA is done directly to/from a user-space
  address.  Maybe that's safe on Blackfin, I don't know...

- I have no idea why some of your functions are using d_inode->i_mutex.

- In coreb_ioctl():

		spin_lock_irq(&coreb_lock);
		if (coreb_status & COREB_IS_RUNNING) {
			retval = -EBUSY;
			break;
		}

  this will exit the function with the spinlock still held and
  interrupts disabled.

	case CMD_COREB_RESET:
		printk(KERN_INFO "Resetting Core B\n");
		bfin_write_SICB_SYSCR(bfin_read_SICB_SYSCR() | 0x0080);
		break;

  You do not acquire the lock here, so this can race against other
  ioctl() calls.  And ioctl() can race against read() and write().

Registration and such seem reasonable, so I can't come up with a
scenario where loss of BKL protection will create trouble.  Given the
other problems there, though, I'll confess to being a bit nervous about
it.

jon
