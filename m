Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481Ab0AZX4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0AZX4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237Ab0AZX4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:56:38 -0500
Received: from kroah.org ([198.145.64.141]:35331 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab0AZXnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:40 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:27 2010
Message-Id: <20100126233927.195499266@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [48/98] [SCSI] libfc: Fix frags in frame exceeding SKB_MAX_FRAGS in fc_fcp_send_data
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yi Zou <yi.zou@intel.com>

commit d37322a43ebac79eef417149f5696390cf8872db upstream.

In case of sequence offload, in fc_fcp_send_data(), the skb_fill_page_info()
called may end up adding more frags to the skb_shinfo(fp_skb(fp))->frags[],
exceeding SKB_MAX_FRAGS, this eventually corrupts the memory. I am adding the
FR_FRAME_SG_LEN back, but as SKB_MAX_FRAGS -1, leaving 1 for our fcoe_eof_crc
page. And send will be broken into multiple large sends if the frame already
contains more frags than skb handle.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libfc/fc_fcp.c |    3 ++-
 include/scsi/fc_frame.h     |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -575,7 +575,8 @@ static int fc_fcp_send_data(struct fc_fc
 		tlen -= sg_bytes;
 		remaining -= sg_bytes;
 
-		if (tlen)
+		if ((skb_shinfo(fp_skb(fp))->nr_frags < FC_FRAME_SG_LEN) &&
+		    (tlen))
 			continue;
 
 		/*
--- a/include/scsi/fc_frame.h
+++ b/include/scsi/fc_frame.h
@@ -37,6 +37,9 @@
 #define	FC_FRAME_HEADROOM	32	/* headroom for VLAN + FCoE headers */
 #define	FC_FRAME_TAILROOM	8	/* trailer space for FCoE */
 
+/* Max number of skb frags allowed, reserving one for fcoe_crc_eof page */
+#define FC_FRAME_SG_LEN		(MAX_SKB_FRAGS - 1)
+
 #define fp_skb(fp)	(&((fp)->skb))
 #define fr_hdr(fp)	((fp)->skb.data)
 #define fr_len(fp)	((fp)->skb.len)


