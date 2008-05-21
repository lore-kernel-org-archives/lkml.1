Return-Path: <linux-kernel-owner+w=401wt.eu-S1765044AbYEUWBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765044AbYEUWBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbYEUWBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:01:38 -0400
Received: from gw.goop.org ([64.81.55.164]:44967 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbYEUWBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:01:38 -0400
Message-ID: <48349B9D.1000501@goop.org>
Date: Wed, 21 May 2008 23:01:01 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Suspected regression in "x86: extend e820 ealy_res support 32bit"
References: <483467CD.90401@goop.org> <86802c440805211335q27334ba1g32a43fb1c0498b9b@mail.gmail.com>
In-Reply-To: <86802c440805211335q27334ba1g32a43fb1c0498b9b@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Wed, May 21, 2008 at 11:19 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   
>> I'm seeing a crash in current x86.git tip/auto-latest when booting under
>> Xen.  The crash is rather early, but it's in __alloc_bootmem_core() in the
>> final memset clear.  Apparently the allocator is returning a bad page.
>>
>> This points to changes in the setup of the bootmem allocator, and the
>> changes "x86: extend e820 ealy_res support 32bit" make to
>> arch/x86/kernel/setup_32.c:setup_bootmem_allocator() looks like the most
>> likely suspect.  Unfortunately its a rather large patch which is not easy to
>> revert, so I haven't actually confirmed this yet.
>>     
>
>
> thanks. please check the attached patch
>   

Thanks for the quick response.  I definitely confirmed that "x86: extend 
e820 ealy_res support 32bit" is the source of the regression, and 
reverting the change makes the system bootable under Xen. (My previous 
reversion failed because I didn't actually have the x86.git changes 
applied :-/)

This patch generates the warning:

      CC      arch/x86/kernel/setup_32.o
    /home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/setup_32.c: In
    function ‘setup_arch’:
    /home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/setup_32.c:580:
    warning: ‘bootmap_size’ is used uninitialized in this function

but I think it's just that the panic() message still uses it before its 
assigned.

Hm, and it also fails to fix the problem.  I'm still seeing the virtual 
machine crash in the same way.

Thanks,
    J
