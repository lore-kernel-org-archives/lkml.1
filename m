Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935307Ab0CMA54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:57:56 -0500
Received: from kroah.org ([198.145.64.141]:46816 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935393Ab0CMAbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:14 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:08 2010
Message-Id: <20100313002708.732128828@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [040/145] net-sysfs: Use rtnl_trylock in wireless sysfs methods.
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit b8afe6416101549e877f8470f2a160df69676166 ]

The wireless sysfs methods like the rest of the networking sysfs
methods are removed with the rtnl_lock held and block until
the existing methods stop executing.  So use rtnl_trylock
and restart_syscall so that the code continues to work.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/net-sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -366,7 +366,8 @@ static ssize_t wireless_show(struct devi
 	const struct iw_statistics *iw;
 	ssize_t ret = -EINVAL;
 
-	rtnl_lock();
+	if (!rtnl_trylock())
+		return restart_syscall();
 	if (dev_isalive(dev)) {
 		iw = get_wireless_stats(dev);
 		if (iw)


