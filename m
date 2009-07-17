Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbZGQUTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbZGQUTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbZGQUTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:19:40 -0400
Received: from kroah.org ([198.145.64.141]:43064 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530AbZGQUTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:38 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:29 2009
Message-Id: <20090717201228.781324899@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:08:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 03/24] tun/tap: Fix crashes if open() /dev/net/tun and then poll() it. (CVE-2009-1897)
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=tun-tap-fix-crashes-if-open-dev-net-tun-and-then-poll-it.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

commit 3c8a9c63d5fd738c261bd0ceece04d9c8357ca13 upstream.

Fix NULL pointer dereference in tun_chr_pool() introduced by commit
33dccbb050bbe35b88ca8cf1228dcf3e4d4b3554 ("tun: Limit amount of queued
packets per device") and triggered by this code:

	int fd;
	struct pollfd pfd;
	fd = open("/dev/net/tun", O_RDWR);
	pfd.fd = fd;
	pfd.events = POLLIN | POLLOUT;
	poll(&pfd, 1, 0);

Reported-by: Eugene Kapun <abacabadabacaba@gmail.com>
Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/tun.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -486,12 +486,14 @@ static unsigned int tun_chr_poll(struct 
 {
 	struct tun_file *tfile = file->private_data;
 	struct tun_struct *tun = __tun_get(tfile);
-	struct sock *sk = tun->sk;
+	struct sock *sk;
 	unsigned int mask = 0;
 
 	if (!tun)
 		return POLLERR;
 
+	sk = tun->sk;
+
 	DBG(KERN_INFO "%s: tun_chr_poll\n", tun->dev->name);
 
 	poll_wait(file, &tun->socket.wait, wait);


