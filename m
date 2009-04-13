Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbZDMKKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbZDMKKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 06:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbZDMKKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 06:10:07 -0400
Received: from sh.osrg.net ([192.16.179.4]:59489 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbZDMKKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 06:10:06 -0400
Date: Mon, 13 Apr 2009 19:07:57 +0900
To: jeff@garzik.org
Cc: fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, tj@kernel.org,
       petkovbb@gmail.com, bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-ide@vger.kernel.org
Subject: Re: [PATCHSET pata-2.6] ide: rq->buffer, data, special and misc
	cleanups
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49E2F84C.6080804@garzik.org>
References: <49E2EFBE.5000709@garzik.org>
	<20090413172143B.fujita.tomonori@lab.ntt.co.jp>
	<49E2F84C.6080804@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090413190615C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 13 Apr 2009 19:07:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 04:31:08 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> FUJITA Tomonori wrote:
> > On Mon, 13 Apr 2009 03:54:38 -0400
> > Jeff Garzik <jeff@garzik.org> wrote:
> > 
> >> FUJITA Tomonori wrote:
> >>> On Tue, 31 Mar 2009 16:04:39 +0300
> >>> Boaz Harrosh <bharrosh@panasas.com> wrote:
> >>>
> >>>>> I
> >>>>> just don't think bvec should be used outside of block/fs interface.
> >>>>> As I wrote before, non-FS users have no reason to worry about bio.
> >>>>> All it should think about is the requst it needs to issue and the
> >>>>> memory area it's gonna use as in/out buffers.  bio just doesn't have a
> >>>>> place there.
> >>>>>
> >>>> I don't understand what happens to all the people that start to work on the block
> >>>> layer, they start getting defensive about bio being private to the request
> >>>> level. But the Genie is out of the bag already (I know cats and bottles).
> >>>> bio is already heavily used above the block layer from directly inside filesystems
> >>>> to all kind of raid engines, DM MD managers, multi paths, integrity information ...
> >>>>
> >>>> Because bio is exactly that Ideal page carrier you are talking about.
> >>> Wrong. multi path doesn't use bio. md accesses to the bio internal
> >>> (it's not nice) and has the own way to carry pages. dm has the own
> >>> mechanism on the top of bio. And bio doesn't work nicely for file
> >>> systems such as btrfs, which handle multiple devices.
> >>>
> >>> Please stop your wrong argument 'bio is the ideal page carrier'.
> >> What is the multi-device problem with bio?
> > 
> > Well, if it works nicely, I guess that we don't have something like
> > drivers/dm/{dm-bio-record.h, dm-bio-list.h}, btrfs_multi_bio struct,
> > or md's own page carrier?
> 
> It was an honest question.  I am seeking information, not denying your 
> argument.
> 
> What, specifically, is this multi-device problem with bio, please?

dm-bio-record.h says:

/*
 * There are lots of mutable fields in the bio struct that get
 * changed by the lower levels of the block layer.  Some targets,
 * such as multipath, may wish to resubmit a bio on error.  The
 * functions in this file help the target record and restore the
 * original bio state.
 */


I guess that dm-bio-list.h is a way to link multiple bios for multiple
devices to a single structure but others use bio->bi_next for a
different purpose (for example, building a large request in the block
mapping API) so it's confusing.
