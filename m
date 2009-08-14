Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZHNWKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZHNWKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 18:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756738AbZHNWKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 18:10:53 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:28170 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706AbZHNWKu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 18:10:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EvY6CrFQx2byHWpd8/tyCGHTKAxiSfPFXxIcnv5LhjnVrI6Xq0OYOSZMGi/aRWmay2
         W2RAF/wSFOoBLnIOIB0JyKDDzYjkSteCX7eBJ8qydarBcBGxexVFYd1YFgZpM4WOzH1u
         T1JF3geznu5NUxp6Xfs349RzMMejaALHyJZxw=
MIME-Version: 1.0
In-Reply-To: <adafxbu3vqt.fsf@cisco.com>
References: <200908122007.43522.ngupta@vflare.org>
	 <alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>
	 <87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>
	 <alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm>
	 <87f94c370908131428u75dfe496x1b7d90b94833bf80@mail.gmail.com>
	 <46b8a8850908131520s747e045cnd8db9493e072939d@mail.gmail.com>
	 <87f94c370908131719l7d84c5d0x2157cfeeb2451bce@mail.gmail.com>
	 <46b8a8850908131758s781b07f6v2729483c0e50ae7a@mail.gmail.com>
	 <87f94c370908141433h111f819j550467bf31c60776@mail.gmail.com>
	 <adafxbu3vqt.fsf@cisco.com>
Date: Fri, 14 Aug 2009 18:10:50 -0400
Message-ID: <87f94c370908141510p1752183elf32c879c0510ebc4@mail.gmail.com>
Subject: Re: Discard support
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Richard Sharpe <realrichardsharpe@gmail.com>, david@lang.hm,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 5:56 PM, Roland Dreier<rdreier@cisco.com> wrote:
>
>  > It seems to me that unmap is not all that different, why do we need to
>  > do it even close in time proximity to the deletes?  With a bitmap, we
>  > have total timing control of when the unmaps are forwarded down to the
>  > device.  I like that timing control much better than a cache and
>  > coalesce approach.
>
> The trouble I see with a bitmap is the amount of memory it consumes.  It
> seems that discards must be tracked on no bigger than 4KB sectors (and
> possibly even 512 byte sectors).  But even with 4KB, then, say, a 32 TB
> volume (just 16 * 2TB disks, or even lower end with thin provisioning)
> requires 1 GB of bitmap memory.  Which is a lot just to store, let alone
> walk over etc.

Have the filesystem guys created any efficient extent tree tracking solutions?

I mean a 16TB filesystem obviously has to track the freespace somehow
that does not require 1GB of ram.  Can that logic be leveraged in
block to track freespace?  That obviously assumes its not too cpu
intensive to do so.

If a leaf in the extent tracking tree becomes big enough, it could
even be sent down from the block layer and that leaf deleted.  ie. If
a leaf of the tree grows to represent X contiguous blocks, then a
discard could be sent down to the device and the leaf representing
those free blocks deleted.

The new topo info about block devices might be able to help optimize
the minimum size of a coalesced discard.

Greg
--
Greg Freemyer
