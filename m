Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbXLKVg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbXLKVg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 16:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXLKVgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 16:36:17 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:44455 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbXLKVgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 16:36:16 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Howells <dhowells@redhat.com>
Cc: Karl MacMillan <kmacmill@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <9789.1197405725@redhat.com>
References: <1197401823.28006.74.camel@moss-spartans.epoch.ncsc.mil>
	 <1197322068.18120.176.camel@moss-spartans.epoch.ncsc.mil>
	 <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil>
	 <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil>
	 <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
	 <20071205193859.24617.36392.stgit@warthog.procyon.org.uk>
	 <25037.1197306473@redhat.com> <25572.1197320887@redhat.com>
	 <25965.1197329769@redhat.com>   <9789.1197405725@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 11 Dec 2007 16:34:07 -0500
Message-Id: <1197408847.28006.184.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-11 at 20:42 +0000, David Howells wrote:
> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > > That sounds too SELinux specific.  How do I do it so that it works for any
> > > LSM?
> > 
> > You can't.  There is no LSM for userspace; LSM specifically disavowed
> > any common userspace API, and that was one of our original
> > objections/concerns about it.
> 
> So, basically, userspace programs (outside of security tools) aren't supposed
> to need access to the security infrastructure?

I didn't say that.  I said that LSM provides no standard way for
userspace to access the security infrastructure, at least beyond the
raw /proc/self/attr and xattr APIs, and I view that as a defect in LSM.
SELinux does have a userspace API, because we think there should be a
way for userspace to do that, and it is being used by userspace programs
outside of security tools.

> > > Is linking against libselinux is a viable option if it's not available under
> > > all LSM models?  Is it available under all LSM models?  Perhaps Casey can
> > > answer this one.
> > 
> > Nope, they would all have their own libraries, if they have a library at
> > all.  But that isn't your problem
> 
> It is if I have to maintain a special pieces of code for each possible LSM.
> One piece for SELinux, one piece for AppArmour, one piece for Smack, one piece
> for Casey's security system.  That sounds like a pain.

All your code has to do is invoke a function provided by libselinux.  If
at some later time a liblsm is introduced that provides a common
front-end to a libselinux, libsmack, ..., then you can use that.  But it
doesn't exist today.   But it all just becomes a simple function call
regardless.

> > - your kernel interface should be generic, and your LSM hooks should be
> > generic, but your userspace isn't required to be.  Have a look at how many
> > programs in the distribution currently link against libselinux, whether
> > directly or by dlopen'ing it.
> 
> In /usr/bin ldd reports approximately 297 binaries link to libselinux, though
> I can't say how many of those linked against it directly rather than picking
> it up by contamination through a shared library.  Furthermore, I've no idea
> how many more find it by dlopen.

The point being that userspace is already using the SELinux API directly
- cachefilesd certainly won't be the first or most crucial application
to do so.

> > > > > I use to do that, but someone objected...  Possibly Karl MacMillan.
> > > > 
> > > > Yes, but I think I disagreed then too.
> > > 
> > > So, who's right?
> > 
> > Karl isn't a maintainer of the SELinux kernel code.  And I had thought
> > that even he had reconsidered this idea after further discussion.
> 
> Not that I know of.

Well, he can speak to that.  But regardless, he isn't the maintainer.

> > > > It doesn't fit with how other users of security_kernel_act_as() will
> > > > likely want to work (they will want to just set the context to a
> > > > specified value, whether one obtained from the client or from some local
> > > > source), nor with how type transitions normally work (exec, with the
> > > > program type as the second type field).  I think it will just cause
> > > > confusion and subtle breakage.
> > > 
> > > It's causing me lots of confusion as it is.  I have been / am being told by
> > > different people to do different things just in dealing with SELinux, and
> > > various people are raising extra requirements or restrictions beyond that.
> > > There doesn't seem to be a consensus.
> > > 
> > > It sounds like the best option is just to have the kernel nick the userspace
> > > daemon's security context and use that as is, and junk all the restrictions on
> > > what the daemon can do so that the kernel isn't too restricted.
> > 
> > Well, you could do that, if that meets your needs, but it doesn't sound
> > very optimal either.
> 
> True.  I'd rather have separate security for each.
> 
> > Why are you opposed to having userspace determine the context and write it
> > to a cachefiles interface,
> 
> Because, from what I gather, that means my userspace program needs to do
> something different, depending on the security model that's currently in force
> on a system.  Furthermore, I would have to have separate code, as far as I
> know, for each security model as there's no commonality in userspace.
>
> I can't just link against libselinux.  It might not be there.  I'm not going
> to tie my program to SELinux either.

You can certainly make the linking conditional at compile time based on
a build flag, and/or you can dlopen it at runtime and fall back
gracefully if not present.  It isn't tying your program to libselinux,
just using it if present, in this case to obtain an input to supply to
your kernel module so that the "policy" of deciding what context to use
is completely determined in userspace and not hardcoded at all into the
kernel.  If init and ls and ps can do it, cachefilesd can too.

> Furthermore, I worked out "the right way to do this" with some apparent
> SELinux person, and you seemed reasonably accepting of it.  Now I have to go
> and redo all the work, having had to redo the security stuff a couple of times
> already because someone objected.  *That* is the main obstacle to getting my
> code accepted at the moment, I think.

I did express reservations about it, and I really don't think that this
is the main obstacle - the determination of the acting task security
label and how to set it is really only a small part of your patch set,
and considerably less disruptive than the rest of it.

> How about I just stick the context in /etc/cachefilesd.conf as a textual
> configuration item and have the daemon pass that as a string to the cachefiles
> kernel module, which can then ask LSM if it's valid to set this context as an
> override, given the daemon's own security context?  That seems entirely
> reasonable to me.

That mostly works, but it means that an update to policy may require an
update to /etc/cachefilesd.conf, or that switching from one policy to
another might likewise require changing that file.  Versus using a
separate policy-provided config file for the label.

BTW, as should be obvious, some LSMs aren't label-based at all, so it
would need to be optional.

-- 
Stephen Smalley
National Security Agency

