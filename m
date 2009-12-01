Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbZLAW3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbZLAW3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 17:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbZLAW3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 17:29:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZLAW3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 17:29:34 -0500
Date: Tue, 1 Dec 2009 17:27:34 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, czoccolo@gmail.com,
       Alan.Brunelle@hp.com
Subject: Re: Block IO Controller V4
Message-ID: <20091201222734.GA21145@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 09:59:07PM -0500, Vivek Goyal wrote:
> Hi Jens,
> 
> This is V4 of the Block IO controller patches on top of "for-2.6.33" branch
> of block tree.
> 
> A consolidated patch can be found here:
> 
> http://people.redhat.com/vgoyal/io-controller/blkio-controller/blkio-controller-v4.patch
> 

Hi All,

Here are some test results with V4 of the patches. Alan, I have tried to
create tables like you to get some idea what is happening.

I used one entry level enterprise class storage array. It has got few
rotational disks (5-6).

I have tried to run sequential readers, random readers, sequential writers
and random writers in 8 cgroups with weights 100,200,300,400,500,600,700,
and 800 respectively and see how BW and disk time has been distributed.
Cgroup are named test1, test2, test3.....test8. All the IO is _direct_ IO
and no buffered IO for testing purposes.

I have also run same test with everything being in root cgroup. So
workload remains the same and that is 8 instances of either seq reader,
random reader or seq writer or random writer but everything runs in root
cgroup instead of test cgroups.

Some abbreviation details.

rcg--> All 8 fio jobs are running in root cgroup.
ioc--> Each fio job is running in respective cgroup.
gi0/1--> /sys/block/<disk>/sdc/queue/iosched/group_isolation tunable is 0/1
Tms--> Time in ms, consumed by this group on the disk. This is obtained
       with the help of cgroup file blkio.time
S---> Number of sectors transferred by this group
BW--> Aggregate BW achieved by the fio process running either in root
      group or associated test group.

Summary
======
- To me results look pretty good. We provide fairness in terms of disk
  time and these numbers are pretty close. There are some glitches but
  these can be fixed by diving deeper. Nothing major.

Test    Mode    OT  test1  test2  test3  test4  test5  test6  test7  test8  
==========================================================================
rcg,gi0 seq,rd  BW  1,357K 958K   1,890K 1,824K 1,898K 1,841K 1,912K 1,883K 

ioc,gi0 seq,rd  BW  321K   384K   1,182K 1,669K 2,181K 2,596K 2,977K 3,386K 
ioc,gi0 seq,rd  Tms 848    1665   2317   3234   4107   4901   5691   6611   
ioc,gi0 seq,rd  S   18K    23K    68K    100K   131K   156K   177K   203K   

ioc,gi1 seq,rd  BW  314K   307K   1,209K 1,603K 2,124K 2,562K 2,912K 3,336K 
ioc,gi1 seq,rd  Tms 833    1649   2476   3269   4101   4951   5743   6566   
ioc,gi1 seq,rd  S   18K    18K    72K    96K    127K   153K   174K   200K   

----------------
rcg,gi0 rnd,rd  BW  229K   225K   226K   228K   232K   224K   228K   216K   

ioc,gi0 rnd,rd  BW  234K   217K   221K   223K   235K   217K   214K   217K   
ioc,gi0 rnd,rd  Tms 20     21     50     85     41     52     51     92     
ioc,gi0 rnd,rd  S   0K     0K     0K     0K     0K     0K     0K     0K     

ioc,gi1 rnd,rd  BW  11K    22K    30K    39K    49K    55K    69K    80K    
ioc,gi1 rnd,rd  Tms 666    1301   1956   2617   3281   3901   4588   5215   
ioc,gi1 rnd,rd  S   1K     2K     3K     3K     4K     5K     5K     6K     

Note: 
- With group_isolation=0, all the random readers move to root cgroup
  automatically. Hence we don't see disk time consumed or number of
  sectors transferred. Everything is in root cgroup. There is no service
  differentiation in this case.

- With group_isolation=1, we see service differentiation but we also see
  tremendous overall throughput drop. This happens because now every group
  gets exclusive access to disk and group does not have enough traffic to
  keep disk busy. So group_isolation=1 provides stronger isolation but
  also brings throughput down if groups don't have enough IO to do.

----------------
rcg,gi0 seq,wr  BW  1,748K 1,042K 2,131K 1,211K 1,170K 1,189K 1,262K 1,050K 

ioc,gi0 seq,wr  BW  294K   550K   1,048K 1,091K 1,666K 1,651K 2,137K 2,642K 
ioc,gi0 seq,wr  Tms 826    1484   2793   2943   4431   4459   5595   6989   
ioc,gi0 seq,wr  S   17K    31K    62K    65K    100K   99K    125K   158K   

ioc,gi1 seq,wr  BW  319K   603K   988K   1,174K 1,510K 1,871K 2,179K 2,567K 
ioc,gi1 seq,wr  Tms 891    1620   2592   3117   3969   4901   5722   6690   
ioc,gi1 seq,wr  S   19K    36K    59K    70K    90K    112K   130K   154K   

Note:
- In case of sequential write, files have been preallocated so that
  interference from kjournald is minimum and we see service differentiation.

----------------
rcg,gi0 rnd,wr  BW  1,349K 1,417K 1,034K 1,018K 910K   1,301K 1,443K 1,387K 

ioc,gi0 rnd,wr  BW  319K   542K   837K   1,086K 1,389K 1,673K 1,932K 2,215K 
ioc,gi0 rnd,wr  Tms 926    1547   2353   3058   3843   4511   5228   6030   
ioc,gi0 rnd,wr  S   19K    32K    50K    65K    83K    98K    112K   130K   

ioc,gi1 rnd,wr  BW  299K   603K   843K   1,156K 1,467K 1,717K 2,002K 2,327K 
ioc,gi1 rnd,wr  Tms 845    1641   2286   3114   3922   4629   5364   6289   
ioc,gi1 rnd,wr  S   18K    36K    50K    69K    88K    103K   120K   139K   

Thanks
Vivek
