Return-Path: <linux-kernel-owner+w=401wt.eu-S1763331AbZEFWNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763331AbZEFWNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761575AbZEFVzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:55:05 -0400
Received: from kroah.org ([198.145.64.141]:57336 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761396AbZEFVy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:58 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:01 2009
Message-Id: <20090506214801.406281064@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:12 -0700
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
       alan@lxorguk.ukuu.org.uk, Lennert Buytenhek <buytenh@marvell.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 44/58] mv643xx_eth: 64bit mib counter read fix
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=mv643xx_eth-64bit-mib-counter-read-fix.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lennert Buytenhek <buytenh@wantstofly.org>

commit 93af7aca44f0e82e67bda10a0fb73d383edcc8bd upstream.

On several mv643xx_eth hardware versions, the two 64bit mib counters
for 'good octets received' and 'good octets sent' are actually 32bit
counters, and reading from the upper half of the register has the same
effect as reading from the lower half of the register: an atomic
read-and-clear of the entire 32bit counter value.  This can under heavy
traffic occasionally lead to small numbers being added to the upper
half of the 64bit mib counter even though no 32bit wrap has occured.

Since we poll the mib counters at least every 30 seconds anyway, we
might as well just skip the reads of the upper halves of the hardware
counters without breaking the stats, which this patch does.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Cc: stable@kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/mv643xx_eth.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/mv643xx_eth.c
+++ b/drivers/net/mv643xx_eth.c
@@ -1177,7 +1177,6 @@ static void mib_counters_update(struct m
 
 	spin_lock_bh(&mp->mib_counters_lock);
 	p->good_octets_received += mib_read(mp, 0x00);
-	p->good_octets_received += (u64)mib_read(mp, 0x04) << 32;
 	p->bad_octets_received += mib_read(mp, 0x08);
 	p->internal_mac_transmit_err += mib_read(mp, 0x0c);
 	p->good_frames_received += mib_read(mp, 0x10);
@@ -1191,7 +1190,6 @@ static void mib_counters_update(struct m
 	p->frames_512_to_1023_octets += mib_read(mp, 0x30);
 	p->frames_1024_to_max_octets += mib_read(mp, 0x34);
 	p->good_octets_sent += mib_read(mp, 0x38);
-	p->good_octets_sent += (u64)mib_read(mp, 0x3c) << 32;
 	p->good_frames_sent += mib_read(mp, 0x40);
 	p->excessive_collision += mib_read(mp, 0x44);
 	p->multicast_frames_sent += mib_read(mp, 0x48);


