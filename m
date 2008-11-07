Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYKGAhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYKGAhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 19:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbYKGAhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 19:37:21 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:25742 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYKGAhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 19:37:20 -0500
Subject: avr: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 01:37:21 +0100
Message-Id: <1226018241.3189.7.camel@nga>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I did not compile or test it, please let me know, or help fixing
 it, if something is wrong with the conversion)

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: avr: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 arch/avr32/mach-at32ap/clock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/avr32/mach-at32ap/clock.c
+++ b/arch/avr32/mach-at32ap/clock.c
@@ -198,7 +198,7 @@ dump_clock(struct clk *parent, struct cl
 	unsigned	i;
 
 	/* skip clocks coupled to devices that aren't registered */
-	if (parent->dev && !parent->dev->bus_id[0] && !parent->users)
+	if (parent->dev && !dev_name(parent->dev) && !parent->users)
 		return;
 
 	/* <nest spaces> name <pad to end> */
@@ -214,7 +214,7 @@ dump_clock(struct clk *parent, struct cl
 		parent->users ? "on" : "off",	/* NOTE: not-paranoid!! */
 		clk_get_rate(parent));
 	if (parent->dev)
-		seq_printf(r->s, ", for %s", parent->dev->bus_id);
+		seq_printf(r->s, ", for %s", dev_name(parent->dev));
 	seq_printf(r->s, "\n");
 
 	/* cost of this scan is small, but not linear... */


