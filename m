Return-Path: <linux-kernel-owner+w=401wt.eu-S933617AbXEPX3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbXEPX3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbXEPX3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:29:04 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35334 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757473AbXEPX3D (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:29:03 -0400
Date: Thu, 17 May 2007 09:28:50 +1000
From: David Chinner <dgc@sgi.com>
To: David Howells <dhowells@redhat.com>
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1 of 2] block_page_mkwrite() Implementation V2
Message-ID: <20070516232850.GO85884050@sgi.com>
References: <20070318233008.GA32597093@melbourne.sgi.com> <18993.1179310769@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18993.1179310769@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 11:19:29AM +0100, David Howells wrote:
> 
> However, page_mkwrite() isn't told which bit of the page is going to be
> written to.  This means it has to ask prepare_write() to make sure the whole
> page is filled in.  In other words, offset and to must be equal (in AFS I set
> them both to 0).

The assumption is the page is already up to date and we are writing
the whole page unless EOF lands inside the page. AFAICT, we can't
get called with a page that is not uptodate and so page filling is
not something we should be doing (or want to be doing) here. All we
want to do is to be able to change the mapping from a read to a
write mapping (e.g. a read mapping of a hole needs to be changed on
write) and do the relevant space reservation/allocation and buffer
mapping needed for this change.

> However, if someone adds a syscall to punch holes in files, this may change...

We already have them - ioctl(XFS_IOC_UNRESVSP) and
madvise(MADV_REMOVE) - and another - fallocate(FA_DEALLOCATE) - is
on it's way. Racing with truncates should already be handled by the
truncate code (i.e. partial page truncation does the zero filling).

/me makes note to implement ->truncate_range() in XFS for MADV_REMOVE.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
