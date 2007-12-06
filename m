Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbXLFWPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbXLFWPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 17:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbXLFWPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 17:15:23 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39858 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbXLFWPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 17:15:22 -0500
Date: Thu, 6 Dec 2007 23:15:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dave Anderson <anderson@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: [NEW-PATCH] exec: allow > 2GB executables to run on 64-bit systems
Message-ID: <20071206221520.GG20595@one.firstfloor.org>
References: <4756C590.9080301@redhat.com> <p73fxyhj5f7.fsf@bingen.suse.de> <475702E7.1000607@redhat.com> <20071205195637.GA20595@one.firstfloor.org> <47570B0A.6040404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47570B0A.6040404@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since Dave didn't post an updated patch. This is how I think what
the patch should be. I also changed sys_uselib just to be complete.

----


Always use O_LARGEFILE for opening executables

This allows to use executables >2GB.

Based on a patch by Dave Anderson

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6.24-rc3/fs/exec.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/exec.c
+++ linux-2.6.24-rc3/fs/exec.c
@@ -119,7 +119,7 @@ asmlinkage long sys_uselib(const char __
 	if (error)
 		goto exit;
 
-	file = nameidata_to_filp(&nd, O_RDONLY);
+	file = nameidata_to_filp(&nd, O_RDONLY|O_LARGEFILE);
 	error = PTR_ERR(file);
 	if (IS_ERR(file))
 		goto out;
@@ -658,7 +658,8 @@ struct file *open_exec(const char *name)
 			int err = vfs_permission(&nd, MAY_EXEC);
 			file = ERR_PTR(err);
 			if (!err) {
-				file = nameidata_to_filp(&nd, O_RDONLY);
+				file = nameidata_to_filp(&nd,
+							O_RDONLY|O_LARGEFILE);
 				if (!IS_ERR(file)) {
 					err = deny_write_access(file);
 					if (err) {
