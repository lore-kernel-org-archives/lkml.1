Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbZG0TP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbZG0TP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 15:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZG0TP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 15:15:29 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:60022 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZG0TP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 15:15:28 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Mon, 27 Jul 2009 13:14:53 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/2] implement uid mount option for ext2
In-reply-to: <200907251744.05444.ludwig.nussel@suse.de>
To: Ludwig Nussel <ludwig.nussel@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <20090727191453.GQ4231@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de>
 <1248431444-18842-2-git-send-email-ludwig.nussel@suse.de>
 <20090724165201.GA4231@webber.adilger.int>
 <200907251744.05444.ludwig.nussel@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 25, 2009  17:44 +0200, Ludwig Nussel wrote:
> Andreas Dilger wrote:
> > To be honest, rather than mapping the specified file to uid == 0/gid == 0
> > it would be more useful (and safe) to allow specifying a mapping from one
> > UID to another, or have the on-disk UID always be set to/from the specified
> > UID.  Given that your original problem is for the user having UIDX on
> > system X and UIDY on system Y, you should just specify the X->Y mapping
> > explicitly, instead of an implicit X->0 mapping.  Otherwise, if the user
> > is unable to access root-owned files on either one of system X or Y your
> > current patch fails.
> 
> That's unnecessarily complicated. You don't have to keep track of
> your user ids when using e.g. FAT formatted USB memory sticks
> either. The files just always magically appear to be owned by the
> user who mounted the file system. The goal is to have it just as
> simple with ext2 on the USB stick.

But that isn't how this patch works either.  It only makes files owned
by root available to the mounting user, and then (to add confusion)
files created by the user end up being owned by root.  That means it
won't be a generally useful feature until every system also has this
patch.  Also, by using root for the file owner you potentially expose
the system to more security risks compared to using any other user.

> If one of the systems doesn't mount media with the uid option the
> files might be unaccesible, that's true.

... but that is the whole point of this patch - to make files on the
device accessible between multiple systems, so if it doesn't do that
right out of the box it isn't a very useful feature.

> IOW on that system the situation is no different from
> today any you'll have to resort to the same workarounds you have to
> use today already (like sudo chown -R $USER or chmod 777).

But it also makes the problem worse, because the new files are owned
by root instead of either the UID on the original system or the UID
on the current system.


A more "obvious" solution would be to just have the filesystem mounted
with this option to make ALL files appear to be owned by the UID specified
to the "uid=${localuid}", which would at least more closely match the
behaviour of the fat/vfat filesystems with the uid= option.  New files
could be created using the local UID with no more effort than creating
them with uid=0, but there would be less surprise on another system if
files don't magically appear as owned by root.

My further suggestion was that if it is possible to optionally specify
the remote UID then at least one side does not have to have this patch
in order to mount and use the filesystem.  Hence, my suggestion to have
"uid={localuid}[={diskuid}]".  The [={diskuid}] part could be optional,
and doesn't add any significant complication to the patch, AFAICS.
Initialize the diskuid = localuid, and if the additional diskuid is given
use that instead, for all inodes written to the disk.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

