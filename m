Return-Path: <linux-kernel-owner+w=401wt.eu-S968222AbXFHHcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968222AbXFHHcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967567AbXFHHTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:19:52 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:57614 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966932AbXFHHTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:19:50 -0400
Message-Id: <20070608071554.380591000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:36 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       Vasily Averin <vvs@sw.ru>
Subject: [patch 25/32] NET: "wrong timeout value" in sk_wait_data() v2
Content-Disposition: inline; filename=net-wrong-timeout-value-in-sk_wait_data-v2.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Vasily Averin <vvs@sw.ru>

sys_setsockopt() do not check properly timeout values for
SO_RCVTIMEO/SO_SNDTIMEO, for example it's possible to set negative timeout
values. POSIX do not defines behaviour for sys_setsockopt in case negative
timeouts, but requires that setsockopt() shall fail with -EDOM if the send and
receive timeout values are too big to fit into the timeout fields in the socket
structure.
In current implementation negative timeout can lead to error messages like
"schedule_timeout: wrong timeout value".

Proposed patch:
- checks tv_usec and returns -EDOM if it is wrong
- do not allows to set negative timeout values (sets 0 instead) and outputs
ratelimited information message about such attempts.

Signed-off-By: Vasily Averin <vvs@sw.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/core/sock.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- linux-2.6.20.13.orig/net/core/sock.c
+++ linux-2.6.20.13/net/core/sock.c
@@ -204,7 +204,19 @@ static int sock_set_timeout(long *timeo_
 		return -EINVAL;
 	if (copy_from_user(&tv, optval, sizeof(tv)))
 		return -EFAULT;
+	if (tv.tv_usec < 0 || tv.tv_usec >= USEC_PER_SEC)
+		return -EDOM;
 
+	if (tv.tv_sec < 0) {
+		static int warned = 0;
+		*timeo_p = 0;
+		if (warned < 10 && net_ratelimit())
+			warned++;
+			printk(KERN_INFO "sock_set_timeout: `%s' (pid %d) "
+			       "tries to set negative timeout\n",
+			        current->comm, current->pid);
+		return 0;
+	}
 	*timeo_p = MAX_SCHEDULE_TIMEOUT;
 	if (tv.tv_sec == 0 && tv.tv_usec == 0)
 		return 0;

-- 
