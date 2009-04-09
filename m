Return-Path: <linux-kernel-owner+w=401wt.eu-S1760554AbZDIE6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554AbZDIE6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbZDIE6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:58:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43166 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbZDIE6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:58:03 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Neil Brown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Ram Pai <linuxram@us.ibm.com>, Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH v2 2/2] mounts_poll() make consistent to mdstat_poll
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20090409134916.B3E6.A69D9226@jp.fujitsu.com>
References: <20090409092302.8D8A.A69D9226@jp.fujitsu.com> <20090409134916.B3E6.A69D9226@jp.fujitsu.com>
Message-Id: <20090409135633.B3E9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu,  9 Apr 2009 13:57:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In recently sysfs_poll discussion, Neil Brown pointed out /proc/mounts also should
be fixed.

SUSv3 says "Regular files shall always poll TRUE for reading and writing".
  see http://www.opengroup.org/onlinepubs/009695399/functions/poll.html

Then, mounts_poll()'s default should be "POLLIN | POLLRDNORM".
it mean always readable.

In addition, event trigger should use "POLLERR | POLLPRI" instead POLLERR.
it makes consistent to mdstat_poll() and sysfs_poll(). and, select(2) can
handle POLLPRI easily.


Reported-by: Neil Brown <neilb@suse.de>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
--
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
 



