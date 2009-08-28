Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbZH1QlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbZH1QlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 12:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbZH1QlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 12:41:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57002 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbZH1QlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 12:41:06 -0400
Date: Fri, 28 Aug 2009 12:41:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jamie Lokier <jamie@shareable.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
Message-ID: <20090828164106.GA9951@infradead.org>
References: <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org> <20090824023422.GA775@infradead.org> <20090827143459.GB31453@shareable.org> <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com> <20090828154647.GA15808@infradead.org> <4A98008B.6050503@redhat.com> <20090828161745.GA8755@infradead.org> <4A9806D9.5050409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9806D9.5050409@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 09:33:29AM -0700, Ulrich Drepper wrote:
> On 08/28/2009 09:17 AM, Christoph Hellwig wrote:
>> I'll put it on my todo list.
>
> Any ABI change like this takes a long time to trickle down.
>
> If this is agreed to be the correct approach then adding the O_*  
> definitions earlier is better.  Even if it isn't yet implemented.  Then,  
> once the kernel side is implemented, programs are ready to use it.  I  
> cannot jump the gun and define the flags myself first.

Yeah.  The implementation really is trivial in 2.6.32 - we basically
just need to change one function to check the new O_REALLY_SYNC flag
and pass down a 0 instead of a 1 to another routine in the generic
fs code, plus doing the same in a few filesystems opencoding it instead
of using the generic helpers.

So the logistics of doing the flags really is the biggest work here.
And I'm not entirely sure how to do it correctly.  Can we just switch
the current O_SYNC defintion in the kernel headers to O_DSYNC while
adding the new O_SYNC and everything will continue to work? 

>>   - O_RSYNC basically means we need to commit atime updates before a
>>     read returns, right?
>
> No, that's not it.
>
> O_RSYNC on its own just means the data is successfully transferred to  
> the calling process (always the case).
>
> O_RSYNC|O_DSYNC means that if a read request hits data that is currently  
> in a cache and not yet on the medium, then the write to medium is  
> successful before the read succeeds.

That includes a write from another process?  So O_RSYNC basically means
doing an range-fdatasync before the actual read request?

Again, we could implement this easily if we care enough.

