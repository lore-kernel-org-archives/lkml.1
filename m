Return-Path: <linux-kernel-owner+w=401wt.eu-S1759003AbZAHKsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003AbZAHKsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZAHKsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:48:22 -0500
Received: from mail1.SerNet.de ([193.175.80.2]:41863 "EHLO mail.SerNet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbZAHKsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:48:21 -0500
X-Greylist: delayed 2354 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2009 05:48:21 EST
Date: Thu, 8 Jan 2009 11:13:51 +0100
From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
To: linux-kernel@vger.kernel.org
Subject: maximum buffer size for splice(2) tcp->pipe?
Reply-To: Volker.Lendecke@SerNet.DE
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Message-Id: <E1LKrp3-004Tub-IR@intern.SerNet.DE>
Organization: SerNet GmbH, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

While implementing splice support in Samba for better
performance I found it blocking when trying to pull data off
tcp into a pipe when the recvq was full. Attached find a
test program that shows this behaviour, on another host I
started

netcat 192.168.19.10 4711 < /dev/zero

vlendec@lenny:~$ uname -a
Linux lenny 2.6.28-06857-g5cbd04a #7 Wed Jan 7 10:10:42 CET 2009 x86_64 =3D=
 GNU/Linux
vlendec@lenny:~$ gcc -o splicetest /host/home/vlendec/splicetest.c -O3 -Wall
vlendec@lenny:~$ ./splicetest out 65536 &
[1] 697
vlendec@lenny:~$ strace -p 697
Process 697 attached - interrupt to quit
splice(0x3, 0, 0x5, 0, 0x56a0, 0x1)     =3D 22176
splice(0x7, 0, 0x4, 0, 0x10000, 0x1^C <unfinished ...>
Process 697 detached
vlendec@lenny:~$ netstat -nt | grep 4711
tcp    69272      0 192.168.19.10:4711 192.168.19.1:33773 ESTABLISHED
vlendec@lenny:~$

Interestingly, whenever I start the strace, it gets another
chunk of data and then blocks in the next splice call.

If I start splicetest with a buffer size of 16384 instead of
65536, it does not block. I could not find a way to ask the
kernel for the tipping point below which it does not block.

What is a safe buffer size to use with splice?

BTW, this kernel is from Steve French's linux-cifs.git repo.

Thanks,

Volker Lendecke

Samba Team

P.S: I'm not subscribed to linux-kernel, so if possible
please CC me directly. If this is inappropriate behaviour,
please give me a quick hint :-)

--=20
SerNet GmbH, Bahnhofsallee 1b, 37081 G=F6ttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG G=F6ttingen, HRB 2816, GF: Dr. Johannes Loxen

--Nq2Wo0NMKNjxTN9z
Content-Type: text/x-c++src; charset=us-ascii
Content-Disposition: attachment; filename="splicetest.c"

#define _GNU_SOURCE
#include <fcntl.h>

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main(int argc, const char *argv[])
{
	int pipefds[2];
	int file_fd;
	int sock;
	int listen_fd;
	struct sockaddr_in in_addr;
	int res;
	int to_read;

	if (argc != 3) {
		fprintf(stderr, "usage: %s <filename> to_read\n", argv[0]);
		exit(1);
	}

	to_read = atoi(argv[2]);

	if (pipe(pipefds) != 0) {
		fprintf(stderr, "pipe returned %s\n", strerror(errno));
		exit(1);
	}

	if ((file_fd = open(argv[1], O_CREAT|O_RDWR, 0644)) == -1) {
		fprintf(stderr, "open returned %s\n", strerror(errno));
		exit(1);
	}

	listen_fd = socket(PF_INET, SOCK_STREAM, 0);
	if (listen_fd == -1) {
		fprintf(stderr, "socket returned %s\n", strerror(errno));
		exit(1);
	}

	in_addr.sin_family = AF_INET;
	inet_aton("0.0.0.0", &in_addr.sin_addr);
	in_addr.sin_port = htons(4711);

	res = bind(listen_fd, (struct sockaddr *)&in_addr, sizeof(in_addr));
	if (res == -1) {
		fprintf(stderr, "bind returned %s\n", strerror(errno));
		exit(1);
	}

	res = listen(listen_fd, 5);
	if (res == -1) {
		fprintf(stderr, "listen returned %s\n", strerror(errno));
		exit(1);
	}

	sock = accept(listen_fd, NULL, NULL);
	if (sock == -1) {
		fprintf(stderr, "accept returned %s\n", strerror(errno));
		exit(1);
	}

	while (1) {
		ssize_t nread, nwritten;

		nread = splice(sock, NULL, pipefds[1], NULL, to_read,
			       SPLICE_F_MOVE);
		if (nread == -1) {
			fprintf(stderr, "splice failed: %s\n",
				strerror(errno));
			exit(1);
		}

		if (nread == 0) {
			printf("EOF\n");
			return 0;
		}

		nwritten = splice(pipefds[0], NULL, file_fd, NULL, nread,
				  SPLICE_F_MOVE);
		if (nwritten != nread) {
			fprintf(stderr, "splice failed: %d/%d %s\n",
				(int)nread, (int)nwritten,
				nwritten == -1 ? strerror(errno) : "");
			exit(1);
		}
	}

	return 0;
}

--Nq2Wo0NMKNjxTN9z--

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFJZdHebsgDfmnSbrYRAoLoAJ0Z3YprE5Gqel4vtUwCNAqZ4ho0jACeO3cZ
4yBP0D6xcz3AD/rvFvza85w=
=IRds
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
