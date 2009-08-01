Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbZHABkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbZHABkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 21:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZHABj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 21:39:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39892 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbZHABj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 21:39:59 -0400
Date: Sat, 1 Aug 2009 03:28:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
Subject: [PATCH 2/2] signals: send_sigio: use do_send_sig_info() to avoid
	check_kill_permission()
Message-ID: <20090801012838.GC30259@redhat.com>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com> <1248869948.6987.3083.camel@twins> <20090729221703.GA25368@redhat.com> <1248953485.6391.41.camel@twins> <20090730192040.GA9503@redhat.com> <1248984003.4164.0.camel@laptop> <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins> <20090731141122.a1939712.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090731141122.a1939712.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

group_send_sig_info()->check_kill_permission() assumes that current
is the sender and uses current_cred().

This is not true in send_sigio_to_task() case. From the security pov
the sender is not current, but the task which did fcntl(F_SETOWN),
that is why we have sigio_perm() which uses the right creds to check.

Fortunately, send_sigio() always sends either SEND_SIG_PRIV or
SI_FROMKERNEL() signal, so check_kill_permission() does nothing. But
still it would be tidier to avoid this bogus security check and save
a couple of cycles.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/fcntl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- WAIT/fs/fcntl.c~2_SIGIO	2009-06-17 14:11:26.000000000 +0200
+++ WAIT/fs/fcntl.c	2009-08-01 02:40:41.000000000 +0200
@@ -462,11 +462,11 @@ static void send_sigio_to_task(struct ta
 			else
 				si.si_band = band_table[reason - POLL_IN];
 			si.si_fd    = fd;
-			if (!group_send_sig_info(signum, &si, p))
+			if (!do_send_sig_info(signum, &si, p, true))
 				break;
 		/* fall-through: fall back on the old plain SIGIO signal */
 		case 0:
-			group_send_sig_info(SIGIO, SEND_SIG_PRIV, p);
+			do_send_sig_info(SIGIO, SEND_SIG_PRIV, p, true);
 	}
 }
 

