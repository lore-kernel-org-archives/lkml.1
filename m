Return-Path: <linux-kernel-owner+w=401wt.eu-S1031673AbXHMNoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031673AbXHMNoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932733AbXHMKMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:12:44 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:41721
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932678AbXHMKMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:12:40 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Distributed storage.
Date: Mon, 13 Aug 2007 03:12:33 -0700
User-Agent: KMail/1.9.5
Cc: Jens Axboe <jens.axboe@oracle.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708130208.57542.phillips@phunq.net> <20070813091856.GA5503@2ka.mipt.ru>
In-Reply-To: <20070813091856.GA5503@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708130312.33903.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 August 2007 02:18, Evgeniy Polyakov wrote:
> On Mon, Aug 13, 2007 at 02:08:57AM -0700, Daniel Phillips 
(phillips@phunq.net) wrote:
> > > But that idea fails as well, since reference counts and IO
> > > completion are two completely seperate entities. So unless end IO
> > > just happens to be the last user holding a reference to the bio,
> > > you cannot free it.
> >
> > That is not a problem.  When bio_put hits zero it calls ->endio
> > instead of the destructor.  The ->endio sees that the count is zero
> > and destroys the bio.
>
> This is not a very good solution, since it requires all users of the
> bios to know how to free it.

No, only the specific ->endio needs to know that, which is set by the 
bio owner, so this knowledge lies in exactly the right place.  A small 
handful of generic endios all with the same destructor are used nearly 
everywhere.

> Right now it is hidden. 
> And adds additional atomic check (although reading is quite fast) in
> the end_io.

Actual endio happens once in the lifetime of the transfer, this read 
will be entirely lost in the noise.

> And for what purpose? To eat 8 bytes on 64bit platform? 
> This will not reduce its size noticebly, so the same number of bios
> will be in the cache's page, so what is a gain? All this cleanups and
> logic complicatins should be performed only if after size shring
> increased number of bios can fit into cache's page, will it be done
> after such cleanups?

Well, exactly,   My point from the beginning was that the size of struct 
bio is not even close to being a problem and adding a few bytes to it 
in the interest of doing the cleanest fix to a core kernel bug is just 
not a dominant issue.

I suppose that leaving out the word "bloated" and skipping straight to 
the "doesn't matter" proof would have saved some bandwidth.

Regards,

Daniel
