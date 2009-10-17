Return-Path: <linux-kernel-owner+w=401wt.eu-S1752020AbZJQOnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbZJQOnz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 10:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZJQOny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 10:43:54 -0400
Received: from mail-qy0-f194.google.com ([209.85.221.194]:33186 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZJQOnw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 10:43:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BPzWFucl65eTVKJ9hbHS2Vu3EK7vxE5dco/xKLI3hsugmyY04qsCR558BacsIHuT5H
         D6ev4BypcDUpQxNiHr+uMTp7A4RQ2Cvgpr+546X6lHwSQfYS+YsDTATgKF5l4YD0Z+Fz
         7XyooSyEJHWcLIAodKI7ZwaSzN/h3snccuoP4=
MIME-Version: 1.0
In-Reply-To: <20091017224028V.fujita.tomonori@lab.ntt.co.jp>
References: <20091009164100.85a36188.akpm@linux-foundation.org>
	 <20091013021818.GA3898@localhost.localdomain>
	 <20091013091017.GA18431@localhost.localdomain>
	 <20091017224028V.fujita.tomonori@lab.ntt.co.jp>
Date: Sat, 17 Oct 2009 23:43:56 +0900
Message-ID: <961aa3350910170743n4c9947d1ka0bd31aa1c7b9917@mail.gmail.com>
Subject: Re: [PATCH 2/8] bitmap: Introduce bitmap_set, bitmap_clear, 
	bitmap_find_next_zero_area
From: Akinobu Mita <akinobu.mita@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net, sparclinux@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       gregkh@suse.de, LW@karo-electronics.de, linux-usb@vger.kernel.org,
       rolandd@cisco.com, yevgenyp@mellanox.co.il, netdev@vger.kernel.org,
       tony.luck@intel.com, fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
       linux-altix@sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/17 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> On Tue, 13 Oct 2009 18:10:17 +0900
> Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
>> My user space testing exposed off-by-one error find_next_zero_area
>> in iommu-helper. Some zero area cannot be found by this bug.
>>
>> Subject: [PATCH] Fix off-by-one error in find_next_zero_area
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> ---
>>  lib/iommu-helper.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
>> index 75dbda0..afc58bc 100644
>> --- a/lib/iommu-helper.c
>> +++ b/lib/iommu-helper.c
>> @@ -19,7 +19,7 @@ again:
>>       index = (index + align_mask) & ~align_mask;
>>
>>       end = index + nr;
>> -     if (end >= size)
>> +     if (end > size)
>
> I think that this is intentional; the last byte of the limit doesn't
> work.

It looks ok to me. Without above change, find_next_zero_area cannot
find a 64 bits zeroed area in next sample code.

        unsigned long offset;

        DECLARE_BITMAP(map, 64);

        bitmap_clear(map, 0, 64);
        offset = find_next_zero_area(map, 64, 0, 64, 0);
        if (offset >= 64)
                printf("not found\n");
        else
                printf("found\n");
