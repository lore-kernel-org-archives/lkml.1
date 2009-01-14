Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbZANAOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbZANAOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbZANANr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:13:47 -0500
Received: from kandzendo.ru ([195.178.208.66]:58091 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbZANANq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:13:46 -0500
Date: Wed, 14 Jan 2009 03:13:45 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Miller <davem@davemloft.net>
Cc: dada1@cosmosbay.com, w@1wt.eu, ben@zeus.com, jarkao2@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
Message-ID: <20090114001345.GB512@ioremap.net>
References: <20090111133533.GB25337@ioremap.net> <496A17A5.7010200@cosmosbay.com> <20090111160548.GA362@ioremap.net> <20090113.160721.68474279.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113.160721.68474279.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 04:07:21PM -0800, David Miller (davem@davemloft.net) wrote:
> > Exactly, and to have it we earlier release a socket so that it could be
> > acked and while we copy it or doing anything else, the next one would
> > received.
> 
> I think the socket release in skb_splice_bits() (although necessary)
> just muddies the waters, and whether the extra one done in
> tcp_splice_read() helps at all is open to debate.

Well, yes, probably simple performance test with and without will
clarify the things.

> That skb_clone() done by skb_splice_bits() pisses me off too,
> we really ought to fix that.  And we also have that data corruption
> bug to cure too.

Clone is needed since tcp expects to own the skb and frees it
unconditionally via __kfree_skb().

What is the best solution for the data corruption bug? To copy the data
all the time or implement own allocator to be used in alloc_skb and
friends to allocate the head? I think it can be done transparently for
the drivers. I can volunteer for this :)
The first one is more appropriate for the current bugfix-only stage,
but this will result in the whole release being too slow.

-- 
	Evgeniy Polyakov
