Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYIXUa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYIXUa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYIXUau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:30:50 -0400
Received: from 1wt.eu ([62.212.114.60]:4468 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbYIXUat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:30:49 -0400
Date: Wed, 24 Sep 2008 22:30:44 +0200
From: Willy Tarreau <w@1wt.eu>
To: yun lin <liny.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Virtual Memory problem in kernel 2.4.18xsmp
Message-ID: <20080924203044.GF24654@1wt.eu>
References: <43c7dbff0809170711h3a48ff4ia3e6d89838868103@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43c7dbff0809170711h3a48ff4ia3e6d89838868103@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 17, 2008 at 10:11:31PM +0800, yun lin wrote:
> Hi all,
>    I am using redhat 8 (kernel 2.4.18 xsmp) on an old cluster (2CPU
> each nodes, 2GB RAM, 4GB swap and NFS). Recently I had encountered a
> problem about virtual memory. A parallel program terminated with
> Segmentation fault (Signal 11). While using gdb to debug, it turns out
> that the exact error message is "virtual memory exhausted". The
> program was compiled using Intel compiler 8.1. I had compiled it on a
> CentOS 5.2(2GB RAM, 4GB swap) with Intel compiler 10.1, and the
> program runs well. It requires about 200 MB RAM, as watching by 'top'
> command. And during its running, 'kswapd' demon would be awakened.
>    While running this program in the cluster, it always dies when the
> RSS reach about 150MB with a signal 11 (or using gdb with 'virtual
> memory exhaust'). During its running, the system has more than 1.2GB
> free RAM, 4GB free swap and the 'kswapd' keeps in 'SW' status. I had
> checked the /etc/security/limits.conf file, which sets no limit. And I
> had tried bash and csh with the stack size, virtual memory, max memory
> size, file size unlimited. I had also doubled the max_map_count in
> /proc/sys/vm/. But all of the above actions had no effect on the
> program, it still died when it occupies about 150MB RAM and reports
> Sig 11 (in gdb 'VM exhauxted'). I had manually set some limits on the
> virtual memory (such as 'virtual memory' limit in the shell or
> max_map_count), the program dies with some different message like
> 'forrtl: not enough virtual memory ...."

First, do not confuse RSS with VSZ. Apparently your program tries to
allocate too much virtual memory, which does not mean that it really
uses it. For instance, it may allocate 1 GB but only use 150 MB. Then
the memory is not really allocated by the system as long as it is not
touched (otherwise you would go out buy RAM sticks every time you
start firefox). I don't now what's in RH 2.4.18, but it is likely
that this kernel does not allow a process to allocate more than one
gig, thus causing trouble to your process. 2.4.18 is quite old, and
a patched RH one makes it even harder to compare to recent things.
But you might be interested in trying to apply one patch which was
lying around at that time in 2.4-aa kernels, to change the memory
split to allow 2G for kernel and as much for user. Look for
"00_3.5G-address-space" in pub/linux/kernel/people/andrea on kernel.org.

>    Are there any other limits that restrain a process from getting
> more virtual memory? I had tried to speed up the fresh frequency of
> 'kswapd', but I can't find 'freepages' file in my /proc/sys/vm
> directory. It is said that this key had been removed since kernel 2.4,
> so how can I increase the fresh frequency of 'kswapd'? Besides, are
> there any special rules in virtual memory control of SMP kernel?
>    Thanks for reading my letters. I hope to get some helps.

You will not change the process' virtual memory size because it's
simply defined by the difference between the top and the bottom of
its address space. So only the process may change it using sbrk()
or munmap().

I hope this helps you a bit,
Willy

