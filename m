Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbXH2OEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbXH2OEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 10:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbXH2OEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 10:04:39 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48329 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbXH2OEj (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 10:04:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, jakub@redhat.com,
       Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1
In-Reply-To: Your message of "Wed, 22 Aug 2007 02:06:48 PDT."
             <20070822020648.5ea3a612.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1188396273_2981P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 29 Aug 2007 10:04:33 -0400
Message-ID: <23252.1188396273@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1188396273_2981P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <23246.1188396273.1@turing-police.cc.vt.edu>

On Wed, 22 Aug 2007 02:06:48 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/

Sorry for not catching this one sooner, but AFAICT, Fedora didn't ship a glibc
that trips over this (2.6.90-12) until Saturday and I installed it yesterday.
-22-rc6-mm1 demonstrated the same issue as well.

The issue:  vdso and gettimeofday seem to be having a quarrel.

At boot, the system clock is just fine.   Right when it hits the 5-minute
uptime mark (and suspiciously close to the jiffie rollover), the date suddenly
shoots forward 4096 seconds.

Dumb test script:

#!/bin/bash
log="uptime.`uname -r`"
touch /root/$log
tail -f /root/$log &
while /bin/true;
do
        uptime >> /root/$log
        date >> /root/$log
        sleep 1
done

Exerpt from runtime:

 19:57:55 up 1 min,  0 users,  load average: 0.09, 0.05, 0.01
Tue Aug 28 19:57:55 EDT 2007
 19:57:56 up 1 min,  0 users,  load average: 0.09, 0.05, 0.01
Tue Aug 28 19:57:56 EDT 2007
 19:57:57 up 2 min,  0 users,  load average: 0.08, 0.05, 0.01
Tue Aug 28 19:57:57 EDT 2007
 19:57:58 up 2 min,  0 users,  load average: 0.08, 0.05, 0.01
...
 20:00:55 up 4 min,  0 users,  load average: 0.01, 0.03, 0.00
Tue Aug 28 20:00:55 EDT 2007
 20:00:56 up 4 min,  0 users,  load average: 0.01, 0.03, 0.00
Tue Aug 28 20:00:56 EDT 2007
 20:00:57 up 5 min,  0 users,  load average: 0.01, 0.03, 0.00
Tue Aug 28 21:09:15 EDT 2007
 20:00:58 up 5 min,  0 users,  load average: 0.01, 0.03, 0.00
Tue Aug 28 21:09:16 EDT 2007
 20:00:59 up 5 min,  0 users,  load average: 0.01, 0.03, 0.00
Tue Aug 28 21:09:17 EDT 2007

uptime keeps reporting the right time, date goes flying ahead.  Once we
get into this state, I can issue a 'date' command to set the *right* time,
and then it will immediately reset back.  Doing a 'touch foo; ls -l foo'
shows the correct time.

Booting with vdso=0 makes the time/date run normally.

Ideas?

--==_Exmh_1188396273_2981P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG1XzxcC3lWbTT17ARArpHAKDfPyAnRQaCmHnMxt5StR7EsusPrwCcCb13
DCnR9fwzmLM/KBVEdOC4YV8=
=Fqlj
-----END PGP SIGNATURE-----

--==_Exmh_1188396273_2981P--
