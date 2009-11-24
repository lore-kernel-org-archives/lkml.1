Return-Path: <linux-kernel-owner+w=401wt.eu-S932684AbZKXKe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684AbZKXKe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932655AbZKXKe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:34:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50675 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbZKXKe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:34:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/4] veth: move loopback logic to common location
Date: Tue, 24 Nov 2009 10:34:43 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31bisect; KDE/4.3.2; x86_64; ; )
Cc: Patrick McHardy <kaber@trash.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Anna Fischer <anna.fischer@hp.com>, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Mark Smith <lk-netdev@lk-netdev.nosense.org>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Patrick Mullaney <pmullaney@novell.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       David Miller <davem@davemloft.net>
References: <1259024166-28158-1-git-send-email-arnd@arndb.de> <200911241002.20904.arnd@arndb.de> <4B0BB2A7.5040707@trash.net>
In-Reply-To: <4B0BB2A7.5040707@trash.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911241034.43961.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18qpREQZ/NC8zUKvldMFY5T230XogpkJew8ipe
 i6JO/k30M29g5bltM4cE05GEwSsw3yZpn4sDKKxuW3SZkb/GSE
 klnP8vjO2OAggQ4rmaFjw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 November 2009 10:17:11 Patrick McHardy wrote:
> Arnd Bergmann wrote:
> > On Tuesday 24 November 2009 09:51:19 Patrick McHardy wrote:
> >>> +     skb_dst_drop(skb);
> >>> +     skb->tstamp.tv64 = 0;
> >>> +     skb->pkt_type = PACKET_HOST;
> >>> +     skb->protocol = eth_type_trans(skb, dev);
> >>> +     skb->mark = 0;
> >> skb->mark clearing should stay private to veth since its usually
> >> supposed to stay intact. The only exception is packets crossing
> >> namespaces, where they should appear like a freshly received skbs.
> > 
> > But isn't that what we want in macvlan as well when we're
> > forwarding from one downstream interface to another?
> 
> In the TX direction you can use the mark for TC classification
> on the underlying device.

I don't use dev_forward_skb for the case where the data is sent
to the underlying device, so the TC classification should stay
intact.
 
> > I did all my testing with macvlan interfaces in separate namespaces
> > communicating with each other, so I'd assume that we should always
> > clear skb->mark and skb->dst in this function.
> 
> Good point, in that case we probably should clear it as well. But
> in the non-namespace case the TC classification currently works and
> this is consistent with any other virtual device driver, so it
> should continue to work.

Do you think we should be able to use TC to direct traffic between
macvlans on the same underlying device in bridge mode? It does sound
useful, but I'm not sure how to implement that or if you'd expect
it to work with the current code. If we support that, it should probably
also work with namespaces, by consuming the mark in the macvlan
and veth drivers.

	Arnd <><
