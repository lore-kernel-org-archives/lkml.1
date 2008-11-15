Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbYKOFZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbYKOFZd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 00:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYKOFYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 00:24:51 -0500
Received: from kroah.org ([198.145.64.141]:50419 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751426AbYKOFYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 00:24:47 -0500
Date: Fri, 14 Nov 2008 21:22:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Kay Sievers <kay.sievers@vrfy.org>,
       Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>
Subject: [patch 01/22] touch_mnt_namespace when the mount flags change
Message-ID: <20081115052241.GB3710@kroah.com>
References: <20081115051732.506914008@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="touch_mnt_namespace-when-the-mount-flags-change.patch"
In-Reply-To: <20081115052220.GA3710@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 0e55a7cca4b66f625d67b292f80b6a976e77c51b upstream

Daemons that need to be launched while the rootfs is read-only can now
poll /proc/mounts to be notified when their O_RDWR requests may no
longer end in EROFS.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namespace.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1553,8 +1553,13 @@ static noinline int do_remount(struct na
 	if (!err)
 		nd->path.mnt->mnt_flags = mnt_flags;
 	up_write(&sb->s_umount);
-	if (!err)
+	if (!err) {
 		security_sb_post_remount(nd->path.mnt, flags, data);
+
+		spin_lock(&vfsmount_lock);
+		touch_mnt_namespace(nd->path.mnt->mnt_ns);
+		spin_unlock(&vfsmount_lock);
+	}
 	return err;
 }
 

-- 
