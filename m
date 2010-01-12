Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635Ab0ALFg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab0ALFg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 00:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245Ab0ALFg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 00:36:56 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:35662 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab0ALFg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 00:36:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=WTQbA+IwdBhbmhvihP7ZxKCWsY8iqUgqCXD1YGI/Lrbxdj8yRpVsGqu/3dlrLN3I7e
         FsRlNATzNIkvCiQ1YrPgCE/nOHw9yC3Dfk9vg2JLSSJeZBmlXSuTXkCdw2BW0D7WVsfs
         7KI9lUO0y6TklyZW3cJ+nPf0BrIzcqZG72vAs=
MIME-Version: 1.0
In-Reply-To: <4e5e476b1001070541y30cae741ofe16ab82670b2633@mail.gmail.com>
References: <58965d8a1001050807l31ddf8d1l55ebcfbadbfc206d@mail.gmail.com>
	 <4e5e476b1001070541y30cae741ofe16ab82670b2633@mail.gmail.com>
Date: Mon, 11 Jan 2010 23:31:54 -0600
X-Google-Sender-Auth: 8d00196f04c960c7
Message-ID: <58965d8a1001112131o2d092016i4f83e97de45d2300@mail.gmail.com>
Subject: Re: Multi-file USB mass-storage copy from PC to Nokia N900 slow when 
	using CFQ
From: Paul Hartman <paul.hartman+linux@gmail.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 7, 2010 at 7:41 AM, Corrado Zoccolo <czoccolo@gmail.com> wrote:
> On Tue, Jan 5, 2010 at 5:07 PM, Paul Hartman
> <paul.hartman+linux@gmail.com> wrote:
>> Hi,
>>
>> Copying more than one file from my PC (kernel 2.6.32) to my Nokia N900
>> over USB mass storage mode is very slow when CFQ is the i/o scheduler.
>> The target uses vfat filesystem.
>>
>> I am using iotop to monitor the I/O in general, plus I performed the
>> following test. file1 and file2 are each 700M and both housed on a
>> ramdrive for this test. They were deleted from the destination between
>> runs.
>>
>> # one file at a time with sync in-between, fast speeds:
>> $ sync; time sh -c "cp file1 /mnt/usb; sync; cp file2 /mnt/usb; sync"
>>
>> real    1m25.697s
>> user    0m0.005s
>> sys     0m2.509s
>>
>> # copy two files in a row, then sync, speed is bad:
>> $ sync; time sh -c "cp file1 file2 /mnt/usb; sync"
>>
>> real    6m51.439s
>> user    0m0.007s
>> sys     0m2.615s
>>
>>
>> Using all I/O schedulers, the speed of the first test was the same. So
>> it's only related to writing more than 1 file to the N900. The timing
>> results for the second test ended up as such:
>>
>> cfq: 6m51.439s
>> noop: 3m0.733s
>> anticipatory: 1m44.348s
>> deadline: 1m36.804s
>>
>>
>> Also, in 2.6.31 the speed was four times slower, so the removal of old
>> pdflush code may have made a difference in this case. Copying 1
>> gigabyte takes about 1 minute at optimal speed, about 5 minutes using
>> CFQ in kernel 2.6.32, and took about 20 minutes using CFQ in kernel
>> 2.6.31.
>>
>> I thought you may be interested in case there's room to improve the
>> scheduler.  If you want any other info let me know!
>
> Can you try setting:
> /sys/block/**your_device** /queue/iosched/fifo_expire_sync
> to a large number, e.g. 5000 ?
> CFQ operates pretty much like deadline w.r.t. normal writes, but uses
> a much shorter interval to switch between two streams of writes, to
> reduce latency of data hitting disk, and this could cause low
> performance on flash devices, where writes that do not cover whole
> blocks are painfully slow.
>
> Corrado

Hi Corrado,

>From previous test this value was 125. Now I'll try 5000 as you suggest:

real    6m25.435s
user    0m0.006s
sys     0m2.536s

So it's about the same result 5000 as with 125.

Thanks
Paul
