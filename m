Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXA1ClJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXA1ClJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 21:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932367AbXA1ClJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 21:41:09 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48037 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344AbXA1ClI (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 21:41:08 -0500
Message-Id: <200701280241.l0S2f2ga015847@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@osdl.org>
Cc: Tilman Schmidt <tilman@imap.cc>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Hansjoerg Lipp <hjlipp@web.de>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
In-Reply-To: Your message of "Sat, 27 Jan 2007 13:41:16 PST."
             <20070127134116.06bdadd8.akpm@osdl.org>
From: Valdis.Kletnieks@vt.edu
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net> <6bffcb0e0701270837i1ec40560l6e61e8876177e9da@mail.gmail.com> <45BBC444.8090109@imap.cc>
            <20070127134116.06bdadd8.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1169952061_13160P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 27 Jan 2007 21:41:02 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1169952061_13160P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, 27 Jan 2007 13:41:16 PST, Andrew Morton said:
> > > On 26/01/07, akpm=40osdl.org <akpm=40osdl.org> wrote:
> > >> The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
> > >>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz

> I have everything compiling now, mostly.  The number of fixes which were
> needed was just extraordinary.  I'm thinking about making changes...

Another one - I can't get this to build for x86_64. (Skipping over all the
already-mentioned build errors that others have already reported...)

First, I had to do some ad-crock hacking of Kconfig files to get kernel/timer.c
to build right, because otherwise it didn't include any of the defines in
include/kernel/clockchips.c so CLOCK_EVT_NOTIFY_RESUME wasn't defined (either
that, or a #ifdef for GENERIC_TIME had its #endif land in the wrong place?)

--- linux-2.6.20-rc6-mm1/arch/x86_64/Kconfig.dist	2007-01-26 14:30:53.000000000 -0500
+++ linux-2.6.20-rc6-mm1/arch/x86_64/Kconfig	2007-01-27 07:14:22.000000000 -0500
@@ -32,6 +32,14 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default y
 
+config GENERIC_CLOCKEVENTS
+	bool
+	default y
+
+config GENERIC_CLOCKEVENTS_BROADCAST
+	bool
+	default y
+
 config ZONE_DMA32
 	bool
 	default y
@@ -126,6 +134,8 @@ source "init/Kconfig"
 
 menu "Processor type and features"
 
+source "kernel/time/Kconfig"
+
 choice
 	prompt "Subarchitecture Type"
 	default X86_PC

And even after that, I hit this:

  CC      kernel/time/clocksource.o
In file included from kernel/time/clocksource.c:31:
include/linux/tick.h:45: error: field sched_timer has incomplete type
make: *** =5Bkernel/time/clocksource.o: Error 1

--- linux-2.6.20-rc6-mm1/kernel/time/clocksource.c.dist	2007-01-27 19:36:31.000000000 -0500
+++ linux-2.6.20-rc6-mm1/kernel/time/clocksource.c	2007-01-27 19:36:03.000000000 -0500
@@ -28,6 +28,7 @@
 #include <linux/sysdev.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/hrtimer.h>
 #include <linux/tick.h>
 
 /* XXX - Would like a better way for initializing curr_clocksource */

Then we live long enough to hit this:

  CC      block/elevator.o
block/elevator.c: In function elv_insert:
block/elevator.c:611: error: unplug_it undeclared (first use in this function)

--- linux-2.6.20-rc6-mm1/block/elevator.c.dist	2007-01-26 14:30:36.000000000 -0500
+++ linux-2.6.20-rc6-mm1/block/elevator.c	2007-01-27 19:57:02.000000000 -0500
@@ -604,12 +604,6 @@ void elv_insert(request_queue_t *q, stru
 		 */
 		rq->cmd_flags |= REQ_SOFTBARRIER;
 
-		/*
-		 * Most requeues happen because of a busy condition,
-		 * don't force unplug of the queue for that case.
-		 */
-		unplug_it = 0;
-
 		if (q->ordseq == 0) {
 			list_add(&rq->queuelist, &q->queue_head);
 			break;


(How did *that* one manage to compile for anybody??!?)

After all that, I finally got a clean compile....  Maybe later I'll get brave
and actually try to boot it. :)



--==_Exmh_1169952061_13160P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFFvA09cC3lWbTT17ARAp0eAJ9dzLfdZ0n/XnZbNQMpsCytqTo6GgCg71bb
C3WJASbXfnkCTCefdwvjTiI=
=XErw
-----END PGP SIGNATURE-----

--==_Exmh_1169952061_13160P--
