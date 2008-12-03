Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYLCTvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYLCTvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbYLCTuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:04 -0500
Received: from kroah.org ([198.145.64.141]:34482 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754198AbYLCTuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:02 -0500
Date: Wed, 3 Dec 2008 11:48:18 -0800
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
       alan@lxorguk.ukuu.org.uk, Ingo van Lil <inguin@gmx.de>,
       Pete Zaitcev <zaitcev@redhat.com>
Subject: [patch 003/104] USB: usbmon: fix read(2)
Message-ID: <20081203194818.GD8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-usbmon-fix-read.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Pete Zaitcev <zaitcev@redhat.com>

commit f1c0a2a3aff53698f4855968d576464041d49b39 upstream.

There's a bug in the usbmon binary reader: When using read() to fetch
the packets and a packet's data is partially read, the next read call
will once again return up to len_cap bytes of data. The b_read counter
is not regarded when determining the remaining chunk size.

So, when dumping USB data with "cat /dev/usbmon0 > usbmon.trace" while
reading from a USB storage device and analyzing the dump file
afterwards it will get out of sync after a couple of packets.

Signed-off-by: Ingo van Lil <inguin@gmx.de>
Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/mon/mon_bin.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -687,7 +687,10 @@ static ssize_t mon_bin_read(struct file 
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

