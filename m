Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbZKJTPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbZKJTPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818AbZKJTPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:15:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757786AbZKJTPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:15:48 -0500
Date: Tue, 10 Nov 2009 14:15:20 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [RFC] Workload type Vs Groups (Was: Re: [PATCH 02/20] blkio:
	Change CFQ to use CFS like queue time stamps)
Message-ID: <20091110191520.GC3497@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-3-git-send-email-vgoyal@redhat.com> <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com> <20091106222257.GB2969@redhat.com> <4e5e476b0911091347t60e4d572kef2e632800fbf849@mail.gmail.com> <20091109231257.GG22860@redhat.com> <4e5e476b0911100329v5da70aedj4a943c4b0220cee8@mail.gmail.com> <20091110133113.GA1083@redhat.com> <20091110141246.GB1083@redhat.com> <4e5e476b0911101005x3da4a552g8f636022ae2c3bed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0911101005x3da4a552g8f636022ae2c3bed@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 07:05:19PM +0100, Corrado Zoccolo wrote:
> On Tue, Nov 10, 2009 at 3:12 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Ok, I ran some simple tests on my NCQ SSD. I had pulled the Jen's branch
> > few days back and it has your patches in it.
> >
> > I am running three direct sequential readers or prio 0, 4 and 7
> > respectively using fio for 10 seconds and then monitoring who got how
> > much job done.
> >
> > Following is my fio job file
> >
> > ****************************************************************
> > [global]
> > ioengine=sync
> > runtime=10
> > size=1G
> > rw=read
> > directory=/mnt/sdc/fio/
> > direct=1
> > bs=4K
> > exec_prerun="echo 3 > /proc/sys/vm/drop_caches"
> >
> > [seqread0]
> > prio=0
> >
> > [seqread4]
> > prio=4
> >
> > [seqread7]
> > prio=7
> > ************************************************************************
> 
> Can you try without direct and bs?
> 

Ok, here are the results without direct and bs. So it is now buffered
reads. The fio file above remains more or less same except that I had
to change size to 2G as with-in 10 seconds some process can finish reading
1G and get out of contention.

First Run
=========
read : io=382MB, bw=39,112KB/s, iops=9,777, runt= 10001msec
read : io=939MB, bw=96,194KB/s, iops=24,048, runt= 10001msec
read : io=765MB, bw=78,355KB/s, iops=19,588, runt= 10004msec

Second run
==========
read : io=443MB, bw=45,395KB/s, iops=11,348, runt= 10004msec
read : io=1,058MB, bw=106MB/s, iops=27,081, runt= 10001msec
read : io=650MB, bw=66,535KB/s, iops=16,633, runt= 10006msec

Third Run
=========
read : io=727MB, bw=74,465KB/s, iops=18,616, runt= 10004msec
read : io=890MB, bw=91,126KB/s, iops=22,781, runt= 10001msec
read : io=406MB, bw=41,608KB/s, iops=10,401, runt= 10004msec

Fourth Run
==========
read : io=792MB, bw=81,143KB/s, iops=20,285, runt= 10001msec
read : io=1,024MB, bw=102MB/s, iops=26,192, runt= 10009msec
read : io=314MB, bw=32,093KB/s, iops=8,023, runt= 10011msec

Still can't get the service difference proportionate to priority levels.
In fact in some cases it is more like priority inversion where higher
priority is getting lower BW.

> >
> > Following are the results of 4 runs. Every run lists three jobs of prio0,
> > prio4 and prio7 respectively.
> >
> > First run
> > =========
> > read : io=75,996KB, bw=7,599KB/s, iops=1,899, runt= 10001msec
> > read : io=95,920KB, bw=9,591KB/s, iops=2,397, runt= 10001msec
> > read : io=21,068KB, bw=2,107KB/s, iops=526, runt= 10001msec
> >
> > Second run
> > ==========
> > read : io=103MB, bw=10,540KB/s, iops=2,635, runt= 10001msec
> > read : io=102MB, bw=10,479KB/s, iops=2,619, runt= 10001msec
> > read : io=720KB, bw=73,728B/s, iops=18, runt= 10000msec
> >
> > Third Run
> > =========
> > read : io=103MB, bw=10,532KB/s, iops=2,632, runt= 10001msec
> > read : io=85,728KB, bw=8,572KB/s, iops=2,142, runt= 10001msec
> > read : io=19,696KB, bw=1,969KB/s, iops=492, runt= 10001msec
> >
> > Fourth Run
> > ==========
> > read : io=50,060KB, bw=5,005KB/s, iops=1,251, runt= 10001msec
> > read : io=102MB, bw=10,409KB/s, iops=2,602, runt= 10001msec
> > read : io=54,844KB, bw=5,484KB/s, iops=1,370, runt= 10001msec
> >
> > I can't see fairness being provided to processes of diff prio levels. In
> > first run prio4 got more BW than prio0 process.
> >
> > In second run prio 7 process got completely starved. Based on slice
> > calculation, the difference between prio 0 and prio 7 should be 180/40=4.5
> >
> > Third run is still better.
> >
> > In fourth run again prio 4 got double the BW of prio 0.
> >
> > So I can't see how are you achieving fariness on NCQ SSD?
> >
> > One more important thing to notice is that throughput of SSD has come down
> > significantly. If I just run one job then I get 73MB/s. With these tree
> > jobs running, we are achieving close to 19 MB/s.
> 
> I think it depends on the hardware. On Jeff's SSD, 32 random readers
> were obtaining approximately the same aggregate bandwidth than a
> single sequential reader. I think that the decision to avoid idling is
> sane on that kind of hardware, but not on the ones like yours, in
> which seek has a very large penalty (I have one in my netbook, for
> which reading 4k takes 1ms). However, if you increase block size, or
> remove the direct I/O, the prefetch should still work for you.

Of course increasing the block size of making the IO buffered which in
turn will increase the block size for sequential reads will increase
the throughput.

Here I wanted to get cache out of picture so that we can see what is
happening at IO scheduling layer.

Thanks
Vivek

> >
> > I think this is happening because of seeks happening almost after every
> > dispatch and that brings down the overall throughput. If we had idled
> > here, I think probably overall throughput would have been better.
> Agreed. In fact, I'd like to add some measurements in cfq, to
> determine the idle parameters, instead of relying on those binary
> rules of thumbs.
> Which hardware is this, btw?
> 
> >
> > Thanks
> > Vivek
> >
> Thanks
> Corrado
