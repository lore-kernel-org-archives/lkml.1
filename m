Return-Path: <linux-kernel-owner+w=401wt.eu-S934316AbXHIIVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316AbXHIIVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 04:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933520AbXHIIVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 04:21:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:40585 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S936744AbXHIIVH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 04:21:07 -0400
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX1/gsWBNxBngJUHpXnb7clGYZq3uPGPOqVGi2BGJ/B
	RrvPSxf2IRRXa2
From: Dimitrios Apostolou <jimis@gmx.net>
To: =?iso-8859-2?q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
Subject: Re: high system cpu load during intense disk i/o
Date: Thu, 9 Aug 2007 11:17:50 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200708031903.10063.jimis@gmx.net> <200708071750.51019.jimis@gmx.net> <46BA14A2.5030705@interia.pl>
In-Reply-To: <46BA14A2.5030705@interia.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708091117.51687.jimis@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafal, thank you for your help! 

On Wednesday 08 August 2007 22:08:18 Rafa³ Bilski wrote:
> > Hello again,
>
> Hi,
>
> > I 'm now using libata on the same system described before (see attached
> > dmesg.txt). When writing to both disks I think the problem is now worse
> > (pata_oprof_bad.txt, pata_vmstat_bad.txt), even the oprofile script
> > needed half an hour to complete! For completion I also attach the same
> > tests when I write to only one disk (pata_vmstat_1disk.txt,
> > pata_oprof_1disk.txt), whence everything is normal.
> >
> > FWIW, libata did not give me any performance benefit, 20MB/s is again the
> > peak hdparm reports.
>
> This OProfile thing is extremly not usefull in this case. It says that Your
> system is using 25% CPU time for no-op loops, but it doesn't say why. Your
> system really isn't very busy. Look here:
> procs -----------memory---------- ---swap-- -----io---- -system--
> ----cpu---- r  b   swpd   free   buff  cache   si   so    bi    bo   in  
> cs us sy id wa 2  2      0 225352   5604  91700    0    0 18112  1664 28145
> 6315 29 71  0  0 2  2      0 225360   5604  91700    0    0 18496  1664
> 27992 6358 30 70  0  0 1  2      0 225360   5604  91700    0    0 18432 
> 1472 28511 6315 28 72  0  0 1  2      0 225360   5604  91700    0    0
> 18240  1536 28031 6153 31 69  0  0 + video 720x576 25fps yuv stream over
> PCI. And system is fully responsive. Of course programs which need disk
> access must wait a bit longer, but later are running fine.
> I don't have disks so fast like Yours and I can't do destructive write
> test. First disk:
> 1  1      0 241848   7312 100768    0    0 27712     0  927 1270 29 13  0
> 58 1  1      0 241052   7580 100896    0    0  4612  4676  519  702 34 12 
> 0 54 Second disk:
> 0  1      0 237752   7268 100980    0    0  6464     0  468  583 37 10  0
> 53 0  1      0 241060   7532 100884    0    0  1728  1728  465  578 31  9 
> 0 60 Both:
> 0  2      0 241592   7384 100776    0    0 33024     0  905 1415 33 16  0
> 51 1  2      0 240804   7528 100884    0    0  6848  6848  642  780 38 10 
> 0 52 So sda + sdc = both.
>
> Your single disk:
> 0  1      0 128804  19620  82484    0    0     0 21120  335  675  0  4  0
> 96 Both:
> 5  2      0 168480  10972  47152    0    0     0 16000  252  470 22 78  0 
> 0 I would expect 2*21k, but we have only 2*8k and it is lower then single
> disk case. Of course this math isn't moving us forward. Only thing which
> would help would be function call trace as Andrew wrote. Which function is
> calling delay_tsc()? Is it calling it often or once but with long delay?

Please guide me on doing these call traces. Unfortunately I don't have any 
experience at all regarding kernel-space debugging. What tools should I use? 
Keep in mind also that I mostly have remote access to this PC. 

However I am not really confident that the cause is delay_tsc(). It only 
appeared on the libata tests. To summarize I will write down the first lines 
of all problematic oprofilings I've done until now: 

first test: 
3832     23.4818  __switch_to
3380     20.7121  schedule
653       4.0015  mask_and_ack_8259A
452       2.7698  __blockdev_direct_IO
327       2.0038  dequeue_task

second test, with idle=poll (which didn't really help, it seems the cpu is not 
idling at all): 
2477     31.2871  __switch_to
1625     20.5255  schedule
246       3.1072  mask_and_ack_8259A
222       2.8041  __blockdev_direct_IO
147       1.8568  follow_page

third test, libata and idle=poll (the problem felt like it was greater here, 
oprofiling took a really long time):
9556     26.0523  delay_tsc
6424     17.5136  iowrite8
6178     16.8430  __switch_to
4015     10.9460  schedule
3335      9.0921  ioread8
1429      3.8959  iowrite32


So I would assume that delay_tsc() probably only makes the situation worse for 
the libata tests, but the real problem is at __switch_to() and schedule(). Do 
you agree with these assumptions? What are these functions used for? My guess 
would be that __switch_to() is for context switching and schedule() for 
process scheduling. However the context switch rate, as reported by vmstat, 
is not that great to verify the time lost in __switch_to(). As shown from the 
measurements on one disk the context switching rate is greater, but the time 
spent is much less. 

Is there a way to for oprofile to report the time spent in function calls 
depending on the call trace?

> So far it looks like some kind of hardware limit for me. Do You have any
> options in BIOS which can degrade PCI or disk performance?

None that I can think of. Do you have any specific options in mind?


Thanks again for the help. I guess if that doesn't lead anywhere I'll just 
start compiling older vanilla kernels and see when the problem dissapears. 
But this needs a lot of time and I'm not sure for how long I'll be able to 
not offer any service with those disks (I was supposed to use RAID 0 to 
provide storage space with them, but with the current problems that wouldn't 
be so wise). 

Dimitris

>
> > Thanks,
> > Dimitris
>
> Rafa³
