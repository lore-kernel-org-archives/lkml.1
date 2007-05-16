Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbXEPR23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbXEPR23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759847AbXEPR2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:28:20 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:24940 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757358AbXEPR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:28:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=V7QWUxwyPS+J1TVUkw+F5Y9NJkuTEMrpvCyXjqEnKLs8MyLQCfqYY/3x9g1CF+h2Vzls/gX8zF3G/duDO++XwT4SFMbm3Evt93vagud6XWDTxSDFVDhF4V5Vhh39i+tj0z0+EwykbSG+S4jrUEFINm/064cA1nfI/Ri+I6h42GU=  ;
X-YMail-OSG: 3O80Uo8VM1lSlvlvy7mQtqLIGFI0.hbLQj7p40.r4byfpPMK_N2n8kYOTgfzknipRKoB.4l9sw--
Message-ID: <464B3F2D.9030603@yahoo.com.au>
Date: Thu, 17 May 2007 03:28:13 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement shared-writable mmap [try #2]
References: <464B3209.4010003@yahoo.com.au> <464B07EC.4050308@yahoo.com.au> <464AF3F3.30204@yahoo.com.au> <20070516100225.18685.51699.stgit@warthog.cambridge.redhat.com> <17173.1179321391@redhat.com> <19714.1179331928@redhat.com> <23262.1179334587@redhat.com>
In-Reply-To: <23262.1179334587@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>>I can't call invalidate_inode_pages() or similar because that might
>>>incorrectly kill one of B's writes (or someone else's writes); besides,
>>>the on-server file hasn't changed.
>>
>>Why would that kill anyone's writes?
> 
> 
> Because invalidate_inode_pages() forcibly removes the dirty flag from each page

It had better not. We use that sucker to nuke pagecache when we're trying to
reclaim inodes, for example...


>>>I can't as it can/would deadlock if called from prepare_write() in two
>>>different ways.
>>
>>Which ways? Are you talking about prepare_write being called from
>>page_mkwrite, or anywhere?
> 
> 
>  (1) prepare_write() is called with the target page locked and does not release
>      the lock.  The truncation routines lock the page prior to invalidating it.
>      Any truncation routine that skips locked pages is of no use.

You can drop the lock, do the invalidation, and return AOP_TRUNCATED_PAGE. The
new aops patches will provide a better solution, but that will work today.


>  (2) Consider a run of pages that make up a single write by one user.  Two
>      other writes from other users may be attempting to overwrite that run at
>      the same time.  Each of them would need to invalidate the other's locked
>      page(s).

See #1.


> Furthermore, the caller of prepare_write() probably won't take kindly to the
> page it's dealing with being evicted from the pagecache.

It's fine if you return AOP_TRUNCATED_PAGE.


>>More generally it sounds like a nasty thing to have a writeback cache if it
>>can become incoherent (due to dirty pages that subsequently cannot be
>>written back) without notification. Have you tried doing a write-through
>>one?
> 
> 
> How do you do a write-through cache for shared-writable mmap?

I just mean more generally. simple write(2) writes, for starters.

For shared writable mmap? I don't know... does POSIX require mmap data
to be coherent with read(2)/write(2)? ;)


>>You may be clearing PG_uptodate, but isn't there still an underlying problem
>>that you can have mappings to the page at that point? If that isn't a problem
>>for you, then I don't know why you would have to clear PG_uptodate at all.
> 
> 
> There might be, yes.  I guess I should ask the VM to nuke all PTEs to each of
> these pages too.

That's what the invalidate / truncate routines do.

-- 
SUSE Labs, Novell Inc.
