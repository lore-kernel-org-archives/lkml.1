Return-Path: <linux-kernel-owner+w=401wt.eu-S1764929AbXJZHR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764929AbXJZHR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763557AbXJZHCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 03:02:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:37145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762897AbXJZHCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 03:02:50 -0400
Date: Fri, 26 Oct 2007 00:04:00 -0700
From: John Johansen <jjohansen@suse.de>
To: jjohansen@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 00/45] AppArmor security module overview
Message-ID: <20071026070400.GG3298@suse.de>
References: <20071026064024.243943043@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pE2VAHO2njSJCslu"
Content-Disposition: inline
In-Reply-To: <20071026064024.243943043@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--pE2VAHO2njSJCslu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 25, 2007 at 11:40:24PM -0700, jjohansen@suse.de wrote:
Sorry this got dropped some how.

This submission of the AppArmor security module is based against -mm.

Any comments and feedback to improve implementation are appreciated.

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

  http://forgeftp.novell.com/apparmor/LKML_Submission-Oct-07/

Only the most recent features are covered in brief here for a more
complete explaination please refere to the technical documentation.

Changes since previous submission
- fix wrong error code for failed pathname
- fix change_profile ref counting bug
- fix change_hat missing mandatory profile bug
- file rules can now be specified in permission first order
- add append permission which is subset of write permission
- add lock mediation for finer grained control, previously locking only
  required access right to a file
- added simple Network toggles for course network mediation
- added profile namespaces (currently only available through change_profile)
- added DAC style permissions
- added the ability to specify hard link rules using location pairs
- added per profile namespace default profile
- added pix transition mode
- builtin only

Outstanding Issues
- use of d_namespace_path and buffer allocation to obtain a pathname for
  mediation.
- conditional passing of the vfsmnt.  This can be addressed by rebasing
  on the lookup intent patches but that has not been done for this
  submission.
- ipc and signal mediation are a wip and not included.
- fine grained network mediation
- system confinement from boot is a wip and not included.
- documentation needs to be updated to include newest features


Explanation of new features

  The user side policy parser now support specifying file rules with
  permissions specified before the path expression; the old syntax is
  still supported.

  eg.
    r /etc/shadow,


Profile Namespaces
  AppArmor now allows for profile sets to exist in seperate namespaces.
  This is the first step in allowing AppArmor to have different policy,
  per container.

  Profile namespaces currently can only be set through change_profile.
  Confined tasks inherit the namespace of their parent. =20
 =20

User, Group, Other permission masks
  AppArmor now allows file permissions to be specified at the user,
  group, and other level similar to DAC.  For each permission set of user,
  group, other the full AppArmor permission set (rwaxlmk) are provided.
  The permission group to apply is determined using the fsuid.

  The permission sets are seperated using the : character.  This deviates
  from dac but the permission sets are wider, and do not have a set order.
  If any distinct user:group:other permissions are being expressed then all
  of the user:group:other permissions for the rule must be expressed.  That
  is to say just writing rw, does not provide user rw, and rw:r does not
  provide user and group permissions.
  eg.
    /foo rw:r:r,   # give user rw, group and other r
    /foo rw::,     # give user rw, no permissions to group and other
    /foo :r:r,     # give group and other read permissions
    /foo ::r,      # give other read permissions

  Traditional AppArmor rules are still supported user side and are mapped
  to the same permission in each of user, group and other.  So
    /foo rwpx,
  is the same as
    /foo rwpx:rwpx:rwpx,

  For a given rule user, group, other must use the same exec qualifier.
  Multiple rules can be used to specify different exec qualifiers for
  each of user, group, or other for a given match.
  eg.
    /bin/foo  px::,
    /bin/foo  :ix:ix,
 =20
  The link permission is determined by the target files ownership this
  allows for writting rules that enforce openwall style link restrictions.
    /** l::,   #allow linking to any file owned by the user

  The user, group, other permission masks can be written in a permission
  first manner as well.


Link rules
  Dedicated link rules using source and destination have been added,
  to allow for tighter control of hard links when necessary.
  eg.
    link /linkname -> /targetname,

  if user:group:other link specification is desired then a user:group:other
  mask containing only the link perm in the appropriate positions can be
  specified.  The permission group to apply is determined by the target
  and the fsuid.
  eg.
    link l:: /linkname -> /targetname,   # allow if /targetname owned by us=
er
  or
    l:: /linkname -> /targetname,

  Both the linkname and the target support full AppArmor globbing.
  link l:: /** -> /**,      # allow any link to target owned by user

  Traditional AA style links are still supported and are mapped by the
  parser into the newer link pair for the kernel.
    /linkname rwl,
  is mapped to
    link /linkname -> /**,


> --=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--pE2VAHO2njSJCslu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD4DBQFHIZFgi/GH5xuqKCcRAvenAJjSUHMfHraeUd3NVcm89IcF8J6OAJ9CYlY0
6MAQtrxNKUzcxGmq89ezvQ==
=mXQ7
-----END PGP SIGNATURE-----

--pE2VAHO2njSJCslu--
