Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbYJEQF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbYJEQF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755998AbYJEQEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:04:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54836 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755955AbYJEQEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:04:49 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 02/76] drivers/char/hvc_console.c: adjust call to
	put_tty_driver
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:04:49 +0100
Message-ID: <20081005160444.1997.84077.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/hvc_console.c |    4 ++--
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

