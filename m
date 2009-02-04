Return-Path: <linux-kernel-owner+w=401wt.eu-S1760706AbZBDWrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706AbZBDWrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 17:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbZBDWrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 17:47:25 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:39760 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785AbZBDWrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 17:47:24 -0500
Date: Wed, 4 Feb 2009 15:47:23 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH B 01/10] OMAP2/3 clock: combine clkdm, clkdm_name into
 union in struct clk
In-Reply-To: <alpine.DEB.2.00.0902030142590.29513@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.00.0902041542550.31536@utopia.booyaka.com>
References: <20090128024301.27240.39391.stgit@localhost.localdomain> <20090128024401.27240.68328.stgit@localhost.localdomain> <20090131115523.GF1394@n2100.arm.linux.org.uk> <alpine.DEB.2.00.0902030142590.29513@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Tue, 3 Feb 2009, Paul Walmsley wrote:

> On Sat, 31 Jan 2009, Russell King - ARM Linux wrote:
> 
> > On Tue, Jan 27, 2009 at 07:44:08PM -0700, Paul Walmsley wrote:
> > > diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
> > > index 55c5d67..7aa09f5 100644
> > > --- a/arch/arm/mach-omap2/clock.c
> > > +++ b/arch/arm/mach-omap2/clock.c
> > > @@ -77,17 +77,17 @@ void omap2_init_clk_clkdm(struct clk *clk)

...

> > This is unsafe - if the clock domain can not be found, you leave the
> > union pointing at the string, and there's no way for this to prevent
> > the clock from being registered.
> 
> Agreed.  Now that omap2_init_clk_clkdm() is called by the 
> OMAP arch-specific clk_register(), this should be pretty easy to 
> implement.  Will send a patch that applies on top of F 06.

The following patch prevents a clock with a bad or missing clockdomain 
from registering.  It applies after F 06.


- Paul


From: Paul Walmsley <paul@pwsan.com>
Date: Wed, 4 Feb 2009 15:11:20 -0700

OMAP2/3 clock: prevent clock registration with bad or missing clockdomain

If clk_register() is called on a struct clk without a clockdomain
name, or a struct clk which contains an invalid clockdomain name, fail
the clock registration.  This prevents later code from inadvertently
dereferencing the clockdomain name string as a struct clockdomain
pointer.

Problem reported by Russell King <linux@arm.linux.org.uk>.

Tested on BeagleBoard ES2.1.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Russell King <linux@arm.linux.org.uk>.
---
 arch/arm/mach-omap2/clock.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 600b2f4..53069cd 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -188,26 +188,32 @@ static int _dpll_test_fint(struct clk *clk, u8 n)
 }
 
 /**
- * omap2_init_clk_clkdm - look up a clockdomain name, store pointer in clk
+ * _omap2_init_clk_clkdm - look up a clockdomain name, store pointer in clk
  * @clk: OMAP clock struct ptr to use
  *
  * Convert a clockdomain name stored in a struct clk 'clk' into a
  * clockdomain pointer, and save it into the struct clk.  Intended to be
- * called during clk_register().  No return value.
+ * called during clk_register().  Returns 0 on success or -ENOENT if the
+ * clockdomain is not found.
  */
-void omap2_init_clk_clkdm(struct clk *clk)
+static int _omap2_init_clk_clkdm(struct clk *clk)
 {
 	struct clockdomain *clkdm;
+	int ret;
 
 	clkdm = clkdm_lookup(clk->clkdm.name);
 	if (clkdm) {
 		pr_debug("clock: associated clk %s to clkdm %s\n",
 			 clk->name, clk->clkdm.name);
 		clk->clkdm.ptr = clkdm;
+		ret = 0;
 	} else {
 		pr_err("clock: %s: could not associate to clkdm %s\n",
 		       clk->name, clk->clkdm.name);
+		ret = -ENOENT;
 	}
+
+	return ret;
 }
 
 /**
@@ -1082,12 +1088,5 @@ void omap2_clk_disable_unused(struct clk *clk)
 
 int omap2_clk_register(struct clk *clk)
 {
-	if (!clk->clkdm.name) {
-		pr_debug("clock: %s: missing clockdomain", clk->name);
-		WARN_ON(1);
-		return -EINVAL;
-	}
-
-	omap2_init_clk_clkdm(clk);
-	return 0;
+	return _omap2_init_clk_clkdm(clk);
 }
-- 
1.6.0.2.GIT

