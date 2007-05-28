Return-Path: <linux-kernel-owner+w=401wt.eu-S1760934AbXE1Ey3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760934AbXE1Ey3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 00:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbXE1EyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 00:54:22 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:24017 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753307AbXE1EyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 00:54:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=JwtQdyowrUElixhsGkd6kn7YZxp1T+diPAxKkNUfdGpgL0rnkTi4XZ04TDMc+eEx6inHFgnAhKHY95aQWh0i7f1fM020jdkID6iQNNEbfm2kclkdhb4epQnRew+IyNTiyl2FEXvEACT+fcSkPXC6ifjEoPjp4m4ljtGmCmXpkO8=  ;
X-YMail-OSG: QrgD0z4VM1n6PDNPi9nK0zjUFtKabGXO4ZbdTV1_MJbs2NDopIXiaV6zIA7YZe5dX1e_2Ayymg--
Message-ID: <465A6078.6010804@yahoo.com.au>
Date: Mon, 28 May 2007 14:54:16 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Preserve the dirty bit in init_page_buffers
References: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com>	<465A55E7.50904@yahoo.com.au> <m18xb9a7sy.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m18xb9a7sy.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> 
> 
>>Eric W. Biederman wrote:
>>
>>>The problem:  When we are trying to free buffers try_to_free_buffers
>>>will look at ramdisk pages with clean buffer heads and remove the
>>>dirty bit from the page.  Resulting in ramdisk pages with data that
>>>get removed from the page cache.  Ouch!
>>>
>>>Buffer heads appear on ramdisk pages when a filesystem calls getblk,
>>>which through a series of function calls eventually calls
>>>init_page_buffers.
>>>
>>>So to fix the mismatch between buffer head state and page state this
>>>patch modifies init_page_buffers to transfer the dirty bit from the
>>>page to the buffer heads like we currently do for the uptodate bit.
>>
>>Ouch indeed!
>>
>>But can we ever have a dirty page at init_page_buffers-time?
> 
> 
> Definitely, and it was a royal pain to trace the bug that this
> caused.  An initial ramdisk having pieces disappear after mkfs
> is called can look like the entire machine is dying.
> 
> When we initialize the ramdisk by writing to /dev/ram0 usually in
> init/do_mounts_rd.c we don't allocate buffer heads but we do set
> the dirty bit, and the page is in the page cache.  So when we
> later call getblk it reuses the same page and then calls
> init_page_buffers.

Hmm, so this would be a problem for block_dev.c as well, then?
Because it would be possible to have a dirty block dev page
have its buffers reclaimed and then reinitialised via
init_page_buffers, AFAIKS.


>>I would have thought we can fix this simply by removing the
>>broken ramdisk_set_page_dirty (as far as the comment goes, we
>>set CAP_NO_ACCT_DIRTY anyway, so the normal set_page_dirty
>>should handle everything properly, no?).
> 
> 
> No.  I don't know where accounting comes into play.  I didn't
> trace that path.  But if we have a non-dirty ramdisk page with
> buffers (basically a hole in the middle or at the end of the ramdisk).
> We need to set the buffer dirty bits when we write to it.

Accounting is done in set_page_dirty.

> 
> So I don't see how it would make sense to reuse the generic
> set_page_dirty, and handling all of the logic in set_page_dirty
> to dirty the buffer heads seemed to have made the most sense.

That's what the generic set_page_dirty does. What I want to know
is why *doesn't* it make sense to reuse the generic set_page_dirty?
Unless there is a good reason, then reusing is better than writing
your own.

-- 
SUSE Labs, Novell Inc.
