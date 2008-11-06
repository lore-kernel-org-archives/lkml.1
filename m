Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbYKFBIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbYKFBIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 20:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYKFBHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 20:07:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752913AbYKFBHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 20:07:55 -0500
Date: Wed, 5 Nov 2008 17:07:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chad Talbott <ctalbott@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com
Subject: Re: Metadata in sys_sync_file_range and fadvise(DONTNEED)
Message-Id: <20081105170748.0e7dac89.akpm@linux-foundation.org>
In-Reply-To: <1786ab030811051656r7cc09fcakbf485c3b0663757@mail.gmail.com>
References: <1786ab030810311354h1a7c8fb0q1267969d432f521c@mail.gmail.com>
	<20081101022128.3f8a535c.akpm@linux-foundation.org>
	<1786ab030811051656r7cc09fcakbf485c3b0663757@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008 16:56:54 -0800
Chad Talbott <ctalbott@google.com> wrote:

> On Sat, Nov 1, 2008 at 1:21 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > And fadvise(FADV_DONTNEED) is just that: "I won't be using that data
> > again".  Implementing specific writeback behaviour underneath that hint
> > is unobvious and a bit weird.  It's a bit of a fluke that it does
> > writeout at all!
> >
> > We have much more flexibility with sync_file_range(), and it is more
> > explicit.
> 
> So in the new world, an application should call sync_file_range
> (solving my problem by including metadata) to initiate writeout, and
> then call posix_fadvise(DONTNEED) to drop the pages from page cache?
> I think this would work for me.

That would work.

Although Nick is threatening to make
sync_file_range(SYNC_FILE_RANGE_WRITE) all slow by using WB_SYNC_ALL,
probably unnecessarily, ho hum.

> > That being said, I don't understand why the IO scheduling problems
> > which you're seeing are occurring.  There is code in fs/mpage.c
> > specifically to handle this case (search for "write_boundary_block").
> > It will spot that 4k indirect block in the middle of two 4MB data
> > blocks and will schedule it for writeout at the right time.
> >
> > So why isn't that working?
> 
> Very good question, I'll look into why it's not helping here.
> 

Thanks.
