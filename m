Return-Path: <linux-kernel-owner+w=401wt.eu-S932876AbZGPR1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbZGPR1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932863AbZGPR1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:27:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37091 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862AbZGPR1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:27:50 -0400
Date: Thu, 16 Jul 2009 19:27:49 +0200
From: Jan Kara <jack@suse.cz>
To: Sylvain Rochet <gradator@gradator.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28.9: EXT3/NFS inodes corruption
Message-ID: <20090716172749.GC3740@atrey.karlin.mff.cuni.cz>
References: <20090420162017.GA28079@gradator.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420162017.GA28079@gradator.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> We(TuxFamily) are having some inodes corruptions on a NFS server.
> 
> So, let's start with the facts.
> 
> 
> ==== NFS Server
> 
> Linux bazooka 2.6.28.9 #1 SMP Mon Mar 30 12:58:22 CEST 2009 x86_64 GNU/Linux
  Can you still see the corruption with 2.6.30 kernel?

...
> /dev/md10 on /data type ext3 (rw,noatime,nodiratime,grpquota,commit=5,data=ordered)
> 
>   ==> We used data=writeback, we fallback to data=ordered,
>       problem's still here
> 
...
> 
> # df -m
> /dev/md10              1378166     87170   1290997   7% /data
  1.3 TB, a large filesystem ;).

> # df -i
> /dev/md10            179224576 3454822 175769754    2% /data
> 
> 
> 
> ==== NFS Clients
> 
> 6x Linux cognac 2.6.28.9-grsec #1 SMP Sun Apr 12 13:06:49 CEST 2009 i686 GNU/Linux
> 5x Linux martini 2.6.28.9-grsec #1 SMP Tue Apr 14 00:01:30 UTC 2009 i686 GNU/Linux
> 2x Linux armagnac 2.6.28.9 #1 SMP Tue Apr 14 08:59:12 CEST 2009 i686 GNU/Linux
> 
> x.x.x.x:/data/... on /data/... type nfs (rw,noexec,nosuid,nodev,async,hard,nfsvers=3,udp,intr,rsize=32768,wsize=32768,timeo=20,addr=x.x.x.x)
> 
>   ==> All NFS exports are mounted this way, sometimes with the 'sync' 
>       option, like web sessions.
>   ==> Those are often mounted from outside of chroots into chroots, 
>       useless detail I think
...

> ==== So, now, going into the problem
> 
> The kernel log is not really nice with us, here on the NFS Server:
> 
> Mar 22 06:47:14 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Unrecognised inode hash code 52
> Mar 22 06:47:14 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Corrupt dir inode 40420228, running e2fsck is recommended.
> Mar 22 06:47:16 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Unrecognised inode hash code 52
> Mar 22 06:47:16 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Corrupt dir inode 40420228, running e2fsck is recommended.
> Mar 22 06:47:19 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Unrecognised inode hash code 52
> Mar 22 06:47:19 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Corrupt dir inode 40420228, running e2fsck is recommended.
> Mar 22 06:47:19 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Unrecognised inode hash code 52
> Mar 22 06:47:19 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Corrupt dir inode 40420228, running e2fsck is recommended.
> Mar 22 06:47:19 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Unrecognised inode hash code 52
> And so on...
  If you can still see this problem, could you run: debugfs /dev/md10
and send output of the command:
stat <40420228>
(or whatever the corrupted inode number will be)
and also:
dump <40420228> /tmp/corrupted_dir

> And more recently...
> Apr  2 22:19:01 bazooka kernel: EXT3-fs warning (device md10): ext3_unlink: Deleting nonexistent file (40780223), 0
> Apr  2 22:19:02 bazooka kernel: EXT3-fs warning (device md10): ext3_unlink: Deleting nonexistent file (40491685), 0
> Apr 11 07:23:02 bazooka kernel: EXT3-fs warning (device md10): ext3_unlink: Deleting nonexistent file (174301379), 0
> Apr 20 08:13:32 bazooka kernel: EXT3-fs warning (device md10): ext3_unlink: Deleting nonexistent file (54942021), 0
> 
> 
> Not much stuff in the kernel log of NFS clients, history is quite lost, 
> but we got some of them:
> 
> ....................: NFS: Buggy server - nlink == 0!
> 
> 
> == Going deeper into the problem
> 
> Something like that is quite common:
> 
> root@bazooka:/data/...# ls -la
> total xxx
> drwxrwx--- 2 xx    xx        4096 2009-04-20 03:48 .
> drwxr-xr-x 7 root  root      4096 2007-01-21 13:15 ..
> -rw-r--r-- 1 root  root         0 2009-04-20 03:48 access.log
> -rw-r--r-- 1 root  root  70784145 2009-04-20 00:11 access.log.0
> -rw-r--r-- 1 root  root   6347007 2009-04-10 00:07 access.log.10.gz
> -rw-r--r-- 1 root  root   6866097 2009-04-09 00:08 access.log.11.gz
> -rw-r--r-- 1 root  root   6410119 2009-04-08 00:07 access.log.12.gz
> -rw-r--r-- 1 root  root   6488274 2009-04-07 00:08 access.log.13.gz
> ?--------- ?    ?     ?         ?                ? access.log.14.gz
> ?--------- ?    ?     ?         ?                ? access.log.15.gz
> ?--------- ?    ?     ?         ?                ? access.log.16.gz
> ?--------- ?    ?     ?         ?                ? access.log.17.gz
> -rw-r--r-- 1 root  root   6950626 2009-04-02 00:07 access.log.18.gz
> ?--------- ?    ?     ?         ?                ? access.log.19.gz
> -rw-r--r-- 1 root  root   6635884 2009-04-19 00:11 access.log.1.gz
> ?--------- ?    ?     ?         ?                ? access.log.20.gz
> ?--------- ?    ?     ?         ?                ? access.log.21.gz
> ?--------- ?    ?     ?         ?                ? access.log.22.gz
> ?--------- ?    ?     ?         ?                ? access.log.23.gz
> ?--------- ?    ?     ?         ?                ? access.log.24.gz
> ?--------- ?    ?     ?         ?                ? access.log.25.gz
> ?--------- ?    ?     ?         ?                ? access.log.26.gz
> -rw-r--r-- 1 root  root   6616546 2009-03-24 00:07 access.log.27.gz
> ?--------- ?    ?     ?         ?                ? access.log.28.gz
> ?--------- ?    ?     ?         ?                ? access.log.29.gz
> -rw-r--r-- 1 root  root   6671875 2009-04-18 00:12 access.log.2.gz
> ?--------- ?    ?     ?         ?                ? access.log.30.gz
> -rw-r--r-- 1 root  root   6347518 2009-04-17 00:10 access.log.3.gz
> -rw-r--r-- 1 root  root   6569714 2009-04-16 00:12 access.log.4.gz
> -rw-r--r-- 1 root  root   7170750 2009-04-15 00:11 access.log.5.gz
> -rw-r--r-- 1 root  root   6676518 2009-04-14 00:12 access.log.6.gz
> -rw-r--r-- 1 root  root   6167458 2009-04-13 00:11 access.log.7.gz
> -rw-r--r-- 1 root  root   5856576 2009-04-12 00:10 access.log.8.gz
> -rw-r--r-- 1 root  root   6644142 2009-04-11 00:07 access.log.9.gz
> 
> 
> root@bazooka:/data/...# cat *      # output filtered, only errors
> cat: access.log.14.gz: Stale NFS file handle
> cat: access.log.15.gz: Stale NFS file handle
> cat: access.log.16.gz: Stale NFS file handle
> cat: access.log.17.gz: Stale NFS file handle
> cat: access.log.19.gz: Stale NFS file handle
> cat: access.log.20.gz: Stale NFS file handle
> cat: access.log.21.gz: Stale NFS file handle
> cat: access.log.22.gz: Stale NFS file handle
> cat: access.log.23.gz: Stale NFS file handle
> cat: access.log.24.gz: Stale NFS file handle
> cat: access.log.25.gz: Stale NFS file handle
> cat: access.log.26.gz: Stale NFS file handle
> cat: access.log.28.gz: Stale NFS file handle
> cat: access.log.29.gz: Stale NFS file handle
> cat: access.log.30.gz: Stale NFS file handle
> 
> 
> "Stale NFS file handle"... on the NFS Server... hummm...
> 
> 
> == Other facts
> 
> fsck.ext3 fixed the filesystem but didn't fix the problem.
> 
> mkfs.ext3 didn't fix the problem either.
  You might want to try disabling the DIR_INDEX feature and see whether
the corruption still occurs...

> It only concerns files which have been recently modified, logs, awstats 
> hashfiles, websites caches, sessions, locks, and such.
> 
> It mainly happens to files which are created on the NFS server itself, 
> but it's not a hard rule.
> 
> Keeping inodes into servers' cache seems to prevent the problem to happen.
> ( yeah, # while true ; do ionice -c3 find /data -size +0 > /dev/null ; done )
  I'd guess just because they don't have to be read from disk where they
get corrupted.

> Hummm, it seems to concern files which are quite near to each others, 
> let's check that:
> 
> Let's build up an inode "database"
> 
> # find /data -printf '%i %p\n' > /root/inodesnumbers
> 
> 
> Let's check how inodes numbers are distributed:
> 
> # cat /root/inodesnumbers | perl -e 'use Data::Dumper; my @pof; while(<>){my ( $inode ) = ( $_ =~ /^(\d+)/ ); my $hop = int($inode/1000000); $pof[$hop]++; }; for (0 .. $#pof) { print $_." = ".($pof[$_]/10000)."%\n" }'
> [... lot of quite unused inodes groups]
> 53 = 3.0371%
> 54 = 26.679%     <= mailboxes
> 55 = 2.7026%
> [... lot of quite unused inodes groups]
> 58 = 1.3262%
> 59 = 27.3211%    <= mailing lists archives
> 60 = 5.5159%
> [... lot of quite unused inodes groups]
> 171 = 0.0631%
> 172 = 0.1063%
> 173 = 27.2895%   <=
> 174 = 44.0623%   <=
> 175 = 45.6783%   <= websites files
> 176 = 45.8247%   <=
> 177 = 36.9376%   <=
> 178 = 6.3294%
> 179 = 0.0442%
> 
> Hummm, all the files are using the same inodes "groups".
>   (groups of a million of inodes)
  Interesting, but it may well be just by the way how these files get
created / updated.

> We use to fix broken folders by moving them to a quarantine folder and 
> by restoring disappeared files from the backup.
> 
> So, let's check corrupted inodes number from the quarantine folder:
> 
> root@bazooka:/data/path/to/rep/of/quarantine/folders# find . -mindepth 1 -maxdepth 1 -printf '%i\n' | sort -n
> 174293418
> 174506030
> 174506056
> 174506073
> 174506081
> 174506733
> 174507694
> 174507708
> 174507888
> 174507985
> 174508077
> 174508083
> 176473056
> 176473062
> 176473064
> 
> Humm... those are quite near to each other 17450... 17647... and are of 
> course in the most used inodes "groups"...
> 
> 
> Open question: are NFS clients can steal inodes numbers from each others ?
> 
> 
> I am not sure whether my bug report is good, feel free to ask questions ;)


										Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
