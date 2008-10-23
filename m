Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbYJWKDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbYJWKDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 06:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYJWKDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 06:03:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:45062 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbYJWKDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 06:03:37 -0400
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.8.0:
	Introduction
From: haotian <haotian.zhang@windriver.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: zumeng.chen@windriver.com, bruce.ashfield@windriver.com,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp,
       "haotian.zhang" <haotian.zhang@windriver.com>
In-Reply-To: <20081022.170536.193712541.ryov@valinux.co.jp>
References: <20081017.160950.71109894.ryov@valinux.co.jp>
	 <48FDB8AC.9020707@windriver.com> <48FEDC63.308@windriver.com>
	 <20081022.170536.193712541.ryov@valinux.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Oct 2008 18:02:38 +0800
Message-Id: <1224756158.8286.36.camel@pek-hzhang-d1>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
X-OriginalArrivalTime: 23 Oct 2008 10:02:42.0105 (UTC) FILETIME=[7D081290:01C934F6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryo Tsuruta:

This is Haotian Zhang, I am testing the bio_tracking as your benchmark
reports. 

I follow the test procedure as you describe in web page with the
xdd-count.sh, but the results are not to indicate the implementation of
IO count-based bandwidth control on per bio-cgroups.

The testing approach is as follow:

1, mount bio-cgroup on /cgroup
#mount -t cgroup -bio none /cgroup

2, create 3 cgroup 
#cd /cgroup \
mkdir 1 2 3

3, create 3 ioband device on each partiton, 
a.I have 3 ext2 partition /dev/sda5 sda6 sda7:
# cat /proc/partitions
 
major minor  #blocks  name

   8     0   58605120 sda
   8     1   32901088 sda1
   8     2          1 sda2
   8     5    8152956 sda5
   8     6    8924076 sda6
   8     7    8626873 sda7


b. Give weights of 40, 20 and 10 to cgroup1, cgroup2 and cgroup3
respectively, and create ioband device:

#echo "0 $DEVSIZE1 ioband $DEV1 1 0 0" \
    "cgroup weight 0 :100 1:40 2:20 3:10" | dmsetup create ioband1
#echo "0 $DEVSIZE2 ioband $DEV2 1 0 0" \
    "cgroup weight 0 :100 1:40 2:20 3:10" | dmsetup create ioband2
#echo "0 $DEVSIZE3 ioband $DEV3 1 0 0" \
    "cgroup weight 0 :100 1:40 2:20 3:10" | dmsetup create ioband3

/*============================================================================
"NOTE"

The variables are exported as:

DEV1=/dev/sda5
DEV2=/dev/sda6
DEV3=/dev/sda7
DEVSIZE1=$(blockdev --getsize $DEV1)
DEVSIZE2=$(blockdev --getsize $DEV2)
DEVSIZE3=$(blockdev --getsize $DEV3)
RANGE=10240
XDDOPT="-op write -queuedepth 32 -blocksize 512 -reqsize 64
-seek random -datapattern random -dio -timelimit 60
-mbytes $RANGE -seek range $((RANGE * 1048576 / 512))"
﻿============================================================================*/

c. Check out the ioband:
#ls /dev/mapper/
control  ioband1  ioband2  ioband3

4, Run 32 processes random direct I/O with data on each ioband device in
60 seconds:

//******* THE first device ioband1 /dev/sda5 ***************//

#export XDDOPT="-op write -queuedepth 32 -blocksize 512 -reqsize 64
-seek random -datapattern random -dio -timelimit 60 -mbytes 10240 -seek
range 20971520"

#echo $$ > /cgroup/1/tasks

#xdd.linux -targets 1 /dev/mapper/ioband1 $XDDOPT -output cgroup1.txt

#tail -4 /root/cgroup1.txt

            T  Q       Bytes      Ops    Time      Rate      IOPS
Latency     %CPU  OP_Type    ReqSize     
Combined    1 32     262766592     8019    60.203     4.365     133.20
0.0075     0.01   write       32768 
Ending time for this run, Thu Oct 23 01:46:38 2008

﻿//******* THE second device ioband2 /dev/sda6 ***************//

Using another ssh terminal
﻿#export XDDOPT="-op write -queuedepth 32 -blocksize 512 -reqsize 64
-seek random -datapattern random -dio -timelimit 60 -mbytes 10240 -seek
range 20971520"

#echo $$ > /cgroup/2/tasks

#xdd.linux -targets 1 /dev/mapper/ioband2 $XDDOPT -output cgroup2.txt

#tail -4 /root/cgroup2.txt

            T  Q       Bytes      Ops    Time      Rate      IOPS
Latency     %CPU  OP_Type    ReqSize     
Combined    1 32     243662848     7436    60.263     4.043     123.39
0.0081     0.01   write       32768 
Ending time for this run, Thu Oct 23 01:50:55 2008

﻿﻿//******* THE third device ioband3 /dev/sda7 ***************//

Using another ssh terminal
﻿#export XDDOPT="-op write -queuedepth 32 -blocksize 512 -reqsize 64
-seek random -datapattern random -dio -timelimit 60 -mbytes 10240 -seek
range 20971520"

#echo $$ > /cgroup/3/tasks

#xdd.linux -targets 1 /dev/mapper/ioband3 $XDDOPT -output cgroup3.txt

#tail -4 /root/cgroup3.txt

            T  Q       Bytes      Ops    Time      Rate      IOPS
Latency     %CPU  OP_Type    ReqSize     
Combined    1 32     222986240     6805    60.073     3.712     113.28
0.0088     0.01   write       32768 
Ending time for this run, Thu Oct 23 01:58:31 2008



The results are almost the same. I can not see any change of Direct I/O
performance for this bio-cgroup kernel feature with dm-ioband support!

Does the methord to caculate throughout should be the Rate of xdd.linux
output? 
Dose my testing approach should be correct? If not, please help me point
out.


Thanks,
Haotian.


On Wed, 2008-10-22 at 17:05 +0900, Ryo Tsuruta wrote:
> Hi Chen,
> 
> > Chen Zumeng wrote:
> > > Hi, Ryo Tsuruta
> > > And our test team want to test bio_tracking as your benchmark reports,
> > > so would you please send me your test codes? Thanks in advance.
> > Hi Ryo Tsuruta,
> > 
> > I wonder if you received last email, so I reply this email to ask
> > for your bio_tracking test codes to generate your benchmark reports
> > as shown in your website. Thanks in advance :)
> 
> I've uploaded two scripts here:
> http://people.valinux.co.jp/~ryov/dm-ioband/scripts/xdd-count.sh
> http://people.valinux.co.jp/~ryov/dm-ioband/scripts/xdd-size.sh
> 
> xdd-count.sh controls bandwidth based on the number of I/O requests,
> and xdd-size.sh controls bandwidth based onthe number of I/O sectors.
> Theses scritpts require xdd disk I/O testing tool which can be
> downloaded from here:
> http://www.ioperformance.com/products.htm
> 
> Please feel free to ask me questions if you have any questions.
> 
> > > P.S. The following are my changes to avoid schedule_timeout:
> 
> Thanks, but your patch seems to cause a problem when ioband devices
> which have the same name are created at the same time. I will fix the
> issue in the next release.
> 
> Thanks,
> Ryo Tsuruta
