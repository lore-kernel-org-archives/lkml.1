Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbYH2MJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbYH2MJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 08:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbYH2MJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 08:09:24 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:11540 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbYH2MJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 08:09:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=YHBoA3i0wMcAQ6QX4pPh7KGekwEuJQQRDolnKTm37pNXbfYPuELKcxF1AENkYufYcV
         B1Dp/8DNe/Bnzr5OfeqPvaaxrAte5Qnua/Z767UW0jVc+Wb8UeMYxf9VIRbuRi3d3gFY
         kJJGW7jLo8Wdbk39sc0pCuDndp613JK3TDWr4=
Message-ID: <48B7E6EE.9090901@tuffmail.co.uk>
Date: Fri, 29 Aug 2008 13:09:18 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Hugh Dickins <hugh@veritas.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
References: <48B701FB.2020905@goop.org>	 <86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>	 <48B76CE0.5010309@goop.org>	 <20080829102547.655440bf@lxorguk.ukuu.org.uk>	 <b170af450808290313x574b4561i3048ffca3e4da197@mail.gmail.com>	 <Pine.LNX.4.64.0808291120540.8561@blonde.site> <b170af450808290454m2f349ce3w4f400b0df0e105a2@mail.gmail.com>
In-Reply-To: <b170af450808290454m2f349ce3w4f400b0df0e105a2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafał Miłecki wrote:
> 2008/8/29 Hugh Dickins <hugh@veritas.com>:
>   
>>> On Fri, 29 Aug 2008, Rafał Miłecki wrote:
>>>
>>> Out of current discussion I tried using s2ram on patched kernel (I did
>>> not try s2ram earlier, my problem was (un)plugging HDMI - some ACPI
>>> code probably).
>>>
>>> Corruption output is quite huge, I attached it to bug report:
>>> http://bugzilla.kernel.org/show_bug.cgi?id=11237
>>> http://bugzilla.kernel.org/attachment.cgi?id=17526
>>>       
>> Not quite the output we were expecting!  I've not got around to trying
>> it yet, so beware, but I think Jeremy's patch needs the following on top.
>> Or you may prefer to wait until one of us reports that it is now working
>> as intended.
>>
>> --- a/arch/x86/kernel/setup.c   2008-08-29 11:17:16.000000000 +0100
>> +++ b/arch/x86/kernel/setup.c   2008-08-29 11:19:24.000000000 +0100
>> @@ -636,11 +636,12 @@ void check_for_bios_corruption(void)
>>                unsigned long *addr = __va(scan_areas[i].addr);
>>                unsigned long size = scan_areas[i].size;
>>
>> -               for(; size; addr++, size--) {
>> +               for(; size; addr++, size -= sizeof(unsigned long)) {
>>                        if (!*addr)
>>                                continue;
>>                        printk(KERN_ERR "Corrupted low memory at %p (%lx phys) = %08lx\n",
>>                               addr, __pa(addr), *addr);
>> +                       *addr = 0;
>>                        corruption = 1;
>>                }
>>        }
>>     
>
> I tried your patch anyway (after applying Jeremy's patch of course)
> and it doesn't seem to work. The only output is:
> scanning 2 areas for BIOS corruption
> after using s2ram. I do not get any
> Corrupted low memory at*
>   
It seemed to work for me.  Did you remember to plug HDMI to trigger the
corruption before you used s2ram?

[   71.663828] Back to C!
[   71.663828] Corrupted low memory at ffff8800000083e8 (83e8 phys) =
803c85370cfc0000
[   71.663828] Corrupted low memory at ffff8800000083f0 (83f0 phys) =
00003000
[   71.663828] Pid: 7335, comm: pm-suspend Not tainted
2.6.27-rc4-00216-ge1c9c9d-dirty #152
[   71.663828]
[   71.663828] Call Trace:
[   71.663828]  [<ffffffff8020fdd5>] check_for_bios_corruption+0xb5/0xd0
[   71.663828]  [<ffffffff803a3e1a>] pm_dev_dbg+0x2a/0xa0
[   71.663828]  [<ffffffff803a49c2>] dpm_power_up+0x32/0xf0

Alan
