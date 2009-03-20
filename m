Return-Path: <linux-kernel-owner+w=401wt.eu-S1763270AbZCTX1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763270AbZCTX1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762923AbZCTXYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:22 -0400
Received: from kroah.org ([198.145.64.141]:48487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762929AbZCTXYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:21 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:23 2009
Message-Id: <20090320222923.469852861@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:14 -0700
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
       alan@lxorguk.ukuu.org.uk, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 04/43] S390: __div64_31 broken for CONFIG_MARCH_G5
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=s390-__div64_31-broken-for-config_march_g5.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 4fa81ed27781a12f6303b9263056635ae74e3e21 upstream.

The implementation of __div64_31 for G5 machines is broken. The comments
in __div64_31 are correct, only the code does not do what the comments
say. The part "If the remainder has overflown subtract base and increase
the quotient" is only partially realized, the base is subtracted correctly
but the quotient is only increased if the dividend had the last bit set.
Using the correct instruction fixes the problem.

Reported-by: Frans Pop <elendil@planet.nl>
Tested-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/lib/div64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/lib/div64.c
+++ b/arch/s390/lib/div64.c
@@ -61,7 +61,7 @@ static uint32_t __div64_31(uint64_t *n, 
 		"	clr	%0,%3\n"
 		"	jl	0f\n"
 		"	slr	%0,%3\n"
-		"	alr	%1,%2\n"
+		"	ahi	%1,1\n"
 		"0:\n"
 		: "+d" (reg2), "+d" (reg3), "=d" (tmp)
 		: "d" (base), "2" (1UL) : "cc" );


