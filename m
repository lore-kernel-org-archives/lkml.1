Return-Path: <linux-kernel-owner+w=401wt.eu-S932296AbZKXIpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbZKXIpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932263AbZKXIpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:45:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56954 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216AbZKXIp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:45:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 2/4] macvlan: cleanup rx statistics
Date: Tue, 24 Nov 2009 08:45:14 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31bisect; KDE/4.3.2; x86_64; ; )
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
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
References: <1259024166-28158-1-git-send-email-arnd@arndb.de> <1259024166-28158-3-git-send-email-arnd@arndb.de> <4B0B9639.4070607@gmail.com>
In-Reply-To: <4B0B9639.4070607@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <200911240845.14454.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/WsHCixWGFgM8JifL95rG37jMXoGQqDZ65sY2
 zJc4NmoBpANxlcWS9lqPiXPXRKVATqLVJkfpNu8h+N/rxN52p0
 Kn3NgP7w9Ya+NSFu9rYPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 November 2009 08:15:53 Eric Dumazet wrote:
> Arnd Bergmann a écrit :
> >  
> > +static inline void macvlan_count_rx(const struct macvlan_dev *vlan, int length,
> > +			     int success, int multicast)
> 
> success and multicast should be declared as bool

ok

> > +{
> > +	struct macvlan_rx_stats *rx_stats;
> > +
> > +	rx_stats = per_cpu_ptr(vlan->rx_stats, smp_processor_id());
> > +	rx_stats->rx_packets += success != 0;
> > +	rx_stats->rx_bytes   += success ? length : 0;
> > +	rx_stats->multicast  += success && multicast;
> > +	rx_stats->rx_errors  += !success;
> > +}
> > +
> 
> I find following more readable, it probably generates more branches,
> but avoid dirtying rx_errors if it is in another cache line.
> 
> if (likely(success)) {
> 	rx_stats->rx_packets++;
> 	rx_stats->rx_bytes += length;
> 	if (multicast)
> 		rx_stats->multicast++;
> } else {
> 	rx_stats->rx_errors++;
> }

Given that the structure only has four members and alloc_percpu requests
cache aligned data, it is rather likely to be in the same cache line.

I'll have a look at what gcc generates on x86-64 for both versions
and use the version you suggested unless it looks significantly more
expensive.

Since we're into micro-optimization territory, do you think it should
be marked inline or not?
 
> > -	rx_stats = per_cpu_ptr(vlan->rx_stats, smp_processor_id());
> >  	skb = skb_share_check(skb, GFP_ATOMIC);
> > -	if (skb == NULL) {
> > -		rx_stats->rx_errors++;
> > -		return NULL;
> > -	}
> > -
> > -	rx_stats->rx_bytes += skb->len + ETH_HLEN;
> > -	rx_stats->rx_packets++;
> > +	macvlan_count_rx(vlan, skb->len + ETH_HLEN, likely(skb != NULL), 0);
> 
> its not _likely_ that skb != NULL, its a fact :)
> 
> -> macvlan_count_rx(vlan, skb->len + ETH_HLEN, true, false);

I don't understand. Note how I removed the check for NULL above and
the skb pointer may be the result of a failing skb_clone().

Looking at this again, I actually introduced a bug by calling netif_rx
on a possibly NULL skb, I'll fix that.

Thanks!

	Arnd <><
