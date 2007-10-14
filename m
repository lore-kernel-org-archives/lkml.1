Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbXJNBD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbXJNBD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 21:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbXJNBDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 21:03:50 -0400
Received: from userg501.nifty.com ([202.248.238.81]:17298 "EHLO
	userg501.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbXJNBDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 21:03:49 -0400
DomainKey-Signature: a=rsa-sha1; s=userg501; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=Q3ITL+zSqZsfxHsm22YnWd/292l1VB/FJVBxXzyuAyRNH0dcGTvZl2hQCCVgLbxEm
	7mL0exqmpF35Hv3mT+rEw==
X-Nifty-SrcIP: [219.104.15.224]
Date: Sun, 14 Oct 2007 10:02:45 +0900
From: Komuro <komurojun@nifty.com>
To: davem@sunset.davemloft.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [NOT VERY SAFE]     [TCP]: Set initial_ssthresh default to zero
 in Cubic and BIC.
Message-Id: <20071014100245.914b784a.komurojun@nifty.com>
In-Reply-To: <20071014073658.d4352b8c.komurojun@nifty.com>
References: <20071006132601.f944f461.komurojun@nifty.com>
	<20071014073658.d4352b8c.komurojun@nifty.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear David

Actually, tcp_sk(sk)->snd_ssthresh is not initialized,
if initial_ssthresh is 0.

The patch should be

 static void bictcp_init(struct sock *sk)
 {
 	bictcp_reset(inet_csk_ca(sk));
-	if (initial_ssthresh)
-		tcp_sk(sk)->snd_ssthresh = initial_ssthresh;
+
+	tcp_sk(sk)->snd_ssthresh = initial_ssthresh;
 }

Best Regards
Komuro

> 
> Dear David
> 
> The patch "[TCP]: Set initial_ssthresh default to zero in Cubic and BIC."
> is not very safe.
> 
> With this patch, ftp-transfer stops in my system.
> (vsftpd-2.0.5-8)
> 
> Please revert this patch.
> 
> 
> Best Regards
> Komuro
> 
> >commit 66e1e3b20cbbf99da63e6c1af0fc6d39c2ed099a
> >Author: David S. Miller <davem@sunset.davemloft.net>
> >Date:   Wed Jun 13 01:03:53 2007 -0700
> >
> >    [TCP]: Set initial_ssthresh default to zero in Cubic and BIC.
> >    
> >    Because of the current default of 100, Cubic and BIC perform very
> >    poorly compared to standard Reno.
> >    
> >    In the worst case, this change makes Cubic and BIC as aggressive as
> >    Reno.  So this change should be very safe.
> >    
> >    Signed-off-by: David S. Miller <davem@davemloft.net>
> >
> >diff --git a/net/ipv4/tcp_bic.c b/net/ipv4/tcp_bic.c
> >index 281c9f9..dd9ef65 100644
> >--- a/net/ipv4/tcp_bic.c
> >+++ b/net/ipv4/tcp_bic.c
> >@@ -29,7 +29,7 @@ static int fast_convergence = 1;
> > static int max_increment = 16;
> > static int low_window = 14;
> > static int beta = 819;		/* = 819/1024 (BICTCP_BETA_SCALE) */
> >-static int initial_ssthresh = 100;
> >+static int initial_ssthresh;
> > static int smooth_part = 20;
> > 
> > module_param(fast_convergence, int, 0644);
> >diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
> >index 1422448..ebfaac2 100644
> >--- a/net/ipv4/tcp_cubic.c
> >+++ b/net/ipv4/tcp_cubic.c
> >@@ -29,7 +29,7 @@
> > static int fast_convergence __read_mostly = 1;
> > static int max_increment __read_mostly = 16;
> > static int beta __read_mostly = 819;	/* = 819/1024 (BICTCP_BETA_SCALE) */
> >-static int initial_ssthresh __read_mostly = 100;
> >+static int initial_ssthresh __read_mostly;
> > static int bic_scale __read_mostly = 41;
> > static int tcp_friendliness __read_mostly = 1;
> > 


-- 
Komuro <komurojun@nifty.com>
