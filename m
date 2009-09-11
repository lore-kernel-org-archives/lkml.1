Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbZIKA3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbZIKA3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZIKA3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:29:01 -0400
Received: from kroah.org ([198.145.64.141]:38041 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbZIKA27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:28:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:09 2009
Message-Id: <20090911002409.524280560@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:22:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben McKeegan <ben@netservers.co.uk>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 04/22] ppp: fix lost fragments in ppp_mp_explode() (resubmit)
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=ppp-fix-lost-fragments-in-ppp_mp_explode.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ben McKeegan <ben@netservers.co.uk>

[ Upstream commit a53a8b56827cc429c6d9f861ad558beeb5f6103f ]

This patch fixes the corner cases where the sum of MTU of the free
channels (adjusted for fragmentation overheads) is less than the MTU
of PPP link.  There are at least 3 situations where this case might
arise:

- some of the channels are busy

- the multilink session is running in a degraded state (i.e. with less
than its full complement of active channels)

- by design, where multilink protocol is being used to artificially
increase the effective link MTU of a single link.

Without this patch, at most 1 fragment is ever sent per free channel
for a given PPP frame and any remaining part of the PPP frame that
does not fit into those fragments is silently discarded.

This patch restores the original behaviour which was broken by commit
9c705260feea6ae329bc6b6d5f6d2ef0227eda0a 'ppp:ppp_mp_explode()
redesign'.  Once all 'free' channels have been given a fragment, an
additional fragment is queued to each available channel in turn, as many
times as necessary, until the entire PPP frame has been consumed.

Signed-off-by: Ben McKeegan <ben@netservers.co.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/ppp_generic.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -1383,7 +1383,7 @@ static int ppp_mp_explode(struct ppp *pp
 
 	/* create a	fragment for each channel */
 	bits = B;
-	while (nfree > 0 &&	len	> 0) {
+	while (len	> 0) {
 		list = list->next;
 		if (list ==	&ppp->channels)	{
 			i =	0;
@@ -1430,29 +1430,31 @@ static int ppp_mp_explode(struct ppp *pp
 		*otherwise divide it according to the speed
 		*of the channel we are going to transmit on
 		*/
-		if (pch->speed == 0) {
-			flen = totlen/nfree	;
-			if (nbigger > 0) {
-				flen++;
-				nbigger--;
-			}
-		} else {
-			flen = (((totfree - nzero)*(totlen + hdrlen*totfree)) /
-				((totspeed*totfree)/pch->speed)) - hdrlen;
-			if (nbigger > 0) {
-				flen += ((totfree - nzero)*pch->speed)/totspeed;
-				nbigger -= ((totfree - nzero)*pch->speed)/
+		if (nfree > 0) {
+			if (pch->speed == 0) {
+				flen = totlen/nfree	;
+				if (nbigger > 0) {
+					flen++;
+					nbigger--;
+				}
+			} else {
+				flen = (((totfree - nzero)*(totlen + hdrlen*totfree)) /
+					((totspeed*totfree)/pch->speed)) - hdrlen;
+				if (nbigger > 0) {
+					flen += ((totfree - nzero)*pch->speed)/totspeed;
+					nbigger -= ((totfree - nzero)*pch->speed)/
 							totspeed;
+				}
 			}
+			nfree--;
 		}
-		nfree--;
 
 		/*
 		 *check	if we are on the last channel or
 		 *we exceded the lenght	of the data	to
 		 *fragment
 		 */
-		if ((nfree == 0) || (flen > len))
+		if ((nfree <= 0) || (flen > len))
 			flen = len;
 		/*
 		 *it is not worth to tx on slow channels:
@@ -1466,7 +1468,7 @@ static int ppp_mp_explode(struct ppp *pp
 			continue;
 		}
 
-		mtu	= pch->chan->mtu + 2 - hdrlen;
+		mtu	= pch->chan->mtu - hdrlen;
 		if (mtu	< 4)
 			mtu	= 4;
 		if (flen > mtu)


