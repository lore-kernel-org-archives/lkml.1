Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYLBTit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYLBTit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbYLBTij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:38:39 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:38139 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbYLBTii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:38:38 -0500
Date: Tue, 02 Dec 2008 12:38:20 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: Support for applications which need NFS or CIFS "share_deny"	flags
 on open
In-reply-to: <524f69650812020831q4e089b87k9a8306ac37f4234a@mail.gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
Message-id: <20081202193819.GJ3186@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <524f69650812020831q4e089b87k9a8306ac37f4234a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 02, 2008  10:31 -0600, Steve French wrote:
> Some of the Wine community posted last month to the cifs mailing list
> asking about a change needed for Wine for working properly over
> network mounts, but the change is not really cifs specific and would
> help other file systems as well so I wanted to mention it here.   The
> original post was:
> http://marc.info/?l=linux-cifs-client&m=122505569315992&w=2
> 
> Support for the flags they suggest would be easy for cifs (the
> protocol has a field for this, and cifs clients on various other OS
> set it), and should be fairly easy for NFSv4 (the RFC for NFSv4
> specifies the "share_deny" field within the NFS open request, and
> various clients, but not Linux, set it), and would allow WINE to
> function properly over a network mount.
> 
> >we proffer to add into the file /usr/include/asm-generic/fcntl.h
> > following flags:
> >
> >#define O_DENYREAD      004000000 /* Do not permit read access */
> >#define O_DENYWRITE     010000000 /* Do not permit write access */
> >#define O_DENYDELETE  020000000 /* Do not permit delete or rename
> > operations*/
> 
> Presumably for applications on local mounts, wine mediates their own
> mandatory locks, but this is impossible on network mounts without this
> change (and can lead to data corruption).

This is a disaster waiting to happen, and I would be against adding
such functionality to Linux.  It would allow userspace applications
to implement a denial of service to any file that they can open (e.g.
open("/lib/libc-2.7.so", O_DENYREAD) would be really bad :-).

It was always also a pain in the ass on Windows systems (back when I used
them) that backing up the filesystem would fail because something (app or
kernel) had files open in this mode and the backup tool couldn't even read
them to do the backup.  In some cases these files were opened very early
in boot and the only way to do a full backup was to boot from a separate
device and run the backup.  Not my idea of fun.

I can't see any reason for O_DENYREAD or O_DENYWRITE that can't be met
with existing file locking to maintain coherency if that is really needed.
As for O_DENYDELETE - wouldn't that be irrelevant if the WINE code keeps
an open file reference?  The data would still be accessible until WINE
exits, and it wouldn't be a DOS.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

