Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbZAMVOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbZAMVOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZAMVOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:14:41 -0500
Received: from mailout06.t-online.de ([194.25.134.19]:38167 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZAMVOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:14:40 -0500
Message-ID: <496D0448.7030508@t-online.de>
Date: Tue, 13 Jan 2009 22:14:48 +0100
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090102)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Fix timeouts in sys_pselect7
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------080109050103070300010608"
X-ID: V81naOZfYh2VC3olYeukL2Dp4yVrYedqjlnT+m0Bxco2NcPB21oEDREEidhopBSQMJ
X-TOI-MSGID: 92c1fc44-9b10-4fa5-8a41-b80807a6eaa5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080109050103070300010608
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Since we (Analog Devices) updated our Blackfin kernel to 2.6.28, we've
seen occasional 5-second hangs from telnet.  telnetd calls select with a
NULL timeout, but with the new kernel, the system call occasionally
returns 0, which causes telnet to call sleep (5).  This did not happen
with earlier kernels.

The code in sys_pselect7 looks a bit strange, in particular the variable
"to" is initialized to NULL, then changed if a non-null timeout was
passed in, but not used further.  It needs to be passed to
core_sys_select instead of &end_time.

Signed-off-by: Bernd Schmidt <bernd.schmidt@analog.com>
Reviewed-by: Ulrich Drepper <drepper@redhat.com>
Tested-by: Robin Getz <rgetz@blackfin.uclinux.org>
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif


--------------080109050103070300010608
Content-Type: text/plain;
 name="select.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="select.diff"

 fs/select.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 08b91be..b0cf1f0 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -610,7 +610,7 @@ asmlinkage long sys_pselect7(int n, fd_set __user *inp, fd_set __user *outp,
 		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
 	}
 
-	ret = core_sys_select(n, inp, outp, exp, &end_time);
+	ret = core_sys_select(n, inp, outp, exp, to);
 	ret = poll_select_copy_remaining(&end_time, tsp, 0, ret);
 
 	if (ret == -ERESTARTNOHAND) {


--------------080109050103070300010608--
