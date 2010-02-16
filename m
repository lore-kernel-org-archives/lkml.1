Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab0BPMpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 07:45:21 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:38639 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab0BPMpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 07:45:19 -0500
X-Spam-ASN: 
Date: Tue, 16 Feb 2010 15:44:56 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH 2/8] pps: documentation programs and examples.
Message-ID: <20100216154456.2cea05d2@desktopvm.lvknet>
In-Reply-To: <1266313885-1195-3-git-send-email-giometti@linux.it>
References: <1266313885-1195-1-git-send-email-giometti@linux.it>
	<1266313885-1195-2-git-send-email-giometti@linux.it>
	<1266313885-1195-3-git-send-email-giometti@linux.it>
Organization: LVK
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/m523a5WX.VI+Rw9GoAhDCtN";
 protocol="application/pgp-signature"; micalg=PGP-SHA256
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/m523a5WX.VI+Rw9GoAhDCtN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Feb 2010 10:51:19 +0100
Rodolfo Giometti <giometti@linux.it> wrote:

> Here some utilities and examples about the PPS API and the LinuxPPS
> support.
>=20
> * ppstest.c implements an useful testing program, while
>=20
> * ppsfind tries to help the user into finding a specific PPS source by
>   using its name or path.

Maybe these tools should be in a separate package (say pps-tools)? I've
written several tools too. They are based on your code. I think there
should be at least two of them:

 * ppsctl to get/set params, get capabilities and bind/unbind kernel
consumer

 * ppstest to fetch data and provide several representations for it

I can assist in this task too.

> Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> ---
>  Documentation/pps/Makefile  |   27 ++++++++
>  Documentation/pps/ppsfind   |   17 +++++
>  Documentation/pps/ppstest.c |  150
> +++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 194
> insertions(+), 0 deletions(-) create mode 100644
> Documentation/pps/Makefile create mode 100644
> Documentation/pps/ppsfind create mode 100644
> Documentation/pps/ppstest.c
>=20
> diff --git a/Documentation/pps/Makefile b/Documentation/pps/Makefile
> new file mode 100644
> index 0000000..3848aba
> --- /dev/null
> +++ b/Documentation/pps/Makefile
> @@ -0,0 +1,27 @@
> +TARGETS =3D ppstest
> +
> +CFLAGS +=3D -Wall -O2 -D_GNU_SOURCE
> +CFLAGS +=3D -I . -I ../../include/
> +CFLAGS +=3D -ggdb
> +
> +# -- Actions section --
> +
> +.PHONY : all depend dep
> +
> +all : .depend $(TARGETS)
> +
> +.depend depend dep :
> +	$(CC) $(CFLAGS) -M $(TARGETS:=3D.c) > .depend
> +
> +ifeq (.depend,$(wildcard .depend))
> +include .depend
> +endif
> +
> +
> +# -- Clean section --
> +
> +.PHONY : clean
> +
> +clean :
> +	rm -f *.o *~ core .depend
> +	rm -f ${TARGETS}
> diff --git a/Documentation/pps/ppsfind b/Documentation/pps/ppsfind
> new file mode 100644
> index 0000000..93c0e17
> --- /dev/null
> +++ b/Documentation/pps/ppsfind
> @@ -0,0 +1,17 @@
> +#!/bin/sh
> +
> +SYS=3D"/sys/class/pps/"
> +
> +if [ $# -lt 1 ] ; then
> +	echo "usage: ppsfind <name>" >&2
> +	exit 1
> +fi
> +
> +for d in $(ls $SYS) ; do
> +	if grep $1 $SYS/$d/name >& /dev/null || \
> +	   grep $1 $SYS/$d/path >& /dev/null ; then
> +		echo "$d: name=3D$(cat $SYS/$d/name) path=3D$(cat
> $SYS/$d/path)"
> +	fi
> +done
> +
> +exit 0
> diff --git a/Documentation/pps/ppstest.c b/Documentation/pps/ppstest.c
> new file mode 100644
> index 0000000..30c8f6d
> --- /dev/null
> +++ b/Documentation/pps/ppstest.c
> @@ -0,0 +1,150 @@
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +
> +#include <timepps.h>
> +
> +int find_source(char *path, pps_handle_t *handle, int *avail_mode)
> +{
> +	pps_params_t params;
> +	int ret;
> +
> +	printf("trying PPS source \"%s\"\n", path);
> +
> +	/* Try to find the source by using the supplied "path" name
> */
> +	ret =3D open(path, O_RDWR);
> +	if (ret < 0) {
> +		fprintf(stderr, "unable to open device
> \"%s\" (%m)\n", path);
> +		return ret;
> +	}
> +
> +	/* Open the PPS source (and check the file descriptor) */
> +	ret =3D time_pps_create(ret, handle);
> +	if (ret < 0) {
> +		fprintf(stderr, "cannot create a PPS source from
> device "
> +				"\"%s\" (%m)\n", path);
> +		return -1;
> +	}
> +	printf("found PPS source \"%s\"\n", path);
> +
> +	/* Find out what features are supported */
> +	ret =3D time_pps_getcap(*handle, avail_mode);
> +	if (ret < 0) {
> +		fprintf(stderr, "cannot get capabilities (%m)\n");
> +		return -1;
> +	}
> +	if ((*avail_mode & PPS_CAPTUREASSERT) =3D=3D 0) {
> +		fprintf(stderr, "cannot CAPTUREASSERT\n");
> +		return -1;
> +	}
> +	if ((*avail_mode & PPS_OFFSETASSERT) =3D=3D 0) {
> +		fprintf(stderr, "cannot OFFSETASSERT\n");
> +		return -1;
> +	}
> +
> +	/* Capture assert timestamps, and compensate for a 675 nsec
> +	 * propagation delay */
> +	ret =3D time_pps_getparams(*handle, &params);
> +	if (ret < 0) {
> +		fprintf(stderr, "cannot get parameters (%m)\n");
> +		return -1;
> +	}
> +	params.assert_offset.tv_sec =3D 0;
> +	params.assert_offset.tv_nsec =3D 675;
> +	params.mode |=3D PPS_CAPTUREASSERT | PPS_OFFSETASSERT;
> +	params.mode &=3D ~(PPS_CAPTURECLEAR | PPS_OFFSETCLEAR);
> +	ret =3D time_pps_setparams(*handle, &params);
> +	if (ret < 0) {
> +		fprintf(stderr, "cannot set parameters (%m)\n");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +int fetch_source(int i, pps_handle_t *handle, int *avail_mode)
> +{
> +	struct timespec timeout;
> +	pps_info_t infobuf;
> +	int ret;
> +
> +	/* create a zero-valued timeout */
> +	timeout.tv_sec =3D 3;
> +	timeout.tv_nsec =3D 0;
> +
> +retry:
> +	if (*avail_mode & PPS_CANWAIT) /* waits for the next event */
> +		ret =3D time_pps_fetch(*handle, PPS_TSFMT_TSPEC,
> &infobuf,
> +				   &timeout);
> +	else {
> +		sleep(1);
> +		ret =3D time_pps_fetch(*handle, PPS_TSFMT_TSPEC,
> &infobuf,
> +				   &timeout);
> +	}
> +	if (ret < 0) {
> +		if (ret =3D=3D -EINTR) {
> +			fprintf(stderr, "time_pps_fetch() got a
> signal!\n");
> +			goto retry;
> +		}
> +
> +		fprintf(stderr, "time_pps_fetch() error %d (%m)\n",
> ret);
> +		return -1;
> +	}
> +
> +	printf("source %d - "
> +	       "assert %ld.%09ld, sequence: %ld - "
> +	       "clear  %ld.%09ld, sequence: %ld\n",
> +	       i,
> +	       infobuf.assert_timestamp.tv_sec,
> +	       infobuf.assert_timestamp.tv_nsec,
> +	       infobuf.assert_sequence,
> +	       infobuf.clear_timestamp.tv_sec,
> +	       infobuf.clear_timestamp.tv_nsec,
> infobuf.clear_sequence); +
> +	return 0;
> +}
> +
> +void usage(char *name)
> +{
> +	fprintf(stderr, "usage: %s <ppsdev> [<ppsdev> ...]\n", name);
> +	exit(EXIT_FAILURE);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int num;
> +	pps_handle_t handle[4];
> +	int avail_mode[4];
> +	int i =3D 0;
> +	int ret;
> +
> +	/* Check the command line */
> +	if (argc < 2)
> +		usage(argv[0]);
> +
> +	for (i =3D 1; i < argc && i <=3D 4; i++) {
> +		ret =3D find_source(argv[i], &handle[i - 1],
> &avail_mode[i - 1]);
> +		if (ret < 0)
> +			exit(EXIT_FAILURE);
> +	}
> +
> +	num =3D i - 1;
> +	printf("ok, found %d source(s), now start fetching
> data...\n", num); +
> +	/* loop, printing the most recent timestamp every second or
> so */
> +	while (1) {
> +		for (i =3D 0; i < num; i++) {
> +			ret =3D fetch_source(i, &handle[i],
> &avail_mode[i]);
> +			if (ret < 0 && errno !=3D ETIMEDOUT)
> +				exit(EXIT_FAILURE);
> +		}
> +	}
> +
> +	for (; i >=3D 0; i--)
> +		time_pps_destroy(handle[i]);
> +
> +	return 0;
> +}


--=20
  Alexander

--Sig_/m523a5WX.VI+Rw9GoAhDCtN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEcBAEBCAAGBQJLepNJAAoJEElrwznyooJbB00H/38zzBDlr1reJzP+9cCZ8/ah
PbIZoqp2yKQ5YRb4cmwu5WVb1Wbi7G/Yr2uiTXpUEfG/3l5yAlxw2eD2r/nOmvQa
6a2UVsKv9iKMmUmpNXIw4Fmerjc2KY6Oye8zeB7ypcN0xcYZY/PBrCV8Doqv79Px
QRlzQDNLUqdCUMJMxGZbOZdSi04x/kKnjONJxFsByp9QIPdsWgtAFj2Z+VStz4CG
vCJ2rCA0KkFm/PsWAnvJhkWqonEYP2vtZv34AHj7VwMvYCi0u5SNALU/D/3hP18T
iI9B8F3yzFNyNWKF/s+BS6k+jpJI2JCRZ3kPT3teCGJf6VSzB5dBEJ69lpfam1E=
=TI/s
-----END PGP SIGNATURE-----

--Sig_/m523a5WX.VI+Rw9GoAhDCtN--
