Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbYJCAV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbYJCAV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 20:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYJCAVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 20:21:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753519AbYJCAVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 20:21:19 -0400
Date: Thu, 2 Oct 2008 17:20:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: david@fromorbit.com, jens.axboe@oracle.com, arjan@infradead.org,
       andi@firstfloor.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-Id: <20081002172023.b0fa3cdb.akpm@linux-foundation.org>
In-Reply-To: <20081002170646.2a532680.akpm@linux-foundation.org>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
	<87fxnfpjqj.fsf@basil.nowhere.org>
	<20081002075511.GX19428@kernel.dk>
	<20081002093326.GF30001@disturbed>
	<20081002094537.GA19428@kernel.dk>
	<20081002120408.21585949@infradead.org>
	<20081002192223.GP19428@kernel.dk>
	<20081002143713.2f8ebc04.akpm@linux-foundation.org>
	<20081002235849.GJ30001@disturbed>
	<20081002170646.2a532680.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 17:06:46 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 3 Oct 2008 09:58:49 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Thu, Oct 02, 2008 at 02:37:13PM -0700, Andrew Morton wrote:
> > > On Thu, 2 Oct 2008 21:22:23 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > Can we agree on this patch?
> > > 
> > > This change will cause _all_ kjournald writeout to have elevated
> > > priority.  The majority of that writeout (in data=ordered mode) is file
> > > data, which we didn't intend to change.
> > > 
> > > The risk here is that this will *worsen* latency for plain old read(),
> > > because now kjournald writeout will be favoured.
> > > 
> > > There is in fact a good argument for _reducing_ kjournald's IO
> > > priority, not increasing it!
> > > 
> > > A better approach might be to mark the relevant buffers/bios as needing
> > > higher priority at submit_bh() time (if that's possible).  At least
> > > that way we don't accidentally elevate the priority of the bulk data.
> > 
> > You can do that for submit_bio() by calling bio_set_prio() before
> > submision - I did that for elevating only the XFS journal I/O.
> > submit_bh() doesn't have any way of passing a priority through to it
> > right now...
> 
> Yup.  There are plenty of spare bits in buffer_head.b_state. 
> set_buffer_kludge()?
> 

And if we do decide to run set_buffer_kludge() against these blocks
then it should be done at the time when they are marked dirty, when JBD
refiles them for checkpoint writeback.

This is because kjournald isn't the only process which writes these
buffers.  Pretty often (usually?) it is pdflush.  The increased IO
prioritisation is a property of the buffer, not of the task which
submits it for IO.  I suspect.
