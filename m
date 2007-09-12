Return-Path: <linux-kernel-owner+w=401wt.eu-S967305AbXILMH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967305AbXILMH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 08:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765745AbXILMHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 08:07:15 -0400
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:36964 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765744AbXILMHN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 08:07:13 -0400
From: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
Organization: Studentenwerk =?iso-8859-1?q?M=FCnchen?=
To: trond.myklebust@fys.uio.no, bfields@fieldses.org
Subject: [patch] sunrpc: make closing of old temporary sockets work (was: problems with lockd in 2.6.22.6)
Date: Wed, 12 Sep 2007 14:07:10 +0200
User-Agent: KMail/1.9.5
Cc: netdev@vger.kernel.org, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709121407.11151.wolfgang.walter@studentenwerk.mhn.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

as already described old temporary sockets (client is gone) of lockd aren't
closed after some time. So, with enough clients and some time gone, there
are 80 open dangling sockets and you start getting messages of the form:

lockd: too many open TCP sockets, consider increasing the number of nfsd threads.

If I understand the code then the intention was that the server closes
temporary sockets after about 6 to 12 minutes:

	a timer is started which calls svc_age_temp_sockets every 6 minutes.

	svc_age_temp_sockets:
		if a socket is marked OLD it gets closed.
		sockets which are not marked as OLD are marked OLD

	every time the sockets receives something OLD is cleared.

But svc_age_temp_sockets never closes any socket though because it only
closes sockets with svsk->sk_inuse == 0. This seems to be a bug.

Here is a patch against 2.6.22.6 which changes the test to
svsk->sk_inuse <= 0 which was probably meant. The patched kernel runs fine
here. Unused sockets get closed (after 6 to 12 minutes)

Signed-off-by: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>

--- ../linux-2.6.22.6/net/sunrpc/svcsock.c	2007-08-27 18:10:14.000000000 +0200
+++ net/sunrpc/svcsock.c	2007-09-11 11:07:13.000000000 +0200
@@ -1572,7 +1575,7 @@
 
 		if (!test_and_set_bit(SK_OLD, &svsk->sk_flags))
 			continue;
-		if (atomic_read(&svsk->sk_inuse) || test_bit(SK_BUSY, &svsk->sk_flags))
+		if (atomic_read(&svsk->sk_inuse) <= 0 || test_bit(SK_BUSY, &svsk->sk_flags))
 			continue;
 		atomic_inc(&svsk->sk_inuse);
 		list_move(le, &to_be_aged);


As svc_age_temp_sockets did not do anything before this change may trigger
hidden bugs.

To be true I don't see why this check

(atomic_read(&svsk->sk_inuse) <= 0 || test_bit(SK_BUSY, &svsk->sk_flags))

is needed at all (it can only be an optimation) as this fields change after
the check. In svc_tcp_accept there is no such check when a temporary socket
is closed.


Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
