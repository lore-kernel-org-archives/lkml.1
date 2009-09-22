Return-Path: <linux-kernel-owner+w=401wt.eu-S932352AbZIVQHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbZIVQHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932335AbZIVQHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:07:03 -0400
Received: from smtp-out.google.com ([216.239.45.13]:22072 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbZIVQHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:07:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=khUooEFQZ9Z4Ss9UkuDBKQFG1TeMuugY0HK39lTCF8m+yRcFMgA+cXA28T3Tt/MGM
	nDKIlo728vMUMCqi5auFg==
Subject: [PATCH] netfilter: nf_nat_helper: tidy up adjust_tcp_sequence
To: netdev@vger.kernel.org
From: Hannes Eder <heder@google.com>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 22 Sep 2009 18:00:55 +0200
Message-ID: <20090922155911.20008.96214.stgit@jazzy.zrh.corp.google.com>
User-Agent: StGit/0.15-rc2-7-gba5c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable 'other_way' gets initialized but is not read afterwards,
so remove it.  Pass the right arguments to a pr_debug call.

While being at tidy up a bit and it fix this checkpatch warning:
  WARNING: suspect code indent for conditional statements

Signed-off-by: Hannes Eder <heder@google.com>

 net/ipv4/netfilter/nf_nat_helper.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_helper.c b/net/ipv4/netfilter/nf_nat_helper.c
index 09172a6..56daa1b 100644
--- a/net/ipv4/netfilter/nf_nat_helper.c
+++ b/net/ipv4/netfilter/nf_nat_helper.c
@@ -41,18 +41,13 @@ adjust_tcp_sequence(u32 seq,
 		    struct nf_conn *ct,
 		    enum ip_conntrack_info ctinfo)
 {
-	int dir;
-	struct nf_nat_seq *this_way, *other_way;
+	int dir = CTINFO2DIR(ctinfo);
 	struct nf_conn_nat *nat = nfct_nat(ct);
+	struct nf_nat_seq *this_way = &nat->seq[dir];
 
-	pr_debug("adjust_tcp_sequence: seq = %u, sizediff = %d\n", seq, seq);
-
-	dir = CTINFO2DIR(ctinfo);
-
-	this_way = &nat->seq[dir];
-	other_way = &nat->seq[!dir];
+	pr_debug("%s(): seq = %u, sizediff = %d\n", __func__, seq, sizediff);
 
-	pr_debug("nf_nat_resize_packet: Seq_offset before: ");
+	pr_debug("%s(): Seq_offset before: ", __func__);
 	DUMP_OFFSET(this_way);
 
 	spin_lock_bh(&nf_nat_seqofs_lock);
@@ -63,13 +58,13 @@ adjust_tcp_sequence(u32 seq,
 	 * retransmit */
 	if (this_way->offset_before == this_way->offset_after ||
 	    before(this_way->correction_pos, seq)) {
-		   this_way->correction_pos = seq;
-		   this_way->offset_before = this_way->offset_after;
-		   this_way->offset_after += sizediff;
+		this_way->correction_pos = seq;
+		this_way->offset_before = this_way->offset_after;
+		this_way->offset_after += sizediff;
 	}
 	spin_unlock_bh(&nf_nat_seqofs_lock);
 
-	pr_debug("nf_nat_resize_packet: Seq_offset after: ");
+	pr_debug("%s(): Seq_offset after: ", __func__);
 	DUMP_OFFSET(this_way);
 }
 

