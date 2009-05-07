Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbZEGPoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbZEGPoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZEGPoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:44:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47641 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbZEGPoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:44:08 -0400
Date: Thu, 7 May 2009 11:42:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com,
       m-ikeda@ds.jp.nec.com, peterz@infradead.org
Subject: Re: IO scheduler based IO Controller V2
Message-ID: <20090507154227.GD9463@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <20090505132441.1705bfad.akpm@linux-foundation.org> <20090506023332.GA1212@redhat.com> <20090506203228.GH8180@redhat.com> <20090506213453.GC4282@linux> <20090506215235.GJ8180@redhat.com> <20090507090450.GA4613@linux> <20090507141126.GA9463@redhat.com> <20090507144501.GB9463@redhat.com> <20090507153642.GC9463@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507153642.GC9463@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 11:36:42AM -0400, Vivek Goyal wrote:
> On Thu, May 07, 2009 at 10:45:01AM -0400, Vivek Goyal wrote:
> > On Thu, May 07, 2009 at 10:11:26AM -0400, Vivek Goyal wrote:
> > 
> > [..]
> > > [root@chilli io-throttle-tests]# ./andrea-test-script.sh 
> > > RT: 223+1 records in
> > > RT: 223+1 records out
> > > RT: 234179072 bytes (234 MB) copied, 0.988448 s, 237 MB/s
> > > BE: 223+1 records in
> > > BE: 223+1 records out
> > > BE: 234179072 bytes (234 MB) copied, 1.93885 s, 121 MB/s
> > > 
> > > So I am still seeing the issue with differnt kind of disks also. At this point
> > > of time I am really not sure why I am seeing such results.
> > 
> > Hold on. I think I found the culprit here. I was thinking that what is
> > the difference between two setups and realized that with vanilla kernels
> > I had done "make defconfig" and with io-throttle kernels I had used an
> > old config of my and did "make oldconfig". So basically config files
> > were differnt.
> > 
> > I now used the same config file and issues seems to have gone away. I
> > will look into why an old config file can force such kind of issues.
> > 
> 
> Hmm.., my old config had "AS" as default scheduler that's why I was seeing
> the strange issue of RT task finishing after BE. My apologies for that. I
> somehow assumed that CFQ is default scheduler in my config.
> 
> So I have re-run the test to see if we are still seeing the issue of
> loosing priority and class with-in cgroup. And we still do..
> 
> 2.6.30-rc4 with io-throttle patches
> ===================================
> Test1
> =====
> - Two readers, one BE prio 0 and other BE prio 7 in a cgroup limited with
>   8MB/s BW.
> 
> 234179072 bytes (234 MB) copied, 55.8448 s, 4.2 MB/s
> prio 0 task finished
> 234179072 bytes (234 MB) copied, 55.8878 s, 4.2 MB/s
> 
> Test2
> =====
> - Two readers, one RT prio 0 and other BE prio 7 in a cgroup limited with
>   8MB/s BW.
> 
> 234179072 bytes (234 MB) copied, 55.8876 s, 4.2 MB/s
> 234179072 bytes (234 MB) copied, 55.8984 s, 4.2 MB/s
> RT task finished
> 
> Test3
> =====
> - Reader Starvation
> - I created a cgroup with BW limit of 64MB/s. First I just run the reader
>   alone and then I run reader along with 4 writers 4 times. 
> 
> Reader alone
> 234179072 bytes (234 MB) copied, 3.71796 s, 63.0 MB/s
> 
> Reader with 4 writers
> ---------------------
> First run
> 234179072 bytes (234 MB) copied, 30.394 s, 7.7 MB/s 
> 
> Second run
> 234179072 bytes (234 MB) copied, 26.9607 s, 8.7 MB/s
> 
> Third run
> 234179072 bytes (234 MB) copied, 37.3515 s, 6.3 MB/s
> 
> Fourth run
> 234179072 bytes (234 MB) copied, 36.817 s, 6.4 MB/s
> 
> Note that out of 64MB/s limit of this cgroup, reader does not get even
> 1/5 of the BW. In normal systems, readers are advantaged and reader gets
> its job done much faster even in presence of multiple writers.   
> 
> Vanilla 2.6.30-rc4
> ==================
> 
> Test3
> =====
> Reader alone
> 234179072 bytes (234 MB) copied, 2.52195 s, 92.9 MB/s
> 
> Reader with 4 writers
> ---------------------
> First run
> 234179072 bytes (234 MB) copied, 4.39929 s, 53.2 MB/s
> 
> Second run
> 234179072 bytes (234 MB) copied, 4.55929 s, 51.4 MB/s
> 
> Third run
> 234179072 bytes (234 MB) copied, 4.79855 s, 48.8 MB/s
> 
> Fourth run
> 234179072 bytes (234 MB) copied, 4.5069 s, 52.0 MB/s
> 
> Notice, that without any writers we seem to be having BW of 92MB/s and
> more than 50% of that BW is still assigned to reader in presence of
> writers. Compare this with io-throttle cgroup of 64MB/s where reader
> struggles to get 10-15% of BW. 
> 
> So any 2nd level control will break the notion and assumptions of
> underlying IO scheduler. We should probably do control at IO scheduler
> level to make sure we don't run into such issues while getting
> hierarchical fair share for groups.
> 

Forgot to attached my reader-writer script last time. Here it is.


***************************************************************
#!/bin/bash

mount /dev/sdb1 /mnt/sdb

mount -t cgroup -o blockio blockio /cgroup/iot/
mkdir -p /cgroup/iot/test1 /cgroup/iot/test2

# Set bw limit of 64 MB/ps on sdb
echo "/dev/sdb:$((64 * 1024 * 1024)):0:0" > /cgroup/iot/test1/blockio.bandwidth-max

sync
echo 3 > /proc/sys/vm/drop_caches

echo $$ > /cgroup/iot/test1/tasks

ionice -c 2 -n 7 dd if=/dev/zero of=/mnt/sdb/testzerofile1 bs=4K count=524288 & 
echo $!

ionice -c 2 -n 7 dd if=/dev/zero of=/mnt/sdb/testzerofile2 bs=4K count=524288 & 
echo $!

ionice -c 2 -n 7 dd if=/dev/zero of=/mnt/sdb/testzerofile3 bs=4K count=524288 & 
echo $!

ionice -c 2 -n 7 dd if=/dev/zero of=/mnt/sdb/testzerofile4 bs=4K count=524288 & 
echo $!

sleep 5
echo "Launching reader"

ionice -c 2 -n 0 dd if=/mnt/sdb/zerofile2 of=/dev/zero &
pid2=$!
echo $pid2

wait $pid2
echo "Reader Finished"
killall dd
**********************************************************************

Thanks
Vivek
