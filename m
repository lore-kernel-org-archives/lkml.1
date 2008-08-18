Return-Path: <linux-kernel-owner+w=401wt.eu-S1758249AbYHRSro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbYHRSro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbYHRSrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:47:33 -0400
Received: from mx1.suse.de ([195.135.220.2]:41218 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbYHRSrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:47:32 -0400
Date: Mon, 18 Aug 2008 11:41:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Tom Zanussi <tzanussi@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Jens Axboe <jens.axboe@oracle.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Andrea Righi <righi.andrea@gmail.com>
Subject: [patch 07/60] relay: fix "full buffer with exactly full last
	subbuffer" accounting problem
Message-ID: <20080818184139.GH29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="relay-fix-full-buffer-with-exactly-full-last-subbuffer-accounting-problem.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tom Zanussi <tzanussi@gmail.com>

commit 32194450330be327f3b25bf6b66298bd122599e9 upstream

In relay's current read implementation, if the buffer is completely full
but hasn't triggered the buffer-full condition (i.e. the last write
didn't cross the subbuffer boundary) and the last subbuffer is exactly
full, the subbuffer accounting code erroneously finds nothing available.
This patch fixes the problem.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/relay.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -832,6 +832,10 @@ static void relay_file_read_consume(stru
 	size_t n_subbufs = buf->chan->n_subbufs;
 	size_t read_subbuf;
 
+	if (buf->subbufs_produced == buf->subbufs_consumed &&
+	    buf->offset == buf->bytes_consumed)
+		return;
+
 	if (buf->bytes_consumed + bytes_consumed > subbuf_size) {
 		relay_subbufs_consumed(buf->chan, buf->cpu, 1);
 		buf->bytes_consumed = 0;
@@ -863,6 +867,8 @@ static int relay_file_read_avail(struct 
 
 	relay_file_read_consume(buf, read_pos, 0);
 
+	consumed = buf->subbufs_consumed;
+
 	if (unlikely(buf->offset > subbuf_size)) {
 		if (produced == consumed)
 			return 0;
@@ -881,8 +887,12 @@ static int relay_file_read_avail(struct 
 	if (consumed > produced)
 		produced += n_subbufs * subbuf_size;
 
-	if (consumed == produced)
+	if (consumed == produced) {
+		if (buf->offset == subbuf_size &&
+		    buf->subbufs_produced > buf->subbufs_consumed)
+			return 1;
 		return 0;
+	}
 
 	return 1;
 }

-- 
