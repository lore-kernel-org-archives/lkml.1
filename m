Return-Path: <linux-kernel-owner+w=401wt.eu-S938411AbXFHH0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938411AbXFHH0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938039AbXFHHSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:18:17 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33295 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938038AbXFHHSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:18:15 -0400
Message-Id: <20070608071551.123673000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:31 -0700
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
       Jerome Borsboom <j.borsboom@erasmusmc.nl>
Subject: [patch 20/32] NET: parse ip:port strings correctly in in4_pton
Content-Disposition: inline; filename=net-parse-ip-port-strings-correctly-in-in4_pton.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jerome Borsboom <j.borsboom@erasmusmc.nl>

in4_pton converts a textual representation of an ip4 address
into an integer representation. However, when the textual representation
is of in the form ip:port, e.g. 192.168.1.1:5060, and 'delim' is set to
-1, the function bails out with an error when reading the colon.

It makes sense to allow the colon as a delimiting character without
explicitly having to set it through the 'delim' variable as there can be
no ambiguity in the point where the ip address is completely parsed. This
function is indeed called from nf_conntrack_sip.c in this way to parse
textual ip:port combinations which fails due to the reason stated above.

Signed-off-by: Jerome Borsboom <j.borsboom@erasmusmc.nl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/core/utils.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.20.13.orig/net/core/utils.c
+++ linux-2.6.20.13/net/core/utils.c
@@ -137,16 +137,16 @@ int in4_pton(const char *src, int srclen
 	while(1) {
 		int c;
 		c = xdigit2bin(srclen > 0 ? *s : '\0', delim);
-		if (!(c & (IN6PTON_DIGIT | IN6PTON_DOT | IN6PTON_DELIM))) {
+		if (!(c & (IN6PTON_DIGIT | IN6PTON_DOT | IN6PTON_DELIM | IN6PTON_COLON_MASK))) {
 			goto out;
 		}
-		if (c & (IN6PTON_DOT | IN6PTON_DELIM)) {
+		if (c & (IN6PTON_DOT | IN6PTON_DELIM | IN6PTON_COLON_MASK)) {
 			if (w == 0)
 				goto out;
 			*d++ = w & 0xff;
 			w = 0;
 			i++;
-			if (c & IN6PTON_DELIM) {
+			if (c & (IN6PTON_DELIM | IN6PTON_COLON_MASK)) {
 				if (i != 4)
 					goto out;
 				break;

-- 
