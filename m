Return-Path: <linux-kernel-owner+w=401wt.eu-S1762421AbZDINeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762421AbZDINeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760529AbZDINeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:34:06 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:25068 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034AbZDINeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:34:05 -0400
Subject: Re: [PATCH] [13/16] POISON: The high level memory error handler in
 the VM II
From: Chris Mason <chris.mason@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: hugh@veritas.com, npiggin@suse.de, riel@redhat.com,
       lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
In-Reply-To: <20090409075805.GG14687@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org>
	 <20090407151010.E72A91D0471@basil.firstfloor.org>
	 <1239210239.28688.15.camel@think.oraclecorp.com>
	 <20090409072949.GF14687@one.firstfloor.org>
	 <20090409075805.GG14687@one.firstfloor.org>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 09:30:29 -0400
Message-Id: <1239283829.23150.34.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49DDF87B.01BD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-09 at 09:58 +0200, Andi Kleen wrote:
> Double checked the try_to_release_page logic. My assumption was that the 
> writeback case could never trigger, because during write back the page
> should be locked and so it's excluded with the earlier lock_page_nosync().
> 
> Is that a correct assumption?

Yes, the page won't become writeback when you're holding the page lock.
But, the FS usually thinks of try_to_releasepage as a polite request.
It might fail internally for a bunch of reasons.

To make things even more fun, the page won't become writeback magically,
but ext3 and reiser maintain lists of buffer heads for data=ordered, and
they do the data=ordered IO on the buffer heads directly.  writepage is
never called and the page lock is never taken, but the buffer heads go
to disk.  I don't think any of the other filesystems do it this way.

At least for Ext3 (and reiser3), try_to_releasepage is required to fail
for some data=ordered corner cases, and the only way it'll end up
passing is if you commit the transaction (which writes the buffer_head)
and try again.  Even invalidatepage will just end up setting
page->mapping to null but leaving the page around for ext3 to finish
processing.

If we really want the page gone, we'll have to tell the FS
drop-this-or-else....sorry, its some ugly stuff.

The good news is, it is pretty rare.  I wouldn't hold up the whole patch
set just for this problem.  We could document the future fun required
and fix the return value check and concentrate on something other than
this ugly corner ;)

-chris


