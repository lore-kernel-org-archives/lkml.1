Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbYIHRyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbYIHRyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYIHRyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:54:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:27497 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbYIHRyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:54:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OG2dOzhWz0o0oPkFpci409eOOrD3bgIvTP9ow0BxAy/OayiNW258pJR6uJrtrV+oIz
         Pp+JFOtj0NtQ/PPIldmrh/YHKO0IvZ6VzjlchW75R1k30YrWh3N308wcyeeh4DCTL//0
         UiskSRhxvkk0p1puMQBJrbkthbowqq+4zKlBU=
Message-ID: <68676e00809081054j3fb9c5bq76c9a6aceea35aa2@mail.gmail.com>
Date: Mon, 8 Sep 2008 19:54:44 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [2.6.27] overlapping early reservations [was: early exception - lockdep related?]
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <86802c440809060906h721d6243t4a3b5fb604a9d7b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <68676e00809051217h3da02a6bld4412b4a2ee3b728@mail.gmail.com>
	 <1220642738.11202.21.camel@twins.programming.kicks-ass.net>
	 <48C19415.9060108@kernel.org>
	 <68676e00809060620k35679302s42fc0a74aa1dc2d3@mail.gmail.com>
	 <20080906145122.GA7693@elte.hu>
	 <86802c440809060906h721d6243t4a3b5fb604a9d7b3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2008 at 6:06 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Sat, Sep 6, 2008 at 7:51 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * Luca Tettamanti <kronos.it@gmail.com> wrote:
>>
>>> On Fri, Sep 5, 2008 at 10:18 PM, H. Peter Anvin <hpa@kernel.org> wrote:
>>> > Peter Zijlstra wrote:
>>> >>
>>> >> On Fri, 2008-09-05 at 21:17 +0200, Luca Tettamanti wrote:
>>> >>>
>>> >>> On Thu, Sep 4, 2008 at 10:51 PM, Luca Tettamanti <kronos.it@gmail.com>
>>> >>> wrote:
>>> >>>>
>>> >>>> On Thu, Sep 4, 2008 at 4:25 PM, Peter Zijlstra <peterz@infradead.org>
>>> >>>> wrote:
>>> >>>>>
>>> >>>>> Sadly your config just boots, albeit not to userspace due to missing
>>> >>>>> drivers.
>>> >>>>
>>> >>>> Yes, I managed to boot it with qemu... I tried kgdb - without luck -
>>> >>>> kernel dies too early.
>>> >>>> I also managed to get a stack trace :D
>>> >>>>
>>> >>>> http://img151.imageshack.us/my.php?image=tracedm1.jpg
>>> >>>>
>>> >>>> It seems that lockdep is an innocent bystander... the kernel died with
>>> >>>> panic() in __reserve_early, and then took another exception while
>>> >>>> printing the panic (I guess).
>>> >>>> Will add further debug stuff to see wtf is going on.
>>> >>>
>>> >>> Hum, kernel says:
>>> >>>
>>> >>> http://img177.imageshack.us/my.php?image=overlappingus2.jpg
>>> >>>
>>> >>> Overlapping early reservations b98000-eff266 RAMDISK to 200000-d09cf7
>>> >>> TEXT DATA BSS
>>> >>>
>>> >>> It would appear that the initramfs is overlapping the kernel itself,
>>> >>> is the boot loader (LILO) doing something stupid?
>>> >>
>>> >> Suppose it is, lets ask hpa..
>>> >>
>>> >
>>> > It definitely looks like it.
>>>
>>> Is there anything that the kernel could to do confuse lilo? The issue
>>> started appearing with 2.6.27 and the outcome of the boot process
>>> varies between versions and seems sensitive to configuration changes
>>> (though a "bad" kernel consistently fails).
>>
>> good question. Does your successful 2.6.26 bootup actually _depend_ on
>> the initrd? Or does it perhaps have enough built-in drivers that make it
>> boot just fine?
>>
>> in that case v2.6.26 might just have stomped on the initrd silently,
>> corrupted it (during kernel decompress), and the initrd unpacker saw the
>> corruption and ignored it. Userspace wouldnt care as the kernel had all
>> the drivers it needed.
>>
>> or perhaps something made your v2.6.27 bzImage larger so that the
>> overlap happens - while it didnt before.
>>
>>> Orthogonal to my problem: the panic() in reserve_early is useless for
>>> debugging since the output won't reach the screen or the serial
>>> console (even worse: the kernel takes an exception while trying to
>>> execute the panic). Is it acceptable to replace it with an
>>> early_printk + hlt?
>>
>> very much so. I was wondering about that already.
>
> console=uart8250,io,0x3f8,115200n8
> could help

Nope, parse_early_param() is called in start_kernel(), my kernel dies
way before it...

> wonder if lilo is fixing bzImage from 1M, and when it is calculating
> pos of ramdisk...base that
> later on-same-position uncompressing, put vmlinux from 2M...

How does LILO decides where to put the initrd (I find LILO code...
obscure)? I mean, it gets a compressed image: how does it know the
size of the uncompressed kernel image? Is it the payload_length in the
real mode header? (answer to self: no, it appears to be the compressed
payload).

> wonder if new lilo could help.

I'm already using the latest version.

Luca
