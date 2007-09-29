Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbXI2Mp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbXI2Mp3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 08:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbXI2Moy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 08:44:54 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35497 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbXI2Mow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 08:44:52 -0400
Date: Sat, 29 Sep 2007 15:44:49 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: Cedric Le Goater <clg@fr.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: 2.6.23-rc8-mm2 - tcp_fastretrans_alert() WARNING
In-Reply-To: <Pine.LNX.4.64.0709282143020.6013@kivilampi-30.cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0709291532200.6776@kivilampi-30.cs.helsinki.fi>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
 <46FD20F0.3050909@fr.ibm.com> <Pine.LNX.4.64.0709282143020.6013@kivilampi-30.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696243703-957210457-1191069889=:6776"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696243703-957210457-1191069889=:6776
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 28 Sep 2007, Ilpo Järvinen wrote:
> On Fri, 28 Sep 2007, Cedric Le Goater wrote:
>
> > I just found that warning in my logs. It seems that it's been 
> > happening since rc7-mm1 at least. 
> > 
> > WARNING: at /home/legoater/linux/2.6.23-rc8-mm2/net/ipv4/tcp_input.c:2314 tcp_fastretrans_alert()
> >
> > Call Trace:
> >  <IRQ>  [<ffffffff8040fdc3>] tcp_ack+0xcd6/0x1894
> > ...snip...
> 
> ...Thanks for the report, I'll have look what could still break 
> fackets_out...

I think this one is now clear to me, tcp_fragment/collapse adjusts 
fackets_out (incorrectly) also for reno flow when there were some dupACKs 
that made sacked_out != 0. Could you please try if patch below proves all 
them to be of non-SACK origin... In case that's true, it's rather 
harmless, I'll send a fix on Monday or so (this would anyway be needed)... 
If you find out that them occur with SACK enabled flow, that would be
more interesting and requires more digging...

-- 
 i.



diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2286361..e642779 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2311,8 +2311,10 @@ tcp_fastretrans_alert(struct sock *sk, int pkts_acked, int flag)
 	if (!tp->packets_out)
 		tp->sacked_out = 0;
 
-	if (WARN_ON(!tp->sacked_out && tp->fackets_out))
+	if (WARN_ON(!tp->sacked_out && tp->fackets_out)) {
+		printk(KERN_ERR "TCP %d\n", tcp_is_reno(tp));
 		tp->fackets_out = 0;
+	}
 
 	/* Now state machine starts.
 	 * A. ECE, hence prohibit cwnd undoing, the reduction is required. */
---696243703-957210457-1191069889=:6776--
