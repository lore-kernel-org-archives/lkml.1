Return-Path: <linux-kernel-owner+w=401wt.eu-S1762017AbZCaQve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762017AbZCaQve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758557AbZCaQvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:51:21 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:54897 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbZCaQvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:51:20 -0400
Message-ID: <49D24A02.6070000@codemonkey.ws>
Date: Tue, 31 Mar 2009 11:51:14 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       chrisw@redhat.com, riel@redhat.com, jeremy@goop.org,
       mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net, yaniv@redhat.com,
       dmonakhov@openvz.org
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
References: <1238457560-7613-5-git-send-email-ieidus@redhat.com> <49D17C04.9070307@codemonkey.ws> <49D20B63.8020709@redhat.com> <49D21B33.4070406@codemonkey.ws> <20090331142533.GR9137@random.random> <49D22A9D.4050403@codemonkey.ws> <20090331150218.GS9137@random.random> <49D23224.9000903@codemonkey.ws> <20090331151845.GT9137@random.random> <49D23CD1.9090208@codemonkey.ws> <20090331162525.GU9137@random.random>
In-Reply-To: <20090331162525.GU9137@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Tue, Mar 31, 2009 at 10:54:57AM -0500, Anthony Liguori wrote:
>   
>> You can still disable ksm and simply return ENOSYS for the MADV_ flag.  You 
>>     
>
> -EINVAL if something, -ENOSYS would tell userland that it shall stop
> trying to use madvise, including the other MADV_ too.
>
>   
>> could even keep it as a module if you liked by separating the madvise bits 
>> from the ksm bits.  The madvise() bits could just provide the tracking 
>> infrastructure for determine which vmas were currently marked as sharable.
>> You could then have ksm as loadable module that consumed that interface to 
>> then perform scanning.
>>     
>
> What's the point of making ksm a module if one has part of ksm code
> loaded in the kernel and not being possible to avoid compiling in?
> People that says KSM=N in their .config (like embedded running with 1M
> of ram), don't want that tracking overhead compiled into the kernel.
>   

You have two things here.  CONFIG_MEM_SHARABLE and CONFIG_KSM.  
CONFIG_MEM_SHARABLE cannot be a module. If it's set to =n, then 
madvise(MADV_SHARABLE) == -ENOSYS.

If CONFIG_MEM_SHARABLE=y, then madvise(MADV_SHARABLE) will keep track of 
all sharable memory regions.  Independently of that, CONFIG_KSM can be 
set to n,m,y.  It depends on CONFIG_MEM_SHARABLE and when it's loaded, 
it consumes the list of sharable vmas.

But honestly, CONFIG_MEM_SHARABLE shouldn't a lot of code so I don't see 
why you'd even need to make it configable.

>> A number of MADV_ flags are Linux specific (like 
>> MADV_DOFORK/MADV_DONTFORK).
>>     
>
> But those aren't kernel module related, so they're in line with the
> standard ones and could be adapted by other OS.
>
> KSM is not a core VM functionality, madvise is a core VM
> functionality, so I don't see fit. KSM as ioctl or KSM creating
> /proc/<pid>/ksm when loaded, sounds fine to me instead. If open of
> either one fails, application won't register in. It's up to you to
> choose KSM=M/N, if you want it as core functionality just build as
> KSM=Y but leave the option to others to save memory.
>   

The ioctl() interface is quite bad for what you're doing.  You're 
telling the kernel extra information about a VA range in userspace.  
That's what madvise is for.  You're tweaking simple read/write values of 
kernel infrastructure.  That's what sysfs is for.

Regards,

Anthony Liguori
