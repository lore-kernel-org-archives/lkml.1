Return-Path: <linux-kernel-owner+w=401wt.eu-S1760814AbYFXORh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbYFXORh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759836AbYFXOQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:16:52 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:46945 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760602AbYFXOQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:16:51 -0400
Date: Tue, 24 Jun 2008 16:16:49 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: configfs: Q: item leak in a failing configfs_attach_group()?
Message-ID: <20080624141649.GH7621@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-24997-1214316916-0001-2"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-24997-1214316916-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I'd like an opinion on the following scenario:

process 1: 					process 2:
configfs_mkdir("A")
  attach_group("A")
    attach_item("A")
      d_instantiate("A")
    populate_groups("A")
      mutex_lock("A")
      attach_group("A/B")
        attach_item("A")
          d_instantiate("A/B")
						mkdir("A/B/C")
						  do_path_lookup("A/B/C", LOOKUP_PARENT)
						    ok
						  lookup_create("A/B/C")
						    mutex_lock("A/B")
						    ok
						  configfs_mkdir("A/B/C")
						    ok
      attach_group("A/C")
        attach_item("A/C")
          d_instantiate("A/C")
        populate_groups("A/C")
          mutex_lock("A/C")
          attach_group("A/C/D")
            attach_item("A/C/D")
              failure
          mutex_unlock("A/C")
          detach_groups("A/C")
            nothing to do
						mkdir("A/C/E")
						  do_path_lookup("A/C/E", LOOKUP_PARENT)
						    ok
						  lookup_create("A/C/E")
						    mutex_lock("A/C")
						    ok
						  configfs_mkdir("A/C/E")
						    ok
        detach_item("A/C")
        d_delete("A/C")
      mutex_unlock("A")
      detach_groups("A")
        mutex_lock("A/B")
        detach_group("A/B")
	  detach_groups("A/B")
	    nothing since no _default_ group
          detach_item("A/B")
        mutex_unlock("A/B")
        d_delete("A/B")
    detach_item("A")
    d_delete("A")

Two bugs (if the scenario is possible):

1/ "A/B/C" and "A/C/E" are created, but never removed while their parent are
removed in the end.

2/ "A" and "A/C" inodes are not locked while detach_item() is called on the=
m,
   which may probably confuse VFS.

Is there something that prevents such scenario? I'd say that once dentries
are instantiated, the dcache does not need to lock their inode to traverse =
them,
so the scenario is possible.

Where am I wrong?

If I'm right, two kinds of solutions for issue 1:
i/ tag new directories with CONFIGFS_USET_NEW before calling d_instantiate,=
 and
validate the whole group+default groups hierarchy in a second pass by clear=
ing
CONFIGFS_USET_NEW

ii/ do not call d_instantiate() immediately in configfs_create() if called =
=66rom
configfs_create_dir(), and d_instantitate() the group+default groups hierar=
chy
in a second pass. Problem: is it correct to add children to a dentry which =
is
not yet instantiated?

For issue 2/, locking the inode before calling detach_item() (as is done fr=
om
configfs_rmdir()), plus a solution for 1/ should be sufficient.

Thanks for your explanations.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-24997-1214316916-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIYQHRVKcRuvQ9Q1QRAo08AJ9I2mFVE+2IDm21BNhhwT2sMtgSaQCeK/ga
5DbaIh1Mm1Mbh7tB/x0CjH0=
=P15Y
-----END PGP SIGNATURE-----

--=_bohort-24997-1214316916-0001-2--
