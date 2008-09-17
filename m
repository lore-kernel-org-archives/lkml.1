Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbYIQXCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbYIQXCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 19:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYIQXCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 19:02:05 -0400
Received: from gw.goop.org ([64.81.55.164]:43055 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbYIQXCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 19:02:03 -0400
Message-ID: <48D18C6B.5010407@goop.org>
Date: Wed, 17 Sep 2008 16:02:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: Populating multiple ptes at fault time
References: <48D142B2.3040607@goop.org> <48D17E75.80807@redhat.com> <48D1851B.70703@goop.org> <48D18919.9060808@redhat.com>
In-Reply-To: <48D18919.9060808@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> We could work around it by having a hypercall to read and clear
> accessed bits.  If we know the guest will only do that via the
> hypercall, we can keep the accessed (and dirty) bits in the host, and
> not update them in the guest at all.  Given good batching, there's
> potential for a large win there.

We added a hypercall to update just the AD bits, though it was primarily
to update D without losing the hardware-set A bit.

I don't think it would be practical to add a hypercall to read the A
bit.  There's too much code which just assumes it can grab a pte and
test the bit state.  There's no pv_op for reading a pte in general, and
even if there were you'd need to have a specialized pv-op for
specifically reading the A bit to avoid unnecessary hypercalls.

Setting/clearing the A bit could be done via the normal set_pte pv_op,
so that's not a big deal.

Do you need to set the A bit synchronously?  What happens if you install
the guest and shadow pte with A clear, and then lazily transfer the A
bit state from the shadow to guest pte?  Maybe at some significant event
like  a tlb flush or:

> (If the host throws away a shadow page, it could sync the bits back
> into the guest pte for safekeeping)


    J
