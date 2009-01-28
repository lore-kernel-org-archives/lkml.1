Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbZA1SSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbZA1SSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 13:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZA1SSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 13:18:36 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:38200 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZA1SSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 13:18:36 -0500
From: Louis Rilling <louis.rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
Subject: [PATCH v2] Make lockdep happy with configfs
Date: Wed, 28 Jan 2009 19:18:31 +0100
Message-Id: <1233166713-9668-1-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Joel,

Here is a revised version of the patchset making lockdep happy with configfs.
I still don't have a good setup to test the second patch beyond compilation, and
I still guess that you have one :)

Louis

Changelog:
- put s_depth logic in separate functions and remove #ifdef LOCKDEP in the
  hooked functions.
- added the following note to explain why configfs_depend_prep() is correct
  when examining attaching items:
+ * Note: items in the middle of attachment start with s_type = 0
+ * (configfs_new_dirent()), and configfs_make_dirent() (called from
+ * create_dir()) sets s_type = CONFIGFS_DIR|CONFIGFS_USET_CREATING. In both
+ * cases the item is ignored. Since s_type is an int, we rely on the CPU to
+ * atomically update the value, without making configfs_make_dirent() take
+ * configfs_dirent_lock.

- fixed parenthesis on pattern !a & b && c --> !(a & b) && c
- quiet checkpatch

Louis Rilling (2):
      configfs: Silence lockdep on mkdir() and rmdir()
      configfs: Rework configfs_depend_item() locking and make lockdep happy

 fs/configfs/configfs_internal.h |    3 +
 fs/configfs/dir.c               |  188 ++++++++++++++++++++++++++++-----------
 fs/configfs/inode.c             |   38 ++++++++
 3 files changed, 175 insertions(+), 54 deletions(-)
-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
