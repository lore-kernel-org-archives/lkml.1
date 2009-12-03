Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbZLCEIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbZLCEIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 23:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZLCEIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 23:08:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:35100 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbZLCEIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 23:08:35 -0500
In-Reply-To: <2a27d3730912012225h3deab5dao2211bc404d247192@mail.gmail.com>
References: <1259663450-28790-1-git-send-email-leoli@freescale.com> <1259665127.2076.363.camel@pasglop> <2a27d3730912010334q24bf0e06g84839aae131475ec@mail.gmail.com> <E389CC83-307F-4A7D-B90B-CD928A1D1D1D@kernel.crashing.org> <2a27d3730912012225h3deab5dao2211bc404d247192@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0CED0757-67E3-4EAD-A2F7-AB8553559E94@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] powerpc/mm: setting mmaped page cache property through  device tree
Date: Thu, 3 Dec 2009 05:15:50 +0100
To: Li Yang <leoli@freescale.com>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> The scenario for the first case is that in a multicore system  
>>> running
>>> ASMP which means different OS runs on different cores.  They might
>>> communicate through a shared memory region.  The region on every OS
>>> need to be mapped with the same cache perperty to avoid cache  
>>> paradox.
>>
>> This isn't true.  In ASMP, you cannot usually do coherency between
>> the different CPUs at all.  Also, in most PowerPC implementations,
>
> Coherency can't be achieved with proper configuration and  
> management?  Why so?

Because different CPUs do not usually speak the same coherency protocol.

However, it occurred to me that what you call ASMP is actually SMP where
you run different OSes on the various cores?

>> it is fine if one CPU maps a memory range as coherent while another
>> maps it as non-coherent; sure, you have to be careful or you will
>
> But we do want the shared region to be coherent.  So mappings should
> have the same cacheability property.

No, they only need WIMG=xx1x on both sides.  Of course, IM=11 might not
be a valid combination on your particular CPU, and it probably is better
for performance to have the RAM cacheable anyway.

>> So make the memory known to the kernel, just tell the kernel not to
>> use it.  If it's normal system RAM, just put it in the "memory" node
>> and do a memreserve on it (or do something in your platform code); if
>> it's some other memory, do a device driver for it, map it there.
>
> Your solution is feasible.  But the memory allocation is a software
> configuration.  IMHO, it should be better and easier addressed by
> changing configurations(like mem parameter) rather than the kernel
> platform code which should address hardware configuration.

Either platform code or some other boot-time code, sure.

The point is, you put the RAM in the device tree, so the kernel can
know that particular range of physical address space is RAM, even
if it doesn't use it itself.


Segher

