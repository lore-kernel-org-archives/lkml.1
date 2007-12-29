Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbXL2Cxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbXL2Cxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXL2CxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:53:23 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:32802 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbXL2CxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:53:23 -0500
Date: Fri, 28 Dec 2007 18:53:22 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: David Newall <david@davidnewall.com>
cc: Mark Lord <lkml@rtr.ca>, Al Viro <viro@ftp.linux.org.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
In-Reply-To: <4768973C.8020909@davidnewall.com>
Message-ID: <alpine.DEB.0.999999.0712281835240.5207@twinlark.arctic.org>
References: <47684DBD.6030502@rtr.ca> <20071218230016.GF8181@ftp.linux.org.uk> <20071218231404.GG8181@ftp.linux.org.uk> <47689608.3030503@rtr.ca> <4768973C.8020909@davidnewall.com>
User-Agent: Alpine 0.999999 (DEB 847 2007-12-06)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007, David Newall wrote:

> Mark Lord wrote:
> > But.. pity there's no mount flag override for smaller systems,
> > where bind mounts might be more useful with link(2) actually working.
> 
> I don't see it.  You always can make hard link on the underlying filesystem.
> If you need to make it on the bound mount, that is, if you can't locate the
> underlying filesystem to make the hard link, you can use a symbolic link.

i run into it on a system where /home is a bind mount of /var/home ... i 
did this because:

- i prefer /home to be nosuid,nodev (multi-user system)
- i prefer /home to not be on same fs as /
- the system has only one raid1 array, and i can't stand having two 
  writable filesystems competing on the same set of spindles (i like to
  imagine that one fs competing for the spindles can potentially result
  in better seek patterns)
- i didn't want to do /var -> /home/var or vice versa ... because i don't 
  like seeing "/var/home/dean" when i'm in my home dir and such.
- i didn't want to try to balance disk space between /var and /home
- i didn't want to use a volume mgr just to handle disk space balance...

so i gave a bind mount a try.

i was surprised to see that mv(1) between /var and /home causes the file 
to be copied due to the link(1) failing...

it does seem like something which should be configurable per mount 
point... maybe that can be done with the patches i've seen going around 
supporting per-bind mount read-only/etc options?

-dean

p.s. in retrospect i probably could have arranged it more like this:

  mount /dev/md1 $tmpmntpoint
  mount --bind $tmpmntpoint/var /var
  mount --bind $tmpmntpoint/home /home
  umount $tmpmntpoint

except i can't easily specify that in fstab... and neither of the bind 
mounts would show up in df(1).  seems like it wouldn't be hard to support 
this type of subtree mount though.  mount(8) could support a single 
subtree mount using this technique but the second subtree mount attempt 
would fail because you can't temporarily remount the device because the 
mount point is gone.
