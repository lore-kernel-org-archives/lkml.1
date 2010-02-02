Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0BBAHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 19:07:35 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40340 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab0BBAHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 19:07:33 -0500
Date: Tue, 2 Feb 2010 11:07:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Baruch Siach <baruch@tkos.co.il>, Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: manual merge of the arm tree with the arm-current tree
Message-Id: <20100202110728.2ae85cfb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Today's linux-next merge of the arm tree got a conflict in
arch/arm/mach-mx25/clock.c between commit
828df43f139c7fbf0d505c7b9a666d321a0f2c25 ("mx25: properly initialize
clocks") from the arm-current tree and commit
dd84ce18c8f522d26aef6e9e9c05c32485b667a7 ("ARM: Consolidate clks_register
() and similar") from the arm tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-mx25/clock.c
index 6acc88b,66916f1..0000000
--- a/arch/arm/mach-mx25/clock.c
+++ b/arch/arm/mach-mx25/clock.c
@@@ -216,21 -208,9 +216,18 @@@ static struct clk_lookup lookups[] = 
  	_REGISTER_CLOCK("fec.0", NULL, fec_clk)
  };
  
 -int __init mx25_clocks_init(unsigned long fref)
 +int __init mx25_clocks_init(void)
  {
- 	int i;
- 
- 	for (i = 0; i < ARRAY_SIZE(lookups); i++)
- 		clkdev_add(&lookups[i]);
+ 	clkdev_add_table(lookups, ARRAY_SIZE(lookups));
 +
 +	/* Turn off all clocks except the ones we need to survive, namely:
 +	 * EMI, GPIO1-3 (CCM_CGCR1[18:16]), GPT1, IOMUXC (CCM_CGCR1[27]), IIM,
 +	 * SCC
 +	 */
 +	__raw_writel((1 << 19), CRM_BASE + CCM_CGCR0);
 +	__raw_writel((0xf << 16) | (3 << 26), CRM_BASE + CCM_CGCR1);
 +	__raw_writel((1 << 5), CRM_BASE + CCM_CGCR2);
 +
  	mxc_timer_init(&gpt_clk, MX25_IO_ADDRESS(MX25_GPT1_BASE_ADDR), 54);
  
  	return 0;
