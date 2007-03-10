Return-Path: <linux-kernel-owner+w=401wt.eu-S1767673AbXCJAKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767673AbXCJAKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 19:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767676AbXCJAKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 19:10:34 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:60817 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767673AbXCJAKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 19:10:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KUisPTzrmPesjGLAME4IV16fJJ7MFKksjV1ZYXK/HW5ImgHlBnjGMhJikrL5s2yX9cM4iDzv0H6twtRtR2d9eAeXur6cIudtx5jKw5gKzVTzd5FvYErz+3fpdriWayPxqcd2gHjPYaGTKeNKBDOYlBScst78d6pymqqk5jm2NXo=
Message-ID: <1b2aacd80703091610h9b5bc0ep1b5b58c53ca58e86@mail.gmail.com>
Date: Fri, 9 Mar 2007 16:10:29 -0800
From: "Luong Ngo" <luong.ngo@gmail.com>
To: "Parav K Pandit" <parav_pandit@mindtree.com>
Subject: Re: Sleeping thread not receive signal until it wakes up
Cc: "Robert Hancock" <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de
In-Reply-To: <2C15D00D262B7245B1D8D1799F04D88F04A58C42@mtw01ex01.mindtree.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.kb3wuhac4W+1DqK61+sKe9uZwto@ifi.uio.no>
	 <fa.cyXmbtXvYymKHdI0rEXZCxyk+KE@ifi.uio.no>
	 <fa.zPDT1vfJF5MjVXXQH/l+YSaLl84@ifi.uio.no>
	 <fa.HmQN7RhZNBRsiJYADMOsY8DL67k@ifi.uio.no>
	 <fa.PDmHwxZ3arhmED5SLuEONyxUlz4@ifi.uio.no>
	 <fa.ygLhZcCLgDxnwAYYVse/Xshr9IE@ifi.uio.no> <45F0B40F.7070301@shaw.ca>
	 <1b2aacd80703081924w44652c71yb8a16e005247a55a@mail.gmail.com>
	 <2C15D00D262B7245B1D8D1799F04D88F04A58C42@mtw01ex01.mindtree.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, Parav K Pandit <parav_pandit@mindtree.com> wrote:
> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Luong Ngo
> Sent: Friday, March 09, 2007 8:54 AM
> To: Robert Hancock
> Cc: linux-kernel; tglx@linutronix.de
> Subject: Re: Sleeping thread not receive signal until it wakes up
>
> On 3/8/07, Robert Hancock <hancockr@shaw.ca> wrote:
> > Luong Ngo wrote:
> > > Hi Thomas and Dick,
> > > I appreciate all the responses. They are very good information to me.
> > > Actually, it wasn't me working on the driver but it's been there long
> > > time. I thought I just need to add the signal and signal handling
> > > part, not expecting it would lead me to the driver space.
> > > Here is what I have in the driver. Maybe racing condition could happen
> > > in scenario that the ioctl realease the lock but befor going to sleep,
> > > the ISR is invoked and call waking up on the queue, hence the ioctl
> > > will not be waken up since the wak up cal already executed. But I
> > > believe in our system, this could be tolerant since the hardware would
> > > keep raising interrupt if the abnormal condition still exists (Due to
> > > the ioctl being blocked so user app nevers get a chance to service the
> > > device). But is this the reason why my signal handler not get executed
> > > at all? Theoretically, according to the Richard Stevens book, I think
> > > the process should be waken up and received the signal even if it gets
> > > blocked in the IOCTL call, am i right?
> >
> > ..
> >
> > > static int ats89_ioctl(struct inode *inode, struct file *file, u_int
> > > cmd, u_long arg)
> > > {
> > >
> > >          switch(cmd){
> > >           case GET_IRQ_CMD: {
> > >            u32  regMask32;
> > >
> > >           spin_lock_irq(dev->lock);
> > >           while ((dev->irqMask & dev->irqEvent) == 0) {
> > >                 // Sleep until board interrupt happens
> > >                 spin_unlock_irq(dev->lock);
> > >                 interruptible_sleep_on(&(dev->boardIRQWaitQueue));
> > >                 if (uncond_wakeup) {
> > >                     /* don't go back to loop */
> > >                     break;
> > >                 }
> > >                 spin_lock_irq(dev->lock);
> > >             }
> >
> > Kernel code does not get pre-empted by signals. If the code needs to be
> > interruptible by signals this has to be handled explicitly.
> > interruptible_sleep on will stop waiting if your task gets a signal, but
> > your code doesn't check the signal_pending flag to know whether it
> > should exit the loop. If signal_pending(current) is set after the sleep
> > you should likely be returning -ERESTARTSYS to allow the task to handle
> > the signal. Then after the signal handler from the task returns, the
> > ioctl will get called again.
> >
> > Also, as was pointed out, you should not use the sleep_on family of
> > functions, use the wait_event functions intead. sleep_on is racy, if the
> > interrupt happened just before you do the sleep, you'll sit there
> > waiting for something that already occurred.
> >
> > --
> > Robert Hancock      Saskatoon, SK, Canada
> > To email, remove "nospam" from hancockr@nospamshaw.ca
> > Home Page: http://www.roberthancock.com/
> >
> >
> > Robert, thanks a lot for your suggestion
> > But I have added the signal_pending(current) check and signal handler
> > is not invoked
>
> >           spin_lock_irq(dev->lock);
> >           while ((dev->irqMask & dev->irqEvent) == 0) {
> >                 // Sleep until board interrupt happens
> >                 spin_unlock_irq(dev->lock);
> >                 interruptible_sleep_on(&(dev->boardIRQWaitQueue));
> >
> >                 if(signal_pending(current) {
> >                           return -ERESTARTSYS;
> >                 }
> >
> >                 if (uncond_wakeup) {
> >                     /* don't go back to loop */
> >                     break;
> >                 }
> >                 spin_lock_irq(dev->lock);
> >             }
> >Still no luck yet.
> >LNgo
> >-
>
> I guess you need to call allow_signal(xxx) before you go for sleep.
> Parav
>
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
> DISCLAIMER:
> This message (including attachment if any) is confidential and may be privileged. Before opening attachments please check them for viruses and defects. MindTree Consulting Limited (MindTree) will not be responsible for any viruses or defects or any forwarded attachments emanating either from within MindTree or outside. If you have received this message by mistake please notify the sender by return  e-mail and delete this message from your system. Any unauthorized use or dissemination of this message in whole or in part is strictly prohibited.  Please note that e-mails are susceptible to change and MindTree shall not be liable for any improper, untimely or incomplete transmission.
>
Thanks Parav, adding singal_allow(SIGALRM) wakeup the blocking
interruptible_sleep_on and checking the signal_pending would return
true now. But a quick question is when detecting signal_pending, I
return -ERESTARTSYS, but the user process receive the return value of
ioctl call is -1, shouldn't it be -4 for EINTR?

Thanks all for the responses,
-LNgo
