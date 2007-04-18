Return-Path: <linux-kernel-owner+w=401wt.eu-S2992518AbXDROEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992518AbXDROEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992516AbXDROEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:04:51 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:44185 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992500AbXDROEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:04:50 -0400
To: trond.myklebust@fys.uio.no
CC: miklos@szeredi.hu, ebiederm@xmission.com, serue@us.ibm.com,
       linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, containers@lists.osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <1176904505.6796.79.camel@heimdal.trondhjem.org> (message from
	Trond Myklebust on Wed, 18 Apr 2007 09:55:05 -0400)
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new
	namespace" clone flag
References: <20070412164620.588752236@szeredi.hu>
	 <20070412203208.GG27772@sergelap.austin.ibm.com>
	 <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
	 <1176713221.9488.17.camel@ram.us.ibm.com>
	 <E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu>
	 <1176716941.9488.57.camel@ram.us.ibm.com>
	 <E1HdNwV-0006l2-00@dorka.pomaz.szeredi.hu>
	 <m18xcsl3yc.fsf@ebiederm.dsl.xmission.com>
	 <E1HdTag-0007bd-00@dorka.pomaz.szeredi.hu>
	 <m1zm58jfj3.fsf@ebiederm.dsl.xmission.com>
	 <20070416195652.GA350@sergelap.austin.ibm.com>
	 <m1k5wbjrsh.fsf@ebiederm.dsl.xmission.com>
	 <E1HdlYr-00015O-00@dorka.pomaz.szeredi.hu>
	 <m1zm56j27m.fsf@ebiederm.dsl.xmission.com>
	 <E1HdsX6-0002Kl-00@dorka.pomaz.szeredi.hu>
	 <m1vefuixp5.fsf@ebiederm.dsl.xmission.com>
	 <E1He6C7-0003Xu-00@dorka.pomaz.szeredi.hu> <1176904505.6796.79.camel@heimdal.trondhjem.org>
Message-Id: <E1HeAkl-000490-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 18 Apr 2007 16:03:23 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > I've tried to make this unprivileged mount thing as simple as
> > > > possible, and no simpler.  If we can make it even simpler, all the
> > > > better.
> > > 
> > > We are certainly much more complex then the code in plan9 (just
> > > read through it) so I think we have room for improvement.
> > > 
> > > Just for reference what I saw in plan 9 was:
> > > - No super user checks in it's mount, unmount, or namespace creation paths.
> > > - A flag to deny new mounts but not new bind mounts (for administrative purposes
> > >   the comment said).
> > > 
> > > Our differences from plan9.
> > > - suid capable binaries. (SUID please go away).
> > > - A history of programs assuming only root could call mount/unmount.
> > 
> > I hate suid as well.  _The_ motivation behind this patchset was to get
> > rid of "fusermount", a suid mount helper for fuse.
> > 
> > But I don't think suid is going away, and definitely not overnight.
> > Also I don't think we want to require auditing userspace before
> > enabling user mounts.
> > 
> > If I understand correctly, your proposal is to get rid of MNT_USER and
> > MNT_ALLOWUSERMNT and allow/deny unprivileged mounts and umounts based
> > on a boolean sysctl flag and on a check if the target namespace is the
> > initial namespace or not.  And maybe add some extra checks which
> > prevent ugliness from happening with suid programs.  Is this correct?
> > 
> > If so, how are we going to make sure this won't break existing
> > userspace without doing a full audit of all suid programs in every
> > distro that wants this feature?
> > 
> > Also how are we going to prevent the user from creating millions of
> > mounts, and using up all the kernel memory for vfsmounts?
> 
> Don't forget that almost all mount flags are per-superblock. How are you
> planning on dealing with the case that one user mounts a filesystem
> read-only, while another is trying to mount the same one read-write?

Yeah, I forgot, the per-mount read-only patches are not yet in.

That doesn't really change my agrument though.  _If_ the flag is per
mount, then it makes sense to be able to change it on a master and not
on a slave.  If mount flags are propagated, this is not possible.

Miklos
