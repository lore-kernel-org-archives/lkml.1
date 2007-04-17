Return-Path: <linux-kernel-owner+w=401wt.eu-S1161333AbXDQU0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161333AbXDQU0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 16:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161331AbXDQU0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 16:26:55 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35327 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161327AbXDQU0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 16:26:53 -0400
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new
	namespace" clone flag
From: Ram Pai <linuxram@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, devel@openvz.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, viro@ftp.linux.org.uk,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <E1Hdtai-0002Ri-00@dorka.pomaz.szeredi.hu>
References: <20070412164541.580374744@szeredi.hu>
	 <20070412164620.588752236@szeredi.hu>
	 <20070412203208.GG27772@sergelap.austin.ibm.com>
	 <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
	 <1176713221.9488.17.camel@ram.us.ibm.com>
	 <E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu>
	 <1176716941.9488.57.camel@ram.us.ibm.com>
	 <E1HdNwV-0006l2-00@dorka.pomaz.szeredi.hu>
	 <1176743669.9488.62.camel@ram.us.ibm.com>
	 <E1HdVLi-0007oe-00@dorka.pomaz.szeredi.hu>
	 <20070417170737.GA14891@sergelap.austin.ibm.com>
	 <E1Hdrir-0002E8-00@dorka.pomaz.szeredi.hu>
	 <1176838111.2813.109.camel@ram.us.ibm.com>
	 <E1Hdtai-0002Ri-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 13:25:04 -0700
Message-Id: <1176841504.2813.124.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 21:43 +0200, Miklos Szeredi wrote:
> > > > I'm a bit lost about what is currently done and who advocates for what.
> > > > 
> > > > It seems to me the MNT_ALLOWUSERMNT (or whatever :) flag should be
> > > > propagated.  In the /share rbind+chroot example, I assume the admin
> > > > would start by doing
> > > > 
> > > > 	mount --bind /share /share
> > > > 	mount --make-slave /share
> > > > 	mount --bind -o allow_user_mounts /share (or whatever)
> > > > 	mount --make-shared /share
> > > > 
> > > > then on login, pam does
> > > > 
> > > > 	chroot /share/$USER
> > > > 
> > > > or some sort of
> > > > 
> > > > 	mount --bind /share /home/$USER/root
> > > > 	chroot /home/$USER/root
> > > > 
> > > > or whatever.  In any case, the user cannot make user mounts except under
> > > > /share, and any cloned namespaces will still allow user mounts.
> > > 
> > > I don't quite understand your method.  This is how I think of it:
> > > 
> > > mount --make-rshared /
> > > mkdir -p /mnt/ns/$USER
> > > mount --rbind / /mnt/ns/$USER
> > > mount --make-rslave /mnt/ns/$USER
> > > mount --set-flags --recursive -oallowusermnt /mnt/ns/$USER
> > > chroot /mnt/ns/$USER
> > > su - $USER
> > > 
> > > I did actually try something equivalent (without the fancy mount
> > > commands though), and it worked fine.  The only "problem" is the
> > > proliferation of mounts in /proc/mounts.  There was a recently posted
> > > patch in AppArmor, that at least hides unreachable mounts from
> > > /proc/mounts, so the user wouldn't see all those.  But it could still
> > > be pretty confusing to the sysadmin.
> > 
> > unbindable mounts were designed to overcome the proliferation problem.
> > 
> > Your steps should be something like this:
> > 
> > mount --make-rshared /
> > mkdir -p /mnt/ns
> > mount --bind /mnt/ns /mnt/ns
> > mount --make-unbindable /mnt/ns
> > mkdir -p /mnt/ns/$USER
> > mount --rbind / /mnt/ns/$USER
> > mount --make-rslave /mnt/ns/$USER
> > mount --set-flags --recursive -oallowusermnt /mnt/ns/$USER
> > chroot /mnt/ns/$USER
> > su - $USER
> > 
> > try this and your proliferation problem will disappear. :-)
> 
> Right, this is needed.
> 
> My problem wasn't actually this (which would only have hit, if I tried
> with more than one user), just that the number of mounts in
> /proc/mounts grows linearly with the number of users.
> 
> That can't be helped in such an easy way unfortunately.
> 
> > > Propagating some mount flags and not propagating others is
> > > inconsistent and confusing, so I wouldn't want that.  Currently
> > > remount doesn't propagate mount flags, that may be a bug, 
> > 
> > For consistency reason, one can propagate all the flags. But
> > propagating only those flags that interfere with shared-subtree
> > semantics should suffice.
> 
> I still don't believe not propagating "allowusermnt" interferes with
> mount propagation.  In my posted patches the mount (including
> propagations) is allowed based on the "allowusermnt" flag on the
> parent of the requested mount.  The flag is _not_ checked during
> propagation.
> 
> Allowing this and other flags to NOT be propagated just makes it
> possible to have a set of shared mounts with asymmetric properties,
> which may actually be desirable.

The shared mount feature was designed to ensure that the mount remained
identical at all the locations. Now designing features 
to make it un-identical but still naming it shared, will break its
original purpose.  Slave mounts were designed to make it asymmetric.

Whatever feature that is desired to be exploited; can that be exploited
with the current set of semantics that we have? Is there a real need to
make the mounts asymmetric but at the same time name them as shared?
Maybe I dont understand what the desired application is? 

RP

> 
> Miklos

