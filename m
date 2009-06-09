Return-Path: <linux-kernel-owner+w=401wt.eu-S1761884AbZFIK3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761884AbZFIK3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760246AbZFIKU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:20:26 -0400
Received: from kroah.org ([198.145.64.141]:55115 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760790AbZFIKUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:20:24 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:04 2009
Message-Id: <20090609094104.269896926@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:40 -0700
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
       alan@lxorguk.ukuu.org.uk, Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 52/87] bnx2: Fix panic in bnx2_poll_work().
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=bnx2-fix-panic-in-bnx2_poll_work.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Chan <mchan@broadcom.com>

commit 581daf7e00c5e766f26aff80a61a860a17b0d75a upstream.

Add barrier() to bnx2_get_hw_{tx|rx}_cons() to fix this issue:

http://bugzilla.kernel.org/show_bug.cgi?id=12698

This issue was reported by multiple i386 users.  Without barrier(),
the compiled code looks like the following where %eax contains the
address of the tx_cons or rx_cons in the DMA status block.  The
status block contents can change between the cmpb and the movzwl
instruction.  The driver would crash if the value was not 0xff during
the cmpb instruction, but changed to 0xff during the movzwl
instruction.

6828:	80 38 ff             	cmpb   $0xff,(%eax)
682b:	0f b7 10             	movzwl (%eax),%edx

With the added barrier(), the compiled code now looks correct:

683d:	0f b7 10             	movzwl (%eax),%edx
6840:	0f b6 c2             	movzbl %dl,%eax
6843:	3d ff 00 00 00       	cmp    $0xff,%eax

Thanks to Pascal de Bruijn <pmjdebruijn@pcode.nl> for reporting the
problem and Holger Noefer <hnoefer@pironet-ndh.com> for patiently
testing test patches for us.

[greg - took out version change]

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bnx2.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -2585,6 +2585,7 @@ bnx2_get_hw_tx_cons(struct bnx2_napi *bn
 	/* Tell compiler that status block fields can change. */
 	barrier();
 	cons = *bnapi->hw_tx_cons_ptr;
+	barrier();
 	if (unlikely((cons & MAX_TX_DESC_CNT) == MAX_TX_DESC_CNT))
 		cons++;
 	return cons;
@@ -2864,6 +2865,7 @@ bnx2_get_hw_rx_cons(struct bnx2_napi *bn
 	/* Tell compiler that status block fields can change. */
 	barrier();
 	cons = *bnapi->hw_rx_cons_ptr;
+	barrier();
 	if (unlikely((cons & MAX_RX_DESC_CNT) == MAX_RX_DESC_CNT))
 		cons++;
 	return cons;


