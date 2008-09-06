Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbYIFQOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbYIFQOo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 12:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYIFQOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 12:14:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:37931 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbYIFQOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 12:14:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=edJPvWrha6lVLi0FC+IEgmv4pPIA4mXrzOS9Y+X8rnfDNlpB9nUNHM6MLAx8c4q+ST
         fXz0gtkmej+7wppcGnJUp7px+iXvBuDFGPUkIrl2TDDd7NvDsgx+7+kfJjCfz25uU7d1
         +Gqv/tbolxkkUm5aoFH1K8ub68ieDJTLVQALw=
Message-ID: <86802c440809060914n31f34adal513273bb6dcbef6a@mail.gmail.com>
Date: Sat, 6 Sep 2008 09:14:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [2.6.27] overlapping early reservations [was: early exception - lockdep related?]
Cc: "H. Peter Anvin" <hpa@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>,
       "Luca Tettamanti" <kronos.it@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <20080906134118.GD4910@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <68676e00809051217h3da02a6bld4412b4a2ee3b728@mail.gmail.com>
	 <1220642738.11202.21.camel@twins.programming.kicks-ass.net>
	 <48C19415.9060108@kernel.org> <20080906134118.GD4910@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2008 at 6:41 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * H. Peter Anvin <hpa@kernel.org> wrote:
>
>> Peter Zijlstra wrote:
>>> On Fri, 2008-09-05 at 21:17 +0200, Luca Tettamanti wrote:
>>>> On Thu, Sep 4, 2008 at 10:51 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
>>>>> On Thu, Sep 4, 2008 at 4:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>>>>> Sadly your config just boots, albeit not to userspace due to missing
>>>>>> drivers.
>>>>> Yes, I managed to boot it with qemu... I tried kgdb - without luck -
>>>>> kernel dies too early.
>>>>> I also managed to get a stack trace :D
>>>>>
>>>>> http://img151.imageshack.us/my.php?image=tracedm1.jpg
>>>>>
>>>>> It seems that lockdep is an innocent bystander... the kernel died with
>>>>> panic() in __reserve_early, and then took another exception while
>>>>> printing the panic (I guess).
>>>>> Will add further debug stuff to see wtf is going on.
>>>> Hum, kernel says:
>>>>
>>>> http://img177.imageshack.us/my.php?image=overlappingus2.jpg
>>>>
>>>> Overlapping early reservations b98000-eff266 RAMDISK to 200000-d09cf7
>>>> TEXT DATA BSS
>>>>
>>>> It would appear that the initramfs is overlapping the kernel itself,
>>>> is the boot loader (LILO) doing something stupid?
>>>
>>> Suppose it is, lets ask hpa..
>>>
>>
>> It definitely looks like it.
>
> yeah. Kernel is loaded at the standard 2MB physical, and goes up to
> 13.6MB physical. That's a tad large at 11.6 MB but still valid.
>
> ramdisk image goes from 11.6 MB to 14.9 MB - roughly standard size. That
> overlaps 2 MB into the kernel image so we have to panic. LILO should
> have loaded the ramdisk somewhere else. (or should have aborted the boot
> if it cannot do that)
>
> We could perhaps print a prominent warning, delay the boot for 5 seconds
> or so via mdelay(5000) and simply not load the ramdisk if this happens?
> The kernel is obviously still functional - and such a large vmlinuz
> likely has all the built-in drivers to boot up to user-space - the lack
> of the ramdisk does not necessarily hurt .
>
wonder if lilo is fixing bzImage from 1M, and when it is calculating
pos of ramdisk...base that
later on-same-position uncompressing, put vmlinux from 2M...

it seems kexec is puting initrd as high as possible, or could specify
the ramdisk postion ..

wonder if new lilo could help.

YH
