Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbXLZFns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbXLZFns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 00:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXLZFnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 00:43:42 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54054 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbXLZFnl (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 00:43:41 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul.moore@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc6-mm1 - git-lblnet.patch and networking horkage
In-Reply-To: Your message of "Sat, 22 Dec 2007 23:30:56 PST."
             <20071222233056.d652743e.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20071222233056.d652743e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1198647785_2917P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Dec 2007 00:43:06 -0500
Message-ID: <30638.1198647786@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1198647785_2917P
Content-Type: text/plain; charset=us-ascii

On Sat, 22 Dec 2007 23:30:56 PST, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/

I've bisected it down this far:

kvm-ist-kaput.patch     GOOD
git-lblnet.patch
git-lblnet-fixup.patch
git-leds.patch
git-libata-all.patch
git-libata-all-fix-pata_winbond-borkage.patch
git-libata-all-wtf.patch        BAD

and somehow, I doubt the leds or libata trees horked up networking. ;)

Symptoms - semi-sporadic failures in making network connections.  The test
case that tripped it up was the 'make test' from the Tcl 8.5 - several of the
test cases will create a listening socket, and then try to connect to it.
Under 2.6.24-rc5-mm1, it works just fine, but I'm seeing hangs under -rc6-mm1.
Doing a 'netstat -n -a -A inet -p' while it's hung shows me this:

Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name   
tcp        0      0 127.0.0.1:34118             0.0.0.0:*                   LISTEN      2236/tcltest        
tcp        0      1 127.0.0.1:59460             127.0.0.1:34118             SYN_SENT    2236/tcltest        
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name   
tcp        0      0 127.0.0.1:47842             0.0.0.0:*                   LISTEN      2352/tcltest        
tcp        0      1 127.0.0.1:46510             127.0.0.1:47842             SYN_SENT    2352/tcltest        
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name   
tcp        0      0 127.0.0.1:47842             0.0.0.0:*                   LISTEN      2352/tcltest        
tcp        0      1 127.0.0.1:46510             127.0.0.1:47842             SYN_SENT    2352/tcltest        

Pretty consistent failure mode - a socket is in 'listen', and the connection
gets hung in 'SYN_SENT'. There's 3 outputs listed - the first one from one run
of the test case, the second 2 are some 20 seconds apart on the same run.
It's pretty obvious that if you can't complete a 3-packet handshake to loopback
in 20 seconds, something is hosed.  However, it's apparently some sort of
race/timing issue, as many *other* test cases in the Tcl test tree do in fact
work OK.

I already checked, it's not a slam-dunk to just 'patch -R' as there's 3 or 4
conflicts where later patches need massaging/reverting as well.

It's a problem with both 'classic RCU' and 'preempt RCU' (that was my *first*
guess as to the cause).

Any clues/hints/advice/patches?

--==_Exmh_1198647785_2917P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHcenpcC3lWbTT17ARAlpsAKCv0T0Vgd2SFRSUZ90UNrMxVWjorwCgrDUj
Ctgz9xURqhsbpD4bmDWMpls=
=ZV8L
-----END PGP SIGNATURE-----

--==_Exmh_1198647785_2917P--
