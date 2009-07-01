Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbZGAAwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbZGAAwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761392AbZGAAe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:29 -0400
Received: from kroah.org ([198.145.64.141]:60166 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761356AbZGAAeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:25 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:19 2009
Message-Id: <20090701002418.865780488@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 021/108] tun: Fix unregister race
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=tun-fix-unregister-race.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric W. Biederman <ebiederm@aristanetworks.com>

[ Upstream commit f0a4d0e5b5bfd271e6737f7c095994835b70d450 ]

It is possible for tun_chr_close to race with dellink on the
a tun device.  In which case if __tun_get runs before dellink
but dellink runs before tun_chr_close calls unregister_netdevice
we will attempt to unregister the netdevice after it is already
gone.

The two cases are already serialized on the rtnl_lock, so I have
gone for the cheap simple fix of moving rtnl_lock to cover __tun_get
in tun_chr_close.  Eliminating the possibility of the tun device
being unregistered between __tun_get and unregister_netdevice in
tun_chr_close.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Tested-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/tun.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1275,21 +1275,22 @@ static int tun_chr_open(struct inode *in
 static int tun_chr_close(struct inode *inode, struct file *file)
 {
 	struct tun_file *tfile = file->private_data;
-	struct tun_struct *tun = __tun_get(tfile);
+	struct tun_struct *tun;
 
 
+	rtnl_lock();
+	tun = __tun_get(tfile);
 	if (tun) {
 		DBG(KERN_INFO "%s: tun_chr_close\n", tun->dev->name);
 
-		rtnl_lock();
 		__tun_detach(tun);
 
 		/* If desireable, unregister the netdevice. */
 		if (!(tun->flags & TUN_PERSIST))
 			unregister_netdevice(tun->dev);
 
-		rtnl_unlock();
 	}
+	rtnl_unlock();
 
 	tun = tfile->tun;
 	if (tun)


