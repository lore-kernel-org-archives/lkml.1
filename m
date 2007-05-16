Return-Path: <linux-kernel-owner+w=401wt.eu-S1761690AbXEPQcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761690AbXEPQcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbXEPQcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:32:16 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:40828 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754559AbXEPQcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:32:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=MKT0D9p6uNlaCh1JnDnUDEUBiyEA1AKguN59QMzt3XMO0TATI7x/QBIheNoK6vKsJn901qaHrMHTmGVByUFBYwQ6Q6YojTClVN071Q31AXf0ZzDul7yjkDx0rzNA1KFL0VyU7HLyTe86L1Go3mhqUm2DP6IKX0f9QlNzA8uTeUk=  ;
X-YMail-OSG: bmB3iw0VM1kzji_cJiTVkxzDAQpv.gvsQBzjjZF5zHlppjS9Sd.j3n3lpQZU9Nxwz3EjyCr43A--
Message-ID: <464B3209.4010003@yahoo.com.au>
Date: Thu, 17 May 2007 02:32:09 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement shared-writable mmap [try #2]
References: <464B07EC.4050308@yahoo.com.au> <464AF3F3.30204@yahoo.com.au> <20070516100225.18685.51699.stgit@warthog.cambridge.redhat.com> <17173.1179321391@redhat.com> <19714.1179331928@redhat.com>
In-Reply-To: <19714.1179331928@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>In general (modulo bugs and crazy filesystems), you're not allowed to have
>>!uptodate pages mapped into user addresses because that implies the user
>>would be allowed to see garbage.
> 
> 
> Ths situation I have to deal with is a tricky one.  Consider:
> 
>  (1) User A modifies a page with his key.  This change gets made in the
>      pagecache, but is not written back immediately.
> 
>  (2) User B then wants to modify the same page, but with a different key.
>      This means that afs_prepare_write() has to flush A's writes back to the
>      server before B is permitted to write.
> 
>  (3) The flush fails because A is no longer permitted to write to that file.
>      This means that the change in the page cache is now stale.  We can't just
>      write it back as B because B didn't make the change.
> 
> What I've made afs_prepare_write() do in this situation is to nuke A's entire
> write.  We can't write any of it back.  I can't call invalidate_inode_pages()
> or similar because that might incorrectly kill one of B's writes (or someone
> else's writes); besides, the on-server file hasn't changed.

Why would that kill anyone's writes?


> To nuke A's write, each page that makes up that write is marked non-uptodate
> and then reloaded.  Whilst I might wish to call invalidate_inode_pages_range(),
> I can't as it can/would deadlock if called from prepare_write() in two
> different ways.

Which ways? Are you talking about prepare_write being called from page_mkwrite,
or anywhere?

More generally it sounds like a nasty thing to have a writeback cache if it can
become incoherent (due to dirty pages that subsequently cannot be written
back) without notification. Have you tried doing a write-through one?

You may be clearing PG_uptodate, but isn't there still an underlying problem
that you can have mappings to the page at that point? If that isn't a problem
for you, then I don't know why you would have to clear PG_uptodate at all.


>>>>Minor issue: you can just check for `if (!page->mapping)` for truncation,
>>>>which is the usual signal to tell the reader you're checking for truncate.
>>>
>>>
>>>That's inconsistent with other core code, truncate_complete_page() for
>>>example.
>>
>>Your filesystem internally moves pages between mappings like tmpfs?
> 
> 
> You misunderstand me.  truncate_complete_page() uses this:
> 
> 	if (page->mapping != mapping)
> 
> not this:
> 
> 	if (!page->mapping)
> 
> I think that both cases should work in page_mkwrite().  But !page->mapping does
> not appear to be the "usual signal" from what I've seen.

truncate_complete_page does that because it has to handle the case where
the mapping changes from one thing to something else that is non-NULL,
which tmpfs does.

This is not the case for most code in fs.

-- 
SUSE Labs, Novell Inc.
