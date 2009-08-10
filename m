Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbZHJLxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbZHJLxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 07:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZHJLxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 07:53:40 -0400
Received: from tundra.namei.org ([65.99.196.166]:57177 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbZHJLxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 07:53:40 -0400
Date: Mon, 10 Aug 2009 21:53:01 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: iceberg <strakh@ispras.ru>
cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: BUG memory leakage at ./security/selinux/hooks.c
In-Reply-To: <200908101257.43672.strakh@ispras.ru>
Message-ID: <alpine.LRH.2.00.0908102152270.10706@tundra.namei.org>
References: <200908101257.43672.strakh@ispras.ru>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the report.  (Cc'd to the SELinux list).


On Mon, 10 Aug 2009, iceberg wrote:

>         KERNEL_VERSION: 2.6.30.4
>         SUBJECT:  in function inode_doinit_with_dentry memory is not released 
> on error  path (if rc<0).
>         DESCRIBE:
>         In ./security/selinux/hooks.c in function inode_doinit_with_dentry:
> 1. If in the line 1278 we successfully allocate memory and assign it to 
> context variablehen
> 2. if in the line 1284 getxattr returns -ERANGE and
> 3. if in the line 1288 getxattr returns rc<0
> then we go to out_unlock without releasing memory pointed to by context 
> variable.
> 
> 1278                 context = kmalloc(len, GFP_NOFS);
> 1279                 if (!context) {
> 1280                         rc = -ENOMEM;
> 1281                         dput(dentry);
> 1282                         goto out_unlock;
> 1283                 }
> 1284                 rc = inode->i_op->getxattr(dentry, XATTR_NAME_SELINUX,
> 1285                                            context, len);
> 1286                 if (rc == -ERANGE) {
> 1287                         /* Need a larger buffer.  Query for the
> right size. */
> 1288                         rc = inode->i_op->getxattr(dentry,
> XATTR_NAME_SELINUX,
> 1289                                                    NULL, 0);
> 1290                         if (rc < 0) {
> 1291                                 dput(dentry);
> 1292                                 goto out_unlock;
> 1293                         }
> 1294                         kfree(context);
> 1295                         len = rc;
> 1296                         context = kmalloc(len, GFP_NOFS);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris@namei.org>
