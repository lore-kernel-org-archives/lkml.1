Return-Path: <linux-kernel-owner+w=401wt.eu-S2993027AbXDFSrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993027AbXDFSrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 14:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992977AbXDFSrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 14:47:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:43790 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992860AbXDFSrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 14:47:41 -0400
Date: Fri, 6 Apr 2007 11:47:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] kernel-doc: handle spaces in array size
Message-Id: <20070406114730.02c82f43.randy.dunlap@oracle.com>
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

From: Randy Dunlap <randy.dunlap@oracle.com>

Unfortunately, kernel-doc has problems with a struct field like this:
	uint8_t databuf[NAND_MAX_PAGESIZE + NAND_MAX_OOBSIZE];

simply due to the spaces around the "+" sign, so drop all spaces inside
[...] so that parsing is done correctly (in some sense).

Warning(linux-2.6.20-git15/include/linux/mtd/nand.h:304): No description found for parameter 'NAND_MAX_OOBSIZE]'

This needs to sit in -mm for awhile to see if it has any adverse effects.

And yes, this is just a hack until kernel-doc learns to do better
parsing.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-2.6.21-rc6.orig/scripts/kernel-doc
+++ linux-2.6.21-rc6/scripts/kernel-doc
@@ -1452,6 +1452,12 @@ sub create_parameterlist($$$) {
 	    $arg =~ s/\s*:\s*/:/g;
 	    $arg =~ s/\s*\[/\[/g;
 
+	    # no spaces inside [array size expression];
+	    # messes up split/pop/shift/unshift below;
+	    while ($arg =~ m/\[.*\s.*\]/) {
+		$arg =~ s/\[(.*)\s(.*)\]/\[$1$2\]/;
+	    }
+
 	    my @args = split('\s*,\s*', $arg);
 	    if ($args[0] =~ m/\*/) {
 		$args[0] =~ s/(\*+)\s*/ $1/;
