Return-Path: <linux-kernel-owner+w=401wt.eu-S936569AbXHHTIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936569AbXHHTIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 15:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764672AbXHHTIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 15:08:34 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:17964 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764240AbXHHTIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 15:08:32 -0400
Message-ID: <46BA14A2.5030705@interia.pl>
Date: Wed, 08 Aug 2007 21:08:18 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: high system cpu load during intense disk i/o
References: <200708031903.10063.jimis@gmx.net> <200708071750.51019.jimis@gmx.net>
In-Reply-To: <200708071750.51019.jimis@gmx.net>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: 2f94eacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello again, 
Hi,
> I 'm now using libata on the same system described before (see attached 
> dmesg.txt). When writing to both disks I think the problem is now worse 
> (pata_oprof_bad.txt, pata_vmstat_bad.txt), even the oprofile script needed 
> half an hour to complete! For completion I also attach the same tests when I 
> write to only one disk (pata_vmstat_1disk.txt, pata_oprof_1disk.txt), whence 
> everything is normal. 
> 
> FWIW, libata did not give me any performance benefit, 20MB/s is again the peak 
> hdparm reports. 

This OProfile thing is extremly not usefull in this case. It says that Your 
system is using 25% CPU time for no-op loops, but it doesn't say why. Your 
system really isn't very busy. Look here:
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 2  2      0 225352   5604  91700    0    0 18112  1664 28145 6315 29 71  0  0
 2  2      0 225360   5604  91700    0    0 18496  1664 27992 6358 30 70  0  0
 1  2      0 225360   5604  91700    0    0 18432  1472 28511 6315 28 72  0  0
 1  2      0 225360   5604  91700    0    0 18240  1536 28031 6153 31 69  0  0
+ video 720x576 25fps yuv stream over PCI. And system is fully responsive. Of 
course programs which need disk access must wait a bit longer, but later are 
running fine.
I don't have disks so fast like Yours and I can't do destructive write test.
First disk:
1  1      0 241848   7312 100768    0    0 27712     0  927 1270 29 13  0 58
1  1      0 241052   7580 100896    0    0  4612  4676  519  702 34 12  0 54
Second disk:
0  1      0 237752   7268 100980    0    0  6464     0  468  583 37 10  0 53
0  1      0 241060   7532 100884    0    0  1728  1728  465  578 31  9  0 60
Both:
0  2      0 241592   7384 100776    0    0 33024     0  905 1415 33 16  0 51
1  2      0 240804   7528 100884    0    0  6848  6848  642  780 38 10  0 52
So sda + sdc = both.

Your single disk:
0  1      0 128804  19620  82484    0    0     0 21120  335  675  0  4  0 96
Both:
5  2      0 168480  10972  47152    0    0     0 16000  252  470 22 78  0  0
I would expect 2*21k, but we have only 2*8k and it is lower then single disk 
case. Of course this math isn't moving us forward. Only thing which would 
help would be function call trace as Andrew wrote. Which function is calling 
delay_tsc()? Is it calling it often or once but with long delay?
So far it looks like some kind of hardware limit for me. Do You have any 
options in BIOS which can degrade PCI or disk performance?
> 
> Thanks, 
> Dimitris
Rafa³


----------------------------------------------------------------------
Wszystko czego potrzebujesz latem: kremy do opalania, 
stroje kapielowe, maly romans 

>>>http://link.interia.pl/f1b15

