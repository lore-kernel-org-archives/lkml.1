Return-Path: <linux-kernel-owner+w=401wt.eu-S1760182AbXEPAAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760182AbXEPAAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758299AbXEOX74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 19:59:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37665 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756703AbXEOX7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 19:59:55 -0400
Date: Tue, 15 May 2007 16:56:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: mroos@linux.ee, David Miller <davem@davemloft.net>,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: slab hang on boot
Message-Id: <20070515165636.5057456e.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705151642530.3886@schroedinger.engr.sgi.com>
References: <Pine.SOC.4.64.0705142133190.17204@math>
	<20070514.151148.45744375.davem@davemloft.net>
	<Pine.LNX.4.64.0705141642350.13606@schroedinger.engr.sgi.com>
	<20070515163321.744e2388.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705151642530.3886@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 16:45:22 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 15 May 2007, Andrew Morton wrote:
> 
> > On Mon, 14 May 2007 16:46:17 -0700 (PDT)
> > Christoph Lameter <clameter@sgi.com> wrote:
> > 
> > > @@ -86,6 +87,9 @@ static inline int kmalloc_index(int size
> > >  	 */
> > >  	WARN_ON_ONCE(size == 0);
> > >  
> > > +	if (size >= (1UL << KMALLOC_SHIFT_HIGH))
> > > +		return -1;
> > > +
> > 
> > I don't quite understand why we did this.  The subsequent logic in
> > kmalloc_index() should return -1 for this `size' anyway.  If it doesn't,
> > it's bust, isn't it?
> 
> KMALLOC_SHIFT_HIGH is not a constant but may be less than 25.

It darn well better be a compile-time constant.

And look:

static inline int kmalloc_index(int size)
{
	/*
	 * We should return 0 if size == 0 but we use the smallest object
	 * here for SLAB legacy reasons.
	 */
	WARN_ON_ONCE(size == 0);

	if (size > (1 << KMALLOC_SHIFT_HIGH))
		return -1;

	if (size > 64 && size <= 96)
		return 1;
	if (size > 128 && size <= 192)
		return 2;
	if (size <=          8) return 3;
	if (size <=         16) return 4;
	if (size <=         32) return 5;
	if (size <=         64) return 6;
	if (size <=        128) return 7;
	if (size <=        256) return 8;
	if (size <=        512) return 9;
	if (size <=       1024) return 10;
	if (size <=   2 * 1024) return 11;
	if (size <=   4 * 1024) return 12;
	if (size <=   8 * 1024) return 13;
	if (size <=  16 * 1024) return 14;
	if (size <=  32 * 1024) return 15;
	if (size <=  64 * 1024) return 16;
	if (size <= 128 * 1024) return 17;
	if (size <= 256 * 1024) return 18;
#if KMALLOC_SHIFT_HIGH > 18
	if (size <=  512 * 1024) return 19;
	if (size <= 1024 * 1024) return 20;
#endif
#if KMALLOC_SHIFT_HIGH > 20
	if (size <=  2 * 1024 * 1024) return 21;
	if (size <=  4 * 1024 * 1024) return 22;
	if (size <=  8 * 1024 * 1024) return 23;
	if (size <= 16 * 1024 * 1024) return 24;
	if (size <= 32 * 1024 * 1024) return 25;
#endif
	return -1;

/*
 * What we really wanted to do and cannot do because of compiler issues is:
 *	int i;
 *	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++)
 *		if (size <= (1 << i))
 *			return i;
 */
}

Either that newly-added test isn't needed, or those ifdefs aren't needed?

