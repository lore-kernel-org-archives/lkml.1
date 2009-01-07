Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbZAGNI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbZAGNI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZAGNIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:08:43 -0500
Received: from 1wt.eu ([62.212.114.60]:1227 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609AbZAGNIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:08:42 -0500
Date: Wed, 7 Jan 2009 14:08:29 +0100
From: Willy Tarreau <w@1wt.eu>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Jens Axboe <jens.axboe@oracle.com>, Jarek Poplawski <jarkao2@gmail.com>,
       Changli Gao <xiaosuo@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090107130829.GE6307@1wt.eu>
References: <20090106100112.GB9513@ff.dom.local> <20090106155715.GA28783@1wt.eu> <20090107093915.GA6899@ff.dom.local> <20090107122205.GA6051@1wt.eu> <20090107123153.GA9597@ff.dom.local> <20090107123504.GN32491@kernel.dk> <20090107124034.GB31255@ioremap.net> <20090107125201.GB6307@1wt.eu> <20090107125356.GB26235@gondor.apana.org.au> <20090107125756.GA32336@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107125756.GA32336@ioremap.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 03:57:56PM +0300, Evgeniy Polyakov wrote:
> On Wed, Jan 07, 2009 at 11:53:56PM +1100, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > On Wed, Jan 07, 2009 at 01:52:01PM +0100, Willy Tarreau wrote:
> > > 
> > > Evgeniy, I'd like to understand something related to our apparent lack of
> > > knowledge of when the data is effectively transmitted. If we're focusing
> > > on the send part, I can't understand why I never reproduce the corruption
> > > when the data source is a file or loopback, but I only see it when the source
> > > is an ethernet interface. How is it possible that a problem affecting only
> > 
> > It doesn't happen with a file because in that case you don't
> > start with an skb so there is no skb->head.  It probably doesn't
> > happen with loopback because loopback does GSO so again skb->head
> > does not exist (so to speak).
> 
> Yup, basically splice's transmit pipe buffer contains page references,
> where the first one is actually not a real page but skb, while in the
> case of sendfile() and/or splice() from the file first page is a real
> page of the appropriate file.

OK thanks guys for the clarifications.

Evgeniy, my printk() in tcp_sendpage() fired several times indicating we were
going through do_tcp_sendpage. During the same test, I observed a lot of
corruption.

Also, I have a good news. As you suggested, disabling both SG and GSO indeed
fixes the issue. do_tcp_sendpage() is not called anymore from tcp_sendpage()
in this case (according to dmesg).

Cheers,
Willy

