Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbZKROiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbZKROiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:38:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407AbZKROiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:38:02 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49405 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216AbZKROh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:37:58 -0500
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick McHardy <kaber@trash.net>,
       Patrick Mullaney <pmullaney@novell.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       virtualization@linux-foundation.com,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>
Subject: Re: [PATCH 1/3] macvlan: Reflect macvlan packets meant for other macvlan devices
References: <1258497551-25959-1-git-send-email-arnd@arndb.de>
	<1258497551-25959-2-git-send-email-arnd@arndb.de>
	<4B03949D.4000908@gmail.com> <200911181047.07974.arnd@arndb.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 18 Nov 2009 06:37:50 -0800
In-Reply-To: <200911181047.07974.arnd@arndb.de> (Arnd Bergmann's message of "Wed\, 18 Nov 2009 10\:47\:07 +0100")
Message-ID: <m1pr7fdhkx.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Wednesday 18 November 2009, Eric Dumazet wrote:
>> > -     skb->dev = dev;
>> > -     skb->pkt_type = PACKET_HOST;
>> > +     skb->protocol = eth_type_trans(skb, dev);
>> > +     eth = eth_hdr(skb);
>> >  
>> > -     netif_rx(skb);
>> > -     return NULL;
>> > +     skb_dst_drop(skb);
>> 
>> Why do you drop dst here ?
>> 
>> It seems strange, since this driver specifically masks out IFF_XMIT_DST_RELEASE
>> in its macvlan_setup() :
>> 
>> dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
>> 
>> If we really want to drop dst, it could be done by caller, if IFF_XMIT_DST_RELEASE
>> was not masked in macvlan_setup().
>> 
>
> That must be my fault, it is the only change I did to Eric B's patch when
> forward-porting to 2.6.32. The original patch did
>
> 	skb->protocol = eth_type_trans(skb, dev);
> 	eth = eth_hdr(skb);
> 	dst_release(skb->dst);
> 	skb->dst = NULL;
> 	skb->mark = 0;
>
> and I tried to convert that in the same way that other drivers did, but I
> have to admit that I did not understand the mechanics of IFF_XMIT_DST_RELEASE.

Please copy and ideally share code with the veth driver for recycling a skb.
There are bunch of little things you have to do to get it right.  As I recally
I was missing a few details in my original patch.

Eric
