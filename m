Return-Path: <linux-kernel-owner+w=401wt.eu-S1751732AbXDHCqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbXDHCqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 22:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbXDHCqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 22:46:36 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:58120 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbXDHCqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 22:46:36 -0400
Date: Sat, 7 Apr 2007 19:47:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>, rusty@rustcorp.com.au
Subject: [PATCH] Re: kernel oops with badly formatted module option
Message-Id: <20070407194700.38138108.randy.dunlap@oracle.com>
In-Reply-To: <4618356D.70303@lwfinger.net>
References: <4618356D.70303@lwfinger.net>
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

On Sat, 07 Apr 2007 19:21:01 -0500 Larry Finger wrote:

> With the following line in /etc/modprobe.conf.local:
> 
> options bcm43xx fwpostfix = ".fw3" locale=8
> 
> the kernel oops below is generated. I realize that the line should have no whitespace around the 
> "=", but I do not feel that an oops is the best way to report the syntax error. Could there be a more gentle failure?


From: Randy Dunlap <randy.dunlap@oracle.com>

Catch malformed kernel parameter usage of "param = value".
Spaces are not supported, but don't cause a kernel fault on
such usage, just report an error.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/params.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-2.6.21-rc6.orig/kernel/params.c
+++ linux-2.6.21-rc6/kernel/params.c
@@ -356,6 +356,10 @@ int param_set_copystring(const char *val
 {
 	struct kparam_string *kps = kp->arg;
 
+	if (!val) {
+		printk(KERN_ERR "%s: missing param set value\n", kp->name);
+		return -EINVAL;
+	}
 	if (strlen(val)+1 > kps->maxlen) {
 		printk(KERN_ERR "%s: string doesn't fit in %u chars.\n",
 		       kp->name, kps->maxlen-1);
