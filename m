Return-Path: <linux-kernel-owner+w=401wt.eu-S1761814AbZDQTIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761814AbZDQTIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbZDQTH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:07:27 -0400
Received: from kroah.org ([198.145.64.141]:51202 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753516AbZDQTH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:07:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ram Pai <linuxram@us.ibm.com>, Miklos Szeredi <mszeredi@suse.cz>,
       Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/10] proc: mounts_poll() make consistent to mdstat_poll
Date: Fri, 17 Apr 2009 12:04:29 -0700
Message-Id: <1239995074-4065-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090417190144.GB3548@kroah.com>
References: <20090417190144.GB3548@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

In recently sysfs_poll discussion, Neil Brown pointed out /proc/mounts
also should be fixed.

SUSv3 says "Regular files shall always poll TRUE for reading and
writing".  see
http://www.opengroup.org/onlinepubs/009695399/functions/poll.html

Then, mounts_poll()'s default should be "POLLIN | POLLRDNORM".  it mean
always readable.

In addition, event trigger should use "POLLERR | POLLPRI" instead
POLLERR.  it makes consistent to mdstat_poll() and sysfs_poll(). and,
select(2) can handle POLLPRI easily.


Reported-by: Neil Brown <neilb@suse.de>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/proc/base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index f715597..aa763ab 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -648,14 +648,14 @@ static unsigned mounts_poll(struct file *file, poll_table *wait)
 {
 	struct proc_mounts *p = file->private_data;
 	struct mnt_namespace *ns = p->ns;
-	unsigned res = 0;
+	unsigned res = POLLIN | POLLRDNORM;
 
 	poll_wait(file, &ns->poll, wait);
 
 	spin_lock(&vfsmount_lock);
 	if (p->event != ns->event) {
 		p->event = ns->event;
-		res = POLLERR;
+		res |= POLLERR | POLLPRI;
 	}
 	spin_unlock(&vfsmount_lock);
 
-- 
1.6.2

