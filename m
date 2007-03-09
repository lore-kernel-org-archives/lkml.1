Return-Path: <linux-kernel-owner+w=401wt.eu-S1750740AbXCIDpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750740AbXCIDpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 22:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbXCIDpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 22:45:46 -0500
Received: from mtwmail.mindtree.com.60.200.203.in-addr.arpa ([203.200.60.136]:20848
	"EHLO mailwo11.mindtree.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750740AbXCIDpo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 22:45:44 -0500
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.2826
Content-Class: urn:content-classes:message
Importance: normal
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Sleeping thread not receive signal until it wakes up
Date: Fri, 9 Mar 2007 09:15:33 +0530
Message-ID: <2C15D00D262B7245B1D8D1799F04D88F04A58C42@mtw01ex01.mindtree.com>
In-Reply-To: <1b2aacd80703081924w44652c71yb8a16e005247a55a@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Sleeping thread not receive signal until it wakes up
thread-index: Acdh+xjG84hwOP+XRQWP/ckwd5+OzQAAeGwQ
References: <fa.kb3wuhac4W+1DqK61+sKe9uZwto@ifi.uio.no> <fa.cyXmbtXvYymKHdI0rEXZCxyk+KE@ifi.uio.no> <fa.zPDT1vfJF5MjVXXQH/l+YSaLl84@ifi.uio.no> <fa.HmQN7RhZNBRsiJYADMOsY8DL67k@ifi.uio.no> <fa.PDmHwxZ3arhmED5SLuEONyxUlz4@ifi.uio.no> <fa.ygLhZcCLgDxnwAYYVse/Xshr9IE@ifi.uio.no> <45F0B40F.7070301@shaw.ca> <1b2aacd80703081924w44652c71yb8a16e005247a55a@mail.gmail.com>
From: "Parav K Pandit" <parav_pandit@mindtree.com>
To: "Luong Ngo" <luong.ngo@gmail.com>, "Robert Hancock" <hancockr@shaw.ca>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>
X-OriginalArrivalTime: 09 Mar 2007 03:45:46.0743 (UTC) FILETIME=[6BDA3070:01C761FD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Luong Ngo
Sent: Friday, March 09, 2007 8:54 AM
To: Robert Hancock
Cc: linux-kernel; tglx@linutronix.de
Subject: Re: Sleeping thread not receive signal until it wakes up

On 3/8/07, Robert Hancock <hancockr@shaw.ca> wrote:
> Luong Ngo wrote:
> > Hi Thomas and Dick,
> > I appreciate all the responses. They are very good information to me.
> > Actually, it wasn't me working on the driver but it's been there long
> > time. I thought I just need to add the signal and signal handling
> > part, not expecting it would lead me to the driver space.
> > Here is what I have in the driver. Maybe racing condition could happen
> > in scenario that the ioctl realease the lock but befor going to sleep,
> > the ISR is invoked and call waking up on the queue, hence the ioctl
> > will not be waken up since the wak up cal already executed. But I
> > believe in our system, this could be tolerant since the hardware would
> > keep raising interrupt if the abnormal condition still exists (Due to
> > the ioctl being blocked so user app nevers get a chance to service the
> > device). But is this the reason why my signal handler not get executed
> > at all? Theoretically, according to the Richard Stevens book, I think
> > the process should be waken up and received the signal even if it gets
> > blocked in the IOCTL call, am i right?
>
> ..
>
> > static int ats89_ioctl(struct inode *inode, struct file *file, u_int
> > cmd, u_long arg)
> > {
> >
> >          switch(cmd){
> >           case GET_IRQ_CMD: {
> >            u32  regMask32;
> >
> >           spin_lock_irq(dev->lock);
> >           while ((dev->irqMask & dev->irqEvent) == 0) {
> >                 // Sleep until board interrupt happens
> >                 spin_unlock_irq(dev->lock);
> >                 interruptible_sleep_on(&(dev->boardIRQWaitQueue));
> >                 if (uncond_wakeup) {
> >                     /* don't go back to loop */
> >                     break;
> >                 }
> >                 spin_lock_irq(dev->lock);
> >             }
>
> Kernel code does not get pre-empted by signals. If the code needs to be
> interruptible by signals this has to be handled explicitly.
> interruptible_sleep on will stop waiting if your task gets a signal, but
> your code doesn't check the signal_pending flag to know whether it
> should exit the loop. If signal_pending(current) is set after the sleep
> you should likely be returning -ERESTARTSYS to allow the task to handle
> the signal. Then after the signal handler from the task returns, the
> ioctl will get called again.
>
> Also, as was pointed out, you should not use the sleep_on family of
> functions, use the wait_event functions intead. sleep_on is racy, if the
> interrupt happened just before you do the sleep, you'll sit there
> waiting for something that already occurred.
>
> --
> Robert Hancock      Saskatoon, SK, Canada
> To email, remove "nospam" from hancockr@nospamshaw.ca
> Home Page: http://www.roberthancock.com/
>
>
> Robert, thanks a lot for your suggestion
> But I have added the signal_pending(current) check and signal handler
> is not invoked

>           spin_lock_irq(dev->lock);
>           while ((dev->irqMask & dev->irqEvent) == 0) {
>                 // Sleep until board interrupt happens
>                 spin_unlock_irq(dev->lock);
>                 interruptible_sleep_on(&(dev->boardIRQWaitQueue));
>
>                 if(signal_pending(current) {
>                           return -ERESTARTSYS;
>                 }
>
>                 if (uncond_wakeup) {
>                     /* don't go back to loop */
>                     break;
>                 }
>                 spin_lock_irq(dev->lock);
>             }
>Still no luck yet.
>LNgo
>-

I guess you need to call allow_signal(xxx) before you go for sleep.
Parav

To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


DISCLAIMER:
This message (including attachment if any) is confidential and may be privileged. Before opening attachments please check them for viruses and defects. MindTree Consulting Limited (MindTree) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within MindTree or outside. If you have received this message by mistake please notify the sender by return  e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited.  Please note that e-mails are susceptible to change and MindTree shall not be liable for any improper, untimely or incomplete transmission.
