Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab0CJRR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:17:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55935 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab0CJRR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:17:57 -0500
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: howto combat highly pathologic latencies on a server?
Date: Wed, 10 Mar 2010 18:17:42 +0100
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201003101817.42812.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1/UWMDON6B7RwqRFeyG4viSrBygAaEvgD9gEyS
 mN4NAZxDD590A9F13aIVTvtPI24r2OHEwN7IuU6NuBjr6m+TyP
 yp73wotcqvHNgev7jAEZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in a commercial setting, with all those evil elements at work like VMware, 
NFS, XFS, openSUSE, diskless fat clients, you name it...

System description:

Dual socket board: Tyan S2892, 2 * AMD Opteron 285 @ 2.6 GHz, 8 GB RAM, 
PRO/1000 MT Dual Port Server NIC, Areca ARC-1261 16 channel RAID 
controller, with 3 sets of RAID 5 arrays attached:
System is running from: 4 * WD Raptor 150GB (WDC WD1500ADFD-00NLR5)
VMware (XP-) images used via NFS: 6 * WD Raptor 74 GB (WDC WD740GD-00FLA0)
Homes, diskless clients, appl. data: 4 * Hitachi 1 GB (HDE721010SLA330).

All filesystems are xfs. The server serves about 20 diskless PC's, most use 
an Intel Pro/1000 GT NIC, all attached on a 3com 3870 48-port 10/100/1000 
switch.

OS is openSUSE 11.1/i586 with kernel 2.6.27.45 (the same kernel as SLE 11).

It serves mostly NFS, SMB, and does mild database (MySQL) and email 
processing (Cyrus IMAP, Postfix...). It also drives an ancient (but very 
important) terminal based transport order mgmt system, that often syncs 
it's data. Unfortunately, it's also used for running a VMware-Server 
(1.0.10) XP-client, that itself does simple database stuff (employers time 
registration).

Users generally describe this system as slow, although the load on the 
server is less than 1.5 most of the time. Interestingly, the former system, 
using ancient kernels (2.6.11, SuSE 9.3) was perceived significantly 
quicker (but not fast..).

The diskless clients are started once in the morning (taking 60-90 sec), use 
an aufs2 layered NFS mount for their openSUSE 11.1 system, and simple NFS 
mounted homes and shared folders. 2/3th also need running a VMware XP 
client (also NFS mounted). Their CPUs range from Athlon 64 3000+ up to 
Phenom X4 955, with 2 or 4 GB RAM.

While this system usually operates fine, it suffers from delays, that are 
displayed in latencytop as: "Writing page to disk:     8425,5 ms": 
ftp://urpla.net/lat-8.4sec.png, but we see them also in the 1.7-4.8 sec 
range: ftp://urpla.net/lat-1.7sec.png, ftp://urpla.net/lat-2.9sec.png, 
ftp://urpla.net/lat-4.6sec.png and ftp://urpla.net/lat-4.8sec.png.

>From other observations, this issue "feels" like it is induced by single 
syncronisation points in the block layer, eg. if I create heavy IO load on 
one RAID array, say resizing a VMware disk image, it can take up to a 
minute to log in by ssh, although the ssh login does not touch this area at 
all (different RAID arrays). Note, that the latencytop snapshots above are 
made during normal operation, not this kind of load..

The network side looks fine, as its main interface rarely passes 40MiB/s, 
and usually keeps in the 1 Kib/s - 5 MiB/s range. 

The xfs filesystems are mounted with rw,noatime,attr2,nobarrier,noquota 
(yes, I do have a BBU on the areca, and disk write cache is effectively 
turned off). 

The clients mount their system:
/:ro/rw,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,nointr,nolock,proto=tcp,
timeo=600,retrans=2,sec=sys,mountvers=3,mountproto=udp
/home: similar
/shared: without nolock

Might later kernels mitigate this problem? As this is a production system, 
that is used 6.5 days a week, I cannot do dangerous experiments, also 
switching to 64 bit is a problem due to the legacy stuff described above...
OTOH, my users suffer from this, and anything helping in this respect is 
highly appreciated.

Thanks in advance,
Pete
