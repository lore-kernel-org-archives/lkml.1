Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYGDUKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYGDUKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 16:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYGDUKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 16:10:46 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:37435 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbYGDUKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 16:10:46 -0400
Message-ID: <486E83C3.1040509@skyrush.com>
Date: Fri, 04 Jul 2008 14:10:43 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <87fxqurqpz.fsf@denkblock.local>
In-Reply-To: <87fxqurqpz.fsf@denkblock.local>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------080302030303080304050606"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080302030303080304050606
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Elias Oltmanns wrote:
>> I have encountered the following situation several times, but I've been
>> unable to come up with a way to reproduce this until now:
>>  - some process is keeping the disk busy (some cron job for example:
>> updatedb, chkrootkit, ...)
>>  - other processes that want to do I/O have to wait (this is normal)
>>  - I have a (I/O bound) process running in my terminal, and I want to
>> interrupt it with Ctrl+C
>>  - I type Ctrl+C several times, and the process is not interrupted for
>> several seconds (10-30 secs)
>>  - if I type Ctrl+Z, and use kill %1 the process dies faster than
>> waiting for it to react to Ctrl+C
> 
> The following patch to 2.6.26-rc8 fixes the issue for me. Perhaps we
> really want to do something else, but since I'm not all that familiar
> with the standard behaviour on other Unices and since the comment
> describing the changed order of function calls in the original commit
> didn't give the reason for that change, I leave that to more
> knowledgeable people.

I have tried to reproduce the original poster's issue on
2.6.26-rc8-git3 without success.  In around 100 attempts (restarting the
disk activity process over each time it completed), it always broke out
after one ^C - one time took an extra second or two.  Note that I did
not run latencytop (did not have it compiled in my kernel) - if that is
required for the test, let me know, but I assume it is just for
gathering info when the issue occurs.

Can you please try something for me?  For one, apply the attached patch,
which removes what seems to be a redundant flush (since both calls end
up calling the same n_tty routine).  This made no difference for me, but
I am curious if it might help you.

If you still see the problem, please try typing "stty noflsh" and try
again.  This disables the flush step, which may be affecting you.
Again, this did not make a difference for me.

It will really help me to know the results of these steps for you.

As far as moving the flush after the signal, I have tried this (in the
patch I posted earlier), and it ends up causing various anomalies in
output, so I do not think that is the right solution.

						-Joe


--------------080302030303080304050606
Content-Type: text/x-patch;
 name="gentoo-sources-2.6.26-remove-redundant-flush.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gentoo-sources-2.6.26-remove-redundant-flush.patch"

--- linux/drivers/char/n_tty.c.orig	2008-07-04 09:45:37.000000000 -0600
+++ linux/drivers/char/n_tty.c	2008-07-04 11:25:38.000000000 -0600
@@ -589,10 +589,8 @@
 {
 	if (tty->pgrp)
 		kill_pgrp(tty->pgrp, sig, 1);
-	if (flush || !L_NOFLSH(tty)) {
+	if (flush || !L_NOFLSH(tty))
 		n_tty_flush_buffer(tty);
-		tty_driver_flush_buffer(tty);
-	}
 }
 
 /**
@@ -765,10 +763,8 @@
 			 * the order to be:
 			 * 1) flush, 2) echo, 3) signal
 			 */
-			if (!L_NOFLSH(tty)) {
+			if (!L_NOFLSH(tty))
 				n_tty_flush_buffer(tty);
-				tty_driver_flush_buffer(tty);
-			}
 			if (L_ECHO(tty))
 				echo_char(c, tty);
 			if (tty->pgrp)


--------------080302030303080304050606--
