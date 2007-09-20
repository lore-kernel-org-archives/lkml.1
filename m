Return-Path: <linux-kernel-owner+w=401wt.eu-S1760872AbXITIcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760872AbXITIcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbXITIbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:31:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:31752 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbXITIbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:31:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=lnJ0AYewOL83yEbpk9kfPMK3mA2S4uQzoq79Aug1ZkxpKk79+ysG9Th0WDL/d1GkI4imvUng9w2oj+64trrYALDHRb3yFeIkHYrVZ9kL3cYX7kx86P0DUAyx3D/ApuQGyl0gDWOHNHZdxXp92cuqhjqAYz36dvVR6w52otdj4Gw=
Subject: [PATCHSET 4/4] sysfs: implement new features
In-Reply-To: 
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:31:37 +0900
Message-Id: <11902770971822-git-send-email-htejun@gmail.com>
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

Hello, all.

This is the fourth patchset of four sysfs update patchset series[1]
and to be applied on top of the third patchset[2].

This patchset implements the following new features.

* Notify pollers on file deactivation.

* Name-formatting for symlinks.  e.g. symlink pointing to
  /dira/dirb/leaf can be named as "symlink:%1-%0" and it will show up
  as "symlink:dirb-leaf".  This only applies when new interface is
  used.

* Autoremoval of symlinks when target is removed.  This only applies
  when new interface is used.

* Autorenaming of symlinks according to the name format string when
  target or one of its ancestors is renamed or moved.  This only
  applies when new interface is used.

* Plugged operations.  Sysfs users can plug top node and build subtree
  gradually without revealing the process to userland.  When subtree
  is fully constructed, the top node can be unplugged and userland
  will see completely built subtree appearing at once.  If subtree
  creation fails in the process, the whole subtree can be removed by
  simply removing the top node.  There won't be any userland
  noticeable event.  This is to be combined with uevent_suppress
  mechanism of driver model.

* Batch error handling.  A plugged node accumulates any error
  condition occurring below it and can return the first error when
  asked.  Also, all interface functions accepth ERR_PTR() value as
  sysfs_dirent parameter.  This means that constructs like the
  following can be used to replace the current group interface.

  <<-- code -->>
  group = sysfs_add_dir(parent, "group_name", 0777 | SYSFS_PLUGGED, NULL);
  sysfs_add_file(group, "file0", 0777, file0_ops, file0_data);
  sysfs_add_file(group, "file1", 0777, file1_ops, file1_data);
  ...
  sysfs_add_file(group, "fileN", 0777, fileN_ops, fileN_data);
  rc = sysfs_check_batch_error(group);
  if (rc) {
	sysfs_remove(group);
	return rc;
  }
  sysfs_unplug(group);
  return 0;
  <<-- end of code -->>

  The above will create a subdirectory "group_name" which contains N
  files and show them atomically to userland or remove them without
  letting userland notice if any failure happens.  This will simplify
  sysfs users quite a bit (not only for groups, other stuff too).

This patchset contains the following 8 patches.

 0001-sysfs-notify-file-on-deactivation.patch
 0002-sysfs-add-name-formatting-support-for-symlinks.patch
 0003-sysfs-chain-symlinks-to-their-targets.patch
 0004-sysfs-implement-symlink-auto-removal.patch
 0005-sysfs-implement-symlink-auto-rename.patch
 0006-sysfs-implement-plugged-creation-of-sysfs-nodes.patch
 0007-sysfs-implement-batch-error-handling.patch
 0008-sysfs-add-copyrights.patch

0001 implements notification on file deactivation.  0002-0005
implement symlink name formatting, autoremoving and autorenaming.
0006 implements plugged creation.  0007 batch error handling, and 0008
adds copyright notices on top of all sysfs header and source files.

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/582105
[2] http://thread.gmane.org/gmane.linux.kernel/582147


