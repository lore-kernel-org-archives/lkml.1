Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbZD2JlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbZD2JlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbZD2Jkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:40:53 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57125 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbZD2Jkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:40:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hdlxmp86xu4jfpbub6N1W76HNDuTxhaXiG/WOCYLd/KXKNP0bmpAVy3jMrcrsY43l0
         g5s1Zw7sAmZVghYy+g/XN47q/BZdc9JAzzHiilZZ2tH/Hr+Lq/ltsX6QxdFH9+qUvuUe
         9OWjojOpKySW0kXxGbTWIxuq55EZPW9d6THGY=
Date: Wed, 29 Apr 2009 11:40:44 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, Peter Zijlstra <peterz@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: prevent divide error for small values of
	vm_dirty_bytes
Message-ID: <20090429094043.GC3151@linux>
References: <1240993759-30787-1-git-send-email-righi.andrea@gmail.com> <alpine.DEB.2.00.0904290224260.31490@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904290224260.31490@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 02:26:11AM -0700, David Rientjes wrote:
> On Wed, 29 Apr 2009, Andrea Righi wrote:
> 
> > Avoid to set less than two pages for vm_dirty_byte: this is necessary to avoid
> > potential division by 0 (like the following) in get_dirty_limits().
> > 
> 
> Where exactly is the divide by 0 in get_dirty_limits()?

in the evaluation of the BDI's share ratio:
...
	if (bdi) {
		u64 bdi_dirty;
		long numerator, denominator;

		/*
		 * Calculate this BDI's share of the dirty ratio.
		 */
		bdi_writeout_fraction(bdi, &numerator, &denominator);

		bdi_dirty = (dirty * (100 - bdi_min_ratio)) / 100;
		bdi_dirty *= numerator;
		do_div(bdi_dirty, denominator);
		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
...

More exactly:
/home/righiandr/Software/linux/git/linux-2.6/mm/page-writeback.c:474
    1186:       48 89 f0                mov    %rsi,%rax
    1189:       48 f7 f7                div    %rdi

And looking at the trace:

[   49.952195] RAX: 00000000000000c0 RBX: ffff88001de03b80 RCX: 28f5c28f5c28f5c3
[   49.952195] RDX: 0000000000000000 RSI: 00000000000000c0 RDI: 0000000000000000
                                                           ^^^^^^^^^^^^^^^^^^^^^
> 
> Is this because we forced the background threshold to be half of the dirty 
> threshold when its setting is greater?

No (see above).

-Andrea
