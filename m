Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYKNFRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYKNFRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 00:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYKNFQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 00:16:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41887 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092AbYKNFQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 00:16:55 -0500
Date: Thu, 13 Nov 2008 22:15:36 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Ingo van Lil <inguin@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usbmon binary format reader loses synchronization
Message-Id: <20081113221536.c69ce161.zaitcev@redhat.com>
In-Reply-To: <20081113125945.GA10450@zaphod.peppercon.de>
References: <20081113125945.GA10450@zaphod.peppercon.de>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 13:59:45 +0100, Ingo van Lil <inguin@gmx.de> wrote:

> When dumping USB data with "cat /dev/usbmon0 > usbmon.trace" while
> reading from a USB storage device and analyzing the dump file
> afterwards it will get out of sync after a couple of packets.

I think you nailed the problem. I only want shorter lines.
How about this:

diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index c9de3f0..e06810a 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -687,7 +687,10 @@ static ssize_t mon_bin_read(struct file *file, char __user *buf,
 	}
 
 	if (rp->b_read >= sizeof(struct mon_bin_hdr)) {
-		step_len = min(nbytes, (size_t)ep->len_cap);
+		step_len = ep->len_cap;
+		step_len -= rp->b_read - sizeof(struct mon_bin_hdr);
+		if (step_len > nbytes)
+			step_len = nbytes;
 		offset = rp->b_out + PKT_SIZE;
 		offset += rp->b_read - sizeof(struct mon_bin_hdr);
 		if (offset >= rp->b_size)

Also, please send me signed-off-by if you want it.

-- Pete
