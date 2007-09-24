Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbXIXQj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbXIXQj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759148AbXIXQ2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:28:00 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58054 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761001AbXIXQ16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:27:58 -0400
Date: Mon, 24 Sep 2007 09:22:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Nick Bowler <nbowler@ellipticsemi.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [39/50] Fix IPSEC AH4 options handling
Message-ID: <20070924162216.GN13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-ipsec-ah4-options-handling.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Bowler <nbowler@ellipticsemi.com>

commit 8ee4f391831cb96916a8e8a05f04b1c1d7dd30d8 in mainline.

In testing our ESP/AH offload hardware, I discovered an issue with how
AH handles mutable fields in IPv4.  RFC 4302 (AH) states the following
on the subject:

        For IPv4, the entire option is viewed as a unit; so even
        though the type and length fields within most options are immutable
        in transit, if an option is classified as mutable, the entire option
        is zeroed for ICV computation purposes.

The current implementation does not zero the type and length fields,
resulting in authentication failures when communicating with hosts
that do (i.e. FreeBSD).

I have tested record route and timestamp options (ping -R and ping -T)
on a small network involving Windows XP, FreeBSD 6.2, and Linux hosts,
with one router.  In the presence of these options, the FreeBSD and
Linux hosts (with the patch or with the hardware) can communicate.
The Windows XP host simply fails to accept these packets with or
without the patch.

I have also been trying to test source routing options (using
traceroute -g), but haven't had much luck getting this option to work
*without* AH, let alone with.

Signed-off-by: Nick Bowler <nbowler@ellipticsemi.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/ah4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -46,7 +46,7 @@ static int ip_clear_mutable_options(stru
 			memcpy(daddr, optptr+optlen-4, 4);
 			/* Fall through */
 		default:
-			memset(optptr+2, 0, optlen-2);
+			memset(optptr, 0, optlen);
 		}
 		l -= optlen;
 		optptr += optlen;

-- 
