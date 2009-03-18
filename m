Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbZCRPLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbZCRPLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 11:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757646AbZCRPLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 11:11:30 -0400
Received: from mx1.mxtelecom.com ([87.86.212.101]:47745 "EHLO
	puma.mxtelecom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757128AbZCRPL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:11:29 -0400
X-Greylist: delayed 1048 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Mar 2009 11:11:28 EDT
Date: Wed, 18 Mar 2009 14:53:47 +0000
From: Paul Evans <paul@mxtelecom.com>
To: linux-kernel@vger.kernel.org
Subject: Slow long-term increase in dirty pages
Message-ID: <20090318145347.3d709de8@nacelle.mxtelecom.com>
Organization: MX Telecom
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/TX/0MYuEXaCRzK5EKaLs1Rb";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TX/0MYuEXaCRzK5EKaLs1Rb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

We have a server whose dirty page count keeps increasing all the time,
to the point where 'sync' takes ages to flush the pages:

  root@freehand:~# time sync

  real    1m15.570s
  user    0m0.000s
  sys     0m0.052s

We have some graphs of the dirty page count, as captured
from /proc/vmstat's "nr_dirty" entry:

  http://opensource.mxtelecom.com/tmp/freehand-dirty-day.png
  http://opensource.mxtelecom.com/tmp/freehand-dirty-week.png

I have tuned the dirty page flushing sysctls to the following:

  root@freehand:~# for F in /proc/sys/vm/dirty_*; do echo -n "$F: "; cat $F=
; done
  /proc/sys/vm/dirty_background_ratio: 1
  /proc/sys/vm/dirty_expire_centisecs: 3000
  /proc/sys/vm/dirty_ratio: 3
  /proc/sys/vm/dirty_writeback_centisecs: 500

The role of the machine itself is that it performings large amount of
kernel iptables routing/firewalling traffic, and runs a set of apache
servers as HTTP<->Tomcat gateways.

  root@freehand:~# uname -r
  2.6.27-fes

(this is a build of stock 2.6.27 source, with some extra iptables
patches. There shouldn't be anything mm-related here)

By my understanding of the dirty page flush algorithm, we shouldn't be
accumulating these pages all the time; any page older than 30 seconds
ought to be written out, yes?

If we manually 'sync', as above, then the count drops to zero, but then
slowly starts ramping up again as observed.

As a temporary workaround I've put 'sync' in cron every 10 minutes, but
is there some more tuning I can do; or at least probing to see where
these pages are being accumulated from?

--=20
Paul Evans <paul@mxtelecom.com>
Tel: +44 (0) 845 666 7778
Fax: +44 (0) 870 163 4694
http://www.mxtelecom.com

--Sig_/TX/0MYuEXaCRzK5EKaLs1Rb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknBCvsACgkQcGehlx3Gqx69cwCgjX7h40MILE8qqCWJQje9KlWe
YgIAnj7jNJtOno6u0Fz3FFTzb7plF/U9
=uNzi
-----END PGP SIGNATURE-----

--Sig_/TX/0MYuEXaCRzK5EKaLs1Rb--
