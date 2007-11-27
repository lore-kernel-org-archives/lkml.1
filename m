Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbXK0Ue3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbXK0Ue3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 15:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbXK0UeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 15:34:21 -0500
Received: from smtpoutm.mac.com ([17.148.16.69]:58649 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982AbXK0UeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 15:34:20 -0500
In-Reply-To: <200711271840.24825.rjw@sisk.pl>
References: <4744FD87.7010301@goop.org> <200711262253.35420.rjw@sisk.pl> <20071127053846.GA28884@srcf.ucam.org> <200711271840.24825.rjw@sisk.pl>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8B00F353-983F-40E7-931B-EA73CCD32F0A@mac.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: freeze vs freezer
Date: Tue, 27 Nov 2007 15:33:48 -0500
To: "Rafael J. Wysocki" <rjw@sisk.pl>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 27, 2007, at 12:40:24, Rafael J. Wysocki wrote:
> On Tuesday, 27 of November 2007, Matthew Garrett wrote:
>> On Mon, Nov 26, 2007 at 10:53:34PM +0100, Rafael J. Wysocki wrote:
>>> On Monday, 26 of November 2007, David Chinner wrote:
>>>> So how do you handle threads that are blocked on I/O or a lock  
>>>> during the system freeze process, then?
>>>
>>> We wait until they can continue.
>>
>> So if I have a process blocked on an unavilable NFS mount, I can't
>> suspend?
>
> That's correct, you can't.
>
> [And I know what you're going to say. ;-)]

Why exactly does suspend/hibernation depend on "TASK_INTERRUPTIBLE"  
instead of a zero preempt_count()?  Really what we should do is just  
iterate over all of the actual physical devices and tell each one  
"Block new IO requests preemptably, finish pending DMA, put the  
hardware in low-power mode, and prepare for suspend/hibernate".  As  
long as each driver knows how to do those simple things we can have  
an entirely consistent kernel image for both suspend and for  
hibernation.

When all tasks are preemptable we can very trivially rely on the  
drivers to enforce the "Stop new IO submission" with a dirt-simple  
semaphore or waitqueue.  The sleep itself will be  
TASK_UNINTERRUPTIBLE, but it will be done from a preemptible context.

That way the system suspend time is the sum of the suspend times of  
the devices on the system, and the suspend time of any given device  
is the sum of its maximum non-preemptible critical section and the  
time to flush all of its remaining pending DMA/etc.  This is almost  
completely independent of the load-level of the machine, and it does  
not depend on things like NFS filesystems.  The one gotcha is that it  
does not flush dirty filesystem pages to disk first, although that  
could be fixed with a few VFS and blockdev hooks which hierarchically  
flush and "freeze" block devices and filesystems before actually  
disabling devices much the way that device-mapper can pause a device  
to take a snapshot and end up with a clean journal on the filesystem  
afterwards.

Cheers,
Kyle Moffett

