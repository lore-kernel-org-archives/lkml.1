Return-Path: <linux-kernel-owner+w=401wt.eu-S934601AbXKPS4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934601AbXKPS4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933685AbXKPSzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:55:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46944 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630AbXKPSzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:55:35 -0500
Date: Fri, 16 Nov 2007 10:52:32 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.13
Message-ID: <20071116185232.GB10141@kroah.com>
References: <20071116185219.GA10141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116185219.GA10141@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index b55f9bf..500f6a8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 22
-EXTRAVERSION = .12
+EXTRAVERSION = .13
 NAME = Holy Dancing Manatees, Batman!
 
 # *DOCUMENTATION*
diff --git a/kernel/exit.c b/kernel/exit.c
index 5c8ecba..e3adc46 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1336,8 +1336,7 @@ static int wait_task_stopped(struct task_struct *p, int delayed_group_leader,
 		int why = (p->ptrace & PT_PTRACED) ? CLD_TRAPPED : CLD_STOPPED;
 
 		exit_code = p->exit_code;
-		if (unlikely(!exit_code) ||
-		    unlikely(p->state & TASK_TRACED))
+		if (unlikely(!exit_code) || unlikely(p->exit_state))
 			goto bail_ref;
 		return wait_noreap_copyout(p, pid, uid,
 					   why, (exit_code << 8) | 0x7f,
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e33fb3d..2e1d8e7 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -994,6 +994,9 @@ tcp_sacktag_write_queue(struct sock *sk, struct sk_buff *ack_skb, u32 prior_snd_
 	if (before(TCP_SKB_CB(ack_skb)->ack_seq, prior_snd_una - tp->max_window))
 		return 0;
 
+	if (!tp->packets_out)
+		goto out;
+
 	/* SACK fastpath:
 	 * if the only SACK change is the increase of the end_seq of
 	 * the first block then only apply that SACK block
@@ -1262,6 +1265,8 @@ tcp_sacktag_write_queue(struct sock *sk, struct sk_buff *ack_skb, u32 prior_snd_
 	    (!tp->frto_highmark || after(tp->snd_una, tp->frto_highmark)))
 		tcp_update_reordering(sk, ((tp->fackets_out + 1) - reord), 0);
 
+out:
+
 #if FASTRETRANS_DEBUG > 0
 	BUG_TRAP((int)tp->sacked_out >= 0);
 	BUG_TRAP((int)tp->lost_out >= 0);
