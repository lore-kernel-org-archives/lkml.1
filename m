Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbZGXQwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbZGXQwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZGXQwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:52:34 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:38711 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbZGXQwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:52:33 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Fri, 24 Jul 2009 10:52:01 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/2] implement uid mount option for ext2
In-reply-to: <1248431444-18842-2-git-send-email-ludwig.nussel@suse.de>
To: Ludwig Nussel <ludwig.nussel@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <20090724165201.GA4231@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de>
 <1248431444-18842-1-git-send-email-ludwig.nussel@suse.de>
 <1248431444-18842-2-git-send-email-ludwig.nussel@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 24, 2009  12:30 +0200, Ludwig Nussel wrote:
> @@ -1353,7 +1356,13 @@ int ext2_write_inode(struct inode *inode, int do_sync)
>  
>  	ext2_get_inode_flags(ei);
>  	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
> +	if (EXT2_SB(sb)->s_uid &&
> +	    inode->i_uid == EXT2_SB(sb)->s_uid) {
> +		raw_inode->i_uid_high = 0;
> +		raw_inode->i_uid_low  = 0;
> +		raw_inode->i_gid_high = 0;
> +		raw_inode->i_gid_low  = 0;

I would suggest to also clear the SUID flag on this inode.  Otherwise,
it opens the risk of creating SUID root files that might be handled
incorrectly.

To be honest, rather than mapping the specified file to uid == 0/gid == 0
it would be more useful (and safe) to allow specifying a mapping from one
UID to another, or have the on-disk UID always be set to/from the specified
UID.  Given that your original problem is for the user having UIDX on
system X and UIDY on system Y, you should just specify the X->Y mapping
explicitly, instead of an implicit X->0 mapping.  Otherwise, if the user
is unable to access root-owned files on either one of system X or Y your
current patch fails.

I would have the option be something like "uid={local_uid}={disk_uid}"
(which hopefully the option parser can handle), or "uid=X:Y" if not.
That way, the on-disk filesystem will remain correct for at least one
of the two systems.  If someone wants to specify disk_uid=0 that is
fine, but it shouldn't be the only option.

PS - please also send a patch for ext4.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

