Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbXHUPPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbXHUPPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 11:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761408AbXHUPPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 11:15:19 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:41462 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761348AbXHUPPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 11:15:17 -0400
X-Greylist: delayed 1842 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Aug 2007 11:15:17 EDT
Date: Tue, 21 Aug 2007 10:44:33 -0400
From: Nick Bowler <nbowler@ellipticsemi.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] AH4: Update IPv4 options handling to conform to RFC 4302.
Message-ID: <20070821144433.GA5015@totient.ellipticsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In testing our ESP/AH offload hardware, I discovered an issue with how AH
handles mutable fields in IPv4.  RFC 4302 (AH) states the following on the
subject:

        For IPv4, the entire option is viewed as a unit; so even
        though the type and length fields within most options are immutable
        in transit, if an option is classified as mutable, the entire option
        is zeroed for ICV computation purposes.

The current implementation does not zero the type and length fields, resulting
in authentication failures when communicating with hosts that do (i.e. FreeBSD).

I have tested record route and timestamp options (ping -R and ping -T) on a
small network involving Windows XP, FreeBSD 6.2, and Linux hosts, with one
router.  In the presence of these options, the FreeBSD and Linux hosts (with
the patch or with the hardware) can communicate.  The Windows XP host simply
fails to accept these packets with or without the patch.

I have also been trying to test source routing options (using traceroute -g),
but haven't had much luck getting this option to work *without* AH, let alone
with.

Signed-off-by: Nick Bowler <nbowler@ellipticsemi.com>
---
 net/ipv4/ah4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index 7a23e59..39f6211 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -46,7 +46,7 @@ static int ip_clear_mutable_options(struct iphdr *iph, __be32 *daddr)
 			memcpy(daddr, optptr+optlen-4, 4);
 			/* Fall through */
 		default:
-			memset(optptr+2, 0, optlen-2);
+			memset(optptr, 0, optlen);
 		}
 		l -= optlen;
 		optptr += optlen;
-- 
1.5.2.2

-- 
Nick Bowler, Elliptic Semiconductor (http://www.ellipticsemi.com/)

