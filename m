Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbYCATyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbYCATyv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 14:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbYCATym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 14:54:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55533 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491AbYCATyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 14:54:41 -0500
Message-ID: <47C9B443.9000905@zytor.com>
Date: Sat, 01 Mar 2008 11:53:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Klaus S. Madsen" <ksm@hjernemadsen.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
References: <20080228094000.GA2987@elte.hu> <20080228150444.GG17932@hjernemadsen.org> <47C6F4F9.90700@zytor.com> <20080228192404.GH17932@hjernemadsen.org> <47C70C01.4020605@zytor.com> <20080228194920.GJ17932@hjernemadsen.org> <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org>
In-Reply-To: <20080301094525.GQ17932@hjernemadsen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Klaus S. Madsen wrote:
> On Fri, Feb 29, 2008 at 22:26:54 +0100, Ingo Molnar wrote:
>> * H. Peter Anvin <hpa@zytor.com> wrote:
>>
>>> Klaus S. Madsen wrote:
>>>> open("/dev/mem", O_RDWR)                = 5
>>>> mmap2(NULL, 1282, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_SHARED|MAP_FIXED, 5, 0) = 0
>>>> mmap2(0xa0000, 393216, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_FIXED, 5, 0xa0) = 0xa0000
>>>                          ^^^^^^^^^^^^^^^^^^^^
>>>> close(5)                                = 0
>>>> ioperm(0, 0x400, 0x1)                   = 0
>>>> iopl(0x3)                               = 0
>>>> access("/sys/bus/pci", R_OK)            = 0
>>>> write(1, "Calling get_mode\n", 17)      = 17
>>>> vm86(0x1, 0xb7f14ccc, 0xb7f14830, 0xc000, 0x18b6 <unfinished ...>
>>>> --- SIGSEGV (Segmentation fault) @ 0 (0) ---
>>>> +++ killed by SIGSEGV (core dumped) +++
>>> This is the VGA BIOS being mapped, it's mapped PROT_READ|PROT_WRITE, but  
>>> no PROT_EXEC; if the kernel is NX-capable it *should* segfault trying to 
>>> execute out of this area, which is exactly what will happen when vm86 
>>> executes INT 10h.
>>>
>>> If we can find that mmap() in the s2ram source code and add PROT_EXEC 
>>> to it, it would be interesting.
>> Klaus, could you send your .config as well? Lets make sure that NX is 
>> even relevant in this context.
> Allright. The mmap in question is in the x86-common.c file in libx86,
> and adding PROT_EXEC to it solves the problem.
> 
> I have attached my .config.
> 
> The only thing I don't understand is why this is suddenly a problem with
> 2.6.25, and not with 2.6.24? Is there a bug in 2.6.24 and previously
> that allows real-mode execution of non-executable pages?
> 

One wonders, especially since the checkin it was bisected to it had 
nothing to do with NX.  I suspect there is either a bug in the NX logic, 
which this checkin inadvertently fixed(!), or there is an ad hoc hack 
that should probably never have existed.  More investigation necessary, 
but now we know a lot more.

	-hpa
