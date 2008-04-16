Return-Path: <linux-kernel-owner+w=401wt.eu-S1762896AbYDPRs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762896AbYDPRs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYDPRsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:48:00 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:64584 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbYDPRr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:47:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=pTnkEf72RnQt/YuMZiJDr3ZETnPr1Ref2B0C0/P4EYldDfZURWKsePovwzVzIw6jGPmf9uHHvljSNXUMTyb3cwU2+UOIQc1dTdKJYc9CAjuBOvDG4MuSgQlbvwT03VhIAq7fW3ulskWWI0Z+PPzA/Pz7fJZOZjyGgrTkNRprUEE=
References: <20080416174421.442716301@gmail.com>>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 21:44:22 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: bfields@fieldses.org, neilb@suse.de, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, kkeil@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 1/3] NFS: fix potential NULL pointer dereference
Content-Disposition: inline; filename=nfs-kstrdup-nul-fix
Message-ID: <48063bc9.2234440a.747d.09ea@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible to get NULL pointer dereference
if kstrndup failed

Here is a possible scenario

nfs4_get_sb
  nfs4_validate_mount_data
    o kstrndup failed so args->nfs_server.export_path = NULL
  nfs4_create_server
    nfs4_path_walk(..., NULL) -> Oops!

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

Index: linux-2.6.git/fs/nfs/super.c
===================================================================
--- linux-2.6.git.orig/fs/nfs/super.c	2008-04-15 23:01:30.000000000 +0400
+++ linux-2.6.git/fs/nfs/super.c	2008-04-16 20:01:44.000000000 +0400
@@ -1858,6 +1858,8 @@ static int nfs4_validate_mount_data(void
 		if (len > NFS4_MAXPATHLEN)
 			return -ENAMETOOLONG;
 		args->nfs_server.export_path = kstrndup(c, len, GFP_KERNEL);
+		if (!args->nfs_server.export_path)
+			return -ENOMEM;
 
 		dprintk("NFS: MNTPATH: '%s'\n", args->nfs_server.export_path);

-- 
