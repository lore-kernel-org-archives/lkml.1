Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbXE0TZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbXE0TZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 15:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbXE0TZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 15:25:42 -0400
Received: from daemonizer.de ([87.230.16.230]:50890 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbXE0TZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 15:25:40 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: Michael Buesch <mb@bu3sch.de>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Re: b44: regression in 2.6.22 (resend)
Date: Sun, 27 May 2007 21:25:17 +0200
User-Agent: KMail/1.9.7
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070525172431.60affaca@freepuppy> <200705261901.18110.mb@bu3sch.de>
In-Reply-To: <200705261901.18110.mb@bu3sch.de>
MIME-Version: 1.0
Message-Id: <200705272125.25506.maxi@daemonizer.de>
X-Length: 13538
Content-Type: multipart/signed;
  boundary="nextPart1690049.q556Q8Z98W";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.0 (----)
X-Spam-Report: No, hits=-4.0 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00 autolearn=ham version=3.1.7-deb 
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.4 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1690049.q556Q8Z98W
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I send this again because my first mail accidently had html code in it and=
=20
might have been filtered by some people.

On Saturday 26 May 2007, Michael Buesch wrote:
> On Saturday 26 May 2007 02:24:31 Stephen Hemminger wrote:
> > Something is broken with the b44 driver in 2.6.22-rc1 or later. Now
> > bisecting. The performance (with iperf) for receiving is normally 94Mbi=
ts
> > or more. But something happened that dropped performance to less than
> > 1Mbit, probably corrupted packets.
> >
> > There is nothing obvious in the commit log for drivers/net/b44.c, so it
> > probably is something more general.
> >
> >
> > Looking at the code in b44_rx(), I see a couple unrelated of bugs:
> > 1. In the small packet case it recycles the skb before copying data
> > out... Not good if new data arrives overwriting existing data.
> >
> > 2. Macros like RX_PKT_BUF_SZ that depend on local variables are evil!!
>
> Very interesting!
> 2.6.22 doesn't include ssb, does it?
>
> Adding CCs to make reporters of another bugreport aware of this.

I did some more tests with my BCM4401 and different kernels, here are the=20
results:

2.6.21.1:

iperf:
[  5] local 192.168.1.2 port 58414 connected with 192.168.1.1 port 5001
[  5]  0.0-60.6 sec  1.13 MBytes    157 Kbits/sec
[  4] local 192.168.1.2 port 5001 connected with 192.168.1.1 port 57837
[  4]  0.0-63.1 sec  2.82 MBytes    375 Kbits/sec

koala:~# ping -c10 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=3D1 ttl=3D64 time=3D0.241 ms
64 bytes from 192.168.1.1: icmp_seq=3D2 ttl=3D64 time=3D0.215 ms
64 bytes from 192.168.1.1: icmp_seq=3D3 ttl=3D64 time=3D0.230 ms
64 bytes from 192.168.1.1: icmp_seq=3D4 ttl=3D64 time=3D0.238 ms
64 bytes from 192.168.1.1: icmp_seq=3D5 ttl=3D64 time=3D0.229 ms
64 bytes from 192.168.1.1: icmp_seq=3D6 ttl=3D64 time=3D0.228 ms
64 bytes from 192.168.1.1: icmp_seq=3D7 ttl=3D64 time=3D0.231 ms
64 bytes from 192.168.1.1: icmp_seq=3D8 ttl=3D64 time=3D0.229 ms
64 bytes from 192.168.1.1: icmp_seq=3D9 ttl=3D64 time=3D0.228 ms
64 bytes from 192.168.1.1: icmp_seq=3D10 ttl=3D64 time=3D0.237 ms

=2D-- 192.168.1.1 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 8998ms
rtt min/avg/max/mdev =3D 0.215/0.230/0.241/0.018 ms

The system was unusable while i ran the iperf test, when I moved the mouse =
it=20
was only jumping around and doing anything like starting programs or=20
switching the desktop first happend after iperf had finished it's test.

I did a http downlaod with wget and got 11.23M/s.


2.6.22-rc3:

[  5] local 192.168.1.2 port 46557 connected with 192.168.1.1 port 5001
[  5]  0.0-60.4 sec  58.9 MBytes  8.18 Mbits/sec
[  4] local 192.168.1.2 port 5001 connected with 192.168.1.1 port 51633
[  4]  0.0-63.1 sec  7.27 MBytes    967 Kbits/sec

koala:~# ping -c10 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=3D1 ttl=3D64 time=3D0.243 ms
64 bytes from 192.168.1.1: icmp_seq=3D2 ttl=3D64 time=3D0.234 ms
64 bytes from 192.168.1.1: icmp_seq=3D3 ttl=3D64 time=3D0.238 ms
64 bytes from 192.168.1.1: icmp_seq=3D4 ttl=3D64 time=3D0.235 ms
64 bytes from 192.168.1.1: icmp_seq=3D5 ttl=3D64 time=3D0.230 ms
64 bytes from 192.168.1.1: icmp_seq=3D6 ttl=3D64 time=3D0.317 ms
64 bytes from 192.168.1.1: icmp_seq=3D7 ttl=3D64 time=3D0.232 ms
64 bytes from 192.168.1.1: icmp_seq=3D8 ttl=3D64 time=3D0.232 ms
64 bytes from 192.168.1.1: icmp_seq=3D9 ttl=3D64 time=3D0.228 ms
64 bytes from 192.168.1.1: icmp_seq=3D10 ttl=3D64 time=3D0.238 ms

=2D-- 192.168.1.1 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 8997ms
rtt min/avg/max/mdev =3D 0.228/0.242/0.317/0.031 ms

System responsiveness was the same as with 2.6.21.1.

wget got 11.23M/s, again same as 2.6.21.1.


2.6.22-rc2-mm1:

[  5] local 192.168.1.2 port 42198 connected with 192.168.1.1 port 5001
[  5]  0.0-60.1 sec    402 MBytes  56.1 Mbits/sec
[  4] local 192.168.1.2 port 5001 connected with 192.168.1.1 port 48598
[  4]  0.0-63.0 sec    177 MBytes  23.6 Mbits/sec

koala:~# ping -c10 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=3D1 ttl=3D64 time=3D39.8 ms
64 bytes from 192.168.1.1: icmp_seq=3D2 ttl=3D64 time=3D52.7 ms
64 bytes from 192.168.1.1: icmp_seq=3D3 ttl=3D64 time=3D86.7 ms
64 bytes from 192.168.1.1: icmp_seq=3D4 ttl=3D64 time=3D8.22 ms
64 bytes from 192.168.1.1: icmp_seq=3D5 ttl=3D64 time=3D32.1 ms
64 bytes from 192.168.1.1: icmp_seq=3D6 ttl=3D64 time=3D56.0 ms
64 bytes from 192.168.1.1: icmp_seq=3D7 ttl=3D64 time=3D80.0 ms
64 bytes from 192.168.1.1: icmp_seq=3D8 ttl=3D64 time=3D1.52 ms
64 bytes from 192.168.1.1: icmp_seq=3D9 ttl=3D64 time=3D25.4 ms
64 bytes from 192.168.1.1: icmp_seq=3D10 ttl=3D64 time=3D49.3 ms

=2D-- 192.168.1.1 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9000ms
rtt min/avg/max/mdev =3D 1.526/43.207/86.700/26.369 ms

Here system responsiveness was ok whil I ran iperf, I didn't notic anything=
=20
anomalous.

When I tried the wget http download the tranfer did stall and from this poi=
nt=20
on I couldn't send or receive anything on my BCM4401 anymore. Taken the=20
interface down and up again didn't help anything. I wonder if this is Uwe's=
=20
problem

on all the kernels there apperaded nothing special in dmesg.

for the iperf test I connect my BCM4401 directly with an e100. The system w=
ith=20
the e100 was iperf server and ran fine all over the test.

Maxi

--nextPart1690049.q556Q8Z98W
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWdslOimwv528XGERAqWrAJ0RAT9itb1CylS5IVfmig+QFxvSTACeIYIb
Lw4L6a7jeXbBfu4A5ljmWwE=
=pe3p
-----END PGP SIGNATURE-----

--nextPart1690049.q556Q8Z98W--
