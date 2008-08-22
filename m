Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbYHVVjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbYHVVjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 17:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbYHVVjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 17:39:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56849 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773AbYHVVjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 17:39:00 -0400
Message-ID: <48AF318E.1060508@redhat.com>
Date: Fri, 22 Aug 2008 17:37:18 -0400
From: Christopher Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Wappler Marcel <Marcel.Wappler@bridgeco.net>
CC: Alex Riesen <raa.lkml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Behaviour of the VM on a embedded linux
References: <83116F0A4FF67A4F97BA0B6E408C48E30289D8F0@zuerich.BC-Int.NET> <81b0412b0808220559w502edf03y7f318d0f3673884@mail.gmail.com> <83116F0A4FF67A4F97BA0B6E408C48E30289D979@zuerich.BC-Int.NET>
In-Reply-To: <83116F0A4FF67A4F97BA0B6E408C48E30289D979@zuerich.BC-Int.NET>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wappler Marcel wrote:
> Alex Riesen wrote:
>>> I'm trying to figure out whats going on an embedded system I have to deal
>>> with. It's running a 2.6.24.7 kernel on 32 MBytes of RAM. There is no
>>> swapping. There are some daemons and shells running and - a big
>>> monolithic c++ application.
>>> 
>>> The application runs a lot of pthreads on different real time priority
>>> levels. It looks like the application consumes  a huge ammount of real
>>> memory in contrast to the assumption, that large code size is no problem
>>> due to paging out pages with unused code.
>> Maybe the kernel wont page anything if the paging support is compiled out.
>> IOW, you still need paging code even if there is now swap partitions.
> 
> Alex, this is the case - I do observe normal operation of the VM subsytem -
> it moves memory pages dynamicaly throughout the system. But: when I create a
> large file on the tmpfs a kernel OOM occurs and kills the big monolithic
> application instead of stealing pages from the application. This is the fact
> I'm wondering about. In the past every guy told me that code size is no
> problem on systems using MMUs because the system can steal pages which
> contain code of the application in situations of low memory. But in my
> situation this is not the case.
> 
> Any ideas?
> 
> Marcel PS: please CC me on replies

All these things you're doing in userspace have a memory footprint in 
kernelspace as well, and that memory can't be swapped.  Page tables for your 
tmpfs mappings aren't free.  Kernel stacks and task_structs for your threads 
aren't free.

Also, there are many places in the kernel where a thread may not go to sleep to 
wait for memory to be freed.  The kernel has asynchronous tasks that try to keep 
memory free to avoid this problem, but if you're churning through your big 
monolithic binary, it's getting paged in as fast as the kernel can page it out.

That said, the modern VM is tuned with larger systems in mind, so you may be 
able to improve the situation by tweaking the vm.* sysctls, particularly 
vm.min_free_kbytes.  You can also change oom-killer settings for your process 
via the /proc/$PID/oom_* parameters.  It might help, or it might replace a 
recoverable userspace oom-kill with an unrecoverable kernel oom panic.

Either way, I'd be a little more conservative about code size on very small 
systems with no swap.

-- Chris
