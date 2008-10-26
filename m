Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692AbYJZS45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbYJZS45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 14:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYJZS4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 14:56:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43711 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbYJZS4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 14:56:49 -0400
Date: Sun, 26 Oct 2008 18:56:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: dwmw2@infradead.org
Subject: [software coproarchaeology] sbc8240 story
Message-ID: <20081026185647.GP28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where: drivers/mtd/maps/sbc8240.c
What: fucked
When: since before the merge into mainline 4 years ago
How: won't even compile, for starters.

The driver had been added to mtd CVS back in September 2003.  At the time
it had moderate bitrot - it appears to have been written for the mtd tree
as of early May 2003.  The changes needed to fix it had been trivial -
mtd->module got renamed to mtd->owner.  Additionally, it had been ripe
for conversion to simple_map_init().

The sucker had sat there until July 2004, when it got pushed into the
mainline.  Just before the merge the conversion to simple_map_init()
had been done - with a trivial fuckup.  Instead of

                simple_map_init(&sbc8240_map[i]);
                sbc8240_mtd[i] = do_map_probe("jedec_probe", &sbc8240_map[i]);
it did
                simple_map_init(&sbc8240_mtd[i]);
                sbc8240_mtd[i] = do_map_probe("jedec_probe", &sbc8240_map[i]);

Note that this not only makes no sense at all; cc(1) would scream on that,
since simple_map_init() expects a pointer to map_info to be filled, not
a pointer to pointer to mtd_info.  Not that it mattered much, since the
damn thing wouldn't compile anyway - a few lines below we have
                        sbc8240_mtd[i]->module = THIS_MODULE;
and that field had been renamed to 'owner'.

So it had sat in the mainline kernel for 4 years.  During those years _nobody_
had ever tried to compile it.  Nonetheless, there had been patches affecting
it - including such exciting stuff as removal of trailing whitespaces, which
had certainly greatly improved the damn thing.

Frankly, I don't know what the right thing to do with that.  Sure, fixing
this couple of idiocies is trivial and the driver is straightforward enough,
so that's probably all it would take to.  Moreover, it's not as if that
mess had been the original author's fault - the driver definitely used to
work around the time it had been submitted to mtd CVS.

On the other hand...  Trivially fixed or not, we have the absolute proof
that nobody had ever used that driver since its inclusion into the mainline. 
So it's either the patch below or removing the thing completely...

As an aside, this story says a lot about our build coverage.  And probably
quite a few sad things about development process...

diff --git a/drivers/mtd/maps/sbc8240.c b/drivers/mtd/maps/sbc8240.c
index 6e1e99c..236c947 100644
--- a/drivers/mtd/maps/sbc8240.c
+++ b/drivers/mtd/maps/sbc8240.c
@@ -169,12 +169,12 @@ int __init init_sbc8240_mtd (void)
 			}
 			return -EIO;
 		}
-		simple_map_init(&sbc8240_mtd[i]);
+		simple_map_init(&sbc8240_map[i]);
 
 		sbc8240_mtd[i] = do_map_probe("jedec_probe", &sbc8240_map[i]);
 
 		if (sbc8240_mtd[i]) {
-			sbc8240_mtd[i]->module = THIS_MODULE;
+			sbc8240_mtd[i]->owner = THIS_MODULE;
 			devicesfound++;
 		} else {
 			if (sbc8240_map[i].map_priv_1) {
