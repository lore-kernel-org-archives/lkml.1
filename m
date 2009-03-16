Return-Path: <linux-kernel-owner+w=401wt.eu-S1756607AbZCPKdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbZCPKdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZCPKct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:32:49 -0400
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:22728 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751835AbZCPKcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:32:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vN1QkQPeTxisNUUjRsW0aMgL5zDSJGsryj6jgsJdrRGfr5GqmF8iJy390HJJBs4e0Ojmy9XndYNCcZ/Dh8qLBGztwEJPbT4OcvBqlSejsUFR9fWxvft6XIbvB2ZnFv/NlKYVM8Xfm/F9CHyCWM7erD3O7QZ8u8E+HhBJZG7SFEY=  ;
X-YMail-OSG: M.QZ3lEVM1laXOpWA9vk2lZ.Es1ushtR0x1J25.FNhLQyKdxFpOiNfYA7Qa3TIW.aS2o8ssIN5vRmZ1HefZ7Nj9MaOrkRgwfnhKFBY2CY2v3eB4VezcMlh2XdV1WIagVpRfJVUzz.IDysu45jUXq9jFGSW_9Lp9hROmFIshBDvU7djYFEp_vnIYBzIMqzQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Daniel Phillips <phillips@phunq.net>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Mon, 16 Mar 2009 21:32:39 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, tux3@tux3.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <20090315214426.GA6357@mit.edu> <200903151541.36223.phillips@phunq.net>
In-Reply-To: <200903151541.36223.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903162132.40344.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 March 2009 09:41:35 Daniel Phillips wrote:
> Hi Ted,

> > So the really unfortunate thing about allocating the block as soon as
> > the page is dirty is that it spikes out delayed allocation.  By
> > delaying the physical allocation of the logical->physical mapping as
> > long as possible, the filesystem can select the best possible physical
> > location.
>
> Tux3 does not dirty the metadata until data cache is flushed, so the
> allocation decisions for data and metadata are made at the same time.
> That is the reason for the distinction between physical metadata above,
> and logical metadata such as directory data and bitmaps, which are
> delayed.  Though physical metadata is positioned when first dirtied,
> physical metadata dirtying is delayed until delta commit.
>
> Implementing this model (we are still working on it) requires taking
> care of a lot of subtle details that are specific to the Tux3 cache
> model.  I have a hard time imagining those allocation decisions driven
> by callbacks from a buffer-like library.

The filesystem can get pagecache-block-dirty events in a few ways
(often a combination of):
write_begin/write_end, set_page_dirty, page_mkwrite, etc. Short of
implementing entirely your own write path (and even then you need to
hook at least page_mkwrite to catch mmapped writes, for completeness),
I don't see why a get_block(BLOCK_DIRTY) kind of callback is much
harder for you to imagine than any of the other callbacks. Actually
I imagine the block based callback should be easier for filesystems
that support any block size != page size because all the others are
page based.

I would like to hear firm details about any problems definitely,
because I would like to try to make it more generic even if your
filesystem won't use it :)

Now this is not to say the current buffer APIs are totally _optimal_.
As I said, I would like to see at least something along the lines of
"we are about to dirty range (x,y)" callback in the higher level
generic write code. But that's another story (which I am planning
to get to).


