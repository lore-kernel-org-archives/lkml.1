Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbXFZCmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbXFZCmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 22:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXFZCmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 22:42:33 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:22493 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752121AbXFZCmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 22:42:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=RKdC5rHj7Ixnq+k9aENG7oO0hAHixp3tZIOrQW8pGUZnENOQVCTpgzrRWcqNctB+1VkY6qvrFtkySrtCGXsb5HjPkPQRCzPZPawS9Uw0K+3cOobwVoz7KGxGLN7wkWhKjbvXxQbCLZrtON6WzjX9xRPv/m5HiNGnLSsB1l3JIqU=  ;
X-YMail-OSG: DG7RLfEVM1mdJzb3qHQ35xzZ72DlBhXpN1j1OSjAfOFGw.NP7LTf0X92iveBiQfKGKuT4f2Now--
Message-ID: <46807D13.4070703@yahoo.com.au>
Date: Tue, 26 Jun 2007 12:42:27 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/3] add the fsblock layer
References: <20070624014528.GA17609@wotan.suse.de> <20070624014613.GB17609@wotan.suse.de> <20070625131917.GD12852@think.oraclecorp.com>
In-Reply-To: <20070625131917.GD12852@think.oraclecorp.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
> On Sun, Jun 24, 2007 at 03:46:13AM +0200, Nick Piggin wrote:
> 
>>Rewrite the buffer layer.
> 
> 
> Overall, I like the basic concepts, but it is hard to track the locking
> rules.  Could you please write them up?

Yeah I will do that.

Thanks for taking a look. One thing I am thinking about is to get
rid of the unmap_underlying_metadata calls from the generic code.
I found they were required for minix to prevent corruption, however
I don't know exactly what metadata is interfering here (maybe it
is indirect blocks or something?). Anyway, I think I will make it
a requirement that the filesystem has to already handle this before
returning a newly allocated block -- they can probably do it more
efficiently and we avoid the extra work on every block allocation.


> I like the way you split out the assoc_buffers from the main fsblock
> code, but the list setup is still something of a wart.  It also provides
> poor ordering of blocks for writeback.

Yeah, I didn't know how much effort to put in here because I don't
know whether modern filesystems are going to need to implement their
own management of this stuff or not.

I haven't actually instrumented this in something like ext2 to see
how much IO comes from the assoc buffers...


> I think it makes sense to replace the assoc_buffers list head with a
> radix tree sorted by block number.  mark_buffer_dirty_inode would up the
> reference count and put it into the radix, the various flushing routines
> would walk the radix etc.
> 
> If you wanted to be able to drop the reference count once the block was
> written you could have a back pointer to the appropriate inode.

I was actually thinking about a radix-tree :) One annoyance is that
unsigned long != sector_t :P rbtree would probably be OK.

-- 
SUSE Labs, Novell Inc.
