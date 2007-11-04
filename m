Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbXKDLTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbXKDLTc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 06:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbXKDLTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 06:19:23 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:40482 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbXKDLTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 06:19:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=BpWxF4kZt/GKotSn5NDhf1si6zuKIbTtlVRxenmCytnfcbkc6qTnpQsbJ441z90lqX/O5kgv671cKUG5JKECJOPEA0BEmGz/eOPnJKGtGkSvb4CGwjrkNlQ0fPSFeDPRJ+I72+0JaTCS1PtW6lvl3GjsJFBpF2P56ExPJLD6m00=
Message-ID: <64bb37e0711040319l5de285c3xea64474540a51b6e@mail.gmail.com>
Date: Sun, 4 Nov 2007 12:19:19 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "David Chinner" <dgc@sgi.com>
Subject: Re: writeout stalls in current -git
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Fengguang Wu" <wfg@mail.ustc.edu.cn>,
       "Maxim Levitsky" <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
In-Reply-To: <20071102204258.GR995458@sgi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_16409_14543774.1194175159246"
References: <200710221505.35397.maximlevitsky@gmail.com>
	 <393060478.03650@ustc.edu.cn>
	 <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com>
	 <393903856.06449@ustc.edu.cn>
	 <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com>
	 <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com>
	 <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins>
	 <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com>
	 <20071102204258.GR995458@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_16409_14543774.1194175159246
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 11/2/07, David Chinner <dgc@sgi.com> wrote:
> That's stalled waiting on the inode cluster buffer lock. That implies
> that the inode lcuser is already being written out and the inode has
> been redirtied during writeout.
>
> Does the kernel you are testing have the "flush inodes in ascending
> inode number order" patches applied? If so, can you remove that
> patch and see if the problem goes away?

I can now confirm, that I see this also with the current mainline-git-version
I used 2.6.24-rc1-git-b4f555081fdd27d13e6ff39d455d5aefae9d2c0c
plus the fix for the sg changes in ieee1394.
Bisecting would be troublesome, as the sg changes prevent mainline to
boot with my normal config / kill my network.

treogen ~ # vmstat 10
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
-> starting emerge
 1  0      0 3627072    332 157724    0    0    97    13   41  189  2  2 94  2
 0  0      0 3607240    332 163736    0    0   599    10  332  951  2  1 93  4
 0  0      0 3601920    332 167592    0    0   380     2  218  870  1  1 98  0
 0  0      0 3596356    332 171648    0    0   404    21  182  818  0  0 99  0
 0  0      0 3579328    332 180436    0    0   878    12  147  912  1  1 97  2
 0  0      0 3575376    332 182776    0    0   236     4  244  953  1  1 95  3
 2  1      0 3571792    332 185084    0    0   232     7  256 1003  2  1 95  2
 0  0      0 3564844    332 187364    0    0   228   605  246 1167  2  1 93  4
 0  0      0 3562128    332 189784    0    0   230     4  527 1238  2  1 93  4
 0  1      0 3558764    332 191964    0    0   216    24  438 1059  1  1 93  6
 0  0      0 3555120    332 193868    0    0   199    36  406  959  0  0 92  8
 0  0      0 3552008    332 195928    0    0   197    11  458 1023  1  1 90  8
 0  0      0 3548728    332 197660    0    0   183     7  496 1086  1  1 90  8
 0  0      0 3545560    332 199372    0    0   170     8  483 1017  1  1 90  9
 0  1      0 3542124    332 201256    0    0   190     1  544 1137  1  1 88 10
 1  0      0 3536924    332 203296    0    0   195     7  637 1209  2  1 89  8
 1  1      0 3485096    332 249184    0    0   101    16 10372 4537 13  3 76  8
 2  0      0 3442004    332 279728    0    0  1086    40  219 1349  7  3 87  4
-> emerge is done reading its package database
 1  0      0 3254796    332 448636    0    0     0    27  128 8360 24  6 70  0
 2  0      0 3143304    332 554016    0    0    47    33  213 4480 16 11 72  1
-> kernel unpacked
 1  0      0 3125700    332 560416    0    0     1    20  122 1675 24  1 75  0
 1  0      0 3117356    332 567968    0    0     0   674  157 2975 24  2 73  1
 2  0      0 3111636    332 573736    0    0     0  1143  151 1924 23  1 75  1
 2  0      0 3102836    332 581332    0    0     0   890  153 1330 24  1 75  0
 1  0      0 3097236    332 587360    0    0     0   656  194 1593 24  1 74  0
 1  0      0 3086824    332 595480    0    0     0   812  235 2657 25  1 74  0
-> tar.bz2 created, installing starts now
 0  0      0 3091612    332 601024    0    0    82   708  499 2397 17  4 78  1
 0  0      0 3086088    332 602180    0    0    69  2459  769 2237  3  4 88  6
 0  0      0 3085916    332 602236    0    0     2  1752  693  949  1  2 96  1
 0  0      0 3084544    332 603564    0    0    66  4057 1176 2850  3  6 91  0
 0  0      0 3078780    332 605572    0    0    98  3194 1169 3288  5  6 89  0
 0  0      0 3077940    332 605924    0    0    17  1139  823 1547  1  2 97  0
 0  0      0 3078268    332 605924    0    0     0   888  807 1329  0  1 99  0
-> first short stall
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 3077040    332 605924    0    0     0  1950  785 1495  0  2 89  8
 0  0      0 3076588    332 605896    0    0     2  3807  925 2046  1  4 95  0
 0  0      0 3076900    332 606052    0    0    11  2564  768 1471  1  3 95  1
 0  0      0 3071584    332 607928    0    0    87  2499 1108 3433  4  6 90  0
-> second longer stall
(emerge was not able to complete a single filemove until the 'resume' line)
 0  0      0 3071592    332 607928    0    0     0   693  692 1289  0  0 99  0
 0  0      0 3072584    332 607928    0    0     0   792  731 1507  0  1 99  0
 0  0      0 3072840    332 607928    0    0     0   806  707 1521  0  1 99  0
 0  0      0 3072724    332 607928    0    0     0   782  695 1372  0  0 99  0
 0  0      0 3072972    332 607928    0    0     0   677  612 1301  0  0 99  0
 0  0      0 3072772    332 607928    0    0     0   738  681 1352  1  1 99  0
 0  0      0 3073020    332 607928    0    0     0   785  708 1328  0  1 99  0
 0  0      0 3072896    332 607928    0    0     0   833  722 1383  0  0 99  0
-> emerge resumed
 0  0      0 3069476    332 607972    0    0     2  4885  812 2062  1  4 90  5
 1  0      0 3069648    332 608068    0    0     4  4658  833 2158  1  4 93  2
 0  0      0 3064972    332 610364    0    0   106  2494 1095 3620  5  7 88  0
 0  0      0 3057536    332 612444    0    0    86  2023 1012 3440  4  6 90  0
 1  0      0 3054572    332 612368    0    0   102  1526 1024 2277  6  5 87  2
-> emerge finished, but still >100Mb of dirty data accoring to /proc/meminfo
 0  0      0 3048548    332 615764    0    0   337   659  796 1000  3  1 96  0
 0  0      0 3092100    332 615860    0    0    15   616  606 1040  1  0 99  0
 0  0      0 3092148    332 615860    0    0     0   641  622 1085  0  0 99  0
 0  0      0 3092528    332 615860    0    0     0   766  654 1055  1  1 99  0
-> slow writeout until here, might be fixed with Peters patch to scale
the background threshold
 2  0      0 3090828    332 615860    0    0     0  1804  707 1215  0  2 98  0
 0  0      0 3091056    332 615864    0    0     0  3877  831 2047  1  4 94  1
 3  0      0 3090780    332 615864    0    0     0  2048  784 1154  1  2 97  1
 0  0      0 3091096    332 615864    0    0     0  2690  751 1538  0  3 96  1
 0  1      0 3091056    332 615864    0    0     0  2018  748  866  0  2 95  2
 2  0      0 3092960    332 615864    0    0     0  2076  719 1118  0  2 97  0
-> writeout "done", /proc/meminfo showed 0kb of dirty data remaining
 0  0      0 3093072    332 615864    0    0     0   645  646 1104  0  0 99  0
 0  0      0 3093532    332 615864    0    0     0   726  658 1223  0  1 99  0
 0  0      0 3093540    332 615864    0    0     0   801  699 1314  0  1 99  0
 0  0      0 3093580    332 615864    0    0     0   783  738 1350  0  1 99  0
 0  0      0 3093284    332 615920    0    0     6   746  655 1381  1  1 98  0
 0  0      0 3092872    332 615920    0    0     0   862  703 1391  1  1 98  0
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 3093224    332 615920    0    0     0   799  676 1394  0  0 99  0
 0  0      0 3093304    332 615920    0    0     0   835  672 1514  1  1 98  0
 0  0      0 3093476    332 615920    0    0     0   784  641 1404  1  1 98  0
 0  0      0 3093264    332 615920    0    0     0   722  626 1483  1  1 99  0
 0  0      0 3093476    332 615920    0    0     0     7  328  350  0  0 99  0
 0  0      0 3093628    332 615920    0    0     0    11  332  407  0  0 99  0
-> disks finally go idle

Torsten

.config for 2.6.24-rc1+git attached

------=_Part_16409_14543774.1194175159246
Content-Type: application/x-gzip; name=config.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f8lgztwk
Content-Disposition: attachment; filename=config.gz

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
------=_Part_16409_14543774.1194175159246--
