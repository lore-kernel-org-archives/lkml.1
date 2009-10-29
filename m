Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbZJ2Q1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbZJ2Q1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZJ2Q1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:27:33 -0400
Received: from mail-gw.exalead.com ([193.47.80.29]:36702 "EHLO exalead.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755468AbZJ2Q1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:27:32 -0400
X-Greylist: delayed 1112 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Oct 2009 12:27:32 EDT
Message-ID: <4AE9BE21.8020102@exalead.com>
Date: Thu, 29 Oct 2009 17:09:05 +0100
From: Xavier Roche <roche+kml2@exalead.com>
Organization: Exalead
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091020 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.31 / 2.6.32-last: XFS will not mount after a crash when quotas
 are enabled (quota DB corrupted)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

We experience issues with XFS on Kernel >= 2.6.31 when quotas are
enabled. Some recent quotas additions might be the cause of the problems
encountered. (1)

Test case to reproduce the issue:
---------------------------------

- Have an XFS filesystem with quotas enabled for users

/etc/fstab entry:
/dev/sda6   /data           xfs             uqupta,gquota     0 0

- Have a kernel crash while the filesystem is dirty

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git &
sleep 10
echo b >/proc/sysrq-trigger
# we should dead here

On reboot, after the filesystem check, the filesystem will not mount
because the quota db is apparently corrupted:

XFS: dquot too small (104) in xlog_recover_do_dquot_trans.

The filesystem is however still fixable using:
mount -o noquota /data
umount /data
mount /data

(however this will rebuild the entire DB..)

The issue could not be reproduced on a 2.6.30


(1) http://xfs.org/index.php/XFS_Status_Updates
"The Linux 2.6.31 merge opened in the mid of the month and some big XFS
changes have been pushed: A removal of the quotaops infrastructure which
simplifies the quota implementation, the switch from XFS's own Posix ACL
implementation to the generic one shared by various other filesystems
which also supports in-memory caching of ACLs and another incremental
refactoring of the sync code"
