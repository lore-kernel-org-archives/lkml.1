Return-Path: <linux-kernel-owner+w=401wt.eu-S1751720AbXCDPU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbXCDPU5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 10:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932817AbXCDPU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 10:20:57 -0500
Received: from wx-out-0506.google.com ([66.249.82.235]:7778 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbXCDPU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 10:20:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=FUTUE7ucJFmsJ+lqIfM7XtRNdRLiheVclGfXL/HLCPzWTThSfWBEgGCdM9neRqFRoAS8dfTRB1Ue2mhWPjyFRFJnPRY29cR3IPCGgUJz3UfkY2pHOn2F0/qNggtWMDLHmnif8QIYuJyhrsQ6Iktl5erUWnz1VgDUqZVjFMl5s0Y=
Date: Mon, 5 Mar 2007 00:16:59 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Joel Becker <joel.becker@oracle.com>
Subject: Re: [PATCH] configfs: add missing mutex_unlock()
Message-ID: <20070304151659.GA19972@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	Joel Becker <joel.becker@oracle.com>
References: <20070304133812.GC8519@APFDCB5C> <200703041510.20127.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200703041510.20127.arnd@arndb.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 03:10:19PM +0100, Arnd Bergmann wrote:
> On Sunday 04 March 2007 14:38:12 Akinobu Mita wrote:
> > @@ -1168,8 +1168,10 @@ int configfs_register_subsystem(struct c
> >  
> >         err = -ENOMEM;
> >         dentry = d_alloc(configfs_sb->s_root, &name);
> > -       if (!dentry)
> > +       if (!dentry) {
> > +               mutex_unlock(&configfs_sb->s_root->d_inode->i_mutex);
> >                 goto out_release;
> > +       }
> >  
> >         d_add(dentry, NULL);
> 
> This should be changed to jump to a new exit point, before the mutex_unlock
> at the end of the function. Having multiple places in the function that
> release the same lock easily leads to the kind of bug you are fixing here.

Agreed. Please see the patch below (untested).

Index: 2.6-mm/fs/configfs/dir.c
===================================================================
--- 2.6-mm.orig/fs/configfs/dir.c
+++ 2.6-mm/fs/configfs/dir.c
@@ -1169,25 +1169,26 @@ int configfs_register_subsystem(struct c
 	err = -ENOMEM;
 	dentry = d_alloc(configfs_sb->s_root, &name);
 	if (!dentry)
-		goto out_release;
+		goto out_unlock;
 
 	d_add(dentry, NULL);
 
 	err = configfs_attach_group(sd->s_element, &group->cg_item,
 				    dentry);
-	if (!err)
-		dentry = NULL;
-	else
-		d_delete(dentry);
+	if (err)
+		goto out_d_delete;
 
 	mutex_unlock(&configfs_sb->s_root->d_inode->i_mutex);
 
-	if (dentry) {
-	    dput(dentry);
-out_release:
-	    unlink_group(group);
-	    configfs_release_fs();
-	}
+	return 0;
+
+out_d_delete:
+	d_delete(dentry);
+	dput(dentry);
+out_unlock:
+	mutex_unlock(&configfs_sb->s_root->d_inode->i_mutex);
+	unlink_group(group);
+	configfs_release_fs();
 
 	return err;
 }
