Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbYJZFDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbYJZFDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 01:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYJZFC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 01:02:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36986
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751808AbYJZFC5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 01:02:57 -0400
Date: Sat, 25 Oct 2008 22:02:34 -0700 (PDT)
Message-Id: <20081025.220234.25683542.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       sentiniate@tiscali.it, ilpo.jarvinen@helsinki.fi
Subject: Re: [Bug #11721] after upgrade to 2.6.27 i cannot navigate
From: David Miller <davem@davemloft.net>
In-Reply-To: <gLTYxg3cC1.A.S3E.xJ6AJB@chimera>
References: <3ZqdCuOdOqB.A.EPE.fJ6AJB@chimera>
	<gLTYxg3cC1.A.S3E.xJ6AJB@chimera>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sat, 25 Oct 2008 23:07:52 +0200 (CEST)

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.26 and 2.6.27.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11721
> Subject		: after upgrade to 2.6.27 i cannot navigate
> Submitter	: Aldo Maggi <sentiniate@tiscali.it>
> Date		: 2008-10-08 08:08 (18 days old)

Should be fixed by:

commit fd6149d332973bafa50f03ddb0ea9513e67f4517
Author: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Date:   Thu Oct 23 14:06:35 2008 -0700

    tcp: Restore ordering of TCP options for the sake of inter-operability
    
    This is not our bug! Sadly some devices cannot cope with the change
    of TCP option ordering which was a result of the recent rewrite of
    the option code (not that there was some particular reason steming
    from the rewrite for the reordering) though any ordering of TCP
    options is perfectly legal. Thus we restore the original ordering
    to allow interoperability with/through such broken devices and add
    some warning about this trap. Since the reordering just happened
    without any particular reason, this change shouldn't cost us
    anything.
    
    There are already couple of known failure reports (within close
    proximity of the last release), so the problem might be more
    wide-spread than a single device. And other reports which may
    be due to the same problem though the symptoms were less obvious.
    Analysis of one of the case revealed (with very high probability)
    that sack capability cannot be negotiated as the first option
    (SYN never got a response).
    
    Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
    Reported-by: Aldo Maggi <sentiniate@tiscali.it>
    Tested-by: Aldo Maggi <sentiniate@tiscali.it>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index de54f02..e4c5ac9 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -362,6 +362,17 @@ struct tcp_out_options {
 	__u32 tsval, tsecr;	/* need to include OPTION_TS */
 };
 
+/* Beware: Something in the Internet is very sensitive to the ordering of
+ * TCP options, we learned this through the hard way, so be careful here.
+ * Luckily we can at least blame others for their non-compliance but from
+ * inter-operatibility perspective it seems that we're somewhat stuck with
+ * the ordering which we have been using if we want to keep working with
+ * those broken things (not that it currently hurts anybody as there isn't
+ * particular reason why the ordering would need to be changed).
+ *
+ * At least SACK_PERM as the first option is known to lead to a disaster
+ * (but it may well be that other scenarios fail similarly).
+ */
 static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
 			      const struct tcp_out_options *opts,
 			      __u8 **md5_hash) {
@@ -376,6 +387,12 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
 		*md5_hash = NULL;
 	}
 
+	if (unlikely(opts->mss)) {
+		*ptr++ = htonl((TCPOPT_MSS << 24) |
+			       (TCPOLEN_MSS << 16) |
+			       opts->mss);
+	}
+
 	if (likely(OPTION_TS & opts->options)) {
 		if (unlikely(OPTION_SACK_ADVERTISE & opts->options)) {
 			*ptr++ = htonl((TCPOPT_SACK_PERM << 24) |
@@ -392,12 +409,6 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
 		*ptr++ = htonl(opts->tsecr);
 	}
 
-	if (unlikely(opts->mss)) {
-		*ptr++ = htonl((TCPOPT_MSS << 24) |
-			       (TCPOLEN_MSS << 16) |
-			       opts->mss);
-	}
-
 	if (unlikely(OPTION_SACK_ADVERTISE & opts->options &&
 		     !(OPTION_TS & opts->options))) {
 		*ptr++ = htonl((TCPOPT_NOP << 24) |
