Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbZGYPoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbZGYPoL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 11:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbZGYPoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 11:44:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:59356 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZGYPoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 11:44:09 -0400
From: Ludwig Nussel <ludwig.nussel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/2] implement uid mount option for ext2
Date: Sat, 25 Jul 2009 17:44:05 +0200
User-Agent: KMail/1.9.9
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de> <1248431444-18842-2-git-send-email-ludwig.nussel@suse.de> <20090724165201.GA4231@webber.adilger.int>
In-Reply-To: <20090724165201.GA4231@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907251744.05444.ludwig.nussel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger wrote:
> On Jul 24, 2009  12:30 +0200, Ludwig Nussel wrote:
> > @@ -1353,7 +1356,13 @@ int ext2_write_inode(struct inode *inode, int do_sync)
> >  
> >  	ext2_get_inode_flags(ei);
> >  	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
> > +	if (EXT2_SB(sb)->s_uid &&
> > +	    inode->i_uid == EXT2_SB(sb)->s_uid) {
> > +		raw_inode->i_uid_high = 0;
> > +		raw_inode->i_uid_low  = 0;
> > +		raw_inode->i_gid_high = 0;
> > +		raw_inode->i_gid_low  = 0;
> 
> I would suggest to also clear the SUID flag on this inode.  Otherwise,
> it opens the risk of creating SUID root files that might be handled
> incorrectly.

Doesn't really matter. The mount options nosuid,nodev are standard
for user mounts ever since people started using floppy disks :-)

> To be honest, rather than mapping the specified file to uid == 0/gid == 0
> it would be more useful (and safe) to allow specifying a mapping from one
> UID to another, or have the on-disk UID always be set to/from the specified
> UID.  Given that your original problem is for the user having UIDX on
> system X and UIDY on system Y, you should just specify the X->Y mapping
> explicitly, instead of an implicit X->0 mapping.  Otherwise, if the user
> is unable to access root-owned files on either one of system X or Y your
> current patch fails.

That's unnecessarily complicated. You don't have to keep track of
your user ids when using e.g. FAT formatted USB memory sticks
either. The files just always magically appear to be owned by the
user who mounted the file system. The goal is to have it just as
simple with ext2 on the USB stick. If one of the systems doesn't
mount media with the uid option the files might be unaccesible,
that's true. IOW on that system the situation is no different from
today any you'll have to resort to the same workarounds you have to
use today already (like sudo chown -R $USER or chmod 777).
 
> PS - please also send a patch for ext4.

One thing after another :-)

cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\   SUSE LINUX Products GmbH, Development
 V_/_  http://www.suse.de/

