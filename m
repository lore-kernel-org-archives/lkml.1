Return-Path: <linux-kernel-owner+w=401wt.eu-S1758681AbZFJPIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681AbZFJPIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 11:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381AbZFJPIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 11:08:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56000 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259AbZFJPIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 11:08:40 -0400
Date: Wed, 10 Jun 2009 16:08:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Theodore Tso <tytso@mit.edu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: linux-next: next-20090609 hangs in early user mode
Message-ID: <20090610150839.GS8633@ZenIV.linux.org.uk>
References: <20090610180058.99bd3dda.sfr@canb.auug.org.au> <20090610130054.GR8633@ZenIV.linux.org.uk> <20090610131909.GB6647@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610131909.GB6647@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 09:19:09AM -0400, Theodore Tso wrote:
> On Wed, Jun 10, 2009 at 02:00:54PM +0100, Al Viro wrote:
> > 
> > Yes, it's obviously bogus.  Dropped from the tree; I don't think it's
> > really salvagable - even merging into one unsigned long will not be
> > enough, since we will end up with different locking for different bits.
> 
> Oops, sorry, I didn't realize we were using bitops for i_state.  As
> far as I can tell we're not using the bitops functions for i_flags,
> though.  Is that right?  So we can convert i_flags to be a unsigned
> short, but we can't do anything with i_state.

We can, but... it's again a matter of combining things with different
locking.  i_flags is protected by i_mutex, so if you put another
unsigned short next to it, you'd better make sure that i_mutex
is necessary and sufficient for modifying it.

Depending on the target, gcc may turn 16bit read-modify-store into 32bit one,
so if you have two 16bit fields next to each other, you can run into

CPU1:                     CPU2:
r1 = *(u32 *)p;           r2 = *(u32 *)p;
r1 |= 1;                  r2 |= 1 << 16;
*(u32 *)p = r1;           *(u32 *)p = r2;

with obvious results.  So we need the same locking for both such fields...
