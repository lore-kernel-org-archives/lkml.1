Return-Path: <linux-kernel-owner+w=401wt.eu-S1764498AbXLOVyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764498AbXLOVyx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 16:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbXLOVyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 16:54:44 -0500
Received: from bizon.gios.gov.pl ([212.244.124.8]:47394 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbXLOVyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 16:54:43 -0500
Date: Sat, 15 Dec 2007 22:53:33 +0100 (CET)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: olel@bizon.gios.gov.pl
To: Peter Zijlstra <peterz@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Osterried <osterried@jesse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
In-Reply-To: <Pine.LNX.4.64.0712151324190.12202@bizon.gios.gov.pl>
Message-ID: <Pine.LNX.4.64.0712152223150.14491@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709281005340.17152@bizon.gios.gov.pl> 
 <200709290614.02918.nickpiggin@yahoo.com.au>  <Pine.LNX.4.64.0712021603060.26896@bizon.gios.gov.pl>
  <200712030936.25363.osterried@jesse.de>  <Pine.LNX.4.64.0712131606410.24173@bizon.gios.gov.pl>
 <1197560671.6895.17.camel@twins> <Pine.LNX.4.64.0712131655310.24173@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0712151324190.12202@bizon.gios.gov.pl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-762958269-1197755613=:14491"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-762958269-1197755613=:14491
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE


http://bugzilla.kernel.org/show_bug.cgi?id=3D9182


On Sat, 15 Dec 2007, Krzysztof Oledzki wrote:

>
>
> On Thu, 13 Dec 2007, Krzysztof Oledzki wrote:
>
>>=20
>>=20
>> On Thu, 13 Dec 2007, Peter Zijlstra wrote:
>>=20
>>>=20
>>> On Thu, 2007-12-13 at 16:17 +0100, Krzysztof Oledzki wrote:
>>>>=20
>>>=20
>>>> BTW: Could someone please look at this problem? I feel little ignored =
and
>>>> in my situation this is a critical regression.
>>>=20
>>> I was hoping to get around to it today, but I guess tomorrow will have
>>> to do :-/
>>=20
>> Thanks.
>>=20
>>> So, its ext3, dirty some pages, sync, and dirty doesn't fall to 0,
>>> right?
>>=20
>> Not only doesn't fall but continuously grows.
>>=20
>>> Does it happen with other filesystems as well?
>>=20
>> Don't know. I generally only use ext3 and I'm afraid I'm not able to swi=
tch=20
>> this system to other filesystem.
>>=20
>>> What are you ext3 mount options?
>> /dev/root / ext3 rw,data=3Djournal 0 0
>> /dev/VolGrp0/usr /usr ext3 rw,nodev,data=3Djournal 0 0
>> /dev/VolGrp0/var /var ext3 rw,nodev,data=3Djournal 0 0
>> /dev/VolGrp0/squid_spool /var/cache/squid/cd0 ext3=20
>> rw,nosuid,nodev,noatime,data=3Dwriteback 0 0
>> /dev/VolGrp0/squid_spool2 /var/cache/squid/cd1 ext3=20
>> rw,nosuid,nodev,noatime,data=3Dwriteback 0 0
>> /dev/VolGrp0/news_spool /var/spool/news ext3=20
>> rw,nosuid,nodev,noatime,data=3Dordered 0 0
>
> BTW: this regression also exists in 2.6.24-rc5. I'll try to find when it =
was=20
> introduced but it is hard to do it on a highly critical production system=
,=20
> especially since it takes ~2h after a reboot, to be sure.
>
> However, 2h is quite good time, on other systems I have to wait ~2 months=
 to=20
> get 20MB of leaked memory:
>
> # uptime
> 13:29:34 up 58 days, 13:04,  9 users,  load average: 0.38, 0.27, 0.31
>
> # sync;sync;sleep 1;sync;grep Dirt /proc/meminfo
> Dirty:           23820 kB

More news, I hope this time my problem get more attention from developers=
=20
since now I have much more information.

So far I found that:
  - 2.6.20-rc4 - bad: http://bugzilla.kernel.org/attachment.cgi?id=3D14057
  - 2.6.20-rc2 - bad: http://bugzilla.kernel.org/attachment.cgi?id=3D14058
  - 2.6.20-rc1 - OK (probably, I need to wait little more to be 100% sure).

2.6.20-rc1 with 33m uptime:
~$ grep Dirt /proc/meminfo ;sync ; sleep 1 ; sync ; grep Dirt /proc/meminfo
Dirty:           10504 kB
Dirty:               0 kB

2.6.20-rc2 was released Dec 23/24 2006 (BAD)
2.6.20-rc1 was released Dec 13/14 2006 (GOOD?)

It seems that this bug was introduced exactly one year ago. Surprisingly,=
=20
dirty memory in 2.6.20-rc2/2.6.20-rc4 leaks _much_ more faster than in=20
2.6.20-final and later kernels as it took only about 6h to reach 172MB.=20
So, this bug might be cured afterward, but only a little.

There are three commits that may be somehow related:

http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-2.6.20.y.git;a=3Dc=
ommitdiff;h=3Dfba2591bf4e418b6c3f9f8794c9dd8fe40ae7bd9
http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-2.6.20.y.git;a=3Dc=
ommitdiff;h=3D3e67c0987d7567ad666641164a153dca9a43b11d
http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-2.6.20.y.git;a=3Dc=
ommitdiff;h=3D5f2a105d5e33a038a717995d2738434f9c25aed2

I'm going to check 2.6.20-rc1-git... releases but it would be *very* nice=
=20
if someone could finally give ma a hand and point some hints helping=20
debugging this problem.

Please note that none of my systems with kernels >=3D 2.6.20-rc1 is able to=
=20
reach 0 kb of dirty memory, even after many synces, even when idle.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-762958269-1197755613=:14491--
