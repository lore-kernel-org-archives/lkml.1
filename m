Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbZJ1P5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbZJ1P5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 11:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbZJ1P53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 11:57:29 -0400
Received: from mail.vyatta.com ([76.74.103.46]:56073 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634AbZJ1P52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 11:57:28 -0400
Date: Wed, 28 Oct 2009 08:57:27 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, opurdila@ixiacom.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH] net: fold network name hash (v2)
Message-ID: <20091028085727.7fc09ab0@nehalam>
In-Reply-To: <4AE7DF8E.3020607@gmail.com>
References: <9986527.24561256620662709.JavaMail.root@tahiti.vyatta.com>
	<19864844.24581256620784317.JavaMail.root@tahiti.vyatta.com>
	<20091026.222428.80364204.davem@davemloft.net>
	<20091027102251.244ee681@nehalam>
	<20091027150436.56e673cd@nehalam>
	<4AE7DF8E.3020607@gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009 07:07:10 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Stephen Hemminger a écrit :
> > The full_name_hash does not produce a value that is evenly distributed
> > over the lower 8 bits. This causes name hash to be unbalanced with large
> > number of names. There is a standard function to fold in upper bits
> > so use that.
> > 
> > This is independent of possible improvements to full_name_hash()
> > in future.
> 
> >  static inline struct hlist_head *dev_name_hash(struct net *net, const char *name)
> >  {
> >  	unsigned hash = full_name_hash(name, strnlen(name, IFNAMSIZ));
> > -	return &net->dev_name_head[hash & ((1 << NETDEV_HASHBITS) - 1)];
> > +	return &net->dev_name_head[hash_long(hash, NETDEV_HASHBITS)];
> >  }
> >  
> >  static inline struct hlist_head *dev_index_hash(struct net *net, int ifindex)
> 
> full_name_hash() returns an "unsigned int", which is guaranteed to be 32 bits
> 
> You should therefore use hash_32(hash, NETDEV_HASHBITS),
> not hash_long() that maps to hash_64() on 64 bit arches, which is
> slower and certainly not any better with a 32bits input.

OK, I was following precedent. Only a couple places use hash_32, most use
hash_long().

Using the upper bits does give better distribution.
With 100,000 network names:

               Time       Ratio       Max   StdDev
hash_32       0.002123     1.00       422  11.07
hash_64       0.002927     1.00       400   3.97

The time field is pretty meaningless for such a small sample
