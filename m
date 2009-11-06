Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbZKFSJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbZKFSJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 13:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759525AbZKFSJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 13:09:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56696 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbZKFSJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 13:09:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/7] =?utf-8?q?appletalk:=C2=A0handle=20SIOCATALKDIFADDR=20compat=20ioctl?=
Date: Fri,  6 Nov 2009 19:09:06 +0100
Message-Id: <1257530949-9695-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1257530949-9695-1-git-send-email-arnd@arndb.de>
References: <1257530949-9695-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX19uPibJZme3ytjQgPvp+drJkr0+vI7Q58vme+q
 zbcp8TB61me14Xt/aTJk7DrVcBnGeqdiwAsRIYcd58JGHxdv/p
 2FGGWIQXVkGrGbdNRomUQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must not have a compat ioctl handler for SIOCATALKDIFADDR
in common code, because the same number is used in other protocols
with different data structures.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/compat_ioctl.c   |    1 -
 net/appletalk/ddp.c |   12 +++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index f4a5a01..50d2a5f 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -2536,7 +2536,6 @@ HANDLE_IOCTL(SIOCSIFHWBROADCAST, dev_ifsioc)
 HANDLE_IOCTL(SIOCSHWTSTAMP, dev_ifsioc)
 
 /* ioctls used by appletalk ddp.c */
-HANDLE_IOCTL(SIOCATALKDIFADDR, dev_ifsioc)
 HANDLE_IOCTL(SIOCDIFADDR, dev_ifsioc)
 HANDLE_IOCTL(SIOCSARP, dev_ifsioc)
 HANDLE_IOCTL(SIOCDARP, dev_ifsioc)
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index b1a4290..db9c75a 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1810,12 +1810,14 @@ static int atalk_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 static int atalk_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 {
 	/*
-	 * All Appletalk ioctls except SIOCATALKDIFADDR are standard.  And
-	 * SIOCATALKDIFADDR is handled by upper layer as well, so there is
-	 * nothing to do.  Eventually SIOCATALKDIFADDR should be moved
-	 * here so there is no generic SIOCPROTOPRIVATE translation in the
-	 * system.
+	 * SIOCATALKDIFADDR is a SIOCPROTOPRIVATE ioctl number, so we
+	 * cannot handle it in common code. The data we access if ifreq
+	 * here is compatible, so we can simply call the native
+	 * handler.
 	 */
+	if (cmd == SIOCATALKDIFADDR)
+		return atalk_ioctl(sock, cmd, (unsigned long)compat_ptr(arg));
+
 	return -ENOIOCTLCMD;
 }
 #endif
-- 
1.6.3.3

