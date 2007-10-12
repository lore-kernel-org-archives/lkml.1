Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbXJLOho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbXJLOho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 10:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbXJLOhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 10:37:35 -0400
Received: from rayleigh.systella.fr ([213.41.184.253]:49308 "EHLO
	rayleigh.systella.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbXJLOhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 10:37:35 -0400
X-Greylist: delayed 1069 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Oct 2007 10:37:34 EDT
Message-ID: <470F8263.4020107@systella.fr>
Date: Fri, 12 Oct 2007 16:19:15 +0200
From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux sparc64; fr-FR; rv:1.8.1.6) Gecko/20070802 Iceape/1.1.4 (Debian-1.1.4-1)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: nbd-general@lists.sourceforge.net, sparclinux@vger.kernel.org
Subject: Blockdev API returns erroneous size on /dev/nbd
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-3.1.8 (rayleigh.systella.fr [192.168.254.1]); Fri, 12 Oct 2007 16:19:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,

	I'm trying to build a Raid1 volume over TCP/IP. I use net block device 
on a 2.6.23 linux kernel on a T1000 server (sparc64).

NBD server exports /dev/md7 (raid5 volume):
Root poulenc:[~] > blockdev --getsize64 /dev/md7
1499879178240
Root poulenc:[/] > nbd-server 2000 /dev/md7 1464725760 -l 192.168.0.0/24 
-C /etc/nbd-server/empty

On NDB client side:
Root gershwin:[~] > blockdev --getsize64 /dev/nbd0
1464725504
Root gershwin:[~] > blockdev --getsize64 /dev/md7
1499879178240

	When NDB client tries to connect to its server, I obtain :

Root gershwin:[/usr/scripts] > nbd-client bs=4096 192.168.0.2 2000 /dev/nbd0
Negotiation: ..size = 1430396KB
bs=4096, sz=357599
Root gershwin:[/usr/scripts] >

Thus, nbd seems to work. Please note that size is correctly returned. 
Now, I would build a raid1 array on this server with /dev/nbd0 and 
/dev/md7. But mdadm return

Root gershwin:[/usr/scripts] > mdadm -C /dev/md8 -l1 -n2 /dev/md7 /dev/nbd0
mdadm: /dev/md7 appears to contain an ext2fs file system
     size=1464725760K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/md7 appears to be part of a raid array:
     level=raid0 devices=2 ctime=Fri Oct 12 14:22:27 2007
mdadm: /dev/nbd0 appears to contain an ext2fs file system
     size=1464725760K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/nbd0 appears to be part of a raid array:
     level=raid0 devices=2 ctime=Fri Oct 12 14:22:27 2007
mdadm: largest drive (/dev/md7) exceed size (1430272K) by more than 1%

I have seen that it is possible to use nbd to build raid. But how can I 
fix the size of exported device ? Indeed, /dev/md7 appears to be 1024 
times greater than the _same_ block device exported by nbd !

Other question : I have tried to write large files on /dev/nbd0 and 
kernel returns :

nbd0: rw=1, want=2877616, limit=2860792
attempt to access beyond end of device
nbd0: rw=1, want=2877624, limit=2860792
attempt to access beyond end of device
nbd0: rw=1, want=2877632, limit=2860792
attempt to access beyond end of device
nbd0: rw=1, want=2877640, limit=2860792
attempt to access beyond end of device
nbd0: rw=1, want=2877648, limit=2860792
attempt to access beyond end of device
nbd0: rw=1, want=2877656, limit=2860792
attempt to access beyond end of device
nbd0: rw=1, want=2877664, limit=2860792
attempt to access beyond end of device
nbd0: rw=1, want=2877672, limit=2860792
attempt to access beyond end of device
nbd0: rw=1, want=2877680, limit=2860792
attempt to access beyond end of device
nbd0: rw=1, want=2877688, limit=2860792
attempt to access beyond end of device
nbd0: rw=1, want=2877696, limit=2860792
attempt to access beyond end of device

	I suspect a bug, but I haven't find any fix or workaround...

	Regards,

	JKB
