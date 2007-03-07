Return-Path: <linux-kernel-owner+w=401wt.eu-S965236AbXCGNUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965236AbXCGNUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 08:20:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965351AbXCGNUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 08:20:03 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:3025 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965236AbXCGNUB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 08:20:01 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 07 Mar 2007 13:19:58.0438 (UTC) FILETIME=[4DD62860:01C760BB]
Content-class: urn:content-classes:message
Subject: Re: Sleeping thread not receive signal until it wakes up
Date: Wed, 7 Mar 2007 08:19:57 -0500
Message-ID: <Pine.LNX.4.61.0703070813070.12338@chaos.analogic.com>
In-Reply-To: <1b2aacd80703062131g6c8578fgf200dd05a502c49f@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Sleeping thread not receive signal until it wakes up
Thread-Index: Acdgu03fec+WGD1PSuuZM+rObuMmDw==
References: <1b2aacd80703062131g6c8578fgf200dd05a502c49f@mail.gmail.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Luong Ngo" <luong.ngo@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 7 Mar 2007, Luong Ngo wrote:

> Hi all,
>
> I am having this problem. I have a process with 2 threads created. One
> of the thread will keep calling IOCTL  to get information from the
> kernel and will be blocked if there is no new information. If there is
> information retured, the thread will be checked to see if any error
> happens and trigger an action. Since we have no way to know if the
> error is gone (Hardware provides no signal), so what we do is when
> trigger an action for the error, we will set an timer using alarm()
> and register a SIGALRM handler in the thread by using sigaction. After
> setting the alarm, the thread will loop back and call IOCTL, which
> could cause it to be put to sleep. The problem is the SIGALRM handler
> does not receive the SIGALRM while the thread is being blocked by
> IOCTL. And if we generated some event so that the IOCTL is returned
> with new information, the SIGALRM handler is invoked right away.
> However, as I read the manual, which says a thread/process should be
> waken up even when it sleeps if there is a signal delivered to it. Am
> I right?
> One thing I don't know it mattters or not is that I am not using
> sigwait to block the process and wait for signal because the thread
> need to go back to the IOCTL call and be slept on that. So I used
> sigaction to register the signal handler in hope that this handler wil
> be invoked by the kernel when there is an SIGALRM delivered to the
> thread.
> Could anyone tell me if I did something wrong and what is the correct
> way to achieve this task? I tried to avoid creating another thread
> which will call sigwait and block until the IOCTL thread send it
> explicitly a signal because I want to use timer.
>
>
> Thank you in advance,
> LNgo
> -

Later versions of the kernel lock the kernel when an ioctl() is
entered. This means that if you sleep in the ioctl(), nothing
will get scheduled.

You can do the following (possibly unsafe) in your ioctl():

     int locked = kernel_locked();

     ......... code
     ......... code

     if(locked)  // Before sleeping section
        unlock_kernel();
     .......... sleeping code
     if(locked)  // After sleeping section
         lock_kernel();



Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.71 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
