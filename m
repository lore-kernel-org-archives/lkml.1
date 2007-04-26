Return-Path: <linux-kernel-owner+w=401wt.eu-S1031284AbXDZPim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031284AbXDZPim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031287AbXDZPim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:38:42 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:25298 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031284AbXDZPil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:38:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=WHL1fwWPdtWNsVRxiqWuL5hG+2smWJpB2YngG2emj8QBiuy8PlrBO0NhHV9wZ2cuVZKKppkzXT85VwY8MummiFiiTcudMmMDEKzLje6ujMEWDkdfwPjp//KeCyyzbvKifLiXp/3k9hn+OT4BDgi8o8hY/GjUQo4GTXjETqXWoUs=  ;
X-YMail-OSG: dZmf1JsVM1nnFq7Psouep1TzRhVTbDRNOrmOd_AiBano4cwsuVF2rdLiNudKHUU7PK49IofesQ--
Message-ID: <4630C776.9000804@yahoo.com.au>
Date: Fri, 27 Apr 2007 01:38:30 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com> <m1k5vzmoo7.fsf@ebiederm.dsl.xmission.com> <20070426135033.GU65285596@melbourne.sgi.com>
In-Reply-To: <20070426135033.GU65285596@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Thu, Apr 26, 2007 at 04:10:32AM -0600, Eric W. Biederman wrote:
>>Ok.  Now why are high end hardware manufacturers building crippled
>>hardware?  Or is there only an 8bit field in SCSI for describing
>>scatter gather entries?  Although I would think this would be
>>move of a controller ranter than a drive issue.
> 
> 
> scsi.h:
> 
> /*
>  *      The maximum sg list length SCSI can cope with
>  *      (currently must be a power of 2 between 32 and 256)
>  */
> #define SCSI_MAX_PHYS_SEGMENTS  MAX_PHYS_SEGMENTS
> 
> And from blkdev.h:
> 
> #define MAX_PHYS_SEGMENTS 128
> #define MAX_HW_SEGMENTS 128
> 
> So currentlt on SCSI we are limited to 128 s/g entries, and the
> maximum is 256.  So I'd say we've got good grounds for needing
> contiguous pages to go beyond 1MB I/O size on x86_64.

Or good grounds to increase the sg limit and push for io controller
manufacturers to do the same. If we have a hack in the kernel that
mostly works, they won't.

Page colouring was always rejected, and lots of people who knew
better got upset because it was the only way the hardware would go
fast...


>>>And what do we do for arches that can't do multiple page sizes, only
>>>only have a limited and mostly useless set of page sizes to choose
>>>from?
>>
>>You have HW_PAGE_SIZE != PAGE_SIZE.
> 
> 
> That's rather wasteful, though. Better to only use the large pages
> when the filesystem needs them rather than penalise all filesystems.

But 16k pages are fine for ia64. While you're talking about special
casing stuff, surely a bigger page size could be the config option
instead of higher order pagecache.


>>That is you hide the fact from
>>the bulk of the kernel struct page manges 2 or more real hardware pages.
>>But you expose it to the handful of places that actually care.
>>Partly this is a path you are starting down in your patches, with
>>larger page cache support.
> 
> 
> Right, exactly. So apart from the contiguous allocation issue, you think
> we are doing the right thing?

You could put it that way. Or that it is wrong because of the
fragmenatation problem. Realise that it is somewhat fundamental
considering that it is basically an unsolvable problem with our
current kernel assumptions of unconstrained kernel allocations and
a 1:1 kernel mapping.

-- 
SUSE Labs, Novell Inc.
