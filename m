Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbZCPKOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbZCPKOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbZCPKOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:14:23 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:43720 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753146AbZCPKOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:14:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vmKGE76hIwBgG2EPsjNeOJUAvASTVC470Au5mMVv19WP9QKf2wdekLuiLPMgrNkEHlC8nL55ndKn6RRhkE+YYhVhx58iDoVB9CCdIc9fwLw2g2bPfZ/9FALdbn5DFgQ1zPwEaf6IjFNwxP/eOhBJiRW4ILtEFwp0WG+rM9+yFdI=  ;
X-YMail-OSG: P5s6Rv8VM1kZcl_y.gU8i_d3TtNf7IVnhpNB_RMe7iXP5CDksCYrwuLRPGnDYtYqxoDHOuR_uDnQy476QwEvS3dYhD3.6WlhDx5ZJ6F9rdeaax7U43PfNYoJU1dpJ.RqfbgibDTPHoZUsjuC6ANS4raFGxuQTQXhj.6nUgMhJa4iPGfqwnYtW2B5Fl8PVA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Mon, 16 Mar 2009 21:14:13 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org,
       tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <20090316051211.GB26138@disturbed> <20090316063830.GC6357@mit.edu>
In-Reply-To: <20090316063830.GC6357@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903162114.14460.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 March 2009 17:38:30 Theodore Tso wrote:
> Dave,
>
> It wasn't my intention to say that XFS was bad; in fact, I thought I
> was actually complementing XFS by talking about some of the advanced
> features that XFS had (many of which I have always said that ext3 has,
> and some of which ext4 still does not have, and probably never will
> have).  I stand corrected on some of the details that I got wrong.
> What I was trying to say was that *if* (and perhaps I'm
> misunderstanding fsblock) that fsblock is requiring that as soon as a
> page is dirty, fsblock requests the filesystem to assign a block
> allocation to the buffers attached to the dirty page, that this would
> spike out delayed allocation, which would be unfortunate for *both*
> ext4 and XFS.
>
> But maybe I'm misunderstanding what fsblock is doing, and there isn't
> a problem here.

Yeah, Dave's understanding of fsblock is correct. I might have stated
things confusingly... fsblock allocates the in-memory fsblock metadata
structure (~= struct buffer_head) at the time of block dirtying. It
also asks the filesystem to respond to the dirtying event appropriately.
In the case of say ext2, this means allocating a block on disk. Wheras
XFS does the delalloc/reserve thing (yes, XFS appears to be working
with fsblock well enough to get this far).

fsblock really isn't too much different to buffer_head from an abstract
capability / functionality point of view except that it is often more
strict with things where I feel it makes sense.

So for this particular example; in buffer.c, buffers do tend to be
allocated when a page is dirtied, but not always, and even when they are,
they can get reclaimed while the page is still dirty. fsblock tigtens
this up.

