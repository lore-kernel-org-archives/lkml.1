Return-Path: <linux-kernel-owner+w=401wt.eu-S934550AbZDIOrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934550AbZDIOrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934423AbZDIOq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:46:27 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:37245 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934387AbZDIOqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:46:25 -0400
Subject: Re: [PATCH] [13/16] POISON: The high level memory error handler in
 the VM II
From: Chris Mason <chris.mason@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: hugh@veritas.com, npiggin@suse.de, riel@redhat.com,
       lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
In-Reply-To: <20090409140257.GI14687@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org>
	 <20090407151010.E72A91D0471@basil.firstfloor.org>
	 <1239210239.28688.15.camel@think.oraclecorp.com>
	 <20090409072949.GF14687@one.firstfloor.org>
	 <20090409075805.GG14687@one.firstfloor.org>
	 <1239283829.23150.34.camel@think.oraclecorp.com>
	 <20090409140257.GI14687@one.firstfloor.org>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 10:37:39 -0400
Message-Id: <1239287859.23150.57.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.49DE086B.0069:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-09 at 16:02 +0200, Andi Kleen wrote:
> On Thu, Apr 09, 2009 at 09:30:29AM -0400, Chris Mason wrote:
> > > Is that a correct assumption?
> > 
> > Yes, the page won't become writeback when you're holding the page lock.
> > But, the FS usually thinks of try_to_releasepage as a polite request.
> > It might fail internally for a bunch of reasons.
> > 
> > To make things even more fun, the page won't become writeback magically,
> > but ext3 and reiser maintain lists of buffer heads for data=ordered, and
> > they do the data=ordered IO on the buffer heads directly.  writepage is
> > never called and the page lock is never taken, but the buffer heads go
> > to disk.  I don't think any of the other filesystems do it this way.
> 
> Ok, so do you think my code handles this correctly?

Even though try_to_releasepage only checks page_writeback() the lower
filesystems all bail on dirty pages or dirty buffers (see the checks
done by try_to_free_buffers).

It looks like the only way we have to clean a page and all the buffers
in it is the invalidatepage call.  But that doesn't return success or
failure, so maybe invalidatepage followed by releasepage?

I'll have to read harder next week, the FS invalidatepage may expect
truncate to be the only caller.

> 
> > If we really want the page gone, we'll have to tell the FS
> > drop-this-or-else....sorry, its some ugly stuff.
> 
> I would like to give a very strong hint at least. If it fails
> we can still ignore it, but it will likely have negative consequences later.
> 

Nod.

> > 
> > The good news is, it is pretty rare.  I wouldn't hold up the whole patch
> 
> You mean pages with Private bit are rare? Are you suggesting to just
> ignore those? How common is it to have Private pages which are not
> locked by someone else?
> 

PagePrivate is very common.  try_to_releasepage failing on a clean page
without the writeback bit set and without dirty/locked buffers will be
pretty rare.

-chris


