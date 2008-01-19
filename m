Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbYASWHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbYASWHN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 17:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYASWG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 17:06:59 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:28696 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbYASWG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 17:06:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DhE12gDga/TSgyRZXSuwMOZLX2hb5Ul1PDezWs1a5O0TJWHlyCi2rQ46d0MzAlcWiDf6+ZCOxA7mkZ5uJmCEcFJmes6524VS4Fmb7/Ab9Rcqzqy1QalJz0mnMrekcbsLboTfOlqzrs/L/2cHoaWbnR89hasZnX8za/NVAEZ8bQk=
Message-ID: <524f69650801191406j440e52afsb9b80efed4fa15da@mail.gmail.com>
Date: Sat, 19 Jan 2008 16:06:57 -0600
From: "Steve French" <smfrench@gmail.com>
To: simo <idra@samba.org>
Subject: Re: [linux-cifs-client] [PATCH] Remove information leak in Linux CIFS client
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, samba-technical@lists.samba.org
In-Reply-To: <1200730722.28706.70.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080119045552.GA11134@basil.nowhere.org>
	 <1200730722.28706.70.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The access denied message in the dmesg log reveals no more information
than strace on stat of a local file does (which also returns access
denied and displays access denied), but I agree that logging on
-EACCESS on lookup does clutter the log.

I think it is ok to log a message on unexpected errors (for
QueryPathInfo those would include anything other than ENOENT and
EACCESS - Simo, can you think of others?)  I don't mind ratelimiting
logging on this clause (for errors other than ENOENT and EACCESS) but
it would complicate the code for a case I have not seen in the wild.

I prefer the following to remove the log cluttering on this case:

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 37dc97a..b2802e5 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -517,12 +517,11 @@ cifs_lookup(struct inode *parent_dir_inode,
struct dentry *direntry,
                d_add(direntry, NULL);
        /*      if it was once a directory (but how can we tell?) we could do

                shrink_dcache_parent(direntry); */
-       } else {
+       } else if (rc != -EACCES) {

                cERROR(1, ("Error 0x%x on cifs_get_inode_info in lookup of %s",
                           rc, full_path));
-               /* BB special case check for Access Denied - watch security
-               exposure of returning dir info implicitly via different rc
-               if file exists or not but no access BB */
+               /* We special case check for Access Denied - since that
+               is a common return code */
        }

        kfree(full_path);

On Jan 19, 2008 2:18 AM, simo <idra@samba.org> wrote:
>
>
> On Sat, 2008-01-19 at 05:55 +0100, Andi Kleen wrote:
> > Fix information leak in CIFS client lookup
> >
> > Putting arbitary file names on lookup failures into the system log is not
> > a good idea, because usually everybody can read dmesg and that is thus
> > an information leak if a directory was read protected.
> >
> > Also changed the error printout for this case to a signed number, because
> > it is normally negative and that makes it easier to read.
> >
> > I'm not sure the message is all that useful anyways. Perhaps it
> > should be just removed completely? Or at least rate limited because
> > it allows to spam the kernel log nicely.
> >
> > Signed-off-by: Andi Kleen <ak@suse.de>
> >
> > Index: linux/fs/cifs/dir.c
> > ===================================================================
> > --- linux.orig/fs/cifs/dir.c
> > +++ linux/fs/cifs/dir.c
> > @@ -518,7 +518,7 @@ cifs_lookup(struct inode *parent_dir_ino
> >       /*      if it was once a directory (but how can we tell?) we could do
> >               shrink_dcache_parent(direntry); */
> >       } else {
> > -             cERROR(1, ("Error 0x%x on cifs_get_inode_info in lookup of %s",
> > +             cERROR(1, ("Error %d on cifs_get_inode_info in lookup of file",
> >                          rc, full_path));
>
> then please remove also full_path here ^^^^
>
> Simo.
>
> --
> Simo Sorce
> Samba Team GPL Compliance Officer <simo@samba.org>
> Senior Software Engineer at Red Hat Inc. <ssorce@redhat.com>
>
>



-- 
Thanks,

Steve
