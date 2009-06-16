Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbZFPOWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbZFPOWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbZFPOWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:22:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbZFPOWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:22:13 -0400
Date: Tue, 16 Jun 2009 16:22:14 +0200
From: Nick Piggin <npiggin@suse.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.29.4: softlockup at find_get_page() et al
Message-ID: <20090616142214.GB18444@wotan.suse.de>
References: <20090616110051.GA4864@x200.localdomain> <20090616130833.GA27925@wotan.suse.de> <20090616131454.GA6168@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616131454.GA6168@x200.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 05:14:54PM +0400, Alexey Dobriyan wrote:
> On Tue, Jun 16, 2009 at 03:08:33PM +0200, Nick Piggin wrote:
> > Thanks. Is it rebooted? It would be interesting to know what other
> > CPUs are doing (and even what other tasks are doing) if it is
> > still up.
> 
> It was rebooted, sorry.

Thanks. It is hard to know where it is looping, but I see a put_page
in there which seems to suggest it reached at least the "Has the page
moved" test. But if the stack trace is 100% accurate, then it seems
like it has hit the "Has the page been truncated" part of find_lock_page.

And it is an ext2 dir page. And these pages should not get truncated
unless rmdir. But we can't be in rmdir I think because we are doing a
mkdir.

It would seem like the page is still in the pagecache, but ->mapping
is wrong. But actually that is strange because we should have a
new inode here, so find_get_page should not even find a page in
find_or_create_page. There should be no way for a racing thread to
add a page there either.

I would almost have to suspect hardware or software error causing
random memory scribble. I would definitely be very interested if
you can reproduce (I suspect it won't be reproducable though).

Thanks,
Nick

