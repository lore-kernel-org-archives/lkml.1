Return-Path: <linux-kernel-owner+w=401wt.eu-S933302AbXCEVA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302AbXCEVA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933203AbXCEU6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:58:47 -0500
Received: from mbox.ssc.unict.it ([151.97.230.9]:46884 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933245AbXCEU6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:58:12 -0500
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH 11/11] uml: fix errno usage
Date: Mon, 05 Mar 2007 21:49:10 +0100
To: Andrew Morton <akpm@osdl.org>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Message-Id: <20070305204910.9072.38235.stgit@americanbeauty.home.lan>
In-Reply-To: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
References: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
Content-Type: text/plain; charset=utf-8; format=fixed
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by alpha.home.local id l25L2SZJ008314

From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Avoid reusing userspace errno twice - it can be cleared by libc code everywhere
(in particular printk() does clear it in my setup).

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 arch/um/drivers/daemon_user.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/um/drivers/daemon_user.c b/arch/um/drivers/daemon_user.c
index 310af0f..021b82c 100644
--- a/arch/um/drivers/daemon_user.c
+++ b/arch/um/drivers/daemon_user.c
@@ -56,30 +56,31 @@ static int connect_to_switch(struct daemon_data *pri)
 
 	pri->control = socket(AF_UNIX, SOCK_STREAM, 0);
 	if(pri->control < 0){
+		err = -errno;
 		printk("daemon_open : control socket failed, errno = %d\n", 
-		       errno);		
-		return(-errno);
+		       -err);
+		return err;
 	}
 
 	if(connect(pri->control, (struct sockaddr *) ctl_addr, 
 		   sizeof(*ctl_addr)) < 0){
-		printk("daemon_open : control connect failed, errno = %d\n",
-		       errno);
 		err = -errno;
+		printk("daemon_open : control connect failed, errno = %d\n",
+		       -err);
 		goto out;
 	}
 
 	fd = socket(AF_UNIX, SOCK_DGRAM, 0);
 	if(fd < 0){
-		printk("daemon_open : data socket failed, errno = %d\n", 
-		       errno);
 		err = -errno;
+		printk("daemon_open : data socket failed, errno = %d\n",
+		       -err);
 		goto out;
 	}
 	if(bind(fd, (struct sockaddr *) local_addr, sizeof(*local_addr)) < 0){
-		printk("daemon_open : data bind failed, errno = %d\n", 
-		       errno);
 		err = -errno;
+		printk("daemon_open : data bind failed, errno = %d\n",
+		       -err);
 		goto out_close;
 	}
 


