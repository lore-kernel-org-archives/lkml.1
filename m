Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbZAOUsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbZAOUsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932302AbZAOUCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:02:45 -0500
Received: from kroah.org ([198.145.64.141]:49661 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763452AbZAOUCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:02:40 -0500
Date: Thu, 15 Jan 2009 12:00:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Bernd Schmidt <bernd.schmidt@analog.com>
Subject: [patch 77/94] Fix timeouts in sys_pselect7
Message-ID: <20090115200013.GY14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-timeouts-in-sys_pselect7.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bernd Schmidt <bernds_cb1@t-online.de>

commit 62568510b8e2679cbc331d7de10ea9ba81ae8b3d upstream.

Since we (Analog Devices) updated our Blackfin kernel to 2.6.28, we've
seen occasional 5-second hangs from telnet.  telnetd calls select with a
NULL timeout, but with the new kernel, the system call occasionally
returns 0, which causes telnet to call sleep (5).  This did not happen
with earlier kernels.

The code in sys_pselect7 looks a bit strange, in particular the variable
"to" is initialized to NULL, then changed if a non-null timeout was
passed in, but not used further.  It needs to be passed to
core_sys_select instead of &end_time.

This bug was introduced by 8ff3e8e85fa6c312051134b3953e397feb639f51
("select: switch select() and poll() over to hrtimers").

Signed-off-by: Bernd Schmidt <bernd.schmidt@analog.com>
Reviewed-by: Ulrich Drepper <drepper@redhat.com>
Tested-by: Robin Getz <rgetz@blackfin.uclinux.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/select.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/select.c
+++ b/fs/select.c
@@ -560,7 +560,7 @@ static long do_pselect(int n, fd_set __u
 		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
 	}
 
-	ret = core_sys_select(n, inp, outp, exp, &end_time);
+	ret = core_sys_select(n, inp, outp, exp, to);
 	ret = poll_select_copy_remaining(&end_time, tsp, 0, ret);
 
 	if (ret == -ERESTARTNOHAND) {

