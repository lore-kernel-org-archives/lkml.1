Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbYGaMtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbYGaMtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 08:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYGaMtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 08:49:14 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:26157 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752855AbYGaMtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:49:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lmHSJpN7SWm91x2LipADO5LpTFzDW0V3L9afXYkAVLMkBzpFUwEU7sagn63A1ewO7axdFOyDdgLXJNyw2bQKL+wpsbDXdbfSC+k1MpoFA4yxQDwwFG7kJGrDp6jX/gA0sSMzc4+YA8y0MKvAyg0nLhrq8E5jTkph6QbSyVgwaTE=  ;
X-YMail-OSG: ohI5dI8VM1kHNcehTVglTRoCrC0K5_CVPj9BqdNmQkx7FWXw5eL7kM4Ly.PfFNFTfYcyNXsbNB72sqsB7ALYEUNE8cx7F5fHgLQahtS9eRJc7RBP0eB1EEt2Q.hndmDFP0k-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jamie Lokier <jamie@shareable.org>
Subject: Re: [patch v3] splice: fix race with page invalidation
Date: Thu, 31 Jul 2008 22:49:01 +1000
User-Agent: KMail/1.9.5
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, jens.axboe@oracle.com,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <E1KOIYA-0002FG-Rg@pomaz-ex.szeredi.hu> <20080731102612.GA29766@2ka.mipt.ru> <20080731123350.GB16481@shareable.org>
In-Reply-To: <20080731123350.GB16481@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807312249.02287.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008 22:33, Jamie Lokier wrote:
> Evgeniy Polyakov wrote:
> > On Thu, Jul 31, 2008 at 07:12:01AM +0100, Jamie Lokier 
(jamie@shareable.org) wrote:
> > > The obvious mechanism for completion notifications is the AIO event
> > > interface.  I.e. aio_sendfile that reports completion when it's safe
> > > to modify data it was using.  aio_splice would be logical for similar
> > > reasons.  Note it doesn't mean when the data has reached a particular
> > > place, it means when the pages it's holding are released.  Pity AIO
> > > still sucks ;-)
> >
> > It is not that simple: page can be held in hardware or tcp queues for
> > a long time, and the only possible way to know, that system finished
> > with it, is receiving ack from the remote side. There is a project to
> > implement such a callback at skb destruction time (it is freed after ack
> > from the other peer), but do we really need it? System which does care
> > about transmit will implement own ack mechanism, so page can be unlocked
> > at higher layer. Actually page can be locked during transfer and
> > unlocked after rpc reply received, so underlying page invalidation will
> > be postponed and will not affect sendfile/splice.
>
> This is why marking the pages COW would be better.  Automatic!
> There's no need for a notification, merely letting go of the page
> references - yes, the hardware / TCP acks already do that, no locking
> or anything!  :-)  The last reference is nothing special, it just means
> the next file write/truncate sees the count is 1 and doesn't need to
> COW the page.

Better == more bloat and complexity and corner cases in the VM?

If the app wants to ensure some specific data is sent, then it has
to wait until the receiver receives it before changing it, simple.

And you still don't avoid the fundamental problem that the receiver
may not get exactly what the sender has put in flight if we do things
asynchronously.
