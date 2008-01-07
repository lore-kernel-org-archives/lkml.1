Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbYAGDSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbYAGDSK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 22:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYAGDRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 22:17:55 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35924 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754543AbYAGDRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 22:17:53 -0500
X-Sasl-enc: g6MFSXeoVAj5lLJacPjPvjjRu6LUSGj60c5mMiI2o5Qg 1199675872
Subject: umount -l <path>, getcwd and /proc/<pid>/cwd inconsistent
From: Ian Kent <raven@themaw.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 07 Jan 2008 12:17:30 +0900
Message-Id: <1199675850.3156.15.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Could someone please help me understand what's happening with, what
looks like inconsistent behavior, between getpwd and procfs readlink.

Basically, from a bash shell, setting working directory to a mounted
directory all is fine with "pwd" and "/proc/<pid>/cwd". Following a
"umount - l" on the mount "pwd" continues to return the expected string
but "/proc/<pid>/cwd" returns an empty string.

What I'm really after is why this happens because sys_getcwd and
proc_pid_readlink appear to do essentially the same thing to get the
string.

For example:

[raven@raven ~]$ mount
/dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
/dev/mapper/VolGroup00-LogVol03 on /work type ext3 (rw)
/dev/mapper/VolGroup00-LogVol02 on /home type ext3 (rw)
/dev/mapper/VolGroup02-LogVol00 on /vmware type ext3 (rw)
/dev/sda2 on /boot type ext3 (rw)
tmpfs on /dev/shm type tmpfs (rw)
none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
shark:/export/auto on /mnt/auto type nfs (rw,addr=10.49.97.44)
[raven@raven ~]$ cd /mnt/auto
[raven@raven auto]$ pwd
/mnt/auto
[raven@raven auto]$ ps
  PID TTY          TIME CMD
 5435 pts/2    00:00:00 bash
 5543 pts/2    00:00:00 ps
[raven@raven auto]$ ls -ld /proc/5435/cwd
lrwxrwxrwx 1 raven raven 0 2008-01-07 11:57 /proc/5435/cwd -> /mnt/auto

"umount -l /mnt/auto", done elsewhere at this point.

[raven@raven auto]$ mount
/dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
/dev/mapper/VolGroup00-LogVol03 on /work type ext3 (rw)
/dev/mapper/VolGroup00-LogVol02 on /home type ext3 (rw)
/dev/mapper/VolGroup02-LogVol00 on /vmware type ext3 (rw)
/dev/sda2 on /boot type ext3 (rw)
tmpfs on /dev/shm type tmpfs (rw)
none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
[raven@raven auto]$ pwd
/mnt/auto
[raven@raven auto]$ ls -ld /proc/5435/cwd
lrwxrwxrwx 1 raven raven 0 2008-01-07 11:57 /proc/5435/cwd ->
[raven@raven auto]$


Ian


