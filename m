Return-Path: <linux-kernel-owner+w=401wt.eu-S1763765AbYFNAXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763765AbYFNAXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760946AbYFNAOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:14:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762034AbYFNAOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:14:38 -0400
Date: Fri, 13 Jun 2008 17:11:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Ilpo =?utf-8?B?SsOD4oKscnZpbmVu?= <ilpo.jarvinen@helsinki.fi>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 32/47] tcp FRTO: SACK variant is errorneously used with
	NewReno
Message-ID: <20080614001147.GF24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="tcp-frto-sack-variant-is-errorneously-used-with-newreno.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

[ upstream commit: 62ab22278308a40bcb7f4079e9719ab8b7fe11b5 ]

Note: there's actually another bug in FRTO's SACK variant, which
is the causing failure in NewReno case because of the error
that's fixed here. I'll fix the SACK case separately (it's
a separate bug really, though related, but in order to fix that
I need to audit tp->snd_nxt usage a bit).

There were two places where SACK variant of FRTO is getting
incorrectly used even if SACK wasn't negotiated by the TCP flow.
This leads to incorrect setting of frto_highmark with NewReno
if a previous recovery was interrupted by another RTO.

An eventual fallback to conventional recovery then incorrectly
considers one or couple of segments as forward transmissions
though they weren't, which then are not LOST marked during
fallback making them "non-retransmittable" until the next RTO.
In a bad case, those segments are really lost and are the only
one left in the window. Thus TCP needs another RTO to continue.
The next FRTO, however, could again repeat the same events
making the progress of the TCP flow extremely slow.

In order for these events to occur at all, FRTO must occur
again in FRTOs step 3 while the key segments must be lost as
well, which is not too likely in practice. It seems to most
frequently with some small devices such as network printers
that *seem* to accept TCP segments only in-order. In cases
were key segments weren't lost, things get automatically
resolved because those wrongly marked segments don't need to be
retransmitted in order to continue.

I found a reproducer after digging up relevant reports (few
reports in total, none at netdev or lkml I know of), some
cases seemed to indicate middlebox issues which seems now
to be a false assumption some people had made. Bugzilla
#10063 _might_ be related. Damon L. Chesser <damon@damtek.com>
had a reproducable case and was kind enough to tcpdump it
for me. With the tcpdump log it was quite trivial to figure
out.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ipv4/tcp_input.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -113,8 +113,6 @@ int sysctl_tcp_abc __read_mostly;
 #define FLAG_FORWARD_PROGRESS	(FLAG_ACKED|FLAG_DATA_SACKED)
 #define FLAG_ANY_PROGRESS	(FLAG_FORWARD_PROGRESS|FLAG_SND_UNA_ADVANCED)
 
-#define IsSackFrto() (sysctl_tcp_frto == 0x2)
-
 #define TCP_REMNANT (TCP_FLAG_FIN|TCP_FLAG_URG|TCP_FLAG_SYN|TCP_FLAG_PSH)
 #define TCP_HP_BITS (~(TCP_RESERVED_BITS|TCP_FLAG_PSH))
 
@@ -1685,6 +1683,11 @@ static inline void tcp_reset_reno_sack(s
 	tp->sacked_out = 0;
 }
 
+static int tcp_is_sackfrto(const struct tcp_sock *tp)
+{
+	return (sysctl_tcp_frto == 0x2) && !tcp_is_reno(tp);
+}
+
 /* F-RTO can only be used if TCP has never retransmitted anything other than
  * head (SACK enhanced variant from Appendix B of RFC4138 is more robust here)
  */
@@ -1701,7 +1704,7 @@ int tcp_use_frto(struct sock *sk)
 	if (icsk->icsk_mtup.probe_size)
 		return 0;
 
-	if (IsSackFrto())
+	if (tcp_is_sackfrto(tp))
 		return 1;
 
 	/* Avoid expensive walking of rexmit queue if possible */
@@ -1791,7 +1794,7 @@ void tcp_enter_frto(struct sock *sk)
 	/* Earlier loss recovery underway (see RFC4138; Appendix B).
 	 * The last condition is necessary at least in tp->frto_counter case.
 	 */
-	if (IsSackFrto() && (tp->frto_counter ||
+	if (tcp_is_sackfrto(tp) && (tp->frto_counter ||
 	    ((1 << icsk->icsk_ca_state) & (TCPF_CA_Recovery|TCPF_CA_Loss))) &&
 	    after(tp->high_seq, tp->snd_una)) {
 		tp->frto_highmark = tp->high_seq;
@@ -3110,7 +3113,7 @@ static int tcp_process_frto(struct sock 
 		return 1;
 	}
 
-	if (!IsSackFrto() || tcp_is_reno(tp)) {
+	if (!tcp_is_sackfrto(tp)) {
 		/* RFC4138 shortcoming in step 2; should also have case c):
 		 * ACK isn't duplicate nor advances window, e.g., opposite dir
 		 * data, winupdate

-- 
