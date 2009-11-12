Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbZKLIxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbZKLIxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 03:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbZKLIxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 03:53:11 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:54558 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbZKLIxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 03:53:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tBxkSpTa4v5ib6sTDGTD5EZeZJCsfXfveo3sbI/GV7ZcxpVMbWimC3PmogKONJ+kAK
         Per4n33UpNscZJ2owpFmvxHJr/Q8rfQDCQ23McGJ4vH/tQx5NahnrsltObJeYVV4F99U
         O/w+51B3LWiMv013L8xKICcZNwOSZR0oirrqg=
MIME-Version: 1.0
In-Reply-To: <20091110191520.GC3497@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	 <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com>
	 <20091106222257.GB2969@redhat.com>
	 <4e5e476b0911091347t60e4d572kef2e632800fbf849@mail.gmail.com>
	 <20091109231257.GG22860@redhat.com>
	 <4e5e476b0911100329v5da70aedj4a943c4b0220cee8@mail.gmail.com>
	 <20091110133113.GA1083@redhat.com> <20091110141246.GB1083@redhat.com>
	 <4e5e476b0911101005x3da4a552g8f636022ae2c3bed@mail.gmail.com>
	 <20091110191520.GC3497@redhat.com>
Date: Thu, 12 Nov 2009 09:53:15 +0100
Message-ID: <4e5e476b0911120053v283a4349l730c18f14c18db48@mail.gmail.com>
Subject: Re: [RFC] Workload type Vs Groups (Was: Re: [PATCH 02/20] blkio: 
	Change CFQ to use CFS like queue time stamps)
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 8:15 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Nov 10, 2009 at 07:05:19PM +0100, Corrado Zoccolo wrote:
>> On Tue, Nov 10, 2009 at 3:12 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >
>> > Ok, I ran some simple tests on my NCQ SSD. I had pulled the Jen's branch
>> > few days back and it has your patches in it.
>> >
>> > I am running three direct sequential readers or prio 0, 4 and 7
>> > respectively using fio for 10 seconds and then monitoring who got how
>> > much job done.
>> >
>> > Following is my fio job file
>> >
>> > ****************************************************************
>> > [global]
>> > ioengine=sync
>> > runtime=10
>> > size=1G
>> > rw=read
>> > directory=/mnt/sdc/fio/
>> > direct=1
>> > bs=4K
>> > exec_prerun="echo 3 > /proc/sys/vm/drop_caches"
>> >
>> > [seqread0]
>> > prio=0
>> >
>> > [seqread4]
>> > prio=4
>> >
>> > [seqread7]
>> > prio=7
>> > ************************************************************************
>>
>> Can you try without direct and bs?
>>
>
> Ok, here are the results without direct and bs. So it is now buffered
> reads. The fio file above remains more or less same except that I had
> to change size to 2G as with-in 10 seconds some process can finish reading
> 1G and get out of contention.
>
> First Run
> =========
> read : io=382MB, bw=39,112KB/s, iops=9,777, runt= 10001msec
> read : io=939MB, bw=96,194KB/s, iops=24,048, runt= 10001msec
> read : io=765MB, bw=78,355KB/s, iops=19,588, runt= 10004msec
>
> Second run
> ==========
> read : io=443MB, bw=45,395KB/s, iops=11,348, runt= 10004msec
> read : io=1,058MB, bw=106MB/s, iops=27,081, runt= 10001msec
> read : io=650MB, bw=66,535KB/s, iops=16,633, runt= 10006msec
>
> Third Run
> =========
> read : io=727MB, bw=74,465KB/s, iops=18,616, runt= 10004msec
> read : io=890MB, bw=91,126KB/s, iops=22,781, runt= 10001msec
> read : io=406MB, bw=41,608KB/s, iops=10,401, runt= 10004msec
>
> Fourth Run
> ==========
> read : io=792MB, bw=81,143KB/s, iops=20,285, runt= 10001msec
> read : io=1,024MB, bw=102MB/s, iops=26,192, runt= 10009msec
> read : io=314MB, bw=32,093KB/s, iops=8,023, runt= 10011msec
>
> Still can't get the service difference proportionate to priority levels.
> In fact in some cases it is more like priority inversion where higher
> priority is getting lower BW.

Jeff's numbers are:
~/tmp/for-cz/for-2.6.33/output/be0-through-7.fio ~/tmp/for-cz/for-2.6.33
total priority: 880
total data transferred: 4064576
class	prio	ideal	xferred	%diff
be	0	831390	645764	-23
be	1	739013	562932	-24
be	2	646637	2097156	224
be	3	554260	250612	-55
be	4	461883	185332	-60
be	5	369506	149492	-60
be	6	277130	98036	-65
be	7	184753	75252	-60
~/tmp/for-cz/for-2.6.33
~/tmp/for-cz/for-2.6.33/output/be0-vs-be1.fio ~/tmp/for-cz/for-2.6.33
total priority: 340
total data transferred: 2244584
class	prio	ideal	xferred	%diff
be	0	1188309	1179636	-1
be	1	1056274	1064948	0
~/tmp/for-cz/for-2.6.33
~/tmp/for-cz/for-2.6.33/output/be0-vs-be7.fio ~/tmp/for-cz/for-2.6.33
total priority: 220
total data transferred: 2232808
class	prio	ideal	xferred	%diff
be	0	1826842	1834484	0
be	7	405965	398324	-2

There is one big outlier, but usually the transferred data is in line
with priority.
Seeing your numbers, though, where the process with intermediate
priority is almost consistently getting more bandwidth than the
others, I think it must be some bug in the code that caused both your
results and the outlier seen in Jeff's test.
I'll have a closer look at the interactions of the various parts of
the code, to see if I can spot the problem.

Thanks
Corrado
