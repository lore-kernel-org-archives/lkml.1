Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZFPEoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZFPEoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 00:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbZFPEo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 00:44:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42443 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbZFPEo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 00:44:28 -0400
Date: Tue, 16 Jun 2009 14:44:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Theodore Tso <tytso@MIT.EDU>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: linux-next: ext4 tree build failure
Message-Id: <20090616144413.50e975f9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__16_Jun_2009_14_44_13_+1000_PaggHDtjLOsDsl3S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Jun_2009_14_44_13_+1000_PaggHDtjLOsDsl3S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

Today's linux-next build (powerpc ppc64_defconfig) failed like this after
the slab tree was merged:

In file included from fs/jbd2/checkpoint.c:26:
include/trace/events/jbd2.h:11: error: expected ')' before '(' token
include/trace/events/jbd2.h:31: error: expected ')' before '(' token
include/trace/events/jbd2.h:54: error: expected ')' before '(' token
include/trace/events/jbd2.h:77: error: expected ')' before '(' token
include/trace/events/jbd2.h:100: error: expected ')' before '(' token
include/trace/events/jbd2.h:122: error: expected ')' before '(' token
include/trace/events/jbd2.h:146: error: expected ')' before '(' token
fs/jbd2/checkpoint.c: In function 'jbd2_log_do_checkpoint':
fs/jbd2/checkpoint.c:361: error: implicit declaration of function 'trace_jb=
d2_checkpoint'

It looks like TRACE_EVENT is not defined.

The config differences are:
CONFIG_SLUB_DEBUG and CONFIG_SLUB change from y to n
CONFIG_SLQB_ALLOCATOR, CONFIG_SLQB and CONFIG_SLQB_DEBUG become y

The .i files looks very different (the bad one has TRACE_EVENT explictly
in there, while the other has it expanded).  It appears that some of the
tracing include files that should have been included explicitly were
being included implicitly by the slub include files.

So I have reverted commit 75ef2ffeb02c7e1fbe8114f2fddd2e8880397892
("jbd2: convert instrumentation from markers to tracepoints") for today.

This produced another error:

In file included from include/trace/ftrace.h:262,
                 from include/trace/define_trace.h:57,
                 from include/trace/events/ext4.h:720,
                 from fs/ext4/super.c:51:
include/trace/events/ext4.h: In function 'ftrace_raw_output_ext4_free_inode=
':
include/trace/events/ext4.h:12: error: implicit declaration of function 'jb=
d2_dev_to_name'

So I also reverted commit a6e130e94db16b324fbf2eeed2b310273625acf7 ("ext4: =
convert instrumentation from markers to tracepoints") after reverting the d=
ependent commit 3f9c083c0ffd344da212c9813c3c5ddba1a65936 ("ext4: Fix 64-bit=
 block type problem on 32-bit platforms") for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__16_Jun_2009_14_44_13_+1000_PaggHDtjLOsDsl3S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko3Ix0ACgkQjjKRsyhoI8zQ0wCgqlaAKPOJnyAZoqikIHQVx9Bg
9RkAnjWs9Qj9xGofvbjMeBSIygceFjpO
=wF1a
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Jun_2009_14_44_13_+1000_PaggHDtjLOsDsl3S--
