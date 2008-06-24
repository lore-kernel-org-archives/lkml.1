Return-Path: <linux-kernel-owner+w=401wt.eu-S1759788AbYFXMRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788AbYFXMRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 08:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYFXMRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 08:17:10 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:39681 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752491AbYFXMRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 08:17:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nij9IOLZuqePvCOZj24MNiKMVfu7HALFldnXxKcgPPLRxi2LrhMPbsJUJ3Mxnya3anNeaYJMV7hHp9h+M6llDLFt2aubaefFZCu5S6Nve+Ribszpa2XtufWww87zyn/HwXqdfJP6jLdhi4OlzpxNEs1dXYUZeSzEqc0PNMVBe0w=  ;
X-YMail-OSG: OYk3SVsVM1k8rGB4ZBHfI50dbq9pxTULX7E7qRfFDdjYTrXjiw61NCRrGsRDJgp1M7D_ykaH.ajoTu1ajzgf2s_xvz0nRekliIySgnUNI4DSMthGT503H_awn_.ZRQQrNwI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [rfc patch 3/4] splice: remove confirm from pipe_buf_operations
Date: Tue, 24 Jun 2008 22:16:41 +1000
User-Agent: KMail/1.9.5
Cc: jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org
References: <20080621154607.154640724@szeredi.hu> <20080624111913.GP20851@kernel.dk> <E1KB6p9-0001Gq-Fd@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KB6p9-0001Gq-Fd@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806242216.41548.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2008 21:36, Miklos Szeredi wrote:
> > It's an unfortunate side effect of the read-ahead, I'd much rather just
> > get rid of that. It _should_ behave like the non-ra case, when a page is
> > added it merely has IO started on it. So we want to have that be
> > something like
> >
> >         if (!PageUptodate(page) && !PageInFlight(page))
> >                 ...
> >
> > basically like PageWriteback(), but for read-in.
>
> OK it could be done, possibly at great pain.  But why is it important?

It has been considered, but adding atomic operations on these paths
always really hurts. Adding something like this would basically be
another at least 2 atomic operations that can never be removed again...

Provided that you've done the sync readahead earlier, it presumably
should be a very rare case to have to start new IO in the loop
below, right? In which case, I wonder if we couldn't move that 2nd
loop out of generic_file_splice_read and into
page_cache_pipe_buf_confirm. 


> What's the use case where it matters that splice-in should not block
> on the read?

It just makes it generally less able to pipeline IO and computation,
doesn't it?


> And note, after the pipe is full it will block no matter what, since
> the consumer will have to wait until the page is brought uptodate, and
> can only then commence with getting the data out from the pipe.

True, but (especially with patches to variably size the pipe buffer)
I imagine programs could be designed fairly carefully to the size of
the buffer (and not just things that blast bulk data down the pipe...)
