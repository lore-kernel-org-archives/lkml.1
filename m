Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYJQLKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYJQLKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 07:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYJQLKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 07:10:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55848 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbYJQLKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 07:10:16 -0400
Date: Fri, 17 Oct 2008 13:09:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, tiwai@suse.de,
       linux-ext4@vger.kernel.org, netdev@vger.kernel.org,
       linux-ide@vger.kernel.org, bzolnier@gmail.com, marek.vasut@gmail.com,
       dwmw2@infradead.org, mark.fasheh@oracle.com, ralf@linux-mips.org,
       mchehab@infradead.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: powerpc allmodconfig
Message-ID: <20081017110945.GA32364@elte.hu>
References: <20081015213337.a99a9595.akpm@linux-foundation.org> <20081015.220247.262683261.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081015.220247.262683261.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> > net/dccp/options.c: In function 'dccp_parse_options': 
> > net/dccp/options.c:67: warning: 'value' may be used uninitialized in 
> > this function
> 
> Known issue, not trivial to fix, gcc is just being incredibly silly 
> here as it can't see all of the control flow.

i just ran into this - do you have any objection against the patch 
below?

Should we have a cleaner annotation perhaps instead of 
uninitialized_var()? Something like:

 #define __used          __attribute__((used))

?

	Ingo

---------->
>From d917af0bd043eab40d57f79cba9cf7a7b265a205 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 17 Oct 2008 12:41:30 +0200
Subject: [PATCH] fix warning in net/dccp/options.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fix this warning:

  net/dccp/options.c: In function ‘dccp_parse_options’:
  net/dccp/options.c:67: warning: ‘value’ may be used uninitialized in this function

This is a bogus GCC warning. The compiler does not recognize the relation
between "value" and "mandatory" variables: the code flow can ever reach
the "out_invalid_option:" label if 'mandatory' is set to 1, and when
'mandatory' is non-zero, we'll always have 'value' initialized.

Help out the compiler by annotating the variable.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 net/dccp/options.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/dccp/options.c b/net/dccp/options.c
index 0809b63..18dcfb9 100644
--- a/net/dccp/options.c
+++ b/net/dccp/options.c
@@ -64,7 +64,7 @@ int dccp_parse_options(struct sock *sk, struct dccp_request_sock *dreq,
 					(dh->dccph_doff * 4);
 	struct dccp_options_received *opt_recv = &dp->dccps_options_received;
 	unsigned char opt, len;
-	unsigned char *value;
+	unsigned char *uninitialized_var(value);
 	u32 elapsed_time;
 	__be32 opt_val;
 	int rc;
