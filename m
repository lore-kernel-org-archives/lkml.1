Return-Path: <linux-kernel-owner+w=401wt.eu-S932438AbZICW3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbZICW3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 18:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932426AbZICW3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 18:29:05 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:47963 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbZICW3E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 18:29:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LbAuLsuWEVXy+WUQmaYb/sg/HqRRyug9jeDrGXkpp+ko2cYlyrzIqkQVyWCcuqgfSr
         wKSqIYWQTEoRKxV1YofdHjau0O5kearSdY2nbXPkax1oS1IxKU21O87OiTVYE/dbqRnt
         mtBsKNEyfa9tBwfB0qfXsdMMjs5RYRQH0aOl8=
MIME-Version: 1.0
In-Reply-To: <c4e36d110909010234i5f1b9357l805132137725a4f8@mail.gmail.com>
References: <c4e36d110908310451t7c238e09u5af112fa3321cc23@mail.gmail.com>
	 <200908312119.12121.rjw@sisk.pl>
	 <c4e36d110909010234i5f1b9357l805132137725a4f8@mail.gmail.com>
Date: Fri, 4 Sep 2009 00:29:04 +0200
Message-ID: <c4e36d110909031529q77b53122kdb85785ba293c478@mail.gmail.com>
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, hch@lst.de, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/1 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2009/8/31 Rafael J. Wysocki <rjw@sisk.pl>:
>> On Monday 31 August 2009, Zdenek Kabelac wrote:
>>> Hi
>>>
>>> I've noticed that my machine freezes while doing s2r and having
>>> mounted filesystem from SD card.
>>>
>>> My system: Lenovo T61, 4GB, C2D, kernel 2.6.31-rc8
>>>
>>> Here is the trace of  suspend when SD card is inserted, follows resume
>>> and again suspend and this time with mounted filesystem from SD card.
>>>
>>> System locks with: PM: Removing info for mmc:mmc0:b368
>>> Also btusb_bulk_complete: errors are interesting - I've noticed few
>>> bugzillas in the google.
>>> I could try bisect to find the patch - but it will take time....
>>> So hopefully this trace will help.
>>
>> Not really. :-(
>>
>> Is this a new regression in 2.6.31-rc, or does 2.6.30 also fail?
>>
>
> Well - all I know for now is this:  v2.6.30 goes to suspend (i.e.
> machine turns to sleep), but resume fails - I do not get a single line
> of output on serial console either - so it's hard to tell whether it
> works or not - before suspend there are some INFO traces about lockdep
> problems in cpu frequency.   v2.6.31-rc1 doesn't boot on my machine.
> v2.6.31-rc2 seems to lock on suspend so this version is already
> definitely broken. I may try to do some bisecting between these
> kernels - but it might probably easily lead to some dead-ends probably
> :(...
> Also I'm using  mmc debugs for compilation of these kernels - but
> nothing seems to printed from mmc subsystem at the end of suspend log
> and the end is still the same - last printed lines:
>
>  mmc0: card b368 removed
>  PM: Removing info for mmc:mmc0:b368
>

Ok - another bisect game played - and unexpected winner is:

(fat: add ->sync_fs)

f83d6d46e7adf241a064a4a425e5cd8a8fd8925f

Reverting this commit with current -rc8 kernel makes the system happy
during the suspend/resume cycle. Obviously it has it price :) so just
plain revert is probably not a good solution so the problem looks
'more serious'  (fat is not the only fs with this patch) thus adding
original author to this thread.

Zdenek
