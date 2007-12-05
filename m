Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbXLEPbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbXLEPbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 10:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbXLEPbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 10:31:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbXLEPbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 10:31:06 -0500
Message-ID: <4756C590.9080301@redhat.com>
Date: Wed, 05 Dec 2007 10:36:48 -0500
From: Dave Anderson <anderson@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030611
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: anderson@redhat.com
Subject: [PATCH] exec: allow > 2GB executables to run on 64-bit systems
Content-Type: multipart/mixed;
 boundary="------------010501080904040604060204"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010501080904040604060204
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

When a executable that is greater than 2GB in size is attempted on a 64-bit
system on a file system that calls, or uses generic_file_open() as its
open handler, it fails with an EOVERFLOW erro.  This patch adds a call
to force_o_largefile() call in open_exec(), as done in sys_open() and
sys_openat().

Signed-off-by: anderson@redhat.com
---

--------------010501080904040604060204
Content-Type: text/plain;
 name="LKML_open_exec.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="LKML_open_exec.patch"

--- linux-2.6.24-rc3/fs/exec.c.orig
+++ linux-2.6.24-rc3/fs/exec.c
@@ -658,7 +658,8 @@ struct file *open_exec(const char *name)
 			int err = vfs_permission(&nd, MAY_EXEC);
 			file = ERR_PTR(err);
 			if (!err) {
-				file = nameidata_to_filp(&nd, O_RDONLY);
+				file = nameidata_to_filp(&nd, force_o_largefile() ?
+					O_RDONLY|O_LARGEFILE : O_RDONLY);
 				if (!IS_ERR(file)) {
 					err = deny_write_access(file);
 					if (err) {

--------------010501080904040604060204--

