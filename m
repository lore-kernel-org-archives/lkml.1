Return-Path: <linux-kernel-owner+w=401wt.eu-S1763969AbXLMHJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763969AbXLMHJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760980AbXLMG5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:57:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55390 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761933AbXLMG5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:57:14 -0500
Date: Wed, 12 Dec 2007 22:52:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, oleg@tv-sign.ru, roland@redhat.com,
       scott@ubuntu.com
Subject: [patch 32/60] wait_task_stopped(): pass correct exit_code to
	wait_noreap_copyout()
Message-ID: <20071213065240.GH6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="wait_task_stopped-pass-correct-exit_code-to-wait_noreap_copyout.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Scott James Remnant <scott@ubuntu.com>

patch e6ceb32aa25fc33f21af84cc7a32fe289b3e860c in mainline.

In wait_task_stopped() exit_code already contains the right value for the
si_status member of siginfo, and this is simply set in the non WNOWAIT
case.

If you call waitid() with a stopped or traced process, you'll get the signal
in siginfo.si_status as expected -- however if you call waitid(WNOWAIT) at the
same time, you'll get the signal << 8 | 0x7f

Pass it unchanged to wait_noreap_copyout(); we would only need to shift it
and add 0x7f if we were returning it in the user status field and that
isn't used for any function that permits WNOWAIT.

Signed-off-by: Scott James Remnant <scott@ubuntu.com>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1365,7 +1365,7 @@ static int wait_task_stopped(struct task
 		if (unlikely(!exit_code) || unlikely(p->exit_state))
 			goto bail_ref;
 		return wait_noreap_copyout(p, pid, uid,
-					   why, (exit_code << 8) | 0x7f,
+					   why, exit_code,
 					   infop, ru);
 	}
 

-- 
