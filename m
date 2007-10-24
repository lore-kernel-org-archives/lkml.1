Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbXJXOC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbXJXOC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbXJXOCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:02:48 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57454 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbXJXOCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:02:48 -0400
Date: Wed, 24 Oct 2007 08:02:46 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Message-ID: <20071024140246.GY27248@parisc-linux.org>
References: <1193173966-3550-1-git-send-email-matthew@wil.cx> <87sl401we5.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sl401we5.fsf@mid.deneb.enyo.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 03:21:06PM +0200, Florian Weimer wrote:
> > +struct stringbuf {
> > +	char *s;
> > +	int alloc;
> > +	int len;
> > +};
> 
> I think alloc and len should be unsigned (including some return values
> in the remaining patch).

I don't.  Strings should never be as long as 2GB.  To put this in
perspective, the *entire* Encyclopaedia Britannica (all 32 volumes)
is estimated at being 1GB of text.

While it would be a fair criticism that I haven't put a check for
overrunning 2GB in the code, the implementation relies on a single
continuous buffer from kmalloc, and that's currently limited to 33554432
bytes (32MB).  I don't foresee kmalloc's maximum size going up by 7
orders of magnitude -- and if it did, fragmentation would prevent you
from ever getting it.

So, I might consider a change to set -E2BIG instead of -ENOMEM if we
pass KMALLOC_MAX_SIZE, but I do think this criticism is rather straining
at gnats.

Also, 'alloc' can be an errno, and that is signalled by a negative number.
Yes, we could do something like if (sb->alloc > (unsigned)-4095) like
the mmap code does, but given the points above, it's just not worth doing.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
