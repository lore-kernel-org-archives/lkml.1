Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbXEPNco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbXEPNco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbXEPNcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:32:36 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:22586 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753569AbXEPNcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:32:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=k5j6oZ2BBboLZok28BMNm3EuYdWRR8b2wmjoZq4FKeM7tUhlm3bT8Hmx8Wg0KeemSBujUEJlXs28HGZ04Ku3INjj2lgJR3Nm9TBxn1Gmue8SOVjDtv3BbBEGClavukRy0Q4O8qqjZhZqXqw+GRiHDWGRgVYxdhnVaDKBPKURG7g=  ;
X-YMail-OSG: 3_rIc.MVM1nHRezniKlhhZQ_g_mpBrZizH2gtvwK5XgzFM3d
Message-ID: <464B07EC.4050308@yahoo.com.au>
Date: Wed, 16 May 2007 23:32:28 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement shared-writable mmap [try #2]
References: <464AF3F3.30204@yahoo.com.au> <20070516100225.18685.51699.stgit@warthog.cambridge.redhat.com> <17173.1179321391@redhat.com>
In-Reply-To: <17173.1179321391@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>I would strongly suggest you used (0, PAGE_CACHE_SIZE) for the range,
> 
> 
> That tells prepare_write() that the region to be modified is the whole page -
> which is incorrect.  We're going to change a little bit of it.

You don't know how much you're going to change, but it could be anything
in the range of 0 to PAGE_CACHE_SIZE. Clearly a (0, PAGE_CACHE_SIZE)
range is the right range to pass in.


> Hmmm... Thinking about it again, I probably shouldn't be using
> afs_prepare_write() at all.  afs_prepare_write() does two things:
> 
>  (1) Fills in the bits around the edges of the region to be modified if the
>      page is not up to date.
> 
>  (2) Records the region of the page to be modified.
> 
> If afs_prepare_write() function is invoked by write(), then the region in (2)
> is known, and thus the edges are known.
> 
> But if it's called from page_mkwrite(), we don't know where the edges are, so
> we have to refresh the entire page if it's not up to date, and then we have to
> record that the entire page needs writing back as we don't know which bits
> have changed.

Oh god you're doing ClearPageUptodate directly on pagecache pages?

In general (modulo bugs and crazy filesystems), you're not allowed to have
!uptodate pages mapped into user addresses because that implies the user
would be allowed to see garbage.

If you follow that rule, then you can never have a !uptodate page be passed
into page_mkwrite (unless it has just been truncated, in which case you
catch that case anyway).


>>and have your nopage function DTRT.
> 
> 
> That assumes nopage() will be called in all cases - which it won't.

No, just assumes that nopage brings the page uptodate and people use the
correct invalidation functions to invalidate pagecache, so you never have
!uptodate pages that are mapped.


>>Rather than add this (not always correct) comment about the VM workings, I'd
>>just add a directive in the page_mkwrite API documentation that the filesystem
>>is to return 0 if the page has been truncated.
> 
> 
> I still want to put a comment in my code to say *why* I'm doing this.

The one you put there was wrong.


>>Minor issue: you can just check for `if (!page->mapping)` for truncation,
>>which is the usual signal to tell the reader you're checking for truncate.
> 
> 
> That's inconsistent with other core code, truncate_complete_page() for
> example.

Your filesystem internally moves pages between mappings like tmpfs?


>>Then you can remove the comment...
> 
> 
> The comment stays, though I'm willing to improve it.

Well I don't really care, so I'll just concentrate on trying to get the
code fixed.

-- 
SUSE Labs, Novell Inc.
