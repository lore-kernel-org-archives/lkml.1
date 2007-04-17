Return-Path: <linux-kernel-owner+w=401wt.eu-S1161323AbXDQSPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161323AbXDQSPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 14:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161335AbXDQSPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 14:15:17 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45237 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161323AbXDQSPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 14:15:15 -0400
Date: Tue, 17 Apr 2007 13:15:00 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linuxram@us.ibm.com, devel@openvz.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, viro@ftp.linux.org.uk,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new namespace" clone flag
Message-ID: <20070417181500.GD14891@sergelap.austin.ibm.com>
References: <20070412203208.GG27772@sergelap.austin.ibm.com> <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com> <1176713221.9488.17.camel@ram.us.ibm.com> <E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu> <1176716941.9488.57.camel@ram.us.ibm.com> <E1HdNwV-0006l2-00@dorka.pomaz.szeredi.hu> <1176743669.9488.62.camel@ram.us.ibm.com> <E1HdVLi-0007oe-00@dorka.pomaz.szeredi.hu> <20070417170737.GA14891@sergelap.austin.ibm.com> <E1Hdrir-0002E8-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Hdrir-0002E8-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> > I'm a bit lost about what is currently done and who advocates for what.
> > 
> > It seems to me the MNT_ALLOWUSERMNT (or whatever :) flag should be
> > propagated.  In the /share rbind+chroot example, I assume the admin
> > would start by doing
> > 
> > 	mount --bind /share /share
> > 	mount --make-slave /share
> > 	mount --bind -o allow_user_mounts /share (or whatever)
> > 	mount --make-shared /share
> > 
> > then on login, pam does
> > 
> > 	chroot /share/$USER
> > 
> > or some sort of
> > 
> > 	mount --bind /share /home/$USER/root
> > 	chroot /home/$USER/root
> > 
> > or whatever.  In any case, the user cannot make user mounts except under
> > /share, and any cloned namespaces will still allow user mounts.
> 
> I don't quite understand your method.  This is how I think of it:
> 
> mount --make-rshared /
> mkdir -p /mnt/ns/$USER
> mount --rbind / /mnt/ns/$USER
> mount --make-rslave /mnt/ns/$USER

This was my main point - that the tree in which users can mount will be
a slave of /, so that propagating the "are user mounts allowed" flag
among peers is safe and intuitive.

> mount --set-flags --recursive -oallowusermnt /mnt/ns/$USER
> chroot /mnt/ns/$USER
> su - $USER
> 
> I did actually try something equivalent (without the fancy mount
> commands though), and it worked fine.  The only "problem" is the
> proliferation of mounts in /proc/mounts.  There was a recently posted
> patch in AppArmor, that at least hides unreachable mounts from
> /proc/mounts, so the user wouldn't see all those.  But it could still
> be pretty confusing to the sysadmin.
> 
> So in that sense doing it the complicated way, by first cloning the
> namespace, and then copying and sharing mounts individually which need
> to be shared could relieve this somewhat.

True.  But the kernel functionality you provide enables both ways so no
problem in either case :)

> Another point: user mounts under /proc and /sys shouldn't be allowed.
> There are files there (at least in /proc) that are seemingly writable
> by the user, but they are still not writable in the sense, that
> "normal" files are.

Good point.

> Anyway, there are lots of userspace policy issues, but those don't
> impact the kernel part.

Though it might make sense to enforce /proc and /sys not allowing user
mounts under them in the kernel.

> As for the original question of propagating the "allowusermnt" flag, I
> think it doesn't matter, as long as it's consistent and documented.
> 
> Propagating some mount flags and not propagating others is
> inconsistent and confusing, so I wouldn't want that.  Currently
> remount doesn't propagate mount flags, that may be a bug, dunno.

Dave, any thoughts on safety of propagating the vfsmount read-only
flags?

-serge
