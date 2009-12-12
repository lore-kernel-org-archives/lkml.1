Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbZLLHPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbZLLHPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 02:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbZLLHPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 02:15:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58284 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538AbZLLHPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 02:15:45 -0500
Date: Sat, 12 Dec 2009 08:15:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: gregkh@suse.de, stern@rowland.harvard.edu, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: [PATCH] kaweth: Replace runtime power management primitives
Message-ID: <20091212071543.GA4203@elte.hu>
References: <20091211212646.GB6624@kroah.com>
 <20091212065923.GA8500@elte.hu>
 <20091211.230038.179945578.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211.230038.179945578.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Sat, 12 Dec 2009 07:59:23 +0100
> 
> > 
> > FYI, there's a new build breakage on latest upstream, on allyesconfig 
> > x86:
> > 
> >  drivers/net/usb/kaweth.c: In function kaweth_open:
> >  drivers/net/usb/kaweth.c:719: error: implicit declaration of function usb_autopm_enable
> > 
> > The problem appears to be that usb_autopm_enable() is obsolete and got 
> > eliminated recently via:
> 
> I posted about this a few hours ago, it's been resolved and a fix
> is in net-2.6 and will be pushed out soon.

thanks, i found the patch on netdev - attached below, should anyone only 
subscribed to lkml run into this problem.

	Ingo

-------------------->
>From cf549e36d31c8f12da1fe9aaa44702b60d967aac Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oliver@neukum.org>
Date: Wed, 19 Aug 2009 21:35:01 +0200
Subject: [PATCH] kaweth: Replace runtime power management primitives

This patch removes a rare use of the USB power management API
which won't be supported after the conversion to the new generic
runtime power management framework. Functionality is not
altered.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
LKML-Reference: <200908192135.01422.oliver@neukum.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/usb/kaweth.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index 3b80e8d..f1d64ef 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -716,7 +716,7 @@ static int kaweth_open(struct net_device *net)
 	return 0;
 
 err_out:
-	usb_autopm_enable(kaweth->intf);
+	usb_autopm_put_interface(kaweth->intf);
 	return -EIO;
 }
 
@@ -753,7 +753,7 @@ static int kaweth_close(struct net_device *net)
 
 	kaweth->status &= ~KAWETH_STATUS_CLOSING;
 
-	usb_autopm_enable(kaweth->intf);
+	usb_autopm_put_interface(kaweth->intf);
 
 	return 0;
 }
