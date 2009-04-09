Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbZDIExp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbZDIExp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758934AbZDIExg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:53:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42954 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbZDIExf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:53:35 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Neil Brown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Ram Pai <linuxram@us.ibm.com>, Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH v2 1/2] sysfs poll keep the poll rule of regular file.
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20090409092302.8D8A.A69D9226@jp.fujitsu.com>
References: <18909.15904.704697.734477@notabene.brown> <20090409092302.8D8A.A69D9226@jp.fujitsu.com>
Message-Id: <20090409134916.B3E6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu,  9 Apr 2009 13:53:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, following test programs don't finished.

% ruby -e '
Thread.new { sleep }
File.read("/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies")
'

strace expose the reason.

...
open("/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies", O_RDONLY|O_LARGEFILE) = 3
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbf9fa6b8) = -1 ENOTTY (Inappropriate ioctl for device)
fstat64(3, {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
_llseek(3, 0, [0], SEEK_CUR)            = 0
select(4, [3], NULL, NULL, NULL)        = 1 (in [3])
read(3, "1400000 1300000 1200000 1100000 1"..., 4096) = 62
select(4, [3], NULL, NULL, NULL


Because Ruby (the scripting language) VM assume select system-call against regular file don't block.
it because SUSv3 says "Regular files shall always poll TRUE for reading and writing".
    see http://www.opengroup.org/onlinepubs/009695399/functions/poll.html
it seems valid assumption.

But sysfs_poll() don't keep this rule although sysfs file can read and write always.

This patch restore proper poll behavior to sysfs.
/sys/block/md*/md/sync_action polling application and another sysfs updating sensitive
application still can use POLLERR and POLLPRI.



Cc: Neil Brown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
--
 fs/sysfs/file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 289c43a..4a302f8 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -446,11 +446,11 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 	if (buffer->event != atomic_read(&od->event))
 		goto trigger;
 
-	return 0;
+	return DEFAULT_POLLMASK;
 
  trigger:
 	buffer->needs_read_fill = 1;
-	return POLLERR|POLLPRI;
+	return DEFAULT_POLLMASK|POLLERR|POLLPRI;
 }
 
 void sysfs_notify_dirent(struct sysfs_dirent *sd)




