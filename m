Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbXDPVd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbXDPVd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbXDPVd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:33:26 -0400
Received: from mail.suse.de ([195.135.220.2]:41922 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbXDPVdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:33:24 -0400
Date: Mon, 16 Apr 2007 14:33:50 -0700
From: John Johansen <jjohansen@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: AppArmor FAQ
Message-ID: <20070416213350.GB4030@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lcZGd9BuhuYXNfi"
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Here we present our direct responses to the most frequent questions from
the AppArmor from the 2006 post.

Use of Pathnames For Access Control
-----------------------------------

Some people in the security field believe that pathnames are an
inappropriate security mechanism.  This depends on what you are
primarily trying to protect, and the rest follows from that.

Label-based security (exemplified by SELinux, and its predecessors in
MLS systems) attaches security policy to the data. As the data flows
through the system, the label sticks to the data, and so security
policy with respect to this data stays intact. This is a good approach
for ensuring secrecy, the kind of problem that intelligence agencies have.

Pathname-based security (exemplified in AppArmor, and its predecessor
Janus http://www.cs.berkeley.edu/~daw/janus/ and other systems like
Systrace http://www.citi.umich.edu/u/provos/systrace/ ) attach security
policy to the name of the data.

Controlling access to filenames is important because applications
primarily use those names to access the files behind them, and they
depend on getting to the right files. For example, login(1) expects
/etc/passwd to resolve to a valid list of user accounts.  In the
traditional UNIX model, files do have names but not labels, and
applications only operate in terms of those names.  Pathname-based
security puts more emphasis on the integrity of the system, making
secrecy the secondary goal that follows.

Caveat: Both label-based security and pathname-based security can
provide both secrecy and integrity protection, the above discussion is
only about which model makes it easier to provide which kind of security.

We acknowledge that not all objects on a UNIX system are paths, and we
agree that there is value in also protecting non-path resources.
Contrary to popular belief, AppArmor is *not* "Pathnames R Us", but
rather "Use native abstractions to mediate stuff":  when you mediate
something, you should use the native syntax that users normally use to
access the object. This follows the UNIX philosophy of "least surprise"
so that users can understand the specification. Pathnames are the
natural notation for users to understand what file access rights are
being granted in the policy, and so AppArmor uses shell syntax for fully
qualified pathnames, including shell syntax wildcards.

Similarly, AppArmor grants access to POSIX.1e capabilities by name, the
name of the capability. In future work where AppArmor will add network
access control, the notation will resemble IPTables firewall rules. This
is an important part of what makes AppArmor usable: always using the
native abstraction for mediating access.

We also acknowledge that pathname based access control requires a way to
perform pathname matching in the kernel, and this comes at a cost higher
than comparing object labels -- which assumes that all objects in the
system already have the appropriate labels.

However, those concerned with performance should note that AppArmor
overhead is already quite low (single-digit percent slowdown). Security
is rarely performance-neutral, and AppArmor, and SELinux, are no
exception. However, that overhead is small, and can be selectively
avoided by not applying AppArmor to performance-sensitive programs.

It is also easy to overlook the fact that putting all those labels in
place is a pretty expensive operation as well, particularly considering
large file systems. So by providing string matching in the kernel,
AppArmor trades run-time performance to grant reduced administrative work.

It has been suggested that AppArmor's pathname-based syntax could be
compiled into SELinux policy, and this is in fact what the SEEdit
project http://seedit.sourceforge.net/ does. However, any change in
policy requires a complete re-labeling of the file system, and the
policy cannot apply to files that do not yet exist. AppArmor's in-kernel
string matching allows for policy specifying access to files that might
come to exist in the future.

Use Of d_path() For Computing Pathnames
---------------------------------------

We have been criticized for the use of d_path(), for various reasons:

 - heuristic discovery of the vfsmount of a dentry,
 - inability to reliably identify deleted files,
 - inability to detect unreachable paths,
 - ambiguity of paths for chroot processes,
 - file lookup and the access check are not atomic.

Most of these issues are fixable (and fixed in the meantime), while the
non-atomicity is not really an issue.

Because struct vfsmount was not available to LSM hooks for computing
pathnames from (dentry, vfsmount) pairs, the version of AppArmor posted
last year used heuristics for rediscovering the vfsmounts associated
with dentries -- and possibly the wrong ones.  We are now passing the
vfsmount objects through to all LSM hooks that compute pathnames, and so
this heuristic is gone, and now we always use the appropriate vfsmount.

The d_path patch already in the -mm tree allows reliably identifies
deleted files (at least when using the underlying __d_path()), as well
as unreachable paths.

One of the patches in the AppArmor series ensured that the result
returned by __d_path() is consistent even in face of remounts -- the
path returned will always be the name by which the file question was
reachable at the time when d_path was called.

One of the patches in the AppArmor series introduces d_namespace_path(),
based on __d_path(), which gets rid of the chroot ambiguity by computing
paths relative to the namespace root rather than the chroot.

The file lookup and the LSM access check are not atomic with each other
as far as the filesystem namespace is concerned: files may be renamed or
even removed between the lookup and the access check.  It is important
that the lookup happens before the access check, and that the access
check happens before the access, but beyond that, all we care about
security wise is the pathname that the file in question had at the time
of the access check: the file could have been renamed shortly before the
lookup, or shortly thereafter -- this makes no difference because the
only thing we are interested about is the current name of the file.

In case a file is successfully looked up and then deleted before the
access check, it is also obvious how to proceed: the file might as well
have been deleted before the lookup, so we pretend that it was, and
fail the access with errno set to ENOENT.  (This would be fatal for
accesses via open file descriptors -- temporary files are often accessed
after being deleted -- so we make this a special case, and allow
per-file-descriptor accesses to deleted files.)

The "race window" described above in fact is not only between the lookup
and the access check, but is much wider: when a process looks up a file
relative to its current working directory, the lookup is relative to
that directory, and the directory may long since have been renamed.  The
same is true for absolute paths, which are only absolute relative to the
chroot directory.  Still, what we care about is the pathname of the file
at the time of the access check, as above.

The previous version of AppArmor was basing access decisions on the
pathnames of files, even if those files were already deleted.  While it
can be argued that the pathname that can still be recovered from a
deleted file sometimes holds an informational value, it is not obvious
that the name still has value from a security point of view.  We no
longer do that -- instead, we differentiate between file descriptor and
name based accesses.

Working With Name Spaces
------------------------

AppArmor pathname expressions in profiles are relative to the root of
whatever filesystem namespace a process is in. This is secure because
processes can only create new namespaces if they have the CAP_SYS_ADMIN
capability, which confined processes are not supposed to be granted by
their profile because it would allow them to break out of the
confinement, and they can only manipulate their namespace using the
mount system calls, which  confined processes are currently denied as well.

Unconfined processes can still set up different namespaces, and AppArmor
will apply the global policies to each of those namespaces
independently. This prevents AppArmor from confining ClearCase because
of ClearCase's heavy of namespaces, for example.

We are considering how to make AppArmor more flexible to allow some
controlled kinds of mounts, and how to make namespace support more
flexible. One way of improving the namespace support would be to allow
processes to switch between different sets of profiles. The process
setting up a new namespace could then switch to the set of profiles
appropriate for the new namespace as well. (Switching between different
sets of profiles automatically likely will not work -- namespaces do not
have an intrinsic name, and so if the same binary creates multiple
namespaces, there would be no way of telling one from the other.)

Alternate Implementation Strategies
-----------------------------------

It has been observed that computing the pathname after an object has
been looked up is counter-intuitive and racy, and that the pathname
should instead be constructed forwards, during the lookup. While
appealing, this approach breaks for lookups that are relative to the
current working directory (or relative to another open directory like
with openat(2)): in that case, the parent directories of the directory
are never visited (unless the relative path goes all the way up to the
root with ``..'').

All of these cases force the backwards construction of the pathname from
the middle. The pathname up to the root also cannot be cached because
directories along the path could get renamed at any time. Therefore,
since we must be prepared to do backward path construction anyway, we
might as well simplify the mechanism by computing the entire pathname
after looking up the object all of the time.

It has also been suggested that we use a shadow tree, where the module
maintains a shadow mapping from current dentries of interest to the
pathnames for those dentries. However, a very difficult problem with
this approach is that you have two large, complex data structures that
must be kept perfectly synchronized. This particularly becomes a problem
for renames, especially directory renames, which cause a change in the
fully qualified pathname of every file and directory below it,
necessitating large changes to the shadow tree. Our attempts to make
this approach work resulted in worse problems then we had with d_path.

--3lcZGd9BuhuYXNfi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFGI+u+i/GH5xuqKCcRAv8xAJ9UI5iemmTVkd7kTxbViD423Yxs4gCfbjIl
xHnu3Iq6JrkYMquEATTIUnI=
=w+Bd
-----END PGP SIGNATURE-----

--3lcZGd9BuhuYXNfi--
