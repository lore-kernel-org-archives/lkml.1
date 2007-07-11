Return-Path: <linux-kernel-owner+w=401wt.eu-S933134AbXGKWJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134AbXGKWJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761750AbXGKWJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:09:20 -0400
Received: from mail.suse.de ([195.135.220.2]:56809 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761441AbXGKWJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:09:19 -0400
From: Neil Brown <neilb@suse.de>
To: Daniel Phillips <phillips@phunq.net>
Date: Thu, 12 Jul 2007 08:09:15 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18069.21771.945367.815193@notabene.brown>
Cc: Zan Lynx <zlynx@acm.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
In-Reply-To: message from Daniel Phillips on Wednesday July 11
References: <200707111916.35036.jesper.juhl@gmail.com>
	<46951941.9080908@acm.org>
	<200707111305.08603.phillips@phunq.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday July 11, phillips@phunq.net wrote:
> On Wednesday 11 July 2007 10:54, Zan Lynx wrote:
> > Jesper Juhl wrote:
> > > Hi,
> > >
> > > I'm wondering if it's time to make 4K stacks the default and to start
> > > considering removing the 8K stack option alltogether soon?
> > >
> > > One of the big problem spots was XFS, but that got some stack usage
> > > fixes recently, and the 4K stack option has been around for quite a
> > > while now, so people really should have gotten around to fixing any
> > > code that can't handle it.   Are there still any big problem areas
> > > remaining?
> >
> > Has anyone fixed the infrequent crashes with 4K stacks and ext3 -> LVM
> > snapshot -> LVM -> DM mirror -> libata?
> 
> Ahem: ext3 -> LVM snapshot -> LVM -> DM mirror -> DM crypt -> md -> libata,
> or worse.
> 
> No, it's not fixed.  The model is wrong.  Virtual block drivers should not
> be callling submit_bio.  The recursive IO submissions should be handled
> on a dedicated stack, most probably allocated as part of the request queue.
> This could be done easily in device mapper and md, or better, in
> submit_bio.

Maybe you should read that latest kernel source code.  Particularly
generic_make_request in block/ll_rw_blk.c.
The comment preceding it read:

/*
 * We only want one ->make_request_fn to be active at a time,
 * else stack usage with stacked devices could be a problem.
 * So use current->bio_{list,tail} to keep a list of requests
 * submited by a make_request_fn function.
 * current->bio_tail is also used as a flag to say if
 * generic_make_request is currently active in this task or not.
 * If it is NULL, then no make_request is active.  If it is non-NULL,
 * then a make_request is active, and new requests should be added
 * at the tail
 */

NeilBrown
