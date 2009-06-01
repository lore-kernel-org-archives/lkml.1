Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbZFAOgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbZFAOgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbZFAOgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:36:36 -0400
Received: from smtp.nokia.com ([192.100.122.230]:64829 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866AbZFAOgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:36:35 -0400
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] FAT errors, userspace notifications
Date: Mon,  1 Jun 2009 17:34:46 +0300
Message-Id: <1243866891-18713-1-git-send-email-ext-denis.2.karpov@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 01 Jun 2009 14:34:53.0605 (UTC) FILETIME=[20A7F550:01C9E2C6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

here's a series of patches that implement:

1. Options for FAT file system behavior on errors (continue, panic, 
   remount r/o)

   Current FAT behavior is to remount itself read-only on critical errors.
   Quite often this causes more harm to user space applications than if the
   error would be ignored - file system suddenly becoming r/o leads to all 
   kind of surprises from applications (yes, I know applications should be
   written properly, this is not always the case). 

   'errors' mount option (equivalent to the one in 
   ext2 fs) offers possibility for user space to specify the desired behavior.
   Default behavior is still as it was: remount read-only.
   [PATCH 1]

2. Generic mechanism for notifications of user space about file system's 
   errors/inconsistency on a particular partition using:

     - sysfs entry /sys/block/<bdev>/<part>/fs_unclean
     - uevent KOBJ_CHANGE, uevent's environment variable FS_UNCLEAN=[0:1]

   Userspace might want to monitor these notifications (poll2() on sysfs file
   or udevd's rule for uevent) and fix the fs damage.
   Filesystem can be marked clean again by writing '0' to the corresponding 
   'fs_unclean' sysfs file.

   Reason for this feature: doing full scale fsck on a file system 
   at mounting time (especially residing on a slow and error prone media 
   such as flash) takes long. Full fsck results e.g. in slow boot times.
   Alternative approach is to run limited fsck (or none at all) at 
   mounting/boot time. At run-rime if an fs error is encountered, notify 
   the user space and expect it to fix the file system.
   [PATCH 2]
   
3. Make FAT and EXT2 file systems use the above mechanism to optionally 
   notify user space about errors. Implemented as 'notify' mount option.
   FAT error reporting facilities had to be re-factored in order to 
   simplify sending error notifications.
   [PATCH 3,4,5]

Adrian Hunter and Artem Bityutskiy provided input and ideas on implementing
these features.

Denis Karpov.

P.S. I screwed up w/ email aliases, this email was also sent to:
## to: hirofumi@mail.parknet.co.jp
## cc: linux-fsdevel@vger.kernel.org
## cc: adrian.hunter@nokia.com
## cc: artem.bityutskiy@nokia.com
