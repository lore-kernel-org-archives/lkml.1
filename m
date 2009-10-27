Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZJ0Q2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZJ0Q2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 12:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbZJ0Q2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 12:28:45 -0400
Received: from mail-forward1.uio.no ([129.240.10.70]:45398 "EHLO
	mail-forward1.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbZJ0Q2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 12:28:43 -0400
Message-ID: <4AE71FB2.9080107@simula.no>
Date: Tue, 27 Oct 2009 17:28:34 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, shemminger@vyatta.com,
       ilpo.jarvinen@helsinki.fi, davem@davemloft.net
Subject: [PATCH 0/3] net: TCP thin-stream latency-improving modifications
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 5 msgs/h 1 sum rcpts/h 8 sum msgs/h 2 total rcpts 339 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 65AED7C1D1D1ACB802BFA8C3D9A3D3B3212915FE
X-UiO-SPAM-Test: remote_host: 128.39.37.254 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 4101 max/h 42 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of patches enabling non-intrusive, dynamically triggered modifications that improves retransmission latencies for thin streams.

The patches are based on the original modifications posted in this RFC:

http://article.gmane.org/gmane.linux.rt.user/3674/match=
http://article.gmane.org/gmane.linux.kernel/779290/match=

We have done our best to address the feedback from the RFC in the new patch set.

TCP streams with high interarrival time between packets (thin streams) are often found to be produced by interactive/time-dependent applications. Such streams are not able to trigger fast retransmissions, since too few dupACKs are received before a retransmission by timeout occurs. Exponential backoff also leads to large delays. Since the applications producing such data patterns are very often time-dependent, this causes delays that are very disturbing for the application performance/experience. This set of patches introduce two simple modifications that improves the latencies for thin streams:

1) If the stream is thin, fast retransmit on the first dupACK.
2) If the stream is thin, do not apply exponential backoff.

The modifications are only active if specifically enabled by syscontrol or iocontrol. If enabled, the thin-stream detection is dynamically triggering the modifications on and off based on the current number of packets in flight. Thus, regular (greedy) streams do not trigger the modifications.

The modifications are thoroughly tested and found to improve retransmission latency considerably without negatively influencing fairness. This is also the case when very many streams using the modifications share a common bottleneck.

We have also developed a bundling mechanism (see the RFC linked to above) that can be used in thin-stream scenarios where the packet sizes are small. This mechanism is more intrusive, and will be posted for the net-next tree when we have revised the design.

For more information on time-dependent thin streams and the modifications, please refer to the articles linked to below:

http://simula.no/research/networks/publications/Simula.ND.159/simula_pdf_file
http://simula.no/research/networks/publications/Simula.ND.185/simula_pdf_file
http://simula.no/research/networks/publications/Simula.ND.112/simula_pdf_file
http://simula.no/research/networks/publications/Simula.ND.35/simula_pdf_file

Cheers, 
Andreas

