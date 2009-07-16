Return-Path: <linux-kernel-owner+w=401wt.eu-S1757702AbZGPPOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbZGPPOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757669AbZGPPOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:14:41 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:62500 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680AbZGPPOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:14:40 -0400
From: Christian =?iso-8859-1?q?Borntr=E4ger?= <borntraeger@de.ibm.com>
Organization: IBM
To: Mike Snitzer <snitzer@redhat.com>
Subject: Re: regression post 2.6.30: device mapper fails on some logical volumes
Date: Thu, 16 Jul 2009 17:14:36 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-release; KDE/4.2.4; i686; ; )
Cc: Alasdair G Kergon <agk@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200907151852.15121.borntraeger@de.ibm.com> <200907160736.09885.borntraeger@de.ibm.com> <20090716144438.GA8257@redhat.com>
In-Reply-To: <20090716144438.GA8257@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907161714.37928.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 16 Juli 2009 16:44:39 schrieben Sie:
> On Thu, Jul 16 2009 at  1:36am -0400,
> These "target device dasde1 is misaligned" warnings are a function of
> device-mapper now being topology-aware.  This means that your LVs are
> likely misaligned relative to the underlying hardware.
>
> Moving forward it would likely be wise if we were to add a bit more
> contextual information to the warning so we'd know _why_ a device was
> deemed "misaligned".
>
> So you know these dasd devices to use an internal (aka
> physical_block_size) of 512 bytes?  And a logical_block_size (aka hard
> sect size) of 4096 bytes?  That would be strange; I'm only aware of the
> opposite being possible (physical_block_size=4096,
> logical_block_size=512).

No, the physical block size and the logical block size is 4k for dasds.


> In any case, the reason for your "aisaligned" warnings could be that
> you're using partitions with start offsets into the underlying dasd
> device that aren't aligned on a 4k boundary.
> Please provide the output from the following commands:
>
> pvs -o +pe_start /dev/dasdf1

[root@t63lp34 ~]# pvs  -o +pe_start /dev/dasdf1
  PV          VG    Fmt  Attr PSize  PFree  1st PE
  /dev/dasdf1 space lvm2 a-   22.49G 12.00M 192.00K



> I'm not sure of the /sys/block/ device names that are associated with
> /dev/dasdf1, maybe dasdf is the entire device and dasdf1 is a partition?

Yes, dasdf is a device with up to 3 partitions and dasdf1 is the first 
partition:


> So along the lines of these commands (relative to sda6):
> cat /sys/block/sda/sda6/alignment_offset
> cat /sys/block/sda/queue/physical_block_size
> cat /sys/block/sda/queue/logical_block_size
>
> maybe these are applicable to dasdf1?:
> cat /sys/block/dasdf/dasdf1/alignment_offset
0

> cat /sys/block/dasdf/queue/physical_block_size
4096

> cat /sys/block/dasdf/queue/logical_block_size
4096

>
> It would also be great if you could provide the "dmsetup table"
> output associated the dasdf1 device.  Are you just using linear DM
> mappings?

If you look down the logs, all 4 pv are affected, so I am posting the complete 
dmsetup table output. dasdf1 is 94:21. 

space-s17: 0 819200 striped 2 128 94:21 27148672 94:17 27148672                                                        
space-r5: 0 819200 striped 2 128 94:21 16908672 94:17 16908672                                                         
space-r16: 0 819200 striped 2 128 94:21 25919872 94:17 25919872                                                        
space-s16: 0 819200 striped 2 128 94:21 26329472 94:17 26329472                                                        
space-s9: 0 819200 striped 2 128 94:21 20595072 94:17 20595072                                                         
space-r4: 0 819200 striped 2 128 94:21 16089472 94:17 16089472                                                         
space-r15: 0 819200 striped 2 128 94:21 25100672 94:17 25100672                                                        
space-s15: 0 819200 striped 2 128 94:21 25510272 94:17 25510272                                                        
space-s8: 0 819200 striped 2 128 94:21 19775872 94:17 19775872                                                         
space-r3: 0 819200 striped 2 128 94:21 15270272 94:17 15270272                                                         
space-r29: 0 819200 striped 2 128 94:9 7471488 94:17 45482368                                                          
space-r14: 0 819200 striped 2 128 94:21 24281472 94:17 24281472                                                        
space-s29: 0 819200 striped 2 128 94:9 7881088 94:17 45891968
space-s14: 0 819200 striped 2 128 94:21 24691072 94:17 24691072
space-s7: 0 819200 striped 2 128 94:21 18956672 94:17 18956672
space-r2: 0 819200 striped 2 128 94:21 14451072 94:17 14451072
space-r28: 0 819200 striped 2 128 94:9 6652288 94:17 44663168
space-r13: 0 819200 striped 2 128 94:21 23462272 94:17 23462272
space-usr: 0 6291456 striped 2 128 94:21 10486144 94:17 10486144
space-s28: 0 819200 striped 2 128 94:9 7061888 94:17 45072768
space-s13: 0 819200 striped 2 128 94:21 23871872 94:17 23871872
space-s6: 0 819200 striped 2 128 94:21 18137472 94:17 18137472
space-r1: 0 819200 striped 2 128 94:21 13631872 94:17 13631872
space-r27: 0 819200 striped 2 128 94:9 5833088 94:17 43843968
space-r12: 0 819200 striped 2 128 94:21 22643072 94:17 22643072
space-test: 0 6291456 striped 2 128 94:21 33292672 94:17 33292672
space-test: 6291456 2441216 striped 2 128 94:9 8290688 94:13 8388992
space-test: 8732672 1490944 striped 2 128 94:17 46301568 94:21 46399872
space-s27: 0 819200 striped 2 128 94:9 6242688 94:17 44253568
space-s12: 0 819200 striped 2 128 94:21 23052672 94:17 23052672
space-s5: 0 819200 striped 2 128 94:21 17318272 94:17 17318272
space-r26: 0 819200 striped 2 128 94:9 5013888 94:17 43024768
space-r11: 0 819200 striped 2 128 94:21 21823872 94:17 21823872
space-s26: 0 819200 striped 2 128 94:9 5423488 94:17 43434368
space-s11: 0 819200 striped 2 128 94:21 22233472 94:17 22233472
space-s4: 0 819200 striped 2 128 94:21 16499072 94:17 16499072
space-r25: 0 819200 striped 2 128 94:9 4194688 94:17 42205568
space-home: 0 10485760 striped 2 128 94:21 36962688 94:17 36962688
space-r10: 0 819200 striped 2 128 94:21 21004672 94:17 21004672
space-s25: 0 819200 striped 2 128 94:9 4604288 94:17 42615168
space-s10: 0 819200 striped 2 128 94:21 21414272 94:17 21414272
space-s3: 0 819200 striped 2 128 94:21 15679872 94:17 15679872
space-r24: 0 819200 striped 2 128 94:21 32473472 94:17 32473472
space-base: 0 8388608 striped 2 128 94:9 384 94:13 4194688
space-s24: 0 819200 striped 2 128 94:21 32883072 94:17 32883072
space-s2: 0 819200 striped 2 128 94:21 14860672 94:17 14860672
space-r23: 0 819200 striped 2 128 94:21 31654272 94:17 31654272
space-r9: 0 819200 striped 2 128 94:21 20185472 94:17 20185472
space-s23: 0 819200 striped 2 128 94:21 32063872 94:17 32063872
space-s1: 0 819200 striped 2 128 94:21 14041472 94:17 14041472
space-r22: 0 819200 striped 2 128 94:21 30835072 94:17 30835072
space-space: 0 20971520 striped 2 128 94:21 384 94:17 384
space-root: 0 1048576 striped 2 128 94:21 36438400 94:17 36438400
space-r8: 0 819200 striped 2 128 94:21 19366272 94:17 19366272
space-s22: 0 819200 striped 2 128 94:21 31244672 94:17 31244672
space-r19: 0 819200 striped 2 128 94:21 28377472 94:17 28377472
space-r21: 0 819200 striped 2 128 94:21 30015872 94:17 30015872
space-s19: 0 819200 striped 2 128 94:21 28787072 94:17 28787072
space-r7: 0 819200 striped 2 128 94:21 18547072 94:17 18547072
space-s21: 0 819200 striped 2 128 94:21 30425472 94:17 30425472
space-r18: 0 819200 striped 2 128 94:21 27558272 94:17 27558272
space-r20: 0 819200 striped 2 128 94:21 29196672 94:17 29196672
space-s18: 0 819200 striped 2 128 94:21 27967872 94:17 27967872
space-r6: 0 819200 striped 2 128 94:21 17727872 94:17 17727872
space-ccache: 0 8388608 striped 2 128 94:13 384 94:21 42205568
space-s20: 0 819200 striped 2 128 94:21 29606272 94:17 29606272
space-r17: 0 819200 striped 2 128 94:21 26739072 94:17 26739072


PLease note that most of the LVs are fine, only test and home dont come up.
Maybe the following information is of some use:

[root@t63lp34 ~]# lvdisplay --maps /dev/mapper/space-home
  --- Logical volume ---
  LV Name                /dev/space/home
  VG Name                space
  LV UUID                zqzWBR-orl5-c4N0-XNcP-hqtr-e3qa-TCwNLe
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                5.00 GB
  Current LE             1280
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:51

  --- Segments ---
  Logical extent 0 to 1279:
    Type                striped
    Stripes             2
    Stripe size         64 KB
    Stripe 0:
      Physical volume   /dev/dasdf1
      Physical extents  4512 to 5151
    Stripe 1:
      Physical volume   /dev/dasde1
      Physical extents  4512 to 5151




> p.s. I'm out of the office for a few more days but when I'm back I can
> look to try to reproduce on dasd devices on s390 hardware (if we're
> unable to make progress with you sharing the above info).

Well, next week I am going to leave for my wedding and my honeymoon, so we have 
some kine of overlap here. I know that redhat has an s390, but I can also 
reproduce and test in the middle of august ;-)

Is it possible that the lvm tools created logical volumes in a wrong way, and 
the old kernel never detected a misaligment? (After all, the old code always 
passed 0 to  blk_stack_limits)

Christian












