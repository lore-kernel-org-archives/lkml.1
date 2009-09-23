Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbZIWBFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbZIWBFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 21:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbZIWBFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 21:05:17 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:41162 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbZIWBFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 21:05:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:reply-to:mime-version:content-type
         :content-disposition:user-agent;
        b=vmOeBvcoC0lYd7eX0VZcIk8n8eVFwTDuc9I2MwUN9wRHRU4u2D3QQmX8XayTWUxItv
         jKAGQ9GbBo2GcFFTM7CelyCAXa+nt630cfqG1OHpls9PRs+YQdlevLSCHl7FR2DSn2xK
         ZBkvKDrk3k/upuW2HDhMdBjDxuZI4vqRkKEP0=
Date: Wed, 23 Sep 2009 00:56:44 +0000
From: Andy Spencer <andy753421@gmail.com>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] Privilege dropping security module
Message-ID: <20090923005644.GA28244@c.hsd1.tn.comcast.net>
Reply-To: linux-security-module@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_c-28351-1253667428-0001-2"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_c-28351-1253667428-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I started work on a Linux Security Module called dpriv a few days ago
and would like to get some feedback. It's by no means ready to be
included in the kernel, but I'm sure there are many things that I could
have done better so suggestions are welcome.

The code is available from gitweb and the dpriv branch of my tree:

  git://lug.rose-hulman.edu/~spenceal/linux-dev dpriv

  http://lug.rose-hulman.edu/git/?p=~spenceal/linux-dev;f=security/dpriv;hb=refs/heads/dpriv


I'll start off with a quick FAQ
-------------------------------
Q: Why another LSM, don't we have enough already?
A: As far as I know there are several rather unique things about dpriv
   when compared to other LSMs. (it's also been a good way for me to
   familiarize myself with the kernel)

Q: So what's unique about dpriv?
A: - Dpriv can be used by any user, not just by root
   - The "policy" is created at runtime instead of fixed beforehand
   - It does *not* implement Mandatory Access Control


Now for how it works
--------------------
- Everything is controlled though a securityfs interface which consists
  of three files: "stage", "policy", and "control".

- Policies are created by writing lines to the stage file and then
  writing the "commit" command to the control file. "Committing" the
  policy merges the staged policy into the actual policy (the "policy"
  file). Note that privileges can only be dropped during a commit, and
  afterwards there is no way to get them back.

- Policies are effective for the process which created them and are also
  copied to all it's child processes.

- For example, the following commands will set the root filesystem
  read-only with the exception of allowing execute permission in /bin/
  and write permission in /tmp/. (note that directory permission are
  uppercase and file permissions are lowercase, both are recursive)

  $ echo r--R-X /    > /sys/kernel/security/dpriv/stage
  $ echo r-xR-X /bin > /sys/kernel/security/dpriv/stage
  $ echo rw-RWX /tmp > /sys/kernel/security/dpriv/stage
  $ echo commit      > /sys/kernel/security/dpriv/control


And some technical details
--------------------------
(subject to change)

- Dpriv stores a list of active and staged permissions for each process
  in current->cred->security. Each permissions line consists of a mode
  mask and the inode that it is effective for.

- When determining access rights for an inode: if the inode is in the
  list of active permissions, use that mask, else recursively fetch (and
  merge) the permissions from the inodes parents

  (to do this, all the parents for hard links/mounts will need to be
  known and stored in the inode somehow, possibly using extended
  attributes, I haven't completely worked this out yet)

- Permissions for things other than files could be implemented as well,
  but I haven't started working on those either.


Let me know what you think

--=_c-28351-1253667428-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq5cmQACgkQz1OYJ/s1XTDM+QCfcl2fquAwkKKlRFHvR+S3REsi
4wgAnjBmgv0VgdRgjkMjza/X9LyupwVM
=BU87
-----END PGP SIGNATURE-----

--=_c-28351-1253667428-0001-2--
