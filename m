Return-Path: <linux-kernel-owner+w=401wt.eu-S964785AbXDGAwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964785AbXDGAwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 20:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964791AbXDGAwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 20:52:24 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:15021 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964785AbXDGAwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 20:52:23 -0400
Date: Fri, 6 Apr 2007 17:53:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH v2] kernel-doc: handle spaces in array size
Message-Id: <20070406175325.4bb3c904.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.61.0704070138350.22181@yvahk01.tjqt.qr>
References: <20070406114730.02c82f43.randy.dunlap@oracle.com>
	<Pine.LNX.4.61.0704062117460.6042@yvahk01.tjqt.qr>
	<20070406160335.e125e287.randy.dunlap@oracle.com>
	<Pine.LNX.4.61.0704070138350.22181@yvahk01.tjqt.qr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Jan Engelhardt <jengelh@linux01.gwdg.de>

Unfortunately, kernel-doc has problems with a struct field like this:
	uint8_t databuf[NAND_MAX_PAGESIZE + NAND_MAX_OOBSIZE];

simply due to the spaces around the "+" sign, so drop all spaces inside
[...] so that parsing is done correctly (in some sense).

Warning(linux-2.6.20-git15/include/linux/mtd/nand.h:304): No description found for parameter 'NAND_MAX_OOBSIZE]'

This needs to sit in -mm for awhile to see if it has any adverse effects.

And yes, this is just a hack until kernel-doc learns to do better
parsing.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6.21-rc6.orig/scripts/kernel-doc
+++ linux-2.6.21-rc6/scripts/kernel-doc
@@ -1452,6 +1452,11 @@ sub create_parameterlist($$$) {
 	    $arg =~ s/\s*:\s*/:/g;
 	    $arg =~ s/\s*\[/\[/g;
 
+	    # no spaces inside [array size expression];
+	    # messes up split/pop/shift/unshift below;
+	    while ($arg =~ s/\[(.*)\s+(.*)\]/[$1$2]/) {
+	    }
+
 	    my @args = split('\s*,\s*', $arg);
 	    if ($args[0] =~ m/\*/) {
 		$args[0] =~ s/(\*+)\s*/ $1/;
