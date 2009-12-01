Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbZLARwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbZLARwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbZLARwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:52:11 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:45766 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbZLARwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:52:10 -0500
Message-ID: <4B1557CC.4060503@gmail.com>
Date: Tue, 01 Dec 2009 18:52:12 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: netdev@vger.kernel.org, Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: seeing strange values for tcp sk_rmem_alloc
References: <4B15416A.2060202@nortel.com> <4B154B29.1030807@cosmosbay.com> <4B155252.1040604@nortel.com>
In-Reply-To: <4B155252.1040604@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 01 Dec 2009 18:52:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen a écrit :

> I realize this.  I sent the data from a socket to itself.  It could just
> as easily be done with two tcp sockets.  The important thing is that I
> control both the tx and rx sides, so I know how much data should be
> present in the rx queue at any point in time.
> 
> The part that surprised me was that I could send multiple chunks of data
> without sk_rmem_alloc changing on the socket to which the data was being
> sent.  Then it would jump up by a large amount (up to 20K) all at once.
> 
> I'm starting to suspect that the discrepency might have something to do
> with the skb_copy_datagram_iovec() call in tcp_data_queue(), and how
> skb_set_owner_r() is only called if "eaten" is <= 0.  This could be
> totally off-base though.
> 

If you dont read() your socket, then skb_copy_datagram_iovec() is not called

But be careful of sender tcp stack : It might be delayed a bit,
because it waits for receiver to open its window (slow start)

You probably need something like

while (1) {
	send(fd1, buffer, 2Kbytes);
	sleep(2); // let tcp stack flush its write buffers
	display_sk_rmem_alloc(fd2);
}

