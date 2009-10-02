Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbZJBPmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZJBPmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 11:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbZJBPmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 11:42:12 -0400
Received: from mfbichi11.ns.itscom.net ([219.110.2.189]:45629 "EHLO
	mfbichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbZJBPmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 11:42:09 -0400
X-Greylist: delayed 644 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Oct 2009 11:42:08 EDT
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC] Union mounts/writable overlays design 
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       Arnd Bergmann <arnd@arndb.de>, Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091001145547.GA29152@shell>
References: <20091001145547.GA29152@shell>
Date: Sat, 03 Oct 2009 00:30:42 +0900
Message-ID: <15604.1254497442@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Valerie Aurora:
> Writable overlays (formerly union mounts)
> =========================================
> 
> In this document:
>  - Overview of writable overlays
>  - Terminology
>  - VFS implementation
	:::

While I don't remember exactly when I first read the source files of
UnionMount, I think it is promising. And I have written to Val and Jan
some of my comments or reviews about UnionMount.
Recently I noticed another issue about stat(2) and mountpoint(1). The
latter is a part of 'initscripts' package.

For example,
- you have a union-ed directory, /u = /rw + /ro
- /ro/usr dir exists
- /rw/usr dir does NOT exist
- of course, /u/usr exists

As far as I know, UnionMount is expected to handle /u/usr directory
as if it exists under /u dir.
(I may be wrong since it totally depends upon the design of UnionMount)

In this case, stat(2) for /u and /u/usr will return different st_dev
from each other. eg. stat(/u/usr) returns the st_dev value of /ro,
stat(/u) returns the one for /rw.
This behaviour may make /bin/mountpoint confused, particulary in the
chroot/switch_root-ed environment.
/bin/mountpoint issues stat(2) for the specified dir and its parent, and
compares their st_dev. If they differ from each other, the utility
handles the specified dir as a "mountpoint". I am afraid it will make
some init-scripts crazy because /u/usr is NOT a mountpoint actually.

One possible solution will be setting a hook to vfs_stat(), which
handles the vfsmount set UNION flag differently and returns the pseudo
st_dev for the entires in UnionMount. But it may lead to the duplicated
inode number situation which may make applications crazy.
For instance,
- /ro/fileA is hardlinked to /ro/fileB.
- the inode number of them is i100.
- /rw/fileC is handlinked to /rw/fileD.
- the inode number of them is i100 too.

Since /ro and /rw are different, the same inode number is not a
problem natively. But if UnionMount takes an approach above, they all
have the same st_dev value. And I am afraid some applications may
handle them as a single hardlink unexpectedly.

So UnionMount should maintain its inode numbers by itself?
No, it goes to the filesystem-type implementation. It should not be the
way of UnionMount.
Are there any ideas to solve this problem?


J. R. Okajima
