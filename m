Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbZLCGPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbZLCGPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 01:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbZLCGPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 01:15:00 -0500
Received: from mail-pz0-f184.google.com ([209.85.222.184]:39737 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZLCGO7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 01:14:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=j0nYoVCG/X1vMlnfLIohxQ4Uy3CPXc58GzgpL88ckntwN0WL+RQ59KwXO4EVIoneQ4
         d3O5HNcgsn+fjFRxLJv3pSWBM+CKwY69Hd1Qqre4OO62vymhnkUTaGiACsr/9Gwf7ZQD
         Z/ugzqi9F/C8Bjy1RtBKJusJkYwp4Xjld30aw=
MIME-Version: 1.0
In-Reply-To: <0CED0757-67E3-4EAD-A2F7-AB8553559E94@kernel.crashing.org>
References: <1259663450-28790-1-git-send-email-leoli@freescale.com>
	 <1259665127.2076.363.camel@pasglop>
	 <2a27d3730912010334q24bf0e06g84839aae131475ec@mail.gmail.com>
	 <E389CC83-307F-4A7D-B90B-CD928A1D1D1D@kernel.crashing.org>
	 <2a27d3730912012225h3deab5dao2211bc404d247192@mail.gmail.com>
	 <0CED0757-67E3-4EAD-A2F7-AB8553559E94@kernel.crashing.org>
Date: Thu, 3 Dec 2009 14:15:05 +0800
X-Google-Sender-Auth: 440cb3855b93306d
Message-ID: <2a27d3730912022215t3f575a24uc66e22fd653d8f3c@mail.gmail.com>
Subject: Re: [PATCH] powerpc/mm: setting mmaped page cache property through 
	device tree
From: Li Yang <leoli@freescale.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 3, 2009 at 12:15 PM, Segher Boessenkool
<segher@kernel.crashing.org> wrote:
>>>> The scenario for the first case is that in a multicore system running
>>>> ASMP which means different OS runs on different cores.  They might
>>>> communicate through a shared memory region.  The region on every OS
>>>> need to be mapped with the same cache perperty to avoid cache paradox.
>>>
>>> This isn't true.  In ASMP, you cannot usually do coherency between
>>> the different CPUs at all.  Also, in most PowerPC implementations,
>>
>> Coherency can't be achieved with proper configuration and management?  Why
>> so?
>
> Because different CPUs do not usually speak the same coherency protocol.
>
> However, it occurred to me that what you call ASMP is actually SMP where
> you run different OSes on the various cores?
>

Yup.  There might be some confusion on the ASMP definition.  But with
multi-core common in the market, new ASMP system may run on SMP-like
hardware.

>>> it is fine if one CPU maps a memory range as coherent while another
>>> maps it as non-coherent; sure, you have to be careful or you will
>>
>> But we do want the shared region to be coherent.  So mappings should
>> have the same cacheability property.
>
> No, they only need WIMG=xx1x on both sides.  Of course, IM=11 might not
> be a valid combination on your particular CPU, and it probably is better
> for performance to have the RAM cacheable anyway.

Agreed.  This patch also makes M bit configurable.

>
>>> So make the memory known to the kernel, just tell the kernel not to
>>> use it.  If it's normal system RAM, just put it in the "memory" node
>>> and do a memreserve on it (or do something in your platform code); if
>>> it's some other memory, do a device driver for it, map it there.
>>
>> Your solution is feasible.  But the memory allocation is a software
>> configuration.  IMHO, it should be better and easier addressed by
>> changing configurations(like mem parameter) rather than the kernel
>> platform code which should address hardware configuration.
>
> Either platform code or some other boot-time code, sure.
>
> The point is, you put the RAM in the device tree, so the kernel can
> know that particular range of physical address space is RAM, even
> if it doesn't use it itself.

If device tree always pass all the memory available, we need to
implement memmap= kernel cmdline parameter for powerpc in case the
memory used isn't start at address 0.  Maybe it's better that all
these information be passed with kernel parameter rather than device
tree for cross architecture portability.  What do you think?

- Leo
