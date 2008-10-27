Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbYJ0Izm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbYJ0Izm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 04:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYJ0Izf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 04:55:35 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:38926 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbYJ0Ize (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 04:55:34 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: linux-kernel@vger.kernel.org
Subject: inconsistent behavior with ptrace(TRACEME) and fork/exec
Date: Mon, 27 Oct 2008 04:55:29 -0400
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_EIYBJ6gowMsQYQL"
Message-Id: <200810270455.32247.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_EIYBJ6gowMsQYQL
Content-Type: multipart/signed;
  boundary="nextPart3480442.bVZSW9GQNi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3480442.bVZSW9GQNi
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

i'm hoping my understanding of ptrace is correct and that the attached test=
=20
case (reduced from LTP) isnt just completely broken ... my understanding is=
=20
that if a parent forks and the child does a ptrace(TRACEME) right before=20
doing an exec(), the kernel should always halt it and wait indefinitely for=
=20
the parent to start ptracing it.

unfortunately, this behavior seems to be unreliable.  most of the time it=20
works, but sometimes the kernel does not halt the child and it gladly does=
=20
the exec() that it set out to do.  i dont believe this to be a race in the=
=20
user space parent component as forcing it to delay via judicious usage of=20
sleep() shows the same behavior.

if  all goes well, we should only ever see "SUCCESS!" from the test case:
$ gcc -Wall ptrace-vfork-traceme.c -o ptrace-vfork-traceme
$ while ./ptrace-vfork-traceme ; do :; done
SUCCESS! :D
SUCCESS! :D
SUCCESS! :D
SUCCESS! :D
SUCCESS! :D
SUCCESS! :D
SUCCESS! :D
SUCCESS! :D
SUCCESS! :D
failure, child exited with 17: Child exited
wait() =3D 12275
status =3D 1407
        WIFEXITED =3D 0
        WEXITSTATUS =3D 5
        WIFSIGNALED =3D 0
        WTERMSIG =3D 127 (Unknown signal 127)

i'm testing 2.6.26/2.6.27 atm.  both x86_64 and ppc64 seem to behave the sa=
me. =20
while gcc-4.3.2 / glibc-2.8 is in use in both places, i dont think that=20
matters.

also, while the attached test uses vfork(), same behavior can be observed w=
ith=20
fork().  vfork() is used because i like my test cases to work on both MMU a=
nd=20
no-MMU systems.
=2Dmike

--nextPart3480442.bVZSW9GQNi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJBYIEAAoJEEFjO5/oN/WBV7gP/jHcH1Pdyu5xq99Ivtpan6t8
sXBpB02hlFD9D3lTAXHQQl6GfVLhRKirZr5L64TJwoV9MnBvUn5UYjKtVnwu92Jb
jCAYrmFftNoB79+aL82bktf5AK39pIGdqCJBQ5OM+7a/5i4GqzqViHYF71bnf6YH
5bFXe8NwafH7kA/CpYTzUMX5e8iG6aBxDGuXaWiIk3AGRqN7MfmRU4Z5/HoscPb4
pyTXgi0Rebk/mG1UG3dYb1S3gmPfuaNpdKqfz9/0IRChc++bblgZAPnHjzfz7vln
YQBlITzxTjTL3uoDO4S36y2cyzU4tDQO3r1yjbnGMFdbNZ9GDBh30i9dsACxdSz/
jqm8cfmNr5yLjFTMMhEWeEwoTgitgBpEQ8ifEkFKS+VLdE7zzldmctW/x8sDoXSz
sL8XBb6MpLIyRoag3B7JeCYeYrOErexabxJO3glAmpXqW7FhOEkKZ/q8RqKqrCuN
Cj8vl/4ga5+6Exxhhwk5nGQPJzynqMvn9Fwhih/RTQaQHKrlKJfQ35qZ2d6pITkx
kd5p4/n57BM9L+XhaVY/M86ys2IOBgdc9hZhf8uiN6zXpjIViHw9QJ8K+SxDbLBu
tteP/f9GG0X6wo3qUoOWxU6vMdAhVB8osqsFKIcNCdDCNKLNlu82Q+rlhmaswkAy
mXgVYt85olz8JTV/1LDJ
=rqWg
-----END PGP SIGNATURE-----

--nextPart3480442.bVZSW9GQNi--

--Boundary-00=_EIYBJ6gowMsQYQL
Content-Type: text/x-csrc;
  charset="us-ascii";
  name="ptrace-vfork-traceme.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="ptrace-vfork-traceme.c"

#define _GNU_SOURCE
#include <errno.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ptrace.h>
#include <sys/wait.h>

#define fail(msg, args...) \
do { \
	fprintf(stderr, "FAIL:%i: " msg "\n", __LINE__, ## args); \
	exit(1); \
} while (0)

static void child_exit(int sig)
{
	int status;
	printf("failure, child exited with %i: %s\n", sig, strsignal(sig));
	printf("wait() = %i\n", wait(&status));
	printf("status = %i\n", status);
	printf("\tWIFEXITED = %i\n", WIFEXITED(status));
	printf("\tWEXITSTATUS = %i\n", WEXITSTATUS(status));
	printf("\tWIFSIGNALED = %i\n", WIFSIGNALED(status));
	printf("\tWTERMSIG = %i (%s)\n", WTERMSIG(status), strsignal(WTERMSIG(status)));
	exit(1);
}

int main(int argc, char *argv[])
{
	long pret;
	pid_t pid;

	/* child process ... shouldnt be executed, but just in case ... */
	if (argc > 1 && !strcmp(argv[1], "child"))
		fail("kernel should have halted me...");

	pid = vfork();
	if (pid == -1)
		fail("vfork() didnt work: %m");
	else if (!pid) {
		/* do the child stuff here */
		errno = 0;
		pret = ptrace(PTRACE_TRACEME, 0, NULL, NULL);
		if (pret && errno)
			fail("ptrace(PTRACE_TRACEME) = %li: %m", pret);

		int eret = execlp(argv[0], argv[0], "child", NULL);
		fail("execlp() = %i", eret);
	}

	/* do the parent stuff here */
	signal(SIGCHLD, child_exit);

	errno = 0;
	pret = ptrace(PTRACE_PEEKUSER, pid, NULL, NULL);
	if (pret && errno)
		fail("ptrace(PTRACE_PEEKUSER, %i) = %li: %m", pid, pret);

	puts("SUCCESS! :D");

	return 0;
}

--Boundary-00=_EIYBJ6gowMsQYQL--
