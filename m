Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbXFYTNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbXFYTNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 15:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbXFYTNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 15:13:33 -0400
Received: from smtp108.plus.mail.re1.yahoo.com ([69.147.102.71]:44421 "HELO
	smtp108.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755288AbXFYTNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 15:13:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=lKtmUg3gs5oap5LerreL8Hf1duvwQcNwGdr8/Zz7vmKUIBQfHFsgahdyUd8+ZZzejGNFV5FVsCo/jHsNkgNqn/pESYsKswyZl1c9OrXOX4vGPUHxVi8DB1Pqu51GxwAm7ZVGHbUeAh9nbhxZjTx9k+KIAZM19bWRLbppZR/t0po=  ;
X-YMail-OSG: j9vJiq4VM1kCNXWjPhY3JEjZnj1CTZdxP9yuQ23iQ3qfVkxMghNdIo9Ms2_j9_ZZ_lV.F_DSYw--
Date: Mon, 25 Jun 2007 21:06:36 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] update description in Documentation/filesystems/vfs.txt (typo fixed)
Message-ID: <20070625190636.GA30724@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070624122116.GA8067@gollum.tnic> <w10qlMfE.1182764076.1306850.penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <w10qlMfE.1182764076.1306850.penberg@cs.helsinki.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 12:34:36PM +0300, Pekka Enberg wrote:
> 
> Hi Borislav,
> 
> On 6/24/2007, "Borislav Petkov" <bbpetkov@yahoo.de> wrote:
> > @@ -3,7 +3,7 @@
> > 
> >  	Original author: Richard Gooch <rgooch@atnf.csiro.au>
> > 
> > -		  Last updated on October 28, 2005
> > +		  Last updated on Juni 24, 2007.
> 
> There's a typo here so do s/Juni/June/g please before sending to Andrew.
> Other than that, looks good to me.
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>


Index: linux-2.6.22-rc5/Documentation/filesystems/vfs.txt
===================================================================
--- linux-2.6.22-rc5/Documentation/filesystems/vfs.txt.orig	2007-06-24 13:42:40.000000000 +0200
+++ linux-2.6.22-rc5/Documentation/filesystems/vfs.txt	2007-06-24 14:14:48.000000000 +0200
@@ -3,7 +3,7 @@
 
 	Original author: Richard Gooch <rgooch@atnf.csiro.au>
 
-		  Last updated on October 28, 2005
+		  Last updated on June 24, 2007.
 
   Copyright (C) 1999 Richard Gooch
   Copyright (C) 2005 Pekka Enberg
@@ -107,7 +107,7 @@
 struct file_system_type
 -----------------------
 
-This describes the filesystem. As of kernel 2.6.13, the following
+This describes the filesystem. As of kernel 2.6.22, the following
 members are defined:
 
 struct file_system_type {
@@ -119,6 +119,8 @@
         struct module *owner;
         struct file_system_type * next;
         struct list_head fs_supers;
+	struct lock_class_key s_lock_key;
+	struct lock_class_key s_umount_key;
 };
 
   name: the name of the filesystem type, such as "ext2", "iso9660",
@@ -137,11 +139,12 @@
 
   next: for internal VFS use: you should initialize this to NULL
 
+  s_lock_key, s_umount_key: lockdep-specific
+
 The get_sb() method has the following arguments:
 
-  struct super_block *sb: the superblock structure. This is partially
-	initialized by the VFS and the rest must be initialized by the
-	get_sb() method
+  struct file_system_type *fs_type: decribes the filesystem, partly initialized
+  	by the specific filesystem code
 
   int flags: mount flags
 
@@ -150,12 +153,13 @@
   void *data: arbitrary mount options, usually comes as an ASCII
 	string
 
-  int silent: whether or not to be silent on error
+  struct vfsmount *mnt: a vfs-internal representation of a mount point
 
 The get_sb() method must determine if the block device specified
-in the superblock contains a filesystem of the type the method
-supports. On success the method returns the superblock pointer, on
-failure it returns NULL.
+in the dev_name and fs_type contains a filesystem of the type the method
+supports. If it succeeds in opening the named block device, it initializes a
+struct super_block descriptor for the filesystem contained by the block device.
+On failure it returns an error.
 
 The most interesting member of the superblock structure that the
 get_sb() method fills in is the "s_op" field. This is a pointer to

-- 
Regards/Gruﬂ,
    Boris.
