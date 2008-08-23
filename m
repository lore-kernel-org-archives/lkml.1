Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYHWQBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYHWQBR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 12:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYHWQBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 12:01:00 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35613 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbYHWQA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 12:00:58 -0400
Date: Sat, 23 Aug 2008 18:00:56 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: paulus@samba.org, benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] drivers/char/hvc_console.c: adjust call to put_tty_driver
Message-ID: <Pine.LNX.4.64.0808231800200.3162@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The call to put_tty_driver is out of place and is applied to the wrong
argument.

The function enclosing the patched code calls alloc_tty_driver and stores
the result in drv.  Subsequently, there are two occurrences of error
handling code, one making a goto to put_tty and one making a goto to
stop_thread.  At the point of the first one the assignment hvc_driver = drv
has not yet been executed, and from inspecting the rest of the file it
seems that hvc_driver would be NULL.  Thus the current call to
put_tty_driver is useless, and one applied to drv is needed.  The goto
stop_thread is in the error handling code for a call to
tty_register_driver, but the error cases in tty_register_driver do not free
its argument, so it should be done here.  Thus, I have moved the put_tty
label after the stop_thread label, so that put_tty_driver is called in both
cases.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
expression E,f;
position p1,p2,p3;
identifier l;
statement S;
@@

x = alloc_tty_driver@p1(...)
...
if (x == NULL) S
... when != E = x
    when != put_tty_driver(x)
goto@p2 l;
... when != E = x
    when != f(...,x,...)
    when any
(
return \(0\|x\);
|
return@p3 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
p3 << r.p3;
@@

print "%s: call on line %s not freed or saved before return on line %s via line %s" % (p1[0].file,p1[0].line,p3[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/char/hvc_console.c    |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index fd64137..ec7aded 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -819,11 +819,11 @@ static int hvc_init(void)
 	hvc_driver = drv;
 	return 0;
 
-put_tty:
-	put_tty_driver(hvc_driver);
 stop_thread:
 	kthread_stop(hvc_task);
 	hvc_task = NULL;
+put_tty:
+	put_tty_driver(drv);
 out:
 	return err;
 }
