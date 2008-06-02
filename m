Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbYFBInh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbYFBInh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 04:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbYFBIn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 04:43:29 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:47131 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbYFBIn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 04:43:28 -0400
Date: Mon, 2 Jun 2008 09:43:05 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Pavel Machek <pavel@suse.cz>, mtk.manpages@gmail.com,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
In-Reply-To: <20080601161133.ea344adf.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0806020906001.9534@blonde.site>
References: <Pine.LNX.4.64.0805301451020.19914@blonde.site> <20080530204307.GA4978@ucw.cz>
 <Pine.LNX.4.64.0805311925190.27293@blonde.site> <20080531173950.c4f04028.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0806010752510.24919@blonde.site> <20080601011501.199af80c.akpm@linux-foundation.org>
 <20080601114008.GC16843@elf.ucw.cz> <20080601133727.4e62ae55.akpm@linux-foundation.org>
 <20080601222202.GA2255@elf.ucw.cz> <20080601154736.2e9f5905.akpm@linux-foundation.org>
 <20080601230040.GC2255@elf.ucw.cz> <20080601161133.ea344adf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008, Andrew Morton wrote:
> On Mon, 2 Jun 2008 01:00:40 +0200 Pavel Machek <pavel@suse.cz> wrote:
> > > How about this:
> > > 
> > > - Add a new SYNC_FILE_RANGE_NON_BLOCKING
> > > 
> > > - If userspace set that flag, turn on writeback_control.nonblocking
> > >   in __filemap_fdatawrite_range().
> > > 
> > > - test it a lot.
> > 
> > Works for me. Is the expectation that I code this? I can certainly
> > provide testing ;-).
> 
> Something like this:

Though this fits very easily into the current kernel implementation,
I don't think it's the right interface for userspace.

If we do go this kind of a way, then I'd say SYNC_FILE_RANGE_NON_BLOCKING
needs to tell the caller how far it got before giving up, rather than just
success or failure.  Why? um, um, because it feels right; and would help
the caller help the kernel by not overloading it with needlessly repeated
loop ranges - any stronger reasons?  But sync_file_range() was defined
to return int rather than ssize_t, so that becomes awkward.

Never mind, I don't think it is the right way anyway.  We don't need
additions to the existing sync_file_range() interface, we just need it
to behave as naive people like Pavel and I expected it to behave in the
first place: SYNC_FILE_RANGE_WRITE should be nonblocking (with respect
to queue congestion, and maybe page locking also).

I was imagining that where the existing nonblocking code just gives up,
the SYNC_FILE_RANGE_WRITE case should schedule the remaining work to be
done a little later: possibly by poking and/or leaving info for pdflush.

I guess there may be some resource fairness issues, with either approach:
it ought not to be unreasonable for a process to proceed by writing a
page then SYNC_FILE_RANGE_WRITing that page, page by page, should it?

But once we claim nonblocking at the user interface, I expect we'll
come up against the raciness in the current nonblocking treatment:
just because bdi is not congested when it's tested doesn't mean we
won't block when the write is submitted.  Perhaps a BIO_RW_NONBLOCK
could fix that up?

Hugh
