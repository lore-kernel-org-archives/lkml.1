Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbXF3QOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbXF3QOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 12:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbXF3QOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 12:14:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbXF3QOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 12:14:20 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD 1/4] Pass no useless nameidata to the create, lookup, and permission IOPs
Date: Sat, 30 Jun 2007 18:13:57 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070626231510.883881222@suse.de> <20070626231541.697783295@suse.de> <20070630091302.GA21784@infradead.org>
In-Reply-To: <20070630091302.GA21784@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706301813.58435.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 June 2007 11:13, Christoph Hellwig wrote:
> We need something like this, but I don't quite like the way you've done
> it.  First the name is wrong, it's not a nameidata anymore but a lookup
> intent, so it should be named that way, struct lookup_intent.

Sure, that name was pretty random ... lookup_intent has gotten the majority of 
votes so far, and I'm perfectly fine with that.

> Second the macro hackery is more than ugly,  please keep the structures
> separate. With modern gcc it might be possible to embed the lookup_intent
> into the nameidata anonymously.

http://gcc.gnu.org/onlinedocs/gcc-4.2.0/gcc/Unnamed-Fields.html

If we can add the -fms-extensions gcc option we can get rid of the macro, and 
the code becomes pretty clean (as shown below). If we cannot add this option, 
then gcc would puke on ``struct lookup_intent;'' in the definition of struct 
nameidata. The macro is the cleanest way to work around this I could come up 
with, but maybe somebody knows another trick.

--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -14,14 +14,10 @@ struct open_intent {
 
 enum { MAX_NESTED_LINKS = 8 };
 
-struct nameidata {
+struct lookup_intent {
 	struct dentry	*dentry;
 	struct vfsmount *mnt;
-	struct qstr	last;
 	unsigned int	flags;
-	int		last_type;
-	unsigned	depth;
-	char *saved_names[MAX_NESTED_LINKS + 1];
 
 	/* Intent data */
 	union {
@@ -29,6 +25,19 @@ struct nameidata {
 	} intent;
 };
 
+struct nameidata {
+	struct lookup_intent;
+	struct qstr	last;
+	int		last_type;
+	unsigned	depth;
+	char *saved_names[MAX_NESTED_LINKS + 1];
+};

> Also please either remove the dentry from struct lookup_entry or from the
> direct argument list of the functions and methods - there is no need to pass
> this one twice.

The dentry in the lookup_intent of the create inode operation is the parent 
dentry right now, and the child dentry is passed as the separate parameter. I 
would prefer the cleaner interface in which the lookup_intent refers to the 
child dentry as well. (Getting from the child to the parent is trivial.) I 
guess this can go in an incremental patch with the next version of these 
patches.

Thanks,
Andreas
