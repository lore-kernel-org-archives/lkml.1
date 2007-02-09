Return-Path: <linux-kernel-owner+w=401wt.eu-S1946401AbXBIMHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946401AbXBIMHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946402AbXBIMHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:07:34 -0500
Received: from yumi.tdiedrich.de ([85.10.210.183]:3897 "EHLO yumi.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946401AbXBIMHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:07:32 -0500
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Feb 2007 07:07:32 EST
Date: Fri, 9 Feb 2007 13:07:30 +0100
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Ayaz Abdulla <aabdulla@nvidia.com>, David Ford <firefighterblu3@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: forcedeth problems on 2.6.20-rc6-mm3
Message-ID: <20070209120730.GA11911@melchior.yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Ayaz Abdulla <aabdulla@nvidia.com>,
	David Ford <firefighterblu3@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Robert Hancock <hancockr@shaw.ca>,
	linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
References: <45C6BCE5.90103@shaw.ca> <20070204213603.a5bce839.akpm@linux-foundation.org> <45C6C531.20508@shaw.ca> <20070204221741.63152cbe.akpm@linux-foundation.org> <523e55a00702081326j43de05e3hdd8cf35e946eae9@mail.gmail.com> <45CBE30D.5030006@nvidia.com> <20070209115821.GD10330@melchior.yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070209115821.GD10330@melchior.yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> Ayaz Abdulla wrote:
> > For all those who are having issues, please try out the attached patch.
> 
> Will try.

Does not apply cleanly against 2.6.20, is this one fixed up right?
--- linux-2.6.20/drivers/net/forcedeth.c.orig	2007-02-09 13:02:02.000000000 +0100
+++ linux-2.6.20/drivers/net/forcedeth.c.new	2007-02-09 13:03:45.000000000 +0100
@@ -2603,10 +2603,16 @@
 	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
 	unsigned long flags;
+	u32 retcode;
 
-	pkts = nv_rx_process(dev, limit);
+	if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2) {
+		pkts = nv_rx_process(dev, limit);
+		retcode = nv_alloc_rx(dev);
+	} else {
+		retcode = nv_alloc_rx_optimized(dev);
+	}
 
-	if (nv_alloc_rx(dev)) {
+	if (retcode) {
 		spin_lock_irqsave(&np->lock, flags);
 		if (!np->in_shutdown)
 			mod_timer(&np->oom_kick, jiffies + OOM_REFILL);

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
