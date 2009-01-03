Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbZACAfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbZACAfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 19:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759778AbZACAfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 19:35:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35206 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759765AbZACAfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 19:35:13 -0500
Date: Sat, 3 Jan 2009 09:34:55 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [BUG?] tty doesn't handle ^D at cooked/non-cooked switching corner case
Cc: kosaki.motohiro@jp.fujitsu.com, Joe Peterson <joe@skyrush.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081230134427.003ff13a@lxorguk.ukuu.org.uk>
References: <20081230201932.128D.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081230134427.003ff13a@lxorguk.ukuu.org.uk>
Message-Id: <20090103092837.4C2E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Sorry for late responce.


> On Tue, 30 Dec 2008 21:00:23 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Hi tty expert,
> > 
> > Recently, ruby (scripting program language) developing group found
> > that linux doesn't handle ^D properly at cooked/non-cooked switching
> > corner case.
> 
> I don't believe the behaviour of input characters typed across that
> boundary is defined by the standards at all. That said I think the
> behaviour you expect is reasonable.
> 
> > They create following patch. is it right way?
> 
> You could recompute minimum in this case but zero is definitely
> incorrect. I think what you would actually need to do is to extract out
> the code just below do_it_again: which computes minimum and recompute it
> properly.

How about this?



==
Subject: [PATCH] tty: recompute minimum every wakeup
Impact: corner case bugfix

Generally, tty can be controled by multiple process at the same time.
But unfortunately, linux tty doesn't consider another process might have changed
tty attribute when own process is sleeping.

if following bad scenario happend, tty line discipline can't handle ^D.


reproduce way
=================
1. run tty_test.sh (see below)
2. input any key after "raw" is displayed
3. wait until "cooked" is displayed
4. input ^D  (oops, it's ignored. you can't exit from "cat")

tty_test.sh
--------------
#!/bin/sh

exec 3<&0
cat <&3 &
pid=$!
stty -icanon
echo raw
sleep 3
stty icanon
echo cooked
wait $pid
--------------


Reported-by: Tanaka Akira <akr@fsij.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/char/n_tty.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: b/drivers/char/n_tty.c
===================================================================
--- a/drivers/char/n_tty.c	2009-01-03 09:06:46.000000000 +0900
+++ b/drivers/char/n_tty.c	2009-01-03 09:08:15.000000000 +0900
@@ -1381,6 +1381,11 @@ do_it_again:
 			/* FIXME: does n_tty_set_room need locking ? */
 			n_tty_set_room(tty);
 			timeout = schedule_timeout(timeout);
+
+			/* Someone might have changed VMIN. check again. */
+			minimum = 0;
+			if (!tty->icanon)
+				minimum = MIN_CHAR(tty);
 			continue;
 		}
 		__set_current_state(TASK_RUNNING);




