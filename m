Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbZFRAmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbZFRAmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 20:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZFRAlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 20:41:55 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:18681 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbZFRAly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 20:41:54 -0400
Message-ID: <4A398C5B.6040705@oracle.com>
Date: Wed, 17 Jun 2009 17:37:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       samr <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kernel-doc: fix param matching for array params
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.4A398D1E.020F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function actual parameter vs. kernel-doc description matching
so that a warning is not printed when it should not be:

Warning(include/linux/etherdevice.h:199): Excess function parameter 'addr' description in 'is_etherdev_addr'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- linux-2.6.30-git11.orig/scripts/kernel-doc
+++ linux-2.6.30-git11/scripts/kernel-doc
@@ -1653,6 +1653,15 @@ sub push_parameter($$$) {
 	}
 	}
 
+	# strip spaces from $param so that it is one continous string
+	# on @parameterlist;
+	# this fixes a problem where check_sections() cannot find
+	# a parameter like "addr[6 + 2]" because it actually appears
+	# as "addr[6", "+", "2]" on the parameter list;
+	# but it's better to maintain the param string unchanged for output,
+	# so just weaken the string compare in check_sections() to ignore
+	# "[blah" in a parameter string;
+	###$param =~ s/\s*//g;
 	push @parameterlist, $param;
 	$parametertypes{$param} = $type;
 }
@@ -1671,6 +1680,14 @@ sub check_sections($$$$$$) {
 			$prm_clean = $prms[$px];
 			$prm_clean =~ s/\[.*\]//;
 			$prm_clean =~ s/__attribute__\s*\(\([a-z,_\*\s\(\)]*\)\)//;
+			# ignore array size in a parameter string;
+			# however, the original param string may contain
+			# spaces, e.g.:  addr[6 + 2]
+			# and this appears in @prms as "addr[6" since the
+			# parameter list is split at spaces;
+			# hence just ignore "[..." for the sections check;
+			$prm_clean =~ s/\[.*//;
+
 			##$prm_clean =~ s/^\**//;
 			if ($prm_clean eq $sects[$sx]) {
 				$err = 0;


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
