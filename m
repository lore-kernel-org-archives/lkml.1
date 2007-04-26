Return-Path: <linux-kernel-owner+w=401wt.eu-S1031456AbXDZTMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031456AbXDZTMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031390AbXDZTMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:12:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58420 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031456AbXDZTME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:12:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Kthread question
References: <Pine.LNX.4.44L0.0704261114080.3552-100000@iolanthe.rowland.org>
Date: Thu, 26 Apr 2007 13:11:15 -0600
In-Reply-To: <Pine.LNX.4.44L0.0704261114080.3552-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Thu, 26 Apr 2007 11:29:52 -0400 (EDT)")
Message-ID: <m1r6q7j6i4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> Here's a question about how to use a kthread.
>
> The usb-storage driver creates a new thread to do LUN scanning whenever a
> newly-hotplugged device is detected.  This scanning involves waiting for
> several seconds and then carrying out a potentially long-lasting series of
> I/O operations.  So we don't want to use schedule_work(); instead we
> create a new thread to do it.
>
> Once the scanning thread's work is done, there's no reason for it to hang
> around.  The driver's probe() method has long since exited, leaving nobody
> to reap the thread.  Of course it could always just exit normally, without
> checking kthread_should_stop(), but...
>
> If the device is unplugged during that initial several-second-long delay 
> period, we need to stop the scanning thread immediately.  The obvious 
> answer is to use kthread_stop(), but that's not consistent with the 
> thread's normal behavior of exiting without waiting for 
> kthread_should_stop().
>
> Another problem arises as well.  If the driver's remove() method doesn't
> call kthread_stop() then it doesn't have any straightforward way to wait
> for the thread to exit.  This leads to the possibility that the driver's
> module could be unloaded while the scanning thread is still running.
>
> Would the best approach be to set up a special-purpose struct completion?  
> Then the thread could call complete_and_exit() and the remove() method
> could wait for it safely.

Ok.    Because of the module unloading issue, and because we don't have
a lot of these threads running around, the current plan is to fix
thread_create and kthread_stop so that they must always be paired,
and so that kthread_stop will work correctly if the task has already
exited.

Basically that just involves calling get_task_struct in kthread_create
and put_task_struct in kthread_stop.

I have some patches, hopefully I will start getting them out in the next day or
two.  Sorry I should have acted on this sooner, but I got a little distracted.

Eric
