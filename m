Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbXD2CTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbXD2CTX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 22:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbXD2CTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 22:19:23 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:60702 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbXD2CTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 22:19:21 -0400
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=booyaka.com;
  b=Is0Ovhs/PJAOA3H19EG8G/UcxSmutqYmFwOEXAzErlckKuAkdg2KKTiNqwXRV989qwy4C/d/nKR9YHBpCaYzsLZ5IuX4oajf8o2DJY4zjrtABYBrpyj1nQi6cZdUkkjjYbvpAy4rWtK5/dRuZ1ioLq19GcR7o1DWxb7AQQNY1QrkmpEB3aChXZFbPAu56Zz79ZfvYpTblyTC7uPGaZsC3AzgzPp7KB93qEjwPLSXwDtpugi7yCxbfyKnTOQKpIdii8eq8ZP07jwqlUuRcutX9/H0JZ/Jn1slc+FX/rnk5KSTTaSB8n+1dHPoQ+sKI0x+AIuDX1nsPd3cWekKgJ7m2A==  ;
Date: Sat, 28 Apr 2007 20:19:20 -0600 (MDT)
From: Paul Walmsley <paul@booyaka.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
cc: netdev@vger.kernel.org, mikep@linuxtr.net
Subject: [PATCH] ibmtr_cs: fix hang on eject 
Message-ID: <Pine.LNX.4.64.0704282004370.21519@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sent this patch a few weeks ago to the addresses listed for Token Ring 
maintainers.  No response, and the linux-tr@ address bounced.  Resent 
here in case someone wants to pick it up.  Perhaps a MAINTAINERS edit 
might be in order also.


- Paul


Ejecting a PCMCIA IBM Token Ring card that has not had its dev->open() 
called will reliably trigger an uninitialized spinlock oops when spinlock 
debugging is enabled. The system then hangs, occasionally softlockup 
oopsing.  Apparently ibmtr.c:tok_interrupt() doesn't expect to be called 
before tok_open(), but tok_interrupt() gets called anyway when the card is 
ejected.  So, set an already-existing flag which causes tok_interrupt() to 
bail out early upon card ejection. Tested by inserting and removing the 
PCMCIA card several times.

Patch against 2.6.21-rc6.


Signed-off-by: Paul Walmsley <paul@booyaka.com>

---
  dev/drivers/net/pcmcia/ibmtr_cs.c |   12 ++++++++----
  1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux/dev/drivers/net/pcmcia/ibmtr_cs.c
===================================================================
--- linux.orig/dev/drivers/net/pcmcia/ibmtr_cs.c
+++ linux/dev/drivers/net/pcmcia/ibmtr_cs.c
@@ -189,16 +189,20 @@ static void ibmtr_detach(struct pcmcia_d
  {
      struct ibmtr_dev_t *info = link->priv;
      struct net_device *dev = info->dev;
+    struct tok_info *ti = netdev_priv(dev);

      DEBUG(0, "ibmtr_detach(0x%p)\n", link);
+
+    /*
+     * When the card removal interrupt hits tok_interrupt(),
+     * bail out early, so we don't crash the machine
+     */
+    ti->sram_phys |= 1;

      if (link->dev_node)
  	unregister_netdev(dev);

-    {
-	struct tok_info *ti = netdev_priv(dev);
-	del_timer_sync(&(ti->tr_timer));
-    }
+    del_timer_sync(&(ti->tr_timer));

      ibmtr_release(link);

