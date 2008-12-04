Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbYLDPHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbYLDPHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbYLDPHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:07:11 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:33366 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753993AbYLDPHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:07:10 -0500
Date: Thu, 4 Dec 2008 10:07:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH-mm] usb: file_storage use unaligned endian helpers
 rather than private versions
In-Reply-To: <1228343586.5412.115.camel@brick>
Message-ID: <Pine.LNX.4.44L0.0812040956450.2416-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008, Harvey Harrison wrote:

> > Suppose instead we do this:
> > 
> > #define get_be16(buf)	load_be16_noalign((be16 *) (buf))
> > #define get_be24(buf)	(load_be32_noalign((be32 *) (buf)) >> 8)
> > #define get_be32(buf)	load_be32_noalign((be32 *) (buf))
> > 
> > #define put_be16(buf, val)	store_be16_noalign((be16 *) (buf), val)
> > #define put_be32(buf, val)	store_be32_noalign((be32 *) (buf), val)
> > 
> > Then almost no more changes would be needed, only the 24-bit
> > consolidation stuff.
> > 
> 
> I'd rather the common functions just get used directly and cast as
> necessary...but it's your code.  Or define a few generic structs
> and get a pointer to those and get typechecking for free.

Or use inline routines rather than micros for proper typechecking.  
(Although that's not tremendously important, since the buffers are all
unsigned byte arrays.)  Honestly, which is easier to read and
understand, this:

		lba = load_be32_noalign((__be32 *)&fsg->cmnd[0]) & 0xffffff;

or this:

		lba = get_be24(&fsg->cmnd[1]);

-- especially considering that the value being loaded is defined in the
spec as a 3-byte field starting in byte 1 of the command buffer?

> Something like (is this really so bad?):
> 
> 	store_be32_noalign((__be32 *)&buf[0], curlun->num_sectors - 1);
> 	store_be32_noalign((__be32 *)&buf[4], 512);

IMO it's a lot worse than

	put_be32(&buf[0], curlun->num_sectors - 1);
	put_be32(&buf[4], 512);

> Personally I don't think it's that ugly just using the common functions
> directly. BTW, note that if you know the alignment, there are aligned versions
> coming as well.  YMMV.

In the end, it comes down to a matter of taste.

The aligned versions could be used in a few cases, but on the whole the 
advantage would be negligible.  I say it's not worthwhile to worry 
about using them -- which is consistent with the behavior of the 
original code.

Alan Stern

