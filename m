Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbYKMNAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbYKMNAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYKMM7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 07:59:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:57159 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751635AbYKMM7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 07:59:53 -0500
X-Authenticated: #3035711
X-Provags-ID: V01U2FsdGVkX1+ZS0813Y+Z9/hzuTHIbrLe/5+9ZFmz+ZqXnBTJTP
	ipBqEMM17zUXnf
Date: Thu, 13 Nov 2008 13:59:45 +0100
From: Ingo van Lil <inguin@gmx.de>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] usbmon binary format reader loses synchronization
Message-ID: <20081113125945.GA10450@zaphod.peppercon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pete,

there's a bug in the usbmon binary reader: When using read() to fetch
the packets and a packet's data is partially read the next read call
will once again return up to len_cap bytes of data. The b_read counter
is not regarded when determining the remaining chunk size.

When dumping USB data with "cat /dev/usbmon0 > usbmon.trace" while
reading from a USB storage device and analyzing the dump file
afterwards it will get out of sync after a couple of packets.

Cheers,
Ingo

Signed-off-by: Ingo van Lil <inguin@gmx.de>
---
diff -urN a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
--- a/drivers/usb/mon/mon_bin.c	2008-07-13 23:51:29.000000000 +0200
+++ b/drivers/usb/mon/mon_bin.c	2008-11-13 11:44:03.000000000 +0100
@@ -681,7 +681,7 @@
 	}
 
 	if (rp->b_read >= sizeof(struct mon_bin_hdr)) {
-		step_len = min(nbytes, (size_t)ep->len_cap);
+		step_len = min(nbytes, sizeof(struct mon_bin_hdr) + (size_t)ep->len_cap - rp->b_read);
 		offset = rp->b_out + PKT_SIZE;
 		offset += rp->b_read - sizeof(struct mon_bin_hdr);
 		if (offset >= rp->b_size)
