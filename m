Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbXITIGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbXITIGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbXITIFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:05:48 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:34681 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbXITIFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=iMFqtcG/+fkH+eK5zBBnDnoL3okV9C675lnu7KV36FEgTPZOZMBYhjUlxwyaNnS1wy+uC4bUx98la4SdBfZoIG+r8pU+EQTQK8x9u31x0YYKxYk49OSpY5DRhEljf5r0Iod3Kq9xaTvlERP7KPD+OYEyX7XVwP4dnlL1K7UVPCE=
Subject: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver model
In-Reply-To: 
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:39 +0900
Message-Id: <11902755392688-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver model

Hello, all.

This is the third patchset of four sysfs update patchset series[1] and
to be applied on top of the second patchset[2].

Currently, sysfs interface is based on kobj.  This made more sense
before because lifetime of sysfs nodes were tracked using kobj
reference counts.  However, this is no longer true.  sysfs nodes are
represented with a sysfs_dirent and external reference is severed
immediately on node removal.  The internal implementation reflects
that too and mostly handles sysfs_dirents.

This patchset divorces sysfs from kobject and driver model by
implementing sysfs_dirent based interface.  This has the following
advantages.

* sysfs becomes a separate module and driver model becomes a user of
  sysfs.  Those two are not entangled anymore.  Things are easier to
  understand and test this way.

* Non-driver model users of sysfs (modules, blkdev, etc...) don't have
  to jump through hoops to use sysfs.  kobj based interface requires
  attribute wrapping and is awkward to use directly.  Also, the user
  is required to create a dummy kobj which doesn't serve much purpose
  than being a token for sysfs reference.  New sysfs-dirent based
  interface is straight forward proc-fs like interface and should be
  easier and more intuitive for those users.

* As kobj didn't really represent what actually populate sysfs,
  interface was a bit messy - there was no way to reference a leaf
  node other than using its textual name and directories which aren't
  associated with a kobj needed separate interface, which in turn,
  made adding new features difficult.  New interface is leaner and
  more flexible.

kobject based interface is reimplemented as wrapper functions on top
of the new sysfs_dirent based interface.  Long term plan is to update
kobject based users one-by-one and deprecate kobject based interface.

This change doesn't intend to replace driver-model based interface or
encourage random additions to sysfs hierarchy.  Driver model internal
may change but interfaces to drivers and userland will stay the same.
The goals of this patchset are to 1. clean up sysfs and driver model
internals and 2. make lives easier for sysfs users which aren't
drivers or are having difficulties integrating into the current driver
model.

This patchset contains the following 22 patches.

 0001-sysfs-make-sysfs_root-a-pointer.patch
 0002-sysfs-separate-out-sysfs-kobject.h-and-fs-sysfs-kob.patch
 0003-sysfs-make-sysfs_new_dirent-normalize-mode-and-d.patch
 0004-sysfs-make-SYSFS_COPY_NAME-a-flag.patch
 0005-sysfs-implement-sysfs_find_child.patch
 0006-sysfs-restructure-addrm-helpers.patch
 0007-sysfs-implement-sysfs_dirent-based-remove-interface.patch
 0008-sysfs-implement-sysfs_dirent-based-directory-interf.patch
 0009-sysfs-rename-internal-function-sysfs_add_file.patch
 0010-sysfs-drop-kobj-and-attr-from-file-related-symbols.patch
 0011-sysfs-implement-sysfs_dirent-based-file-interface.patch
 0012-sysfs-drop-kobj-and-attr-from-bin-related-symbols.patch
 0013-sysfs-implement-sysfs_dirent-based-bin-interface.patch
 0014-sysfs-s-symlink-link-g.patch
 0015-sysfs-implement-sysfs_dirent-based-link-interface.patch
 0016-sysfs-convert-group-implementation-to-use-sd-based.patch
 0017-sysfs-s-sysfs_rename_mutex-sysfs_op_mutex-and-prot.patch
 0018-kobject-implement-__kobject_set_name.patch
 0019-sysfs-implement-sysfs_dirent-based-rename-sysfs_r.patch
 0020-sysfs-kill-now-unused-__sysfs_add_file.patch
 0021-sysfs-kill-sysfs_hash_and_remove.patch
 0022-sysfs-move-sysfs_assoc_lock-into-fs-sysfs-kobject.c.patch

0001-0003 are preparations.  0004-0006 implement new features needed
for sysfs_dirent interface.  0007-0016 implement sysfs_dirent based
add, remove interfaces and reimplement kobj-based ones in terms of
them.

0017-0018 preps for sysfs_dirent based rename interface.
sysfs_rename_mutex is renamed to sysfs_op_mutex and protects all tree
modifying operations.  0019 implements sysfs_dirent based rename
interface.  This is one mighty rename interface which can do both
moving and renaming.  The implementation is over-done to later
accomodate symlink auto renaming and hopefully help shadow renaming.

0020-0022 cleans up now unused stuff.

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/582105
[2] http://thread.gmane.org/gmane.linux.kernel/582130


