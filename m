Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbXHJART@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbXHJART (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 20:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbXHJARK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 20:17:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:48341 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbXHJARI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 20:17:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jOYbd4NJ69GK7d4xx7nAVytfXeVAyN6aePBH1nDrqSwAoPtGY8o4n4CTRsKm+bFtx+AQaZncgfYT1w1EqAoIhxMRRbzYCUB1g8BG7edBxetLpS5YDVpCs0phIunFkV9LcBKLlYfxPiRb94HkXzkAEvOFrcn4mUzyfXZYQxgB2dY=
Message-ID: <4a5909270708091717n2f93fcb5i284d82edfd235145@mail.gmail.com>
Date: Thu, 9 Aug 2007 20:17:08 -0400
From: "Daniel Phillips" <daniel.raymond.phillips@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
Cc: "Daniel Phillips" <phillips@phunq.net>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Matt Mackall" <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "David Miller" <davem@davemloft.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Phillips" <phillips@google.com>
In-Reply-To: <Pine.LNX.4.64.0708091146410.25220@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070806102922.907530000@chello.nl>
	 <200708061559.41680.phillips@phunq.net>
	 <Pine.LNX.4.64.0708061605400.5090@schroedinger.engr.sgi.com>
	 <200708061649.56487.phillips@phunq.net>
	 <Pine.LNX.4.64.0708071513290.3683@schroedinger.engr.sgi.com>
	 <4a5909270708080037n32be2a73k5c28d33bb02f770b@mail.gmail.com>
	 <Pine.LNX.4.64.0708081106230.12652@schroedinger.engr.sgi.com>
	 <4a5909270708091141tb259eddyb2bba1270751ef1@mail.gmail.com>
	 <Pine.LNX.4.64.0708091146410.25220@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Thu, 9 Aug 2007, Daniel Phillips wrote:
> > On 8/8/07, Christoph Lameter <clameter@sgi.com> wrote:
> > > On Wed, 8 Aug 2007, Daniel Phillips wrote:
> > > Maybe we need to kill PF_MEMALLOC....
> > Shrink_caches needs to be able to recurse into filesystems at least,
> > and for the duration of the recursion the filesystem must have
> > privileged access to reserves.  Consider the difficulty of handling
> > that with anything other than a process flag.
>
> Shrink_caches needs to allocate memory? Hmmm... Maybe we can only limit
> the PF_MEMALLOC use.

PF_MEMALLOC is not such a bad thing.  It will usually be less code
than mempool for the same use case, besides being able to handle a
wider range of problems.  We  introduce __GPF_MEMALLOC for situations
where the need for reserve memory is locally known, as in the network
stack, which is similar or identical to the use case for mempool.  One
could reasonably ask why we need mempool with a lighter alternative
available.  But this is a case of to each their own I think.  Either
technique will work for reserve management.

> > In theory, we could reduce the size of the global memalloc pool by
> > including "easily freeable" memory in it.  This is just an
> > optimization and does not belong in this patch set, which fixes a
> > system integrity issue.
>
> I think the main thing would be to fix reclaim to not do stupid things
> like triggering writeout early in the reclaim pass and to allow reentry
> into reclaim. The idea of memory pools always sounded strange to me given
> that you have a lot of memory in a zone that is reclaimable as needed.

You can fix reclaim as much as you want and the basic deadlock will
still not go away.  When you finally do get to writing something out,
memory consumers in the writeout path are going to cause problems,
which this patch set fixes.

Agreed that the idea of mempool always sounded strange, and we show
how to get rid of them, but that is not the immediate purpose of this
patch set.

Regards,

Daniel
