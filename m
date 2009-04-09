Return-Path: <linux-kernel-owner+w=401wt.eu-S933273AbZDIOA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbZDIOA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932111AbZDIOAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:00:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33687 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762152AbZDIOAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:00:41 -0400
Date: Thu, 9 Apr 2009 16:02:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, hugh@veritas.com, npiggin@suse.de,
       riel@redhat.com, lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [13/16] POISON: The high level memory error handler in the VM II
Message-ID: <20090409140257.GI14687@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org> <20090407151010.E72A91D0471@basil.firstfloor.org> <1239210239.28688.15.camel@think.oraclecorp.com> <20090409072949.GF14687@one.firstfloor.org> <20090409075805.GG14687@one.firstfloor.org> <1239283829.23150.34.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239283829.23150.34.camel@think.oraclecorp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 09:30:29AM -0400, Chris Mason wrote:
> > Is that a correct assumption?
> 
> Yes, the page won't become writeback when you're holding the page lock.
> But, the FS usually thinks of try_to_releasepage as a polite request.
> It might fail internally for a bunch of reasons.
> 
> To make things even more fun, the page won't become writeback magically,
> but ext3 and reiser maintain lists of buffer heads for data=ordered, and
> they do the data=ordered IO on the buffer heads directly.  writepage is
> never called and the page lock is never taken, but the buffer heads go
> to disk.  I don't think any of the other filesystems do it this way.

Ok, so do you think my code handles this correctly?

> If we really want the page gone, we'll have to tell the FS
> drop-this-or-else....sorry, its some ugly stuff.

I would like to give a very strong hint at least. If it fails
we can still ignore it, but it will likely have negative consequences later.

> 
> The good news is, it is pretty rare.  I wouldn't hold up the whole patch

You mean pages with Private bit are rare? Are you suggesting to just
ignore those? How common is it to have Private pages which are not
locked by someone else?

I keep thinking about doing some instrumentation and figure out
how common the various page types are under different loads, but haven't written 
that bit so far.

> set just for this problem.  We could document the future fun required
> and fix the return value check 

I fixed the return value check. Thanks.

> and concentrate on something other than
> this ugly corner ;)

Any suggestions welcome.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
