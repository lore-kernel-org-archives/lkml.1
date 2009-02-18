Return-Path: <linux-kernel-owner+w=401wt.eu-S1757677AbZBRWgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbZBRWgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757846AbZBRWb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:31:58 -0500
Received: from kroah.org ([198.145.64.141]:34757 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757831AbZBRWb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:31:56 -0500
Date: Wed, 18 Feb 2009 14:29:07 -0800
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
       alan@lxorguk.ukuu.org.uk, Roel Kluin <roel.kluin@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 06/36] 3c505: do not set pcb->data.raw beyond its size
Message-ID: <20090218222907.GG10668@kroah.com>
References: <20090218222447.432108614@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="3c505-do-not-set-pcb-data.raw-beyond-its-size.patch"
In-Reply-To: <20090218222841.GA10668@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit 501aa061bd68169a5b54c123641f8dfa9ad31545 upstream.

Ensure that we do not set pcb->data.raw beyond its size, print an error message
and return false if we attempt to. A timout message was printed one too early.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/3c505.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/net/3c505.c
+++ b/drivers/net/3c505.c
@@ -493,21 +493,27 @@ static bool receive_pcb(struct net_devic
 	}
 	/* read the data */
 	spin_lock_irqsave(&adapter->lock, flags);
-	i = 0;
-	do {
-		j = 0;
-		while (((stat = get_status(dev->base_addr)) & ACRF) == 0 && j++ < 20000);
-		pcb->data.raw[i++] = inb_command(dev->base_addr);
-		if (i > MAX_PCB_DATA)
-			INVALID_PCB_MSG(i);
-	} while ((stat & ASF_PCB_MASK) != ASF_PCB_END && j < 20000);
+	for (i = 0; i < MAX_PCB_DATA; i++) {
+		for (j = 0; j < 20000; j++) {
+			stat = get_status(dev->base_addr);
+			if (stat & ACRF)
+				break;
+		}
+		pcb->data.raw[i] = inb_command(dev->base_addr);
+		if ((stat & ASF_PCB_MASK) == ASF_PCB_END || j >= 20000)
+			break;
+	}
 	spin_unlock_irqrestore(&adapter->lock, flags);
+	if (i >= MAX_PCB_DATA) {
+		INVALID_PCB_MSG(i);
+		return false;
+	}
 	if (j >= 20000) {
 		TIMEOUT_MSG(__LINE__);
 		return false;
 	}
-	/* woops, the last "data" byte was really the length! */
-	total_length = pcb->data.raw[--i];
+	/* the last "data" byte was really the length! */
+	total_length = pcb->data.raw[i];
 
 	/* safety check total length vs data length */
 	if (total_length != (pcb->length + 2)) {

