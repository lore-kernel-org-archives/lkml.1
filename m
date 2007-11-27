Return-Path: <linux-kernel-owner+w=401wt.eu-S1760497AbXK0XPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497AbXK0XPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXK0XP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:15:28 -0500
Received: from smtpoutm.mac.com ([17.148.16.75]:63010 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbXK0XP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:15:26 -0500
In-Reply-To: <474C9EEE.4090904@goop.org>
References: <4744FD87.7010301@goop.org> <200711271840.24825.rjw@sisk.pl> <8B00F353-983F-40E7-931B-EA73CCD32F0A@mac.com> <200711280002.00755.rjw@sisk.pl> <474C9EEE.4090904@goop.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <DA9C1E3E-E7BD-4AC3-AD44-416FBD3871AF@mac.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: freeze vs freezer
Date: Tue, 27 Nov 2007 18:14:32 -0500
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 27, 2007, at 17:49:18, Jeremy Fitzhardinge wrote:
> Rafael J. Wysocki wrote:
>> Well, this is more-or-less how we all imagine that should be done  
>> eventually.
>>
>> The main problem is how to implement it without causing too much  
>> breakage.  Also, there are some dirty details that need to be  
>> taken into consideration.
>
> For Xen suspend/resume, I'd like to use the freezer to get all  
> threads into a known consistent state (where, specifically, they  
> don't have any outstanding pagetable updates pending).  In other  
> words, the freezer as it currently stands is what I want, modulo  
> some of these issues where it gets caught up unexpectedly.  If  
> threads end up getting frozen anywhere preempt isn't explicitly  
> disabled, it wouldn't work for me.

The problem with "one freezer" is that "known consistent state" means  
something completely different to every single driver and subsystem.   
Xen wants it to mean "No pending page table updates and no more  
updates from this point forward".  A network driver wants it to mean  
"All pending network packets DMAed out or in and the device shut down  
with all remaining packets queued.  A SATA controller wants it to  
mean "All DMA quiesced and no more commands", etc.

The only way to have that work is to put minimal definitions of what  
state you care about in the drivers themselves.  For Xen this means  
that you need to have an appropriately-timed suspend handler which  
hooks into Xen code very precisely to create and preserve the "No  
pending page table updates" state that you care about.  It will be  
more work in the short term but it's the only maintainable solution  
in the long term IMO.

Cheers,
Kyle Moffett

