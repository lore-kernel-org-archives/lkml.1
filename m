Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbZAWBVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbZAWBVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbZAWBPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:15:06 -0500
Received: from kroah.org ([198.145.64.141]:50556 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760188AbZAWBO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:14:57 -0500
Date: Thu, 22 Jan 2009 17:12:11 -0800
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
       alan@lxorguk.ukuu.org.uk, Wei Yongjun <yjwei@cn.fujitsu.com>,
       Vlad Yasevich <vladislav.yasevich@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 20/46] sctp: Avoid memory overflow while FWD-TSN chunk is
	received with bad stream ID
Message-ID: <20090123011211.GU19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sctp-avoid-memory-overflow-while-fwd-tsn-chunk-is-received-with-bad-stream-id.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wei Yongjun <yjwei@cn.fujitsu.com>

[ Upstream commit: 9fcb95a105758b81ef0131cd18e2db5149f13e95 ]

If FWD-TSN chunk is received with bad stream ID, the sctp will not do the
validity check, this may cause memory overflow when overwrite the TSN of
the stream ID.

The FORWARD-TSN chunk is like this:

FORWARD-TSN chunk
  Type                       = 192
  Flags                      = 0
  Length                     = 172
  NewTSN                     = 99
  Stream                     = 10000
  StreamSequence             = 0xFFFF

This patch fix this problem by discard the chunk if stream ID is not
less than MIS.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sctp/sm_statefuns.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3691,6 +3691,7 @@ sctp_disposition_t sctp_sf_eat_fwd_tsn(c
 {
 	struct sctp_chunk *chunk = arg;
 	struct sctp_fwdtsn_hdr *fwdtsn_hdr;
+	struct sctp_fwdtsn_skip *skip;
 	__u16 len;
 	__u32 tsn;
 
@@ -3720,6 +3721,12 @@ sctp_disposition_t sctp_sf_eat_fwd_tsn(c
 	if (sctp_tsnmap_check(&asoc->peer.tsn_map, tsn) < 0)
 		goto discard_noforce;
 
+	/* Silently discard the chunk if stream-id is not valid */
+	sctp_walk_fwdtsn(skip, chunk) {
+		if (ntohs(skip->stream) >= asoc->c.sinit_max_instreams)
+			goto discard_noforce;
+	}
+
 	sctp_add_cmd_sf(commands, SCTP_CMD_REPORT_FWDTSN, SCTP_U32(tsn));
 	if (len > sizeof(struct sctp_fwdtsn_hdr))
 		sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_FWDTSN,
@@ -3751,6 +3758,7 @@ sctp_disposition_t sctp_sf_eat_fwd_tsn_f
 {
 	struct sctp_chunk *chunk = arg;
 	struct sctp_fwdtsn_hdr *fwdtsn_hdr;
+	struct sctp_fwdtsn_skip *skip;
 	__u16 len;
 	__u32 tsn;
 
@@ -3780,6 +3788,12 @@ sctp_disposition_t sctp_sf_eat_fwd_tsn_f
 	if (sctp_tsnmap_check(&asoc->peer.tsn_map, tsn) < 0)
 		goto gen_shutdown;
 
+	/* Silently discard the chunk if stream-id is not valid */
+	sctp_walk_fwdtsn(skip, chunk) {
+		if (ntohs(skip->stream) >= asoc->c.sinit_max_instreams)
+			goto gen_shutdown;
+	}
+
 	sctp_add_cmd_sf(commands, SCTP_CMD_REPORT_FWDTSN, SCTP_U32(tsn));
 	if (len > sizeof(struct sctp_fwdtsn_hdr))
 		sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_FWDTSN,

