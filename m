Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbZCYQOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbZCYQOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763416AbZCYQO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:14:29 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49623 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763402AbZCYQO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:14:28 -0400
Date: Wed, 25 Mar 2009 17:14:25 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Manuel Lauss <mano@roarinelk.homelinux.net>, linux-kernel@vger.kernel.org
Subject: Re: MMC layer regression with single-block controllers
Message-ID: <20090325161425.GY27476@kernel.dk>
References: <20090323092802.GA30122@roarinelk.homelinux.net> <20090324210138.71029c2c@mjolnir.ossman.eu> <20090325104837.GA18389@roarinelk.homelinux.net> <20090325110401.GM27476@kernel.dk> <20090325123613.06404b17@mjolnir.ossman.eu> <20090325114248.GN27476@kernel.dk> <20090325165328.251daabb@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325165328.251daabb@mjolnir.ossman.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25 2009, Pierre Ossman wrote:
> On Wed, 25 Mar 2009 12:42:48 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Mar 25 2009, Pierre Ossman wrote:
> > > 
> > > That's an annoying limitation and sort of defeats the purpose of
> > > specifying a maximum sector count. Why can't it go below 8?
> > 
> > Because it would add all sorts of complexity for handling 4kb block size
> > file systems on top of the block device. The bio_add_page() api depends
> > on being able to add a single page at least, it has to or you would need
> > to push that complexity to the callers.
> > 
> 
> Requests going in into the block layer and requests coming out aren't
> that strongly coupled, so I don't see it of that much of a stretch to
> expect this to be handled.

The point is that you have to handle at one side of the block layer, at
submission or at send-to-driver time.

> > So it's annoying, but you have to do the incremental completions
> > yourself for the (obscure) device that doesn't do more than 512b
> > transfers. It's really not that difficult, and it would be simpler than
> > supporting partial completions generically in the block layer.
> 
> The code was there previously, but it seemed a bit redundant to have
> functionality like that in the block driver since we've already told
> the block layer about the restrictions.

You never saw the warnings? It's pretty clear that it does not support <
PAGE_CACHE_SIZE blocks. It has always been so, I don't know why the
subject says regression. I guess that is referring to a mmc layer
regression?

> The code was pretty simple. Basically it just cropped the sg list at
> the correct place. Couldn't that be as easily done in the block layer?

No, because if you do it transparently, then you have to keep partial
state in the bio for completions. So it makes everything a lot more
complex, I don't want to do that for something like this.

> > Saying that it defeats the purpose of the setting is missing the bigger
> > picture - basically all other devices, that have sane limits (like 128k,
> > or whatnot).
> > 
> 
> I suppose. But it makes the feature completely useless for MMC as it
> has to implement it's own cropping of requests anyway.

Unfortunate, it's useful for other cases though.

-- 
Jens Axboe

