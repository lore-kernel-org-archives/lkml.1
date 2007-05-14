Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbXENNuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbXENNuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 09:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbXENNuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 09:50:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:51757 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbXENNuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 09:50:01 -0400
Date: Mon, 14 May 2007 06:50:16 -0700
From: John Johansen <jjohansen@suse.de>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 00/45] AppArmor security module overview
Message-ID: <20070514135016.GB5877@suse.de>
References: <20070514110607.549397248@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <20070514110607.549397248@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

and with the actual introductory text this time

This post contains patches to include the AppArmor application security
framework, with request for inclusion.  It contains fixes for almost
all of the feedback received from the previous post.  A second follow
up posting will address passing NULL nameidata.

Changes since previous post:

 - Refactor d_path() patches: Separate changes to d_path(), getcwd(),
   and /proc/mounts from __d_path() cleanups.

 - Switch from file_permission() to vfs_permission() in do_path_lookup()
   and sys_fchdir(): this avoids calling permission() with a NULL nameidata
   there.

 - Fix file_permission() to not use NULL nameidata for its remaining users:
   it makes little sense to replace file_permission() with vfs_permission()
   everywhere.

 - Remove special casing for access to /proc/self/attr/current by adding
   rules to policy user side.

 - Remove redundant fn's in lsm.c by calling cap functions directly from
   the security operations vector.

 - Disallow ptracing process with different namespace.

 - Use beX_to_cpu instead on ntoX in dfa unpack code.

 - Fix potential overflow in unpack bounds checking.

 - Limit profile recursion depth to 1 level.

 - Factor out sysctl pathname code from selinux to add generic
   sysctl_pathname() function in kernel/sysctl.c. Replace special casing of
   sysctl write with finer grained mediation using sysctl_pathname() functi=
on
   to provide pathname for sysctl mediation.

 - Escape special characters in pathnames when used in audit messages.

 - Remove use of task->comm from audit messages.  The use of task->comm was
   incorrect and only used as a human readable hint.

 - Some structural cleanups on apparmors audit code paths.

 - Set LOOKUP_CONTINUE flag when checking parent permissions.  This allows
   permission functions to tell between parent and leaf checks. Check for
   (LOOKUP_PARENT | LOOKUP_CONTINUE) in the inode_permission apparmor hook.

 - Drop rejection of CLONE_NEWNS since the kernel already requires
   CAP_SYS_ADMIN.

 - Add a missing dput() in apparmorfs_detry_refcount().

 - remove kernel doc style comment header from comments that are not
   in kernel doc format

 - use lock subtyping to address lockdep reporint  possible irq lock
   inversion


The patch series consists of five areas:

 (1) Pass struct vfsmount through to LSM hooks.

 (2) Fixes and improvements to __d_path():

     (a) make it unambiguous and exclude unreachable paths from
         /proc/mounts,

     (b) make its result consistent in the face of remounts,

     (c) introduce d_namespace_path(), a variant of d_path that goes up
         to the namespace root instead of the chroot.

     (d) the behavior of d_path() and getcwd() remain unchanged, and
     there is no hidding of unreachable paths in /proc/mounts.  The
     patches addressing these have been seperated from the AppArmor
     submission and will be introduced at a later date.
=20
     Part (a) has been in the -mm tree for a while; this series includes
     an updated copy of the -mm patch. Parts (b) and (c) shouldn't be too
     controversial.

 (3) Be able to distinguish file descriptor access from access by name
     in LSM hooks.

     Applications expect different behavior from file descriptor
     accesses and accesses by name in some cases. We need to pass this
     information down the LSM hooks to allow AppArmor to tell which is
     which.

 (4) Convert the selinux sysctl pathname computation code into a standalone
     function.

 (5) The AppArmor LSM itself.

     (See below.)

A tarball of the kernel patches, base user-space utilities, example
profiles, and technical documentation (including a walk-through) are
available at:

  http://forgeftp.novell.com//apparmor/LKML_Submission-May_07/

Explaining the AppArmor design in detail would take by far too much
space here, so let me refer you to the technical documentation for that.
Included is a low-level walk-through of the system and basic tools, and
some examples.  The manual pages included in the apparmor-parser package
are worth a read as well.

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGSGkYi/GH5xuqKCcRAuprAJ9AU4YP7jI729CMAem7vNs9DXcZAwCgoMIM
lawLtXpQIenDaPrNhApk2xQ=
=2b3Z
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
