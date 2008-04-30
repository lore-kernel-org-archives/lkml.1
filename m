Return-Path: <linux-kernel-owner+w=401wt.eu-S1762841AbYD3QOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762841AbYD3QOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 12:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758242AbYD3QN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 12:13:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41556 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120AbYD3QNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 12:13:55 -0400
Date: Wed, 30 Apr 2008 13:12:04 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch, -git] drivers/media build fix for modular builds
Message-ID: <20080430131204.0ce73b3b@gaivota>
In-Reply-To: <1209570490.5157.1.camel@marge.simson.net>
References: <20080429185009.716c3284@gaivota>
	<20080430074807.GA11224@elte.hu>
	<20080430.005212.46815036.davem@davemloft.net>
	<20080430081345.GA16519@elte.hu>
	<1209544030.30990.2.camel@marge.simson.net>
	<1209544951.15609.3.camel@marge.simson.net>
	<1209545784.31419.2.camel@marge.simson.net>
	<1209547231.4898.2.camel@marge.simson.net>
	<20080430044009.6c5bbc8d.akpm@linux-foundation.org>
	<1209560592.5265.2.camel@marge.simson.net>
	<20080430122514.2a52942d@gaivota>
	<1209570490.5157.1.camel@marge.simson.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 17:48:10 +0200
Mike Galbraith <efault@gmx.de> wrote:

> 
> On Wed, 2008-04-30 at 12:25 -0300, Mauro Carvalho Chehab wrote:
> 
> > Please try this patch. It should avoid an OOPS, if attach fails.
> 
> Different oops.
> 

Detach order were wrong.

Try this, please.

diff -r d05d249a98a7 linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Wed Apr 30 12:45:00 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Wed Apr 30 13:09:51 2008 -0300
@@ -516,8 +516,8 @@
 	if (!fe) {
 		printk(KERN_ERR "%s/2: xc3028 attach failed\n",
 		       dev->core->name);
+		dvb_unregister_frontend(dev->dvb.frontend);
 		dvb_frontend_detach(dev->dvb.frontend);
-		dvb_unregister_frontend(dev->dvb.frontend);
 		dev->dvb.frontend = NULL;
 		return -EINVAL;
 	}
diff -r d05d249a98a7 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Wed Apr 30 12:45:00 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Wed Apr 30 13:09:51 2008 -0300
@@ -1345,8 +1345,8 @@
 	return ret;
 
 dettach_frontend:
+	dvb_unregister_frontend(dev->dvb.frontend);
 	dvb_frontend_detach(dev->dvb.frontend);
-	dvb_unregister_frontend(dev->dvb.frontend);
 	dev->dvb.frontend = NULL;
 
 	return -1;

Cheers,
Mauro
