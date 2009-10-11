Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbZJKBod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbZJKBod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 21:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbZJKBoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 21:44:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534AbZJKBob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 21:44:31 -0400
Date: Sat, 10 Oct 2009 21:43:39 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: hooanon05@yahoo.co.jp
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       Arnd Bergmann <arnd@arndb.de>, Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Union mounts/writable overlays design
Message-ID: <20091011014339.GB12667@shell>
References: <20091001145547.GA29152@shell> <15604.1254497442@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15604.1254497442@jrobl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 12:30:42AM +0900, hooanon05@yahoo.co.jp wrote:
> 
> Hi,
> 
> Valerie Aurora:
> > Writable overlays (formerly union mounts)
> > =========================================
> > 
> > In this document:
> >  - Overview of writable overlays
> >  - Terminology
> >  - VFS implementation
> 	:::
> 
> While I don't remember exactly when I first read the source files of
> UnionMount, I think it is promising. And I have written to Val and Jan
> some of my comments or reviews about UnionMount.
> Recently I noticed another issue about stat(2) and mountpoint(1). The
> latter is a part of 'initscripts' package.
> 
> For example,
> - you have a union-ed directory, /u = /rw + /ro
> - /ro/usr dir exists
> - /rw/usr dir does NOT exist
> - of course, /u/usr exists
> 
> As far as I know, UnionMount is expected to handle /u/usr directory
> as if it exists under /u dir.
> (I may be wrong since it totally depends upon the design of UnionMount)
> 
> In this case, stat(2) for /u and /u/usr will return different st_dev
> from each other. eg. stat(/u/usr) returns the st_dev value of /ro,
> stat(/u) returns the one for /rw.
> 
> This behaviour may make /bin/mountpoint confused, particulary in the
> chroot/switch_root-ed environment.
> /bin/mountpoint issues stat(2) for the specified dir and its parent, and
> compares their st_dev. If they differ from each other, the utility
> handles the specified dir as a "mountpoint". I am afraid it will make
> some init-scripts crazy because /u/usr is NOT a mountpoint actually.

In writable overlays, every directory will be copied up to the top
writable overlay, so /u and /u/usr will both have the same st_dev.
The copy up happens on lookup, so a stat() will trigger this copy up.
A directory and a regular file in it will have different st_dev's,
though.  Can you foresee any problems with that?

Thanks again,

-VAL

> One possible solution will be setting a hook to vfs_stat(), which
> handles the vfsmount set UNION flag differently and returns the pseudo
> st_dev for the entires in UnionMount. But it may lead to the duplicated
> inode number situation which may make applications crazy.
> For instance,
> - /ro/fileA is hardlinked to /ro/fileB.
> - the inode number of them is i100.
> - /rw/fileC is handlinked to /rw/fileD.
> - the inode number of them is i100 too.
> 
> Since /ro and /rw are different, the same inode number is not a
> problem natively. But if UnionMount takes an approach above, they all
> have the same st_dev value. And I am afraid some applications may
> handle them as a single hardlink unexpectedly.
> 
> So UnionMount should maintain its inode numbers by itself?
> No, it goes to the filesystem-type implementation. It should not be the
> way of UnionMount.
> Are there any ideas to solve this problem?
> 
> 
> J. R. Okajima
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
