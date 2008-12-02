Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbYLBGR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbYLBGR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 01:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYLBGQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 01:16:58 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:43394 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751176AbYLBGQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 01:16:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=f0UiXzSkFQO3161V3dfJhbZuX10jMLqJ8PsX+YM3NgAk0+xrGMoBw86eBd4LQtOlhmVRvE5MY9+tI2djt1hP1PVs4ARicXYPpJDBPxp8dithgtb+s3MeVSoI2vXnl3N4gnwWUq2pvBskAESjb7/iXx15S3orduMZM4lj5KbieAI=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>, lrg@slimlogic.co.uk
Subject: [patch 2.6.28-rc7] regulator: catch some registration errors
Date: Mon, 1 Dec 2008 21:50:35 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>
References: <200812011335.43551.david-b@pacbell.net> <20081201225312.GA6699@sirena.org.uk>
In-Reply-To: <20081201225312.GA6699@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812012150.36342.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Prevent registration of duplicate "struct regulator" names.
They'd be unavailable, and clearly indicate something wrong.

Also make sure the consumer device is provided.  It's nonsensical
to omit these, and not a documented part of the interface.  Since
no code in mainline does such stuff, this is just anti-oops medicine.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/regulator/core.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -772,9 +772,23 @@ static int set_consumer_device_supply(st
 {
 	struct regulator_map *node;
 
-	if (supply == NULL)
+	if (supply == NULL || !consumer_dev)
 		return -EINVAL;
 
+	list_for_each_entry(node, &regulator_map_list, list) {
+		if (consumer_dev != node->dev)
+			continue;
+		if (strcmp(node->supply, supply) != 0)
+			continue;
+
+		dev_dbg(consumer_dev, "%s/%s is '%s' supply; fail %s/%s\n",
+				dev_name(&node->regulator->dev),
+				node->regulator->desc->name,
+				supply,
+				dev_name(&rdev->dev), rdev->desc->name);
+		return -EBUSY;
+	}
+
 	node = kmalloc(sizeof(struct regulator_map), GFP_KERNEL);
 	if (node == NULL)
 		return -ENOMEM;
