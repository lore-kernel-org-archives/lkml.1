Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbXEPNmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbXEPNmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbXEPNlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:41:53 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:48540 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754348AbXEPNlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:41:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=JIf/AmPomXJPAcBVA6cOCr1bqnXoklXt43ggpjPGGYxbkNbpdcbGmfQzomJE3PusAOad6nZ/Krl8tI1YWoltNuf6dZ3W2nRT8mpEZJ1EYX7aiVl6auEr1xCLVA0sKb9KJ2TsHEGmn3BF1BsHN4CLWxBMtd72X9tvxSeqWU5/Kwo=  ;
X-YMail-OSG: NSvtU9wVM1kzoUMlFImhbEvSHk3an1FdnHMdd4Qol1WWMZhhh9pggnzP9W_wiPiz9rVqnSrfSA--
Message-ID: <464B0A1B.4000209@yahoo.com.au>
Date: Wed, 16 May 2007 23:41:47 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1 of 2] block_page_mkwrite() Implementation V2
References: <464AF224.30105@yahoo.com.au> <20070318233008.GA32597093@melbourne.sgi.com> <18993.1179310769@redhat.com> <17244.1179321647@redhat.com>
In-Reply-To: <17244.1179321647@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>Dave is using prepare_write here to ensure blocks are allocated in the
>>given range. The filesystem's ->nopage function must ensure it is uptodate
>>before allowing it to be mapped.
> 
> 
> Which is fine... assuming it's called.  For blockdev-based filesystems, this
> is probably true.  But I'm not sure you can guarantee it.
> 
> I've seen Ext3, for example, unlocking a page that isn't yet uptodate.
> nopage() won't get called on it again, but prepare_write() might.  I don't
> know why this happens, but it's something I've fallen over in doing
> CacheFiles.  When reading, readpage() is just called on it again and again
> until it is up to date.  When writing, prepare_write() is called correctly.

There are bugs in the core VM and block filesystem code where !uptodate pages
are left in pagetables. Some of these are fixed in -mm.

But they aren't a good reason to invent completely different ways to do things.


>>Consider that the code currently works OK today _without_ page_mkwrite.
>>page_mkwrite is being added to do block allocation / reservation.
> 
> 
> Which doesn't prove anything.  All it means is that PG_uptodate being unset is
> handled elsewhere.

It means that Dave's page_mkwrite function will do the block allocation
and everything else continues as it is. Your suggested change to pass in
offset == to is just completely wrong for this.

PG_uptodate being unset should be done via pagecache invalidation or truncation
APIs, which (sometimes... modulo bugs) tear down pagetables first.

-- 
SUSE Labs, Novell Inc.
