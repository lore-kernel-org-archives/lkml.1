Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbZBYQUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbZBYQUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZBYQUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:20:08 -0500
Received: from mail.suse.de ([195.135.220.2]:54110 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbZBYQUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:20:06 -0500
Date: Wed, 25 Feb 2009 17:20:03 +0100
From: Karsten Keil <kkeil@suse.de>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       linux-isdn@vger.kernel.org, Frank Seidel <fseidel@suse.de>,
       jolly@eversberg.eu, kkeil@suse.de, smurf@smurf.noris.de,
       andreas@eversberg.eu, hannes@hanneseder.net
Subject: Re: [PATCH][trivial] mISDN: l1oip - reduce stack memory footprint
Message-ID: <20090225162003.GA8872@pingi.kke.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.60-0.34-smp x86_64
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
X-Enigmail-Version: 0.95.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

Applying kernel janitors todos (reduce stack
footprint where possible) to l1oip mISDN driver.
(Before 1656 bytes on i386, now 164)

Signed-off-by: Frank Seidel <frank@f-seidel.de>
Acked-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/mISDN/l1oip_core.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -663,18 +663,28 @@ l1oip_socket_thread(void *data)
 	struct iovec iov;
 	mm_segment_t oldfs;
 	struct sockaddr_in sin_rx;
-	unsigned char recvbuf[1500];
+	unsigned char *recvbuf;
+	size_t recvbuf_size = 1500;
 	int recvlen;
 	struct socket *socket = NULL;
 	DECLARE_COMPLETION(wait);
 
+	/* allocate buffer memory */
+	recvbuf = kmalloc(recvbuf_size * sizeof(*recvbuf), GFP_KERNEL);
+	if (!recvbuf) {
+		printk(KERN_ERR "%s: Failed to allocate memory.\n", __func__);
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	/* make daemon */
 	allow_signal(SIGTERM);
 
 	/* create socket */
 	if (sock_create(PF_INET, SOCK_DGRAM, IPPROTO_UDP, &socket)) {
 		printk(KERN_ERR "%s: Failed to create socket.\n", __func__);
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	/* set incoming address */
@@ -730,10 +740,10 @@ l1oip_socket_thread(void *data)
 			__func__);
 	while (!signal_pending(current)) {
 		iov.iov_base = recvbuf;
-		iov.iov_len = sizeof(recvbuf);
+		iov.iov_len = recvbuf_size;
 		oldfs = get_fs();
 		set_fs(KERNEL_DS);
-		recvlen = sock_recvmsg(socket, &msg, sizeof(recvbuf), 0);
+		recvlen = sock_recvmsg(socket, &msg, recvbuf_size, 0);
 		set_fs(oldfs);
 		if (recvlen > 0) {
 			l1oip_socket_parse(hc, &sin_rx, recvbuf, recvlen);
@@ -771,6 +781,9 @@ fail:
 	if (debug & DEBUG_L1OIP_SOCKET)
 		printk(KERN_DEBUG "%s: socket thread terminated\n",
 			__func__);
+
+out:
+	kfree(recvbuf);
 	return ret;
 }
 


-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
