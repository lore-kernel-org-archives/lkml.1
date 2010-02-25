Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab0BYHSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 02:18:22 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47570 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0BYHSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 02:18:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=ddo9QuioL2q0N8XYGaGSTAm+E1U7lmKCbOdIJZuPFS6vG71V+5O90pcjQuAD96YM3Y
         MV7xev8Yn3rP2jabm6+n1bDaGOtVgEhKB1IMgqrg89xPCDW1Se8KSONXA7GgUfaddz2P
         FK3HHHSjdgVHAf8lL9bhKXL2VZiSjyRtHOV7Q=
Date: Thu, 25 Feb 2010 10:18:07 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Aravind Srinivasan <raa.aars@gmail.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] splice: comparing unsigned int < 0
Message-ID: <20100225071807.GB4912@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Aravind Srinivasan <raa.aars@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ret" needs to be signed or the error handling for splice_to_pipe() won't work
correctly.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/kernel/relay.c b/kernel/relay.c
index c705a41..3d97f28 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1215,14 +1215,14 @@ static void relay_page_release(struct splice_pipe_desc *spd, unsigned int i)
 /*
  *	subbuf_splice_actor - splice up to one subbuf's worth of data
  */
-static int subbuf_splice_actor(struct file *in,
+static ssize_t subbuf_splice_actor(struct file *in,
 			       loff_t *ppos,
 			       struct pipe_inode_info *pipe,
 			       size_t len,
 			       unsigned int flags,
 			       int *nonpad_ret)
 {
-	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages, ret;
+	unsigned int pidx, poff, total_len, subbuf_pages, nr_pages;
 	struct rchan_buf *rbuf = in->private_data;
 	unsigned int subbuf_size = rbuf->chan->subbuf_size;
 	uint64_t pos = (uint64_t) *ppos;
@@ -1241,6 +1241,7 @@ static int subbuf_splice_actor(struct file *in,
 		.ops = &relay_pipe_buf_ops,
 		.spd_release = relay_page_release,
 	};
+	ssize_t ret;
 
 	if (rbuf->subbufs_produced == rbuf->subbufs_consumed)
 		return 0;
