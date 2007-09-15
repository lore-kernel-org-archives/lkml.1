Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbXIOQ3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbXIOQ3L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 12:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbXIOQ25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 12:28:57 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:41370 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbXIOQ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 12:28:56 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 15 Sep 2007 12:27:07 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][RFC] Extend "memparse" to allow a NULL return pointer value.
Message-ID: <Pine.LNX.4.64.0709151217530.16440@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Extend the memparse() routine to allow a caller to use NULL as the
second parameter value if he has no interest in that returned value.

---

  there appear to be quite a number of calls to "memparse" which have
no use for the value returned in the second parameter (the current
pointer after the successful parse), but which are still forced to
supply a valid char** address since they have no choice but to accept
that value coming back.  in many cases, that value is accepted just
before the end of the calling function, making it clear that the value
is ignored entirely, anyway.

  this patch simply allows NULL as a second parameter to show that the
caller has no interest in that returned value, and it makes that
visually more obvious as well.  theoretically, this extension is
entirely backwards compatible.

  compile-tested on i386.  not boot-time tested yet, but i'm just
asking for feedback.


diff --git a/lib/cmdline.c b/lib/cmdline.c
index f596c08..53a668f 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -128,9 +128,11 @@ char *get_options(const char *str, int nints, int *ints)

 unsigned long long memparse (char *ptr, char **retptr)
 {
-	unsigned long long ret = simple_strtoull (ptr, retptr, 0);
+	char *localptr;

-	switch (**retptr) {
+	unsigned long long ret = simple_strtoull (ptr, &localptr, 0);
+
+	switch (*localptr) {
 	case 'G':
 	case 'g':
 		ret <<= 10;
@@ -140,10 +142,15 @@ unsigned long long memparse (char *ptr, char **retptr)
 	case 'K':
 	case 'k':
 		ret <<= 10;
-		(*retptr)++;
+		localptr++;
 	default:
 		break;
 	}
+
+	if (retptr) {
+		*retptr = localptr;
+	}
+
 	return ret;
 }


-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
