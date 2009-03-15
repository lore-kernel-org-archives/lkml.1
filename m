Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbZCODvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbZCODvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 23:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbZCODvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 23:51:04 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:40264 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751814AbZCODvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 23:51:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vA2Y5Of0zbahJfpXyAV2noBuD26WcpD772e495DEUwheugD5i2qVd9+LYUONUNgQkKnl8KTRDwg3BOZLXM6stKDc5300kKSDjbhZ9zeTF4ZuENg8ZpM4CI4FtNDfOLm/Tzb4qPz/kEhw3787eh8H8AkivKam2qUmc9uqXp0/yLE=  ;
X-YMail-OSG: 9OnxEXwVM1kPWSq.c8DVzzQKaIVyKahd7jpFY.TmGt6ROab6W8n5EnH81.OoKoy5HDB5FtSg7hfZ8J1Eicnzf6W0J.afYqzNmk_3Z_AX3Fjbq7_NYxrRu.J8MOsewwtPex9EL_dsdvS4gB2oHNmeCUKJixGArJ_raiK6iuJXrzKpqLd70Abg04EDCAH8Lg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Daniel Phillips <phillips@phunq.net>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Sun, 15 Mar 2009 14:50:51 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
       tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <20090312135940.GB14425@parisc-linux.org> <200903142024.30142.phillips@phunq.net>
In-Reply-To: <200903142024.30142.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903151450.51726.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 March 2009 14:24:29 Daniel Phillips wrote:
> On Thursday 12 March 2009, Matthew Wilcox wrote:
> > On Fri, Mar 13, 2009 at 12:04:40AM +1100, Nick Piggin wrote:
> > > As far as the per-block pagecache state (as opposed to the per-block fs
> > > state), I don't see any reason it is a problem for efficiency. We have
> > > to do per-page operations anyway.
> >
> > Why?  Wouldn't it be nice if we could do arbitrary extents?  I suppose
> > superpages or soft page sizes get us most of the way there, but the
> > rounding or pieces at the end are a bit of a pain.  Sure, it'll be a
> > huge upheaval for the VM, but we're good at huge upheavals ;-)
>
> Actually, filesystem extents tend to erode the argument for superpages.
> There are three reasons we have seen for wanting big pages: 1) support
> larger block buffers without adding messy changes to buffer.c; 2) TLB
> efficiency; 3) less per-page state in kernel memory.  TLB efficiency is
> only there if the hardware supports it, which X86 arguably doesn't.
> The main argument for larger block buffers is less per-block transfer
> setup overhead, but the BIO model combined with filesystem extents
> does that job better, or at least it will when filesystems learn to
> take better advantage of this.
>
> VM extents on the other hand could possibly do a really good job of
> reducing per-page VM overhead, if anybody still cares about that now
> that 64 bit machines rule the big iron world.
>
> I expect implementing VM extents to be a brutally complex project, as
> filesystem extents always turn out to be, even though one tends to
> enter such projects thinking, how hard could this be?  Answer: harder
> than you think.  But VM extents would be good for a modest speedup, so
> somebody is sure to get brave enough to try it sometime.

I don't think there is enough evidence to be able to make such an
assertion.

When you actually implement extent splitting and merging in a deadlock
free manner and synchronize everything properly I wouldn't be surprised
if it is slower most of the time. If it was significantly faster, then
memory fragmentation means that it is going to get significantly slower
over the uptime of the kernel, so you would have to virtually map the
kernel and implement memory defragmentation, at which point you get even
slower and more complex.

