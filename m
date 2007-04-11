Return-Path: <linux-kernel-owner+w=401wt.eu-S965052AbXDKTMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052AbXDKTMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965034AbXDKTMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:12:20 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57147 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965025AbXDKTMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:12:09 -0400
Date: Wed, 11 Apr 2007 12:11:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zach Brown <zach.brown@oracle.com>
Cc: Ken Chen <kenchen@google.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] convert aio event reap to use atomic-op instead of
 spin_lock
Message-Id: <20070411121146.47ca5b4d.akpm@linux-foundation.org>
In-Reply-To: <20070411180038.GN28322@mami.zabbo.net>
References: <20070410235353.325A7346F64@localhost>
	<20070411180038.GN28322@mami.zabbo.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 11:00:38 -0700
Zach Brown <zach.brown@oracle.com> wrote:

> > -	/* Compensate for the ring buffer's head/tail overlap entry */
> > -	nr_events += 2;	/* 1 is required, 2 for good luck */
> > +	/* round nr_event to next power of 2 */
> > +	nr_events = roundup_pow_of_two(nr_events);
> 
> Is that buggy?  How will the code tell if head == tail means a full ring
> or an empty ring?  The old code added that extra event to let it tell
> the ring was full before head == tail and it would think it's empty
> again, I think.  I'm guessing roundup(nr_events + 1) is needed.

Ken uses the other (superior!) way of implementing ringbuffers: the head
and tail pointers (the naming of which AIO appears to have reversed) are
not constrained to the ringsize - they are simply allowed to wrap through
0xfffffff.  Consequently:

ring full:		(head-tail == size)
ring empty:		head==tail
numer-of-items-in-ring:	head-tail
add to ring:		ring[head++]=item
remove from ring: 	item=ring[tail++]

(adjust the above for AIO naming assbackwardness)
(requires that size be a power of 2)

Many net drivers do it this way for their DMA rings.

