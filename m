Return-Path: <linux-kernel-owner+w=401wt.eu-S1758418AbZA2W7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbZA2W7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZA2W7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:59:41 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:50211 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbZA2W7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:59:41 -0500
Message-ID: <498234DA.5030104@msgid.tls.msk.ru>
Date: Fri, 30 Jan 2009 01:59:38 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Nicholas Miell <nmiell@comcast.net>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: vm: shmat() address for 32 vs 64 bit kernel
References: <4981FEBF.5050603@msgid.tls.msk.ru> <1233258106.12514.6.camel@entropy>
In-Reply-To: <1233258106.12514.6.camel@entropy>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas Miell wrote:
> On Thu, 2009-01-29 at 22:08 +0300, Michael Tokarev wrote:
>>
>> shmat(174358532, 0, 0)            = 0x9569f000
>> Here, the segment ends at (0x9569f000+579067904)/1024/1024 = 2942Mb.
>>
>> And here's what happens with 64bits kernel:
>>
>> shmget(0xc9a7c840, 579067904, IPC_CREAT|IPC_EXCL|0640) = 294912
>> Here, the segment ends at 3965Mb.
>>
[]
>> I understand full well many bad points here: proprietary software,
>> old legacy code, not supported, buggy.
> 
> Fortunately, compatibility is compatibility, and none of these are
> relevant. :)

Well, compatibility for 64bits kernel and 32bits userland it not
the first priority, so to say.

[]
> On 32-bit systems, the kernel is mapped into the last gigabyte of the 4
> GB address space for every process. On 64-bit systems, the kernel is
> mapped in the negative half of the 64-bit address space for all
> processes, which leaves the top gigabyte of the 4 GB address space free
> for userspace use.
> 
> Most of the time this just means more memory for the processes that need
> it, but (as you have discovered) sometimes it can cause problems, which
> is why the setarch command has the --3gb flag.

Oh.  Nice thing, I just discovered personality(2) stuff ;)
Thank you very much for the pointer!

Except of some.. interesting stuff here.  It does not quite work as
*I*'d expect (not to say it's wrong but just unexpected).  Namely,
when setarch is also 32bits, it can't execute anything after setting
ADDR_LIMIT_3GB (or PER_LINUX32_3GB).  execve(2) returns immediately
with EFAULT error.  But if doing the same from a 64bit executable,
it all works as expected.  Or when doing the same from 32bit exe
running on a 32bit kernel.  I.e. the only problematic case for
personality(PER_LINUX32_3GB) call is 32bit userspace on 64bit kernel.

personality(PER_LINUX32_3GB)            = 0
execve("/bin/echo", ["/bin/echo", "foo"], [/* 13 vars */]) = -1 EFAULT (Bad address)

Should it work? ;)

For now, it is running correctly when using a 64bits setarch executable
in-between.  Sure it will not work anymore if I'll reboot into 32bits
kernel ;)  (I run 64bits now because I'm trying to move data between
two databases, one old 32bits and another is 64 bits).

Thank you!

/mjt
