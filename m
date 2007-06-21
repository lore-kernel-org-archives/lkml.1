Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbXFUQtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbXFUQtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbXFUQtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:49:10 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52507 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbXFUQtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:49:07 -0400
Date: Thu, 21 Jun 2007 11:49:07 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that through other means
Message-ID: <20070621164907.GB28311@sergelap.austin.ibm.com>
References: <467994BD.6000403@zytor.com> <20070620210343.GQ21478@ftp.linux.org.uk> <467AA3B4.6090609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467AA3B4.6090609@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting H. Peter Anvin (hpa@zytor.com):
> Al Viro wrote:
> > On Wed, Jun 20, 2007 at 01:57:33PM -0700, H. Peter Anvin wrote:
> >> ... or, alternatively, add a subfield to the first field (which would
> >> entail escaping whatever separator we choose):
> >>
> >> /dev/md6 /export ext3 rw,data=ordered 0 0
> >> /dev/md6:/users/foo /home/foo ext3 rw,data=ordered 0 0
> >> /dev/md6:/users/bar /home/bar ext3 rw,data=ordered 0 0
> > 
> > Hell, no.  The first field is in principle impossible to parse unless
> > you know the fs type.
> > 
> > How about making a new file with sane format?  From the very
> > beginning.  E.g. mountpoint + ID + relative path + type + options,
> > where ID uniquely identifies superblock (e.g. numeric st_dev)
> > and backing device (if any) is sitting among the options...
> 
> The more I'm thinking about this, I think it's simplest to just add
> fields to the right of the existing /proc/*/mounts.  Yes, the format is
> ugly, and it will end up being uglier still, but it's also ugly to have
> a bunch of different chunks of information formatted in different ways.

Since we're defining the order "arbitrarily" in any case, I really don't
think it's all that ugly.

Are there any existing tools which would not be able to handle the extra
fields?

(suppose it's easiest to just add the fields, try a few distros, and see
which balk)

> So, the existing fields are:
> 
> mnt_devname mnt_path filesystem_type options 0 0
> 
> ... and we'd want to add ...
> 
> mnt_id propagation_info sb_dev path_to_fs_root
> 
> As previously stated, in order to avoid having to expose kernel
> addresses to userspace, I suggest we simply add a counter field to
> struct vfsmount and use that for mnt_id.

Agreed - even if it weren't frowned upon to expose the kernel addresses,
it would just be much nicer to have easier to remember ids.  Somehow
with the kernel address, even with just a set of 5 of them printed in
front of me it takes me 2 minutes to figure out which ones are the
same...

> I'm not all that up on what is needed for propagation_info.  I presume
> we want to be able to deduce the full mount lattice.  One particularly

I think Ram's existing patches just provided "PEER (next-peer-id)" or
"SLAVE (master-id)".

> important thing in my mind is to be able to distinguish overmounted
> filesystems (which I think is possible in the current setup only by

What exactly do you mean here?  Do you mean information about stackable
filesystems - i.e. ecryptfs, unionfs, etc?

If so, maybe a last column which the fs itself can fill in with such
information is the best way to go then?  Ecryptfs would have just one
pathname to fill in (the location of the encrypted dir), unionfs might
have several (the full stack of unioned directories).

> ordering -- the filesystem on top I believe will end up last in
> /proc/mounts, but I don't know if there actually is anything that
> enforces that.)

Hmm, or do you actually mean that if i'd done

	mount --bind /tmp/a /tmp
	mount --bind /tmp/b /tmp
	mount --bind /tmp/c /tmp

that you would want to see information about the first two mounts?

-serge
