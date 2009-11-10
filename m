Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZKJSFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZKJSFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZKJSFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:05:16 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:50070 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZKJSFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:05:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=L4yQIm3vnACj9yn9zL/tn0d6tsZDN1lugOCiQhJo7J901Ubyrd/b9ZasiBZy4T2eao
         xDKmYoWpgz6cl46Sael7bn3LAtZIQI6NnubODRXzZKxMl5/lo7KL//Gupa4Rro57jG/y
         Ur3GSxWs0HCPMz3e1/XOsXxaL9PozROAeI2Vc=
MIME-Version: 1.0
In-Reply-To: <20091110141246.GB1083@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	 <1257291837-6246-3-git-send-email-vgoyal@redhat.com>
	 <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com>
	 <20091106222257.GB2969@redhat.com>
	 <4e5e476b0911091347t60e4d572kef2e632800fbf849@mail.gmail.com>
	 <20091109231257.GG22860@redhat.com>
	 <4e5e476b0911100329v5da70aedj4a943c4b0220cee8@mail.gmail.com>
	 <20091110133113.GA1083@redhat.com> <20091110141246.GB1083@redhat.com>
Date: Tue, 10 Nov 2009 19:05:19 +0100
Message-ID: <4e5e476b0911101005x3da4a552g8f636022ae2c3bed@mail.gmail.com>
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

On Tue, Nov 10, 2009 at 3:12 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Ok, I ran some simple tests on my NCQ SSD. I had pulled the Jen's branch
> few days back and it has your patches in it.
>
> I am running three direct sequential readers or prio 0, 4 and 7
> respectively using fio for 10 seconds and then monitoring who got how
> much job done.
>
> Following is my fio job file
>
> ****************************************************************
> [global]
> ioengine=sync
> runtime=10
> size=1G
> rw=read
> directory=/mnt/sdc/fio/
> direct=1
> bs=4K
> exec_prerun="echo 3 > /proc/sys/vm/drop_caches"
>
> [seqread0]
> prio=0
>
> [seqread4]
> prio=4
>
> [seqread7]
> prio=7
> ************************************************************************

Can you try without direct and bs?

>
> Following are the results of 4 runs. Every run lists three jobs of prio0,
> prio4 and prio7 respectively.
>
> First run
> =========
> read : io=75,996KB, bw=7,599KB/s, iops=1,899, runt= 10001msec
> read : io=95,920KB, bw=9,591KB/s, iops=2,397, runt= 10001msec
> read : io=21,068KB, bw=2,107KB/s, iops=526, runt= 10001msec
>
> Second run
> ==========
> read : io=103MB, bw=10,540KB/s, iops=2,635, runt= 10001msec
> read : io=102MB, bw=10,479KB/s, iops=2,619, runt= 10001msec
> read : io=720KB, bw=73,728B/s, iops=18, runt= 10000msec
>
> Third Run
> =========
> read : io=103MB, bw=10,532KB/s, iops=2,632, runt= 10001msec
> read : io=85,728KB, bw=8,572KB/s, iops=2,142, runt= 10001msec
> read : io=19,696KB, bw=1,969KB/s, iops=492, runt= 10001msec
>
> Fourth Run
> ==========
> read : io=50,060KB, bw=5,005KB/s, iops=1,251, runt= 10001msec
> read : io=102MB, bw=10,409KB/s, iops=2,602, runt= 10001msec
> read : io=54,844KB, bw=5,484KB/s, iops=1,370, runt= 10001msec
>
> I can't see fairness being provided to processes of diff prio levels. In
> first run prio4 got more BW than prio0 process.
>
> In second run prio 7 process got completely starved. Based on slice
> calculation, the difference between prio 0 and prio 7 should be 180/40=4.5
>
> Third run is still better.
>
> In fourth run again prio 4 got double the BW of prio 0.
>
> So I can't see how are you achieving fariness on NCQ SSD?
>
> One more important thing to notice is that throughput of SSD has come down
> significantly. If I just run one job then I get 73MB/s. With these tree
> jobs running, we are achieving close to 19 MB/s.

I think it depends on the hardware. On Jeff's SSD, 32 random readers
were obtaining approximately the same aggregate bandwidth than a
single sequential reader. I think that the decision to avoid idling is
sane on that kind of hardware, but not on the ones like yours, in
which seek has a very large penalty (I have one in my netbook, for
which reading 4k takes 1ms). However, if you increase block size, or
remove the direct I/O, the prefetch should still work for you.
>
> I think this is happening because of seeks happening almost after every
> dispatch and that brings down the overall throughput. If we had idled
> here, I think probably overall throughput would have been better.
Agreed. In fact, I'd like to add some measurements in cfq, to
determine the idle parameters, instead of relying on those binary
rules of thumbs.
Which hardware is this, btw?

>
> Thanks
> Vivek
>
Thanks
Corrado
