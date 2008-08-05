Return-Path: <linux-kernel-owner+w=401wt.eu-S1762249AbYHETIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762249AbYHETIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 15:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759161AbYHETIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 15:08:16 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:40091 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273AbYHETIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 15:08:15 -0400
Date: Tue, 5 Aug 2008 22:06:51 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [2.6 patch] ath9k: work around gcc ICEs
Message-ID: <20080805190651.GI22895@cs181140183.pp.htv.fi>
References: <20080805162152.2b55ae5c.sfr@canb.auug.org.au> <20080805153757.GB22895@cs181140183.pp.htv.fi> <20080805160026.GA14186@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080805160026.GA14186@tuxdriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 12:00:26PM -0400, John W. Linville wrote:
> On Tue, Aug 05, 2008 at 06:37:57PM +0300, Adrian Bunk wrote:
> > On Tue, Aug 05, 2008 at 04:21:52PM +1000, Stephen Rothwell wrote:
> > > Hi John,
> > > 
> > > Today's linux-next build (powerpc allyesconfig) failed like this:
> > > 
> > > drivers/net/wireless/ath9k/hw.c: In function 'ath9k_hw_9280_spur_mitigate':
> > > drivers/net/wireless/ath9k/hw.c:4660: internal compiler error: in expand_expr_real_1, at expr.c:9199
> > > 
> > > Clearly not our fault! :-) I have informed our toolchain person.  This
> > > was using the Debian gcc-4.3.  It also fails using the Debian 4.2
> > > compiler but not the 4.1 one.
> > >...
> > 
> > Alexandros Couloumbis already opened a bug for this issue on mips, which 
> > also seems to be affected:
> >   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=37014
> > 
> > It is a gcc bug, but we'll have to work around it in the ath9k driver.
> 
> I imagine that we would be happy to do that.  Anyone have a clue as to how?

Patch below, verified to fix the issue with the following compilers:
- powerpc 4.2.4
- powerpc latest 4.3 SVN
- powerpc latest 4.4 SVN
- mips 4.2.4
- mips 4.3.1

The patch has to be applied twice for fixing both copies of the
same code.  :-)

> John

cu
Adrian


<--  snip  -->


This patch works around an internal compiler error (gcc bug #37014) in 
all gcc 4.2 compilers and the gcc 4.3 series up to at least 4.3.1
on at least powerpc and mips.

Many thanks to Andrew Pinski for analyzing the gcc bug.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d1ec5b9fba6c50c7e98a85776a3b95d3a3a3179b 
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 1f6f393..5edc56d 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -4801,7 +4801,11 @@
 
 	for (i = 0; i < 123; i++) {
 		if ((cur_vit_mask > lower) && (cur_vit_mask < upper)) {
-			if ((abs(cur_vit_mask - bin)) < 75)
+
+			/* workaround for gcc bug #37014 */
+			volatile int tmp = abs(cur_vit_mask - bin);
+
+			if (tmp < 75)
 				mask_amt = 1;
 			else
 				mask_amt = 0;
