Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZB1U52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZB1U52 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 15:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbZB1U5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 15:57:19 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:14652 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbZB1U5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 15:57:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fSbvvjdcEFGOLXV0aZhJW/P3Z6ri00EBA022+SlujileQ9mrkSW8Vm6YFvhP0OrVfd
         MlqXKrAYUDHKCPZW5x6h/Sxjnhfxe3mQV2qjW3MfBBcsV5umvNn+dr5hkiu0UALd++wW
         b2ZOTq8TNcVoSSvPkadu0jXbq8s8t56IOs4EA=
MIME-Version: 1.0
In-Reply-To: <200902280925.56450.prakash@punnoor.de>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>
	 <200902270752.44078.prakash@punnoor.de> <49A8541C.4030601@kernel.org>
	 <200902280925.56450.prakash@punnoor.de>
Date: Sat, 28 Feb 2009 12:57:15 -0800
X-Google-Sender-Auth: ba2fdb6b5c209e68
Message-ID: <86802c440902281257r4b7f6ca3w546310581a3fc6b5@mail.gmail.com>
Subject: Re: [PATCH] pci: don't enable too many HT MSI mapping
From: Yinghai Lu <yinghai@kernel.org>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       Matthew Wilcox <matthew@wil.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 12:25 AM, Prakash Punnoor <prakash@punnoor.de> wrote:
> On Freitag 27 Februar 2009 21:59:08 Yinghai Lu wrote:
>> Prakash Punnoor wrote:
>> > On Dienstag 24 Februar 2009 18:37:35 Jesse Barnes wrote:
>> >> On Monday, February 23, 2009 11:51:59 am Yinghai Lu wrote:
>> >>> Impact: fix bug
>> >>>
>> >>> Prakash reported that his c51-mcp51 system ondie sound card doesn't
>> >>> work MSI but if he hack out the HT-MSI on mcp51, the MSI will work well
>> >>> with sound card.
>> >>>
>> >>> this patch rework the nv_msi_ht_cap_quirk()
>> >>> and will only enable ht_msi on own root device and try to avoid to
>> >>> enable ht_msi on device following that root dev
>> >>>
>> >>> Reported-by: Prakash Punnoor <prakash@punnoor.de>
>> >>> Tested-by: Prakash Punnoor <prakash@punnoor.de>
>> >>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> >>
>> >> Thanks Yinghai & Prakash, applied this fix to my for-linus branch.
>> >
>> > I am very sorry, but I made a mistake testing this patch. I messed up my
>> > kernels and got a false positive and only noticed this now. The patch
>> > does NOT work and even makes things worse:
>> >
>> > dmesg|grep HT
>> > pci 0000:00:09.0: Found disabled HT MSI Mapping
>> > pci 0000:00:09.0: Enabling HT MSI Mapping
>> > pci 0000:00:09.0: Found enabled HT MSI Mapping
>> > pci 0000:00:09.0: Found enabled HT MSI Mapping
>> > pci 0000:00:09.0: Found enabled HT MSI Mapping
>> > pci 0000:00:09.0: Found enabled HT MSI Mapping
>> >
>> > This is exactly the device which shouldn't be MSI enabled for me. On the
>> > other hand, it doesn't enable the needed devices anymore.
>>
>> please check this one, please power off the system before load the kernel
>> with new patch.
>
> Well, the problem now is that MSI doesn't get enabled on the needed host
> bridge 00.0 (device 10de:02f0), so MSI doesn't work at all on my system (but
> also doesn't hang my system.) I have no idea how to differentiate the 00.0
> device from the "forbidden" 09.0 (device 10de:0270) on my system. Perhaps a
> blacklist is really the best? The original patch by NVidia had a white list,
> btw, see also here:
> http://kerneltrap.org/mailarchive/linux-kernel/2007/11/25/443612/thread
>
> The output of your current patch:
> pci 0000:00:05.0: Boot video device
> pci 0000:00:09.0: Found disabled HT MSI Mapping
> pci 0000:00:0e.0: Enabling HT MSI Mapping
> pci 0000:00:09.0: Found disabled HT MSI Mapping
> pci 0000:00:0f.0: Enabling HT MSI Mapping
> pci 0000:00:09.0: Found disabled HT MSI Mapping
> pci 0000:00:10.0: Enabling HT MSI Mapping
> pci 0000:00:09.0: Found disabled HT MSI Mapping
> pci 0000:00:10.1: Enabling HT MSI Mapping
>
> So, ok, MSI gets enabled on the devices as such (good), not enabled on 09.0
> (good), but also not on the needed host bridge 00.0 (bad).

can you post whole bootlog and lspci -vvxxx and lspci -tv and cat
/proc/interrupts?

YH
