Return-Path: <linux-kernel-owner+w=401wt.eu-S932625AbZHQRpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbZHQRpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 13:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbZHQRpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 13:45:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52737 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757644AbZHQRpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 13:45:15 -0400
Date: Mon, 17 Aug 2009 19:40:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: stephane eranian <eranian@googlemail.com>
Cc: Jamie Lokier <jamie@shareable.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
Subject: Re: F_SETOWN_TID: F_SETOWN was thread-specific for a while
Message-ID: <20090817174001.GA17535@redhat.com>
References: <1248984003.4164.0.camel@laptop> <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins> <20090731141122.a1939712.akpm@linux-foundation.org> <7c86c4470908030553v5a0a4448p94ab612700d68066@mail.gmail.com> <20090809054601.GA26152@shareable.org> <7c86c4470908100522q44dc1228i315b29d69fc98da3@mail.gmail.com> <20090810170338.GA14223@redhat.com> <7c86c4470908101401k49f42788o25eb1efaa631f065@mail.gmail.com> <20090817171605.GB15907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817171605.GB15907@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to show the patch,

On 08/17, Oleg Nesterov wrote:
>
> And again, this is even documented. The change is trivial but user-space
> visible, it may confuse the (stupid) app which uses SIGIO + SA_SIGINFO
> without F_SETSIG.

Oleg.

Personally I do not really think this change is good idea. (and in any
case it should be re-diffed on top of Peter's OWN_EX patch).

Btw. _in theory_, "case 0" is not right wrt security_file_send_sigiotask(sig).
I think we shouldn't worry.

--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -431,6 +431,7 @@ static void send_sigio_to_task(struct ta
 			       int fd,
 			       int reason)
 {
+	siginfo_t si;
 	/*
 	 * F_SETSIG can change ->signum lockless in parallel, make
 	 * sure we read it once and use the same value throughout.
@@ -439,33 +440,33 @@ static void send_sigio_to_task(struct ta
 
 	if (!sigio_perm(p, fown, signum))
 		return;
+	/* Queue a rt signal with the appropriate fd as its
+	   value.  We use SI_SIGIO as the source, not 
+	   SI_KERNEL, since kernel signals always get 
+	   delivered even if we can't queue.  Failure to
+	   queue in this case _should_ be reported; we fall
+	   back to SIGIO in that case. --sct */
+	si.si_errno = 0;
+	si.si_fd    = fd;
+	si.si_code  = reason;
+	/* Make sure we are called with one of the POLL_*
+	   reasons, otherwise we could leak kernel stack into
+	   userspace.  */
+	BUG_ON((reason & __SI_MASK) != __SI_POLL);
+	if (reason - POLL_IN >= NSIGPOLL)
+		si.si_band  = ~0L;
+	else
+		si.si_band = band_table[reason - POLL_IN];
 
 	switch (signum) {
-		siginfo_t si;
 		default:
-			/* Queue a rt signal with the appropriate fd as its
-			   value.  We use SI_SIGIO as the source, not 
-			   SI_KERNEL, since kernel signals always get 
-			   delivered even if we can't queue.  Failure to
-			   queue in this case _should_ be reported; we fall
-			   back to SIGIO in that case. --sct */
 			si.si_signo = signum;
-			si.si_errno = 0;
-		        si.si_code  = reason;
-			/* Make sure we are called with one of the POLL_*
-			   reasons, otherwise we could leak kernel stack into
-			   userspace.  */
-			BUG_ON((reason & __SI_MASK) != __SI_POLL);
-			if (reason - POLL_IN >= NSIGPOLL)
-				si.si_band  = ~0L;
-			else
-				si.si_band = band_table[reason - POLL_IN];
-			si.si_fd    = fd;
 			if (!group_send_sig_info(signum, &si, p))
 				break;
 		/* fall-through: fall back on the old plain SIGIO signal */
 		case 0:
-			group_send_sig_info(SIGIO, SEND_SIG_PRIV, p);
+			si.si_signo = SIGIO;
+			group_send_sig_info(SIGIO, &si, p);
 	}
 }
 

