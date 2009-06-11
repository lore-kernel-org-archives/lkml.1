Return-Path: <linux-kernel-owner+w=401wt.eu-S1763430AbZFKM10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763430AbZFKM10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759750AbZFKM0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:26:25 -0400
Received: from smtp.nokia.com ([192.100.122.233]:17792 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762752AbZFKM0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:26:24 -0400
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       adrian.hunter@nokia.com, artem.bityutskiy@nokia.com,
       akpm@linux-foundation.org, kay.sievers@vrfy.org
Subject: [PATCH 0/5][V2] FS: userspace notification of errors
Date: Thu, 11 Jun 2009 15:24:44 +0300
Message-Id: <1244723089-1145-1-git-send-email-ext-denis.2.karpov@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 11 Jun 2009 12:24:52.0897 (UTC) FILETIME=[9F33E110:01C9EA8F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

here's a set of patches that implement user space notification of file
system run-rim errors through sysfs/uevents. The first approach was
discussed here:
http://marc.info/?t=124404183600003&r=1&w=2
Reasons behind the feature are summarized here:
http://marc.info/?l=linux-kernel&m=124409549418926&w=2

Hand-held device with large (large => lengthy/expensive fsck process)
FAT volumes on MMC that are error prone, especially in the scenario
when these volumes are exported through g_file_storage as USB mass
storage to be used externally; instead of just remounting read-only
on 'run-rime' error, notify user space and expect it to do something
about fixing the FS.

Implementation summary:

- add sysfs support for FAT fs: per-mounted-volume kobject and sysfs
  hierarchy under /sys/fs/fat. Same approach as used by ext4 and fuse.
  (PATCH 1)

- introduce kobject attribute 'fs_fault' (/sys/fs/fat/<volume>/fs_fault);
  the attribute is '0' on (re)mount and set to '1' upon an error. (PATCH 3)
  FAT error reporting facilities had to be re-factored (PATCH 2) in
  order to simplify sending error notifications. (PATCH 2)

- provide mechanism to optionally notify userspace of FAT fs volume 
  kobject's attribute changes with uevents. An uevent to be sent is of
  tyme KOBJ_CHANGE, with environment variable 'NAME=value', where NAME 
  is capitalized name of the attribute.
  (PATCH 4)

- add mount option 'notify', which will eneble sending uevents on a FAT 
  kobjects attributes; use it for 'fs_faults' attribute. (PATCH 5)

There were several objections to uevent usage, mostly with argument that
uevents are meant to be used within a device context. One might argue that
uevents are tied to kobjects that are not only used to represent devices,
but also for other things (/sys/modules, /sys/fs, /sys/firmware).

What is wrong with using uevents otherwise? What would be another way to
asyncronousely notify userspace of things happening in kernel, other
than though pseudo filesystem files (procfs, sysfs)?

Denis
