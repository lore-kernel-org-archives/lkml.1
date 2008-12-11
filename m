Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbYLKTSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbYLKTSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756470AbYLKTSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:05 -0500
Received: from kroah.org ([198.145.64.141]:55772 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756111AbYLKTSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:03 -0500
Date: Thu, 11 Dec 2008 11:13:38 -0800
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
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 04/83] niu: Fix readq implementation when architecture does
	not provide one.
Message-ID: <20081211191338.GD5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0003-niu-Fix-readq-implementation-when-architecture-does.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit e23a59e1ca6d177a57a7791b3629db93ff1d9813 ]

This fixes a TX hang reported by Jesper Dangaard Brouer.

When an architecutre cannot provide a fully functional
64-bit atomic readq/writeq, the driver must implement
it's own.  This is because only the driver can say whether
doing something like using two 32-bit reads to implement
the full 64-bit read will actually work properly.

In particular one of the issues is whether the top 32-bits
or the bottom 32-bits of the 64-bit register should be read
first.  There could be side effects, and in fact that is
exactly the problem here.

The TX_CS register has counters in the upper 32-bits and
state bits in the lower 32-bits.  A read clears the state
bits.

We would read the counter half before the state bit half.
That first read would clear the state bits, and then the
driver thinks that no interrupts are pending because the
interrupt indication state bits are seen clear every time.

Fix this by reading the bottom half before the upper half.

Tested-by: Jesper Dangaard Brouer <jdb@comx.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/niu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -51,8 +51,7 @@ MODULE_VERSION(DRV_MODULE_VERSION);
 #ifndef readq
 static u64 readq(void __iomem *reg)
 {
-	return (((u64)readl(reg + 0x4UL) << 32) |
-		(u64)readl(reg));
+	return ((u64) readl(reg)) | (((u64) readl(reg + 4UL)) << 32);
 }
 
 static void writeq(u64 val, void __iomem *reg)

