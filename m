Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbZGKQCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbZGKQCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 12:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZGKQCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 12:02:11 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:44489 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZGKQCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 12:02:11 -0400
Subject: inotify regression, missing events
From: Scott James Remnant <scott@ubuntu.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-plY1K5c+HkzgiOyfXCJ7"
Date: Sat, 11 Jul 2009 17:02:07 +0100
Message-Id: <1247328127.4003.6.camel@wing-commander>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-plY1K5c+HkzgiOyfXCJ7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey folks,

Looks like there's a regression with inotify since the rewrite to use
fanotify.  Events are simply missing and not being delivered to
userspace.

Here's a simple test case, just compile and run it:

----8<--------8<--------8<--------8<--------8<--------8<--------8<----
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/inotify.h>

#include <stdio.h>
#include <assert.h>
#include <limits.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>


enum {
	WD		=3D 0x01,
	FOO		=3D 0x02,
	BAR		=3D 0x04,
	SUBDIR_WD	=3D 0x08,
	SUBDIR		=3D 0x10,
	SUBDIR_FOO	=3D 0x20,
	ALL		=3D 0x3f
};

int
main (int   argc,
      char *argv[])
{
	int     fd;
	char    dirname[PATH_MAX];
	char    filename[PATH_MAX];
	int     ret;
	FILE *  fp;
	int     wd;
	int     subdir_wd;
	char    buf[4096];
	int     expected;
	ssize_t len;
	size_t  sz;
=09
	fd =3D inotify_init ();
	assert (fd >=3D 0);
=09
	/* Create a temporary directory with two files and a sub-directory
	 * containing just one file.
	 */
	strcpy (dirname, "/tmp/inotify_test_XXXXXX");
	assert (mkdtemp (dirname));
=09

	strcpy (filename, dirname);
	strcat (filename, "/subdir");
=09
	ret =3D mkdir (filename, 0755);
	assert (ret =3D=3D 0);
=09

	strcpy (filename, dirname);
	strcat (filename, "/subdir/foo");
=09
	fp =3D fopen (filename, "w");
	assert (fp);
=09
	fprintf (fp, "file in a sub-directory\n");
=09
	ret =3D fclose (fp);
	assert (ret =3D=3D 0);


	strcpy (filename, dirname);
	strcat (filename, "/foo");
=09
	fp =3D fopen (filename, "w");
	assert (fp);
=09
	fprintf (fp, "this is a test\n");
=09
	ret =3D fclose (fp);
	assert (ret =3D=3D 0);
=09

	strcpy (filename, dirname);
	strcat (filename, "/bar");
=09
	fp =3D fopen (filename, "w");
	assert (fp);
=09
	fprintf (fp, "this is another test\n");
=09
	ret =3D fclose (fp);
	assert (ret =3D=3D 0);

=09
	/* Watch those directories for deletions */
	wd =3D inotify_add_watch (fd, dirname, IN_DELETE);
	assert (wd >=3D 0);

	strcpy (filename, dirname);
	strcat (filename, "/subdir");

	subdir_wd =3D inotify_add_watch (fd, filename, IN_DELETE);
	assert (wd >=3D 0);
=09

	/* Clean up the directory */
	strcpy (filename, dirname);
	strcat (filename, "/subdir/foo");

	ret =3D unlink (filename);
	assert (ret =3D=3D 0);

	strcpy (filename, dirname);
	strcat (filename, "/subdir");

	ret =3D rmdir (filename);
	assert (ret =3D=3D 0);
=09
	strcpy (filename, dirname);
	strcat (filename, "/bar");

	ret =3D unlink (filename);
	assert (ret =3D=3D 0);

	strcpy (filename, dirname);
	strcat (filename, "/foo");

	ret =3D unlink (filename);
	assert (ret =3D=3D 0);

	ret =3D rmdir (dirname);
	assert (ret =3D=3D 0);
=09
=09
	/* Read the inotify events */
	expected =3D ALL;
	while (expected) {
		struct inotify_event *ev;
		ssize_t off;
	=09
		printf ("Waiting for:");
		if (expected & WD)
			printf (" wd");
		if (expected & FOO)
			printf (" foo");
		if (expected & BAR)
			printf (" bar");
		if (expected & SUBDIR_WD)
			printf (" subdir_wd");
		if (expected & SUBDIR)
			printf (" subdir");
		if (expected & SUBDIR_FOO)
			printf (" subdir/foo");
		printf ("\n");

		len =3D read (fd, buf, sizeof buf);
		assert (len > 0);
	=09
		off =3D 0;
		while (off < len) {
			ev =3D (struct inotify_event *)(buf + off);
			sz =3D sizeof (struct inotify_event) + ev->len;
			off +=3D sz;

			/* Eliminate the silly */
			assert (! (ev->mask & IN_Q_OVERFLOW));
			assert (! (ev->mask & IN_UNMOUNT));
		=09
			/* Print the event for debugging */
			printf ("Got ");
			if (ev->mask & IN_DELETE)
				printf ("DELETE ");
			if (ev->mask & IN_IGNORED)
				printf ("IGNORED ");
			if (ev->mask & IN_ISDIR)
				printf ("ISDIR ");
			if (ev->len)
				printf ("\"%.*s\" ", ev->len, ev->name);
			printf ("(%d)\n", ev->wd);

			/* Expect the file in the sub-directory to go */		=09
			if ((ev->wd =3D=3D subdir_wd)
			    && (ev->mask & IN_DELETE)
			    && (! (ev->mask & IN_ISDIR))
			    && (strncmp (ev->name, "foo", ev->len) =3D=3D 0))
				expected &=3D ~SUBDIR_FOO;
		=09
			/* Expect the sub-directory to go */
			if ((ev->wd =3D=3D wd)
			    && (ev->mask & IN_DELETE)
			    && (ev->mask & IN_ISDIR)
			    && (strncmp (ev->name, "subdir", ev->len) =3D=3D 0))
				expected &=3D ~SUBDIR;
			=09
			/* Expect an IS_IGNORED for the sub-directory watch */
			if ((ev->wd =3D=3D subdir_wd)
			    && (ev->mask & IN_IGNORED))
				expected &=3D ~SUBDIR_WD;
			=09
			/* Expect the first file in the directory to go */		=09
			if ((ev->wd =3D=3D wd)
			    && (ev->mask & IN_DELETE)
			    && (! (ev->mask & IN_ISDIR))
			    && (strncmp (ev->name, "foo", ev->len) =3D=3D 0))
				expected &=3D ~FOO;
		=09
			/* Expect the second file in the directory to go */		=09
			if ((ev->wd =3D=3D wd)
			    && (ev->mask & IN_DELETE)
			    && (! (ev->mask & IN_ISDIR))
			    && (strncmp (ev->name, "bar", ev->len) =3D=3D 0))
				expected &=3D ~BAR;

			/* And finally expect an IS_IGNORED for the directory */
			if ((ev->wd =3D=3D wd)
			    && (ev->mask & IN_IGNORED))
				expected &=3D ~WD;
		}
	}=09

	ret =3D close (fd);
	assert (ret =3D=3D 0);
=09
	printf ("\n");
	printf ("All good!\n");

	return 0;
}
---->8-------->8-------->8-------->8-------->8-------->8-------->8----

With 2.6.30, you see (as you'd expect) an inotify delete event for each
of the files and the sub-directory along with the IN_IGNORED for the
sub-directory and directory as the watch gets cleaned up by the kernel:


Waiting for: wd foo bar subdir_wd subdir subdir/foo
Got DELETE "foo" (2)
Got DELETE ISDIR "subdir" (1)
Got IGNORED (2)
Got DELETE "bar" (1)
Got DELETE "foo" (1)
Got IGNORED (1)

All good!


But with 2.6.31-rc2, the event for the "foo" file isn't delivered:

Waiting for: wd foo bar subdir_wd subdir subdir/foo
Got DELETE "foo" (2)
Got DELETE ISDIR "subdir" (1)
Got IGNORED (2)
Got DELETE "bar" (1)
Got IGNORED (1)
Waiting for: foo


This doesn't seem to be related to the removal of the parent directory,
without removing that we still hang waiting for the event for that file.

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-plY1K5c+HkzgiOyfXCJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpYt3sACgkQSnQiFMl4yK7DSwCgqDTsSvD6TWF3QrEFyOhZ3EUO
NOUAniS0UOQD609VyYQlzoNcfh2l0BaD
=SdKE
-----END PGP SIGNATURE-----

--=-plY1K5c+HkzgiOyfXCJ7--

