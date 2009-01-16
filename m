Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbZAPIE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbZAPIE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbZAPIEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:04:46 -0500
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:41165 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbZAPIEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:04:45 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [Ecryptfs-devel] [PATCH] ecryptfs: some inode attrs, and a question 
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
In-Reply-To: <496FAFE2.8020102@linux.vnet.ibm.com>
References: <7471.1231827621@jrobl> <1231852628.6954.4.camel@norville.austin.ibm.com> <496FAFE2.8020102@linux.vnet.ibm.com>
Date: Fri, 16 Jan 2009 17:04:38 +0900
Message-ID: <10085.1232093078@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tyler Hicks:
> >> - remove the unnecessary d_drop()s in ecryptfs_link().
> 
> I tend to agree that they look unnecessary, but one of them was added
> for cifs (see ae56fb16) and the other two seem to be intentional (see
> 45ec4aba) as well.  I'm working on adding support for networked
> filesystems, I'll keep these d_drop()s in mind and see if we can drop
> them. :)

commit ae56fb16337c882c52806508f93ead4034004c7a
    When CIFS is the lower filesystem, the old lower dentry needs to be explicitly
    dropped from inside eCryptfs to force a revalidate.  In addition, when CIFS is
    the lower filesystem, the inode attributes need to be copied back up from the
    lower inode to the eCryptfs inode on an eCryptfs revalidate.

Even with this commit, fstat(2) still returns incorrect attributes,
doesn't it? Because fstat(2) doesn't involve revalidate.
{
	fd = open(fileA);
	link(fileA, fileB);
	fstat(fd);
}


commit 45ec4ababe999cb95f9c0cad03b2689cb0b77a2b
    Fix the use of dget/dput calls to balance out on the lower filesystem.
	:::
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 2f2c6cf..ff4865d 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
	:::
@@ -475,8 +470,8 @@ out_lock:
 	unlock_dir(lower_dir_dentry);
 	dput(lower_new_dentry);
 	dput(lower_old_dentry);
-	if (!new_dentry->d_inode)
-		d_drop(new_dentry);
+	d_drop(new_dentry);
+	d_drop(old_dentry);
 	return rc;
 }
 
Are these two d_drop()s really intentional?
I don't understand why they are necessary after the success of link.
It might be the same to the commit ae56fb16 (see above), ie. wanting to
force re-lookup and get the latest inode attributes. (Just a guess)
Actually they are maintained in ecryptfs_link() correctly...


J. R. Okajima
