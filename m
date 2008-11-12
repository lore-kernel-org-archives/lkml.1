Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbYKLAfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbYKLAfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbYKLA0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:36 -0500
Received: from kroah.org ([198.145.64.141]:42330 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752430AbYKLA0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:32 -0500
Date: Tue, 11 Nov 2008 16:23:43 -0800
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
       alan@lxorguk.ukuu.org.uk, Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Dan Williams <dan.j.williams@intel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 24/49] I/OAT: fix channel resources free for not allocated
	channels
Message-ID: <20081112002343.GY10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i-oat-fix-channel-resources-free-for-not-allocated-channels.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maciej Sosnowski <maciej.sosnowski@intel.com>

commit c3d4f44f50b65b0b0290e357f8739cfb3f4bcaca upstream

If the ioatdma driver is loaded but not used it does not allocate descriptors.
Before it frees channel resources it should first be sure
that they have been previously allocated.

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Tested-by: Tom Picard <tom.s.picard@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/dma/ioat_dma.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -801,6 +801,12 @@ static void ioat_dma_free_chan_resources
 	struct ioat_desc_sw *desc, *_desc;
 	int in_use_descs = 0;
 
+	/* Before freeing channel resources first check
+	 * if they have been previously allocated for this channel.
+	 */
+	if (ioat_chan->desccount == 0)
+		return;
+
 	tasklet_disable(&ioat_chan->cleanup_task);
 	ioat_dma_memcpy_cleanup(ioat_chan);
 
@@ -863,6 +869,7 @@ static void ioat_dma_free_chan_resources
 	ioat_chan->last_completion = ioat_chan->completion_addr = 0;
 	ioat_chan->pending = 0;
 	ioat_chan->dmacount = 0;
+	ioat_chan->desccount = 0;
 	ioat_chan->watchdog_completion = 0;
 	ioat_chan->last_compl_desc_addr_hw = 0;
 	ioat_chan->watchdog_tcp_cookie =

-- 
