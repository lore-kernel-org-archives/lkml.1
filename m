Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbZBDIuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbZBDIuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 03:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZBDIuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 03:50:04 -0500
Received: from prod-mail-xrelay01.akamai.com ([72.246.2.12]:51507 "EHLO
	prod-mail-xrelay01.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbZBDIuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 03:50:03 -0500
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Feb 2009 03:50:03 EST
Date: Wed, 4 Feb 2009 00:40:22 -0800
From: Shakesh Jain <shjain@akamai.com>, ShakeshJain@akamai.com
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jason Uhlenkott <juhlenko@akamai.com>
Subject: [PATCH] sysctl: min-max range check is broken
Message-ID: <20090204084022.GB14071@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_proc_dointvec_minmax_conv() which gets callled from
proc_dointvec_minmax proc_handler doesn't increment the pointer to
the 'min' (extra1) and 'max' (extra2) after each range check which
results in doing the check against same set of min and max values.

This breaks the range checking for those sysctl's where you can
write multiple values to /proc with each variable having its own range
specification.

It seems to be implemented for the sysctl() system call strategy in
sysctl_intvec() where min and max are treated as arrays.

Signed-off-by: Shakesh Jain <shjain@akamai.com>
---
 kernel/sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
========================================================================
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 368d163..50bffcd 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2377,8 +2377,8 @@ static int do_proc_dointvec_minmax_conv(int *negp, unsigned long *lvalp,
 	struct do_proc_dointvec_minmax_conv_param *param = data;
 	if (write) {
 		int val = *negp ? -*lvalp : *lvalp;
-		if ((param->min && *param->min > val) ||
-		    (param->max && *param->max < val))
+		if ((param->min && *(param->min++) > val) ||
+		    (param->max && *(param->max++) < val))
 			return -EINVAL;
 		*valp = val;
 	} else {
