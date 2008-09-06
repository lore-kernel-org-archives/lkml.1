Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbYIFRUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbYIFRUk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYIFRUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:20:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:24578 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbYIFRUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:20:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EYUD+QEQFbn61uvfF0rsKayykyp1qH1PY2rNqvX/V03KpFv3IJoqI6DyUim1myFfgT
         TsXDcVgr8RPiGPVcb+Ar6wSQUZckYhmAIxZAO1IxzBP0wvBSpIT0tvJj27v5li/NlCXo
         0yRaykC2mINAVMPsJnCW/WXnM+ZEqgV50EmkU=
Message-ID: <68676e00809061020y440d4c14ye76413d1e0e57e38@mail.gmail.com>
Date: Sat, 6 Sep 2008 19:20:30 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [2.6.27] overlapping early reservations [was: early exception - lockdep related?]
Cc: "H. Peter Anvin" <hpa@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, mingo@redhat.com
In-Reply-To: <20080906145122.GA7693@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <68676e00809051217h3da02a6bld4412b4a2ee3b728@mail.gmail.com>
	 <1220642738.11202.21.camel@twins.programming.kicks-ass.net>
	 <48C19415.9060108@kernel.org>
	 <68676e00809060620k35679302s42fc0a74aa1dc2d3@mail.gmail.com>
	 <20080906145122.GA7693@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2008 at 4:51 PM, Ingo Molnar <mingo@elte.hu> wrote:
> * Luca Tettamanti <kronos.it@gmail.com> wrote:
>
>> On Fri, Sep 5, 2008 at 10:18 PM, H. Peter Anvin <hpa@kernel.org> wrote:
>> > Peter Zijlstra wrote:
>> >>
>> >> On Fri, 2008-09-05 at 21:17 +0200, Luca Tettamanti wrote:
>> >>>
>> >>> On Thu, Sep 4, 2008 at 10:51 PM, Luca Tettamanti <kronos.it@gmail.com>
>> >>> wrote:
>> >>>>
>> >>>> On Thu, Sep 4, 2008 at 4:25 PM, Peter Zijlstra <peterz@infradead.org>
>> >>>> wrote:
>> >>>>>
>> >>>>> Sadly your config just boots, albeit not to userspace due to missing
>> >>>>> drivers.
>> >>>>
>> >>>> Yes, I managed to boot it with qemu... I tried kgdb - without luck -
>> >>>> kernel dies too early.
>> >>>> I also managed to get a stack trace :D
>> >>>>
>> >>>> http://img151.imageshack.us/my.php?image=tracedm1.jpg
>> >>>>
>> >>>> It seems that lockdep is an innocent bystander... the kernel died with
>> >>>> panic() in __reserve_early, and then took another exception while
>> >>>> printing the panic (I guess).
>> >>>> Will add further debug stuff to see wtf is going on.
>> >>>
>> >>> Hum, kernel says:
>> >>>
>> >>> http://img177.imageshack.us/my.php?image=overlappingus2.jpg
>> >>>
>> >>> Overlapping early reservations b98000-eff266 RAMDISK to 200000-d09cf7
>> >>> TEXT DATA BSS
>> >>>
>> >>> It would appear that the initramfs is overlapping the kernel itself,
>> >>> is the boot loader (LILO) doing something stupid?
>> >>
>> >> Suppose it is, lets ask hpa..
>> >>
>> >
>> > It definitely looks like it.
>>
>> Is there anything that the kernel could to do confuse lilo? The issue
>> started appearing with 2.6.27 and the outcome of the boot process
>> varies between versions and seems sensitive to configuration changes
>> (though a "bad" kernel consistently fails).
>
> good question. Does your successful 2.6.26 bootup actually _depend_ on
> the initrd? Or does it perhaps have enough built-in drivers that make it
> boot just fine?

The image is mostly modular (e.g. ahci drivers + LVM + fs are on the
ramdisk), see:
http://marc.info/?l=linux-kernel&m=122046971607455&q=p3

> or perhaps something made your v2.6.27 bzImage larger so that the
> overlap happens - while it didnt before.

The compressed image (bzImage) is roughly the same size as older
kernels (2MB), the uncompressed vmlinux is slightly bigger, but not
much (~100k)

452K    ./mm/built-in.o
100K    ./ipc/built-in.o
8.0K    ./security/built-in.o
3.0M    ./drivers/built-in.o
4.0K    ./usr/built-in.o
216K    ./block/built-in.o
96K     ./init/built-in.o
292K    ./lib/built-in.o
1.3M    ./net/built-in.o
16K     ./crypto/built-in.o
1.1M    ./kernel/built-in.o
1.3M    ./fs/built-in.o
4.0K    ./sound/built-in.o

Luca
