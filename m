Return-Path: <linux-kernel-owner+w=401wt.eu-S1765523AbYASE4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765523AbYASE4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 23:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762752AbYASEz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 23:55:57 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:35566 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762193AbYASEz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 23:55:56 -0500
Date: Sat, 19 Jan 2008 05:55:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: sfrench@samba.org, linux-kernel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, samba-technical@lists.samba.org
Subject: [PATCH] Remove information leak in Linux CIFS client
Message-ID: <20080119045552.GA11134@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 19 Jan 2008 04:49:40.0795 (UTC) FILETIME=[B3A918B0:01C85A56]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix information leak in CIFS client lookup

Putting arbitary file names on lookup failures into the system log is not
a good idea, because usually everybody can read dmesg and that is thus
an information leak if a directory was read protected.

Also changed the error printout for this case to a signed number, because
it is normally negative and that makes it easier to read.

I'm not sure the message is all that useful anyways. Perhaps it 
should be just removed completely? Or at least rate limited because
it allows to spam the kernel log nicely.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/fs/cifs/dir.c
===================================================================
--- linux.orig/fs/cifs/dir.c
+++ linux/fs/cifs/dir.c
@@ -518,7 +518,7 @@ cifs_lookup(struct inode *parent_dir_ino
 	/*	if it was once a directory (but how can we tell?) we could do
 		shrink_dcache_parent(direntry); */
 	} else {
-		cERROR(1, ("Error 0x%x on cifs_get_inode_info in lookup of %s",
+		cERROR(1, ("Error %d on cifs_get_inode_info in lookup of file",
 			   rc, full_path));
 		/* BB special case check for Access Denied - watch security
 		exposure of returning dir info implicitly via different rc
