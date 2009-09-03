Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbZICSqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbZICSqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbZICSqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:46:42 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:59059 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997AbZICSql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:46:41 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Sep 2009 14:46:41 EDT
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: sds@tycho.nsa.gov, jmorris@namei.org, casey@schaufler-ca.com,
       gregkh@suse.de, ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH] Security/sysfs: Enable security xattrs to be set on sysfs files, directories, and symlinks
Date: Thu,  3 Sep 2009 14:25:55 -0400
Message-Id: <1252002358-6612-1-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is revision three of the sysfs labeling patch set. Changes from version
two are that the new LSM hooks proposed in the last patch have been removed and
replaced with several hooks that were developed for labeled NFS. Instead of
storing the secid which Casey objected to it was replaced with the result of a
call to the new security_inode_getsecctx call. This call was developed to
handle the case where we may have a multiple xattr lsm. So in the new case
sysfs will make a call to getsecctx when the new xattr is set and this will
retreive all of the security information in one string. Subsequent inode
instantiations will take this value out of the sysfs dentry and use the new
security_inode_notifysecctx to place it into the sysfs inode. The third hook
setsecctx is there to round off the set and performs both the setting of incore
state and on disk value of the xattrs. This isn't used for sysfs because there
is no disk backing store for the inode.

 fs/sysfs/dir.c             |    1 +
 fs/sysfs/inode.c           |  135 ++++++++++++++++++++++++++++++++------------
 fs/sysfs/symlink.c         |    2 +
 fs/sysfs/sysfs.h           |   12 ++++-
 fs/xattr.c                 |   55 ++++++++++++++----
 include/linux/security.h   |   55 ++++++++++++++++++
 include/linux/xattr.h      |    1 +
 security/capability.c      |   17 ++++++
 security/security.c        |   18 ++++++
 security/selinux/hooks.c   |   33 +++++++++++
 security/smack/smack_lsm.c |   24 ++++++++
 11 files changed, 303 insertions(+), 50 deletions(-)
 
