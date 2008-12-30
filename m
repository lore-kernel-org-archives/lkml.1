Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbYL3MAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbYL3MAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 07:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYL3MA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 07:00:29 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34171 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbYL3MA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 07:00:28 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Joe Peterson <joe@skyrush.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [BUG?] tty doesn't handle ^D at cooked/non-cooked switching corner case
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081230201932.128D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 30 Dec 2008 21:00:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi tty expert,

Recently, ruby (scripting program language) developing group found
that linux doesn't handle ^D properly at cooked/non-cooked switching
corner case.

They (and I) think it isn't typical case, but scripting language vm
shouldn't hang up although script user write any crap and strange code.

They create following patch. is it right way?



reproduce way
--------------
1. run tty_test.sh (see below)
2. input any key before output "cooked"
3. input ^D, but do nothing


tty_test.sh
--------------
#!/bin/sh

exec 3<&0
cat <&3 &
pid=$!
stty -icanon
echo raw
sleep 1
stty icanon
echo cooked
wait $pid

---
 drivers/char/n_tty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/char/n_tty.c
===================================================================
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -1893,7 +1893,7 @@ do_it_again:
 			check_unthrottle(tty);
 		}
 
-		if (b - buf >= minimum)
+		if (b - buf >= (tty->icanon ? 0 : minimum))
 			break;
 		if (time)
 			timeout = time;






