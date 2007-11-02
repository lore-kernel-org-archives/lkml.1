Return-Path: <linux-kernel-owner+w=401wt.eu-S1759204AbXKBTWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbXKBTWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 15:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbXKBTWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 15:22:14 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:25158 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbXKBTWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 15:22:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qvtbnjofknU25vVX5JpRc9C97x6+90R1J9F0zFKUli8uGhGRKNHhCeuS/7/jk7la21ZUULUZb6d8wgiA36Cnl+R/Z5FcXUVHPFvQDADg2g11fkRY/NPR72CcuFj/biGZd6LnXKKRNGamazJVnpClE1syuy+Dx68Parjtlogduqo=
Message-ID: <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com>
Date: Fri, 2 Nov 2007 20:22:10 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: writeout stalls in current -git
Cc: "Fengguang Wu" <wfg@mail.ustc.edu.cn>,
       "Maxim Levitsky" <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Chinner" <dgc@sgi.com>, linux-fsdevel@vger.kernel.org
In-Reply-To: <1193998532.27652.343.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710220822.52370.maximlevitsky@gmail.com>
	 <200710221505.35397.maximlevitsky@gmail.com>
	 <20071022131045.GA5357@mail.ustc.edu.cn> <393060478.03650@ustc.edu.cn>
	 <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com>
	 <393903856.06449@ustc.edu.cn>
	 <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com>
	 <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com>
	 <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/07, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2007-11-02 at 10:21 +0800, Fengguang Wu wrote:
>
> > Interestingly, no background_writeout() appears, but only
> > balance_dirty_pages() and wb_kupdate.  Obviously wb_kupdate won't
> > block the process.
>
> Yeah, the background threshold is not (yet) scaled. So it can happen
> that the bdi_dirty limit is below the background limit.

I still have not seen a trigger of the "throttle_vm_writeout".
This time installing 2.6.24-rc1 again it not even triggerd any other
debugs apart from the one in wb_kupdate.
But 300Mb of new files might still not trigger this with 4Gb of RAM.

I'm currently testing 2.6.23-mm1 with this patch and the second
writeback-debug patch.

> I'm curious though as to these stalls, though, I can't seem to think of
> what goes wrong.. esp since most writeback seems to happen from pdflush.

I also don't know. But looking at the time the system takes to write
out 8kb, I'm starting to suspect that something is writing this out,
but not marking it clean... (Or redirtying it immediately?)

> (or I'm totally misreading it - quite a possible as I'm still recovering
> from a serious cold and not all the green stuff has yet figured out its
> proper place wrt brain cells 'n stuff)

Get well soon!

> I still have this patch floating around:
>
> ---
> Subject: mm: speed up writeback ramp-up on clean systems

applied, but did not fix the stalls.

Here the complete log from vmstat 10 and the syslog from an install of
vanilla 2.6.24-rc1.
(Please note: I installed the source of vanilla 2.6.24-rc1, but I am
still using 2.6.23-mm1!)
All lines with [note] are my comments about what the system was doing,
both logs are from the same run, so the notes should be more or less
in sync. I used SysRq+L to insert the SysRq-Helptext into the syslog
as marker...

The visible effects are similar to the unmerge run, but the stalls
during the moving did only start later. But the same effect after
emerge finished and the almost all dirty data was written, was
visible: I can still hear the disks and see the hdd light flickering
(mostly on) for much, much longer than it should take to write 8kb.

vmstat 10:
[note]emerge start
 1  0      0 3668496    332 187748    0    0     0    29   39  491  3  0 96  0
 1  0      0 3623940    332 188880    0    0    83    17 1724 3893 15  2 81  1
 0  0      0 3559488    332 252432    0    0  1021    48 11719 4536  9  4 74 13
 2  0      0 3482220    332 311916    0    0    70    60   93 3818 11  3 86  0
 1  0      0 3289352    332 486932    0    0     2    35   33 11997 25  3 72  0
 1  0      0 3174036    332 596412    0    0    10    33   35 3937 21  4 75  0
 2  0      0 3215756    332 555292    0    0     6    28   85  742 12 12 76  0
 2  0      0 3202128    332 559792    0    0    32     9   34 1566 31  1 68  0
 2  0      0 3192804    332 568072    0    0    60    46  172 4206 30  2 67  1
 3  0      0 3202424    332 572620    0    0     0    20  111 2223 27  1 72  0
 1  0      0 3196112    332 578900    0    0     0  1649  149 2763 25  2 73  0
 1  0      0 3190004    332 584956    0    0     0    17  110 2270 25  1 74  0
 1  0      0 3183952    332 590840    0    0     0    11  104 2553 25  1 74  0
 1  0      0 3176952    332 597068    0    0     0  2153  124 2886 25  2 72  0
 1  0      0 3171044    332 602592    0    0     0    22  109 2580 26  1 73  0
 1  0      0 3174896    332 605496    0    0   173  1441  312 2249  9  6 84  1
 1  0      0 3165204    332 611856    0    0   569  3221  606 4236  4  7 87  1
 0  0      0 3160856    332 613516    0    0   116  2281  570 3077  3  5 92  0
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 3154712    332 615200    0    0   108  2166  528 3038  3  4 93  0
 0  0      0 3156008    332 615420    0    0    18  1941  537 1015  0  2 97  0
 0  0      0 3156652    332 615504    0    0     8  2232  547  900  0  2 98  0
 0  0      0 3156748    332 615672    0    0    12  1932  537  947  0  2 98  0
 0  0      0 3154720    332 615900    0    0    14  2204  584 1256  1  2 97  0
 0  0      0 3154256    332 616060    0    0    10  2676  610 1317  1  3 96  0
 1  0      0 3152488    332 616284    0    0     9  1994  573 1024  1  2 97  0
 0  0      0 3152404    332 616408    0    0     4  2218  540  904  0  2 97  0
 0  0      0 3151244    332 617156    0    0    44  2198  598 1921  2  4 94  0
 0  0      0 3147224    332 618672    0    0   110  1802  644 2575  3  4 93  0
 0  0      0 3144608    332 619824    0    0    80  1590  543 1900  2  4 95  0
 0  0      0 3140768    332 621448    0    0   111  1758  657 2735  3  4 93  0
 0  0      0 3140816    332 621896    0    0    26   801  531 1667  1  2 98  0
[note] first stall, SysRq+W
 1  0      0 3127620    332 621896    0    0     0   640  490 1381  2  1 97  0
 0  0      0 3127780    332 621900    0    0     0   627  475 1531  2  1 98  0
 0  0      0 3127560    332 621900    0    0     0   587  464 1428  0  0 99  0
 1  0      0 3126272    332 622460    0    0    32   945  556 1922  1  2 97  0
[note] installing resumes
 0  0      0 3120860    332 624048    0    0    94  1950  785 2582  4  5 91  0
 0  0      0 3117392    332 625200    0    0    76  1258  742 2217  2  3 95  0
[note] second stall
 0  0      0 3118192    332 625200    0    0     0   617  559 1617  0  1 99  0
 0  0      0 3118836    332 625200    0    0     0   603  550 1576  5  1 94  0
 0  0      0 3118728    332 625200    0    0     0   682  601 1454  0  0 99  0
 0  0      0 3118860    332 625200    0    0     0   653  557 1382  0  1 99  0
[note] installing resumes
 1  0      0 3111356    332 624576    0    0    91  1277  789 2086 11  4 84  1
 0  0      0 3149768    332 627792    0    0   322   504  655 1444  1  2 96  1
 0  0      0 3150064    332 627792    0    0     0   559  623 1340  0  0 99  0
[note] emerge is finished, ~200Mb dirty data
 0  0      0 3150220    332 627792    0    0     0   622  553 1553  2  1 97  0
 0  0      0 3150456    332 627792    0    0     0   518  595 1315  0  1 99  0
 0  0      0 3149380    332 627792    0    0     0  3759  801 1277  0  3 97  0
 0  0      0 3148664    332 627840    0    0     0  3925  873 1500  0  4 96  0
 0  0      0 3149672    332 627868    0    0     0  2476  800 1355  0  3 97  0
 0  0      0 3148012    332 627872    0    0     0  2865  806 1235  0  3 97  0
 0  0      0 3150496    332 627936    0    0     0  3074  847 1288  0  3 97  0
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 3149568    332 627968    0    0     0  2238  751 1070  0  2 97  0
 0  0      0 3150260    332 627988    0    0     0   872  607 1073  0  1 99  0
 0  0      0 3150228    332 627988    0    0     0  1711  715 1214  0  2 98  0
 0  0      0 3149300    332 627988    0    0     0  2195  752 1042  0  2 98  0
 1  0      0 3150036    332 628032    0    0     0  2192  759 1118  0  2 97  0
 0  0      0 3150868    332 628032    0    0     0  1035  639 1138  0  1 99  0
 0  0      0 3150876    332 628068    0    0     0  1437  740 1153  0  1 98  0
 0  0      0 3151152    332 628068    0    0     0   446  545 1381  0  0 100  0
 0  0      0 3151212    332 628068    0    0     0   461  551 1412  2  0 98  0
[note] normal writeout finishes ~116kb dirty data left
 1  0      0 3151088    332 628068    0    0     0   472  552 1468  0  0 99  0
 0  0      0 3151260    332 628068    0    0     0   462  533 1369  0  0 100  0
 0  0      0 3151296    332 628068    0    0     0   464  559 1325  0  0 100  0
 0  0      0 3150992    332 628068    0    0     0   485  533 1350  0  0 100  0
 0  0      0 3151092    332 628068    0    0     0   492  543 1378  0  0 100  0
[note] hit SysRq+W and SysRw+M
 0  0      0 3150828    332 628076    0    0     0   430  541 1449  9  1 90  0
 0  0      0 3150932    332 628076    0    0     0   459  535 1401  0  0 100  0
 0  0      0 3151068    332 628076    0    0     0   465  536 1471  0  0 99  0
 0  0      0 3151164    332 628076    0    0     0   453  525 1349  0  0 100  0
 0  0      0 3151208    332 628076    0    0     0   474  530 1354  0  0 100  0
 1  0      0 3151036    332 628076    0    0     0   449  506 1348  0  0 100  0
 0  0      0 3151148    332 628076    0    0     0   476  520 1314  0  0 100  0
 0  0      0 3151080    332 628076    0    0     0   467  521 1373  0  0 100  0
 0  0      0 3151096    332 628076    0    0     0   464  521 1324  0  0 100  0
 0  0      0 3151220    332 628076    0    0     0   461  548 1360  0  0 100  0
 0  0      0 3151144    332 628076    0    0     0   417  480 1329  0  0 100  0
 0  0      0 3150892    332 628076    0    0     0   492  543 1363  0  0 99  0
 0  0      0 3151048    332 628076    0    0     0   436  515 1298  0  0 100  0
 0  0      0 3151076    332 628076    0    0     0   434  513 1402  0  0 100  0
 0  0      0 3151296    332 628076    0    0     0   430  508 1367  0  0 100  0
 0  0      0 3150940    332 628076    0    0     0   472  527 1331  0  0 100  0
 0  0      0 3151016    332 628076    0    0     0   472  527 1315  0  0 100  0
 0  0      0 3151024    332 628076    0    0     0   227  409  703  0  0 100  0
 0  0      0 3151272    332 628080    0    0     0    11  315  262  2  0 98  0
[note] writeout really finishes, disks go idle.

from syslog:
[note] emerge started, this unpacks the kernel into a tmpfs, patches
it to rc1, packs it into a tar.bz2 and then moves the files from the
tmpfs to my main xfs root fs
[  322.230000] SysRq : HELP : loglevel0-8 reBoot tErm Full kIll saK
showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks
Unmount shoW-blocked-tasks
[  323.120000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 20090
global 25 0 0 wc __ tw 1024 sk 0
[  328.230000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 20091
global 26 0 0 wc __ tw 1024 sk 0
[  333.290000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 20131
global 29 0 0 wc _M tw 1023 sk 0
[  333.360000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 20130
global 29 0 0 wc _M tw 1023 sk 0
[  333.390000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 20129
global 29 0 0 wc __ tw 1023 sk 0
[  338.300000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 20131
global 28 0 0 wc __ tw 1024 sk 0
[  343.360000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 20196
global 1 28 0 wc __ tw 1000 sk 0
[  348.330000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 20188
global 4 0 0 wc __ tw 1024 sk 0
[  353.380000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 27417
global 4 0 0 wc __ tw 1024 sk 0
[  358.380000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 31801
global 4 0 0 wc __ tw 1024 sk 0
[  363.380000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 40783
global 4 0 0 wc __ tw 1021 sk 0
[  368.460000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 44080
global 1 0 0 wc __ tw 1023 sk 0
[  373.460000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 44085
global 1 0 0 wc __ tw 1024 sk 0
[  378.460000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 44631
global 1 0 0 wc __ tw 1024 sk 0
[  383.510000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 44709
global 1 0 0 wc __ tw 1024 sk 0
[note] around here the creation of the tar.bz2 started
[  388.520000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 45134
global 426 0 0 wc __ tw 1024 sk 0
[  393.530000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 45884
global 1148 0 0 wc __ tw 1024 sk 0
[  398.530000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 47002
global 2262 0 0 wc __ tw 1023 sk 0
[  403.570000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 47619
global 2888 0 0 wc __ tw 1024 sk 0
[  408.570000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 48276
global 3545 0 0 wc __ tw 1024 sk 0
[  413.570000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 48740
global 2997 1012 0 wc _M tw -1 sk 0
[  413.570000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 47715
global 2997 1012 0 wc _M tw 1024 sk 0
[  413.580000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 47715
global 1985 2024 0 wc _M tw -1 sk 0
[  413.590000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46690
global 973 3036 0 wc _M tw -1 sk 0
[  413.590000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 45665
global 7 4002 0 wc __ tw 64 sk 0
[  418.630000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 45595
global 864 0 0 wc __ tw 1024 sk 0
[  423.630000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46294
global 1563 0 0 wc __ tw 1024 sk 0
[  428.630000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 47036
global 2305 0 0 wc __ tw 1023 sk 0
[  433.630000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 47731
global 3000 0 0 wc __ tw 1024 sk 0
[  438.630000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 48525
global 3794 0 0 wc __ tw 1024 sk 0
[  443.630000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 49159
global 4428 0 0 wc __ tw 1024 sk 0
[note] around here the moving from the tmpfs to the xfs started
[  448.630000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 50047
global 4304 1012 0 wc _M tw -1 sk 0
[  448.640000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 49022
global 3292 2024 0 wc _M tw -1 sk 0
[  448.650000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 47997
global 2234 3082 0 wc _M tw -1 sk 0
[  448.650000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46972
global 1222 4094 0 wc _M tw -1 sk 0
[  448.660000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 45947
global 210 5106 0 wc _M tw -1 sk 0
[  448.660000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 44922
global 0 5336 0 wc __ tw 812 sk 0
[  453.700000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 45385
global 654 0 0 wc __ tw 1024 sk 0
[  458.700000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 45881
global 1150 0 0 wc _M tw 1023 sk 0
[  458.790000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 45880
global 1196 0 0 wc _M tw 1023 sk 0
[  458.810000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 45879
global 1196 0 0 wc __ tw 1023 sk 0
[  463.840000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 44729
global 0 0 0 wc __ tw 1024 sk 0
[  468.860000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 45653
global 869 0 0 wc __ tw 1024 sk 0
[  473.880000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 51262
global 6380 0 0 wc __ tw 1024 sk 0
[  478.920000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 56488
global 11523 0 0 wc __ tw 1024 sk 0
[  485.260000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 58839
global 13842 0 0 wc __ tw 1024 sk 0
[  490.260000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 60796
global 15746 0 0 wc __ tw 1023 sk 0
[  495.270000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 64003
global 18907 0 0 wc __ tw 1023 sk 0
[  502.330000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 67524
global 21467 336 0 wc _M tw -5 sk 0
[  505.350000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 66495
global 20615 51 0 wc _M tw 0 sk 0
[  508.140000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 65471
global 19727 213 0 wc _M tw -1 sk 0
[  508.550000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 64446
global 19483 336 0 wc _M tw 760 sk 0
[  509.180000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 64182
global 19470 94 0 wc __ tw 1012 sk 0
[  514.190000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 65780
global 19665 172 0 wc __ tw -1 sk 0
[  517.310000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 64755
global 18827 14 0 wc __ tw -1 sk 0
[  520.100000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 63730
global 17929 96 0 wc _M tw -13 sk 0
[  522.560000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 62693
global 16937 167 0 wc _M tw -1 sk 0
[  527.050000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 61668
global 16021 95 0 wc _M tw -6 sk 0
[  530.460000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 60638
global 15115 52 0 wc _M tw -1 sk 0
[  534.470000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 59613
global 14222 27 0 wc _M tw -4 sk 0
[  537.760000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 58585
global 13386 54 0 wc _M tw 0 sk 0
[  541.050000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 57561
global 12737 58 0 wc _M tw 281 sk 0
[  541.090000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 56818
global 12737 58 0 wc __ tw 1022 sk 0
[  547.200000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 58858
global 12829 72 0 wc __ tw 0 sk 0
[  550.480000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 57834
global 12017 62 0 wc __ tw 0 sk 0
[  552.710000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 56810
global 11133 83 0 wc __ tw 0 sk 0
[  558.660000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 55786
global 10470 33 0 wc _M tw 0 sk 0
[  562.750000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 54762
global 10555 69 0 wc _M tw 0 sk 0
[  565.150000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 53738
global 9562 498 0 wc _M tw -2 sk 0
[  569.490000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 52712
global 8960 2 0 wc _M tw 0 sk 0
[  572.910000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 51688
global 8088 205 0 wc _M tw -13 sk 0
[  574.610000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 50651
global 7114 188 0 wc _M tw -1 sk 0
[  584.270000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 49626
global 14544 0 0 wc _M tw -1 sk 0
[  593.050000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 48601
global 24583 736 0 wc _M tw -1 sk 0
[  600.180000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 47576
global 27004 6 0 wc _M tw 587 sk 0
[  600.180000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 47139
global 27004 6 0 wc __ tw 1014 sk 0
[note] first stall, the output from emerge stops, so it seems it can
not start processing the next file until the stall ends
[  630.000000] SysRq : Emergency Sync
[  630.120000] Emergency Sync complete
[  632.850000] SysRq : Show Blocked State
[  632.850000]   task                        PC stack   pid father
[  632.850000] pdflush       D ffff81000f091788     0   285      2
[  632.850000]  ffff810005d4da80 0000000000000046 0000000000000800
0000007000000001
[  632.850000]  ffff81000fd52400 ffffffff8022d61c ffffffff80819b00
ffffffff80819b00
[  632.850000]  ffffffff80815f40 ffffffff80819b00 ffff810100316f98
0000000000000000
[  632.850000] Call Trace:
[  632.850000]  [<ffffffff8022d61c>] task_rq_lock+0x4c/0x90
[  632.850000]  [<ffffffff8022c8ea>] __wake_up_common+0x5a/0x90
[  632.850000]  [<ffffffff805b16e7>] __down+0xa7/0x11e
[  632.850000]  [<ffffffff8022da70>] default_wake_function+0x0/0x10
[  632.850000]  [<ffffffff805b1365>] __down_failed+0x35/0x3a
[  632.850000]  [<ffffffff803752ce>] xfs_buf_lock+0x3e/0x40
[  632.850000]  [<ffffffff8037740e>] _xfs_buf_find+0x13e/0x240
[  632.850000]  [<ffffffff8037757f>] xfs_buf_get_flags+0x6f/0x190
[  632.850000]  [<ffffffff803776b2>] xfs_buf_read_flags+0x12/0xa0
[  632.850000]  [<ffffffff80368824>] xfs_trans_read_buf+0x64/0x340
[  632.850000]  [<ffffffff80352361>] xfs_itobp+0x81/0x1e0
[  632.850000]  [<ffffffff8026b293>] write_cache_pages+0x123/0x330
[  632.850000]  [<ffffffff80354d0e>] xfs_iflush+0xfe/0x520
[  632.850000]  [<ffffffff803ae5d2>] __down_read_trylock+0x42/0x60
[  632.850000]  [<ffffffff8036ed49>] xfs_inode_flush+0x179/0x1b0
[  632.850000]  [<ffffffff8037ca8f>] xfs_fs_write_inode+0x2f/0x90
[  632.850000]  [<ffffffff802b3aac>] __writeback_single_inode+0x2ac/0x380
[  632.850000]  [<ffffffff804d074e>] dm_table_any_congested+0x2e/0x80
[  632.850000]  [<ffffffff802b3f9d>] generic_sync_sb_inodes+0x20d/0x330
[  632.850000]  [<ffffffff802b4532>] writeback_inodes+0xa2/0xe0
[  632.850000]  [<ffffffff8026bfd6>] wb_kupdate+0xa6/0x140
[  632.850000]  [<ffffffff8026c4b0>] pdflush+0x0/0x1e0
[  632.850000]  [<ffffffff8026c5c0>] pdflush+0x110/0x1e0
[  632.850000]  [<ffffffff8026bf30>] wb_kupdate+0x0/0x140
[  632.850000]  [<ffffffff8024a32b>] kthread+0x4b/0x80
[  632.850000]  [<ffffffff8020c9d8>] child_rip+0xa/0x12
[  632.850000]  [<ffffffff8024a2e0>] kthread+0x0/0x80
[  632.850000]  [<ffffffff8020c9ce>] child_rip+0x0/0x12
[  632.850000]
[  632.850000] emerge        D 0000000000000000     0  6220   6129
[  632.850000]  ffff810103ced9f8 0000000000000086 0000000000000000
0000007000000001
[  632.850000]  ffff81000fd52cf8 ffffffff00000000 ffffffff80819b00
ffffffff80819b00
[  632.850000]  ffffffff80815f40 ffffffff80819b00 ffff810103ced9b8
ffff810103ced9a8
[  632.850000] Call Trace:
[  632.850000]  [<ffffffff805b16e7>] __down+0xa7/0x11e
[  632.850000]  [<ffffffff8022da70>] default_wake_function+0x0/0x10
[  632.850000]  [<ffffffff805b1365>] __down_failed+0x35/0x3a
[  632.850000]  [<ffffffff803752ce>] xfs_buf_lock+0x3e/0x40
[  632.850000]  [<ffffffff8037740e>] _xfs_buf_find+0x13e/0x240
[  632.850000]  [<ffffffff8037757f>] xfs_buf_get_flags+0x6f/0x190
[  632.850000]  [<ffffffff803776b2>] xfs_buf_read_flags+0x12/0xa0
[  632.850000]  [<ffffffff80368824>] xfs_trans_read_buf+0x64/0x340
[  632.850000]  [<ffffffff80352361>] xfs_itobp+0x81/0x1e0
[  632.850000]  [<ffffffff80375bee>] xfs_buf_rele+0x2e/0xd0
[  632.850000]  [<ffffffff80354d0e>] xfs_iflush+0xfe/0x520
[  632.850000]  [<ffffffff803ae5d2>] __down_read_trylock+0x42/0x60
[  632.850000]  [<ffffffff80355c82>] xfs_inode_item_push+0x12/0x20
[  632.850000]  [<ffffffff80368247>] xfs_trans_push_ail+0x267/0x2b0
[  632.850000]  [<ffffffff8035c742>] xfs_log_reserve+0x72/0x120
[  632.850000]  [<ffffffff80366bf8>] xfs_trans_reserve+0xa8/0x210
[  632.850000]  [<ffffffff803731f2>] kmem_zone_zalloc+0x32/0x50
[  632.850000]  [<ffffffff8035263b>] xfs_itruncate_finish+0xfb/0x310
[  632.850000]  [<ffffffff8036daeb>] xfs_free_eofblocks+0x23b/0x280
[  632.850000]  [<ffffffff80371f93>] xfs_release+0x153/0x200
[  632.850000]  [<ffffffff80378010>] xfs_file_release+0x10/0x20
[  632.850000]  [<ffffffff80294251>] __fput+0xb1/0x220
[  632.850000]  [<ffffffff802910a4>] filp_close+0x54/0x90
[  632.850000]  [<ffffffff802929bf>] sys_close+0x9f/0x100
[  632.850000]  [<ffffffff8020bbbe>] system_call+0x7e/0x83
[  632.850000]
[  662.180000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 73045
global 39157 0 0 wc __ tw 0 sk 0
[note] emerge resumed
[  664.030000] SysRq : HELP : loglevel0-8 reBoot tErm Full kIll saK
showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks
Unmount shoW-blocked-tasks
[  673.150000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 72021
global 44617 0 0 wc __ tw -3 sk 0
[note] emerge stalled again
[  693.930000] SysRq : HELP : loglevel0-8 reBoot tErm Full kIll saK
showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks
Unmount shoW-blocked-tasks
[  724.580000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 70994
global 48064 26 0 wc _M tw -5 sk 0
[note] emerge resumed again
[  724.710000] SysRq : HELP : loglevel0-8 reBoot tErm Full kIll saK
showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks
Unmount shoW-blocked-tasks
[  751.470000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 69965
global 47914 46 0 wc _M tw -1 sk 0
[note] emerge is finished, but 200Mb of dirty data remain
[  761.950000] SysRq : HELP : loglevel0-8 reBoot tErm Full kIll saK
showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks
Unmount shoW-blocked-tasks
[  775.520000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 68940
global 46911 414 0 wc _M tw 0 sk 0
[  776.280000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 67916
global 45859 724 0 wc _M tw -2 sk 0
[  777.370000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 66890
global 44834 325 0 wc _M tw -10 sk 0
[  778.450000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 65856
global 43828 242 0 wc _M tw -1 sk 0
[  779.020000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 64831
global 42807 484 0 wc _M tw -1 sk 0
[  780.440000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 63806
global 41768 47 0 wc _M tw -7 sk 0
[  781.560000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 62775
global 40730 445 0 wc _M tw 0 sk 0
[  783.000000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 61751
global 39705 322 0 wc _M tw -3 sk 0
[  785.140000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 60724
global 38732 310 0 wc _M tw -4 sk 0
[  786.390000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 59696
global 37673 406 0 wc _M tw -6 sk 0
[  787.310000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 58666
global 36636 495 0 wc _M tw -9 sk 0
[  787.720000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 57633
global 35578 955 0 wc _M tw -1 sk 0
[  789.100000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 56608
global 34592 139 0 wc _M tw 0 sk 0
[  790.400000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 55584
global 33567 25 0 wc _M tw -3 sk 0
[  791.780000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 54557
global 32491 305 0 wc _M tw -11 sk 0
[  793.790000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 53522
global 31499 506 0 wc _M tw -5 sk 0
[  796.680000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 52493
global 30462 184 0 wc _M tw -3 sk 0
[  798.930000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 51466
global 29411 340 0 wc _M tw -11 sk 0
[  800.330000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 50431
global 28377 69 0 wc _M tw -4 sk 0
[  803.900000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 49403
global 27388 24 0 wc _M tw -2 sk 0
[  805.600000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 48377
global 26330 142 0 wc _M tw -6 sk 0
[  807.740000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 47347
global 25295 138 0 wc _M tw -1 sk 0
[  809.680000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46322
global 24296 268 0 wc _M tw -2 sk 0
[  812.120000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 45296
global 23269 81 0 wc _M tw -5 sk 0
[  813.940000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 44267
global 22249 303 0 wc _M tw -1 sk 0
[  815.940000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 43242
global 21205 220 0 wc _M tw -9 sk 0
[  817.660000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 42209
global 20174 87 0 wc _M tw -7 sk 0
[  819.430000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 41178
global 19142 31 0 wc _M tw -5 sk 0
[  820.360000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 40149
global 18113 316 0 wc _M tw -7 sk 0
[  822.310000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 39118
global 17098 85 0 wc _M tw 0 sk 0
[  824.680000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 38094
global 16064 168 0 wc _M tw 0 sk 0
[  829.250000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 37070
global 15059 44 0 wc _M tw 0 sk 0
[  832.300000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 36046
global 14001 89 0 wc _M tw -2 sk 0
[  836.030000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 35020
global 13741 0 0 wc _M tw 760 sk 0
[  836.050000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 34756
global 13649 92 0 wc _M tw 922 sk 0
[  836.290000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 34654
global 13649 0 0 wc _M tw 1022 sk 0
[  836.720000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 34652
global 13650 0 0 wc __ tw 1023 sk 0
[  843.210000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 60278
global 12631 110 0 wc __ tw 0 sk 0
[  845.380000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 59254
global 11590 72 0 wc __ tw -1 sk 0
[  852.340000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 58229
global 10566 56 0 wc __ tw -1 sk 0
[  854.360000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 57204
global 9551 103 0 wc __ tw 0 sk 0
[  857.140000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 56180
global 8529 33 0 wc __ tw 0 sk 0
[  860.800000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 55156
global 7480 509 0 wc _M tw -9 sk 0
[  863.350000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 54123
global 6443 343 0 wc _M tw -10 sk 0
[  866.020000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 53089
global 5420 215 0 wc _M tw 0 sk 0
[  870.080000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 52065
global 4393 104 0 wc _M tw 0 sk 0
[  872.210000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 51041
global 3385 334 0 wc _M tw -5 sk 0
[  874.280000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 50012
global 2343 234 0 wc _M tw 0 sk 0
[  884.350000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 48988
global 1330 52 0 wc _M tw -4 sk 0
[  889.810000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 47960
global 294 122 0 wc _M tw 0 sk 0
[note] the system is down to 116kb dirty data, but still writing back heavyly
[  905.280000] SysRq : HELP : loglevel0-8 reBoot tErm Full kIll saK
showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks
Unmount shoW-blocked-tasks
[note] after a while in this state I hit SysRq+W and SysRq+M to
capture more state
[  967.770000] SysRq : Show Blocked State
[  967.770000]   task                        PC stack   pid father
[  967.770000] pdflush       D ffff810080043640     0   285      2
[  967.770000]  ffff810005d4da80 0000000000000046 ffff810005d4da48
0000007000000001
[  967.770000]  0000000000000400 0000000000000001 ffffffff80819b00
ffffffff80819b00
[  967.770000]  ffffffff80815f40 ffffffff80819b00 ffff810005d4da40
ffff810005d4da30
[  967.770000] Call Trace:
[  967.770000]  [<ffffffff805b16e7>] __down+0xa7/0x11e
[  967.770000]  [<ffffffff8022da70>] default_wake_function+0x0/0x10
[  967.770000]  [<ffffffff805b1365>] __down_failed+0x35/0x3a
[  967.770000]  [<ffffffff803752ce>] xfs_buf_lock+0x3e/0x40
[  967.770000]  [<ffffffff8037740e>] _xfs_buf_find+0x13e/0x240
[  967.770000]  [<ffffffff8037757f>] xfs_buf_get_flags+0x6f/0x190
[  967.770000]  [<ffffffff803776b2>] xfs_buf_read_flags+0x12/0xa0
[  967.770000]  [<ffffffff80368824>] xfs_trans_read_buf+0x64/0x340
[  967.770000]  [<ffffffff80352361>] xfs_itobp+0x81/0x1e0
[  967.770000]  [<ffffffff8026b293>] write_cache_pages+0x123/0x330
[  967.770000]  [<ffffffff80354d0e>] xfs_iflush+0xfe/0x520
[  967.770000]  [<ffffffff803ae5d2>] __down_read_trylock+0x42/0x60
[  967.770000]  [<ffffffff8036ed49>] xfs_inode_flush+0x179/0x1b0
[  967.770000]  [<ffffffff8037ca8f>] xfs_fs_write_inode+0x2f/0x90
[  967.770000]  [<ffffffff802b3aac>] __writeback_single_inode+0x2ac/0x380
[  967.770000]  [<ffffffff804d074e>] dm_table_any_congested+0x2e/0x80
[  967.770000]  [<ffffffff802b3f9d>] generic_sync_sb_inodes+0x20d/0x330
[  967.770000]  [<ffffffff802b4532>] writeback_inodes+0xa2/0xe0
[  967.770000]  [<ffffffff8026bfd6>] wb_kupdate+0xa6/0x140
[  967.770000]  [<ffffffff8026c4b0>] pdflush+0x0/0x1e0
[  967.770000]  [<ffffffff8026c5c0>] pdflush+0x110/0x1e0
[  967.770000]  [<ffffffff8026bf30>] wb_kupdate+0x0/0x140
[  967.770000]  [<ffffffff8024a32b>] kthread+0x4b/0x80
[  967.770000]  [<ffffffff8020c9d8>] child_rip+0xa/0x12
[  967.770000]  [<ffffffff8024a2e0>] kthread+0x0/0x80
[  967.770000]  [<ffffffff8020c9ce>] child_rip+0x0/0x12
[  967.770000]
[  968.640000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46936
global 30 0 0 wc _M tw 757 sk 0
[  968.670000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46669
global 2 28 0 wc __ tw 996 sk 0
[  970.520000] SysRq : Show Memory
[  970.530000] Mem-info:
[  970.530000] Node 0 DMA per-cpu:
[  970.530000] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:
   0, btch:   1 usd:   0
[  970.540000] CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:
   0, btch:   1 usd:   0
[  970.540000] CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:
   0, btch:   1 usd:   0
[  970.540000] CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:
   0, btch:   1 usd:   0
[  970.540000] Node 0 DMA32 per-cpu:
[  970.540000] CPU    0: Hot: hi:  186, btch:  31 usd:  66   Cold: hi:
  62, btch:  15 usd:  15
[  970.540000] CPU    1: Hot: hi:  186, btch:  31 usd: 159   Cold: hi:
  62, btch:  15 usd:  17
[  970.540000] CPU    2: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:
  62, btch:  15 usd:   0
[  970.540000] CPU    3: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:
  62, btch:  15 usd:   0
[  970.540000] Node 1 DMA32 per-cpu:
[  970.540000] CPU    0: Hot: hi:  186, btch:  31 usd:  28   Cold: hi:
  62, btch:  15 usd:   0
[  970.540000] CPU    1: Hot: hi:  186, btch:  31 usd:  47   Cold: hi:
  62, btch:  15 usd:   0
[  970.540000] CPU    2: Hot: hi:  186, btch:  31 usd: 155   Cold: hi:
  62, btch:  15 usd:  12
[  970.540000] CPU    3: Hot: hi:  186, btch:  31 usd: 183   Cold: hi:
  62, btch:  15 usd:   3
[  970.540000] Node 1 Normal per-cpu:
[  970.540000] CPU    0: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:
  62, btch:  15 usd:   0
[  970.540000] CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:
  62, btch:  15 usd:   0
[  970.540000] CPU    2: Hot: hi:  186, btch:  31 usd: 118   Cold: hi:
  62, btch:  15 usd:  19
[  970.540000] CPU    3: Hot: hi:  186, btch:  31 usd: 163   Cold: hi:
  62, btch:  15 usd:  13
[note] I do think, that /proc/meminfo also showed only 8kb of dirty
remaining at this point, but I'm not 200% sure...
[  970.540000] Active:70883 inactive:117017 dirty:2 writeback:0 unstable:0
[  970.540000]  free:787733 slab:25286 mapped:12000 pagetables:2237 bounce:0
[  970.540000] Node 0 DMA free:9448kB min:16kB low:20kB high:24kB
active:0kB inactive:0kB present:8868kB pages_scanned:0
all_unreclaimable? no
[  970.540000] lowmem_reserve[]: 0 2004 2004 2004
[  970.540000] Node 0 DMA32 free:1465640kB min:4040kB low:5048kB
high:6060kB active:132340kB inactive:310048kB present:2052320kB
pages_scanned:0 all_unreclaimable? no
[  970.540000] lowmem_reserve[]: 0 0 0 0
[  970.540000] Node 1 DMA32 free:1476216kB min:3040kB low:3800kB
high:4560kB active:3528kB inactive:41952kB present:1544000kB
pages_scanned:0 all_unreclaimable? no
[  970.540000] lowmem_reserve[]: 0 0 505 505
[  970.540000] Node 1 Normal free:199628kB min:1016kB low:1268kB
high:1524kB active:147664kB inactive:116068kB present:517120kB
pages_scanned:0 all_unreclaimable? no
[  970.540000] lowmem_reserve[]: 0 0 0 0
[  970.540000] Node 0 DMA: 6*4kB 6*8kB 4*16kB 5*32kB 3*64kB 2*128kB
4*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 9448kB
[  970.540000] Node 0 DMA32: 158*4kB 66*8kB 30*16kB 22*32kB 10*64kB
7*128kB 6*256kB 4*512kB 6*1024kB 5*2048kB 352*4096kB = 1465640kB
[  970.540000] Node 1 DMA32: 866*4kB 446*8kB 228*16kB 122*32kB 50*64kB
32*128kB 23*256kB 17*512kB 16*1024kB 11*2048kB 342*4096kB = 1476216kB
[  970.540000] Node 1 Normal: 511*4kB 618*8kB 471*16kB 325*32kB
185*64kB 92*128kB 72*256kB 55*512kB 38*1024kB 26*2048kB 3*4096kB =
199580kB
[  970.540000] Swap cache: add 0, delete 0, find 0/0, race 0+0
[  970.540000] Free swap  = 9775416kB
[  970.540000] Total swap = 9775416kB
[  970.540000] Free swap:       9775416kB
[  970.570000] 1048576 pages of RAM
[  970.570000] 35174 reserved pages
[  970.570000] 149150 pages shared
[  970.570000] 0 pages swap cached
[ 1137.110000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46642
global 1 0 0 wc _M tw 1022 sk 0
[ 1137.110000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46640
global 1 0 0 wc __ tw 1022 sk 0
[ 1138.110000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46640
global 1 0 0 wc __ tw 1024 sk 0
[ 1143.110000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46640
global 1 0 0 wc __ tw 1024 sk 0
[ 1148.110000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46640
global 1 0 0 wc __ tw 1024 sk 0
[note] finally the disks go idle
[ 1149.020000] SysRq : HELP : loglevel0-8 reBoot tErm Full kIll saK
showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks
Unmount shoW-blocked-tasks
[ 1153.110000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46641
global 2 0 0 wc __ tw 1024 sk 0
[ 1158.110000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46641
global 2 0 0 wc __ tw 1024 sk 0
[ 1163.110000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46641
global 2 0 0 wc __ tw 1024 sk 0
[ 1168.110000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46641
global 2 0 0 wc _M tw 1023 sk 0
[ 1168.160000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46640
global 2 0 0 wc _M tw 1023 sk 0
[ 1168.180000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46639
global 2 0 0 wc __ tw 1023 sk 0
[ 1173.110000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46640
global 1 0 0 wc __ tw 1024 sk 0
[ 1178.110000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46640
global 1 0 0 wc __ tw 1024 sk 0
[ 1183.110000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 46640
global 1 0 0 wc __ tw 1024 sk 0

Torsten
