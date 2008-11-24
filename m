Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbYKXKUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbYKXKUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 05:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYKXKTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 05:19:40 -0500
Received: from nbd.name ([88.198.39.176]:48378 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbYKXKTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 05:19:39 -0500
X-Greylist: delayed 2162 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2008 05:19:39 EST
Message-ID: <492A7733.2000205@openwrt.org>
Date: Mon, 24 Nov 2008 10:43:15 +0100
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
       Derek Smithies <derek@indranet.co.nz>, ath5k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, wally@theblackmoor.net,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ath5k-devel] Unusually low speeds with ath5k and iwl3945
References: <492719ED.5000006@gmail.com> <20081122005240.GA27826@hash.localnet>	<alpine.DEB.2.00.0811221643030.7067@monster> <4927FC0C.10900@gmail.com> <492A5913.3070007@free.fr>
In-Reply-To: <492A5913.3070007@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit PAPILLAULT wrote:
> I did a similar test here and results is very strange. AP was my good
> old linksys WRT54G running an iperf server. Client was a laptop running
> either ath5k or madwifi/trunk and an iperf client. Channel is 5. Both
> drivers show the same behaviour.
> 
> At the beginning, throughput was very low : 500 - 600 kbit/s. Suddenly
> (after few minutes), it jumps to 15 - 17 Mbit/s and then few minutes
> later (let's say 10 - 20 minutes maybe), it jumps back to 500 - 600
> kbit/s. Using a fixed rate has no effect.
> 
> I used my latest wireless monitoring tools and I did not saw lost of
> duplicates or lost packets. The only difference was the number of
> packets sent by seconds....
> 
> Looking a my syslog, I just saw few messages, unrelated in time with the
> throughput going up or down. They were:
> - ath5k : unsupported jumbo
> - switching to short barker preamble
> - switching to long barker preamble
> 
> I can repeat the same test with iwl3945 as well, if needed.
While reading the code for calculating the frame duration, i noticed
something odd: It doesn't seem to be taking into account the short
vs long preamble distinction for ERP rates. IMHO this might be causing
issues like this. I've seen similar behaviour a long time ago when testing
iwl3945 against a Broadcom AP with exactly the same throughput drop (500-
600 kbits/s).
When I analyzed the problem with an extra monitor mode card, I found out
that the throughput drop is caused by a huge number of retransmissions,
and if I remember correctly (I didn't look for this specifically back then),
the retransmissions went down the rate scaling table until they hit the
first non-ERP rate and that one worked on the first try.

Johannes, does that sound like a probable cause? If so, it should be easy
to fix.

- Felix
