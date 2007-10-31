Return-Path: <linux-kernel-owner+w=401wt.eu-S1760529AbXJaP05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760529AbXJaP05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759901AbXJaPYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:24:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33473 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759673AbXJaPYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:24:33 -0400
Date: Wed, 31 Oct 2007 08:11:40 -0700
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
       Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 12/26] : Fix TCP initial sequence number selection.
Message-ID: <20071031151140.GM2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-tcp-initial-sequence-number-selection.patch"
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Eric Dumazet <dada1@cosmosbay.com>

changeset 162f6690a65075b49f242d3c8cdb5caaa959a060 in mainline.

TCP V4 sequence numbers are 32bits, and RFC 793 assumed a 250 KHz clock.
In order to follow network speed increase, we can use a faster clock, but
we should limit this clock so that the delay between two rollovers is
greater than MSL (TCP Maximum Segment Lifetime : 2 minutes)

Choosing a 64 nsec clock should be OK, since the rollovers occur every
274 seconds.

Problem spotted by Denys Fedoryshchenko

[ This bug was introduced by f85958151900f9d30fa5ff941b0ce71eaa45a7de ]

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/random.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1550,11 +1550,13 @@ __u32 secure_tcp_sequence_number(__be32 
 	 *	As close as possible to RFC 793, which
 	 *	suggests using a 250 kHz clock.
 	 *	Further reading shows this assumes 2 Mb/s networks.
-	 *	For 10 Gb/s Ethernet, a 1 GHz clock is appropriate.
-	 *	That's funny, Linux has one built in!  Use it!
-	 *	(Networks are faster now - should this be increased?)
+	 *	For 10 Mb/s Ethernet, a 1 MHz clock is appropriate.
+	 *	For 10 Gb/s Ethernet, a 1 GHz clock should be ok, but
+	 *	we also need to limit the resolution so that the u32 seq
+	 *	overlaps less than one time per MSL (2 minutes).
+	 *	Choosing a clock of 64 ns period is OK. (period of 274 s)
 	 */
-	seq += ktime_get_real().tv64;
+	seq += ktime_get_real().tv64 >> 6;
 #if 0
 	printk("init_seq(%lx, %lx, %d, %d) = %d\n",
 	       saddr, daddr, sport, dport, seq);

-- 
