Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbYKFBTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbYKFBTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 20:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbYKFBTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 20:19:38 -0500
Received: from smtp-out.google.com ([216.239.33.17]:16371 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbYKFBTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 20:19:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding;
	b=mG/BZrxg4rMAVU1xC4LERBi/vIALqkCF0Z4IfWhU8Rv7aNM/YpAKcsHYAeAQfudJs
	qQ/20pXsq2DRJlCoPBK1Q==
MIME-Version: 1.0
In-Reply-To: <20081102224513.GH19509@disturbed>
References: <1786ab030810311354h1a7c8fb0q1267969d432f521c@mail.gmail.com>
	 <20081102224513.GH19509@disturbed>
Date: Wed, 5 Nov 2008 17:19:20 -0800
Message-ID: <1786ab030811051719w63ada9c8ldf75f15367adbb8b@mail.gmail.com>
Subject: Re: Metadata in sys_sync_file_range and fadvise(DONTNEED)
From: Chad Talbott <ctalbott@google.com>
To: Chad Talbott <ctalbott@google.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@google.com>, Michael Rubin <mrubin@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 2, 2008 at 2:45 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Oct 31, 2008 at 01:54:14PM -0700, Chad Talbott wrote:
>> We are looking at adding calls to posix_fadvise(DONTNEED) to various
>> data logging routines.  This has two benefits:
>>
>>   - frequent write-out -> shorter queues give lower latency, also disk
>>     is more utilized as writeout begins immediately
>>
>>   - less useless stuff in page cache
>>
>> One problem with fadvise() (and ext2, at least) is that associated
>> metadata isn't scheduled with the data. So, for a large log file with
>> a high append rate, hundreds of indirect blocks are left to be written
>> out by periodic writeback.  This metadata consists of single blocks
>> spaced by 4MB, leading to spikes of very inefficient disk utilization,
>> deep queues and high latency.
>
> Sounds like a filesystem bug to me, not a problem with
> posix_fadvise(DONTNEED).

Agreed that the right fix is not to hack fadvise().  If the boundary
page mechanism can't be made to work, It looks like right thing might
be to modify ext2_writepages to opportunistically write dirty metadata
in holes between dirty data.  For post-ext2 filesystems which attempt
to provide transactional semantics, this is probably not acceptable.

>> Andrew suggests a new SYNC_FILE_RANGE_METADATA flag for
>> sys_sync_file_range(), and leaving posix_fadvise() alone.
>
> What is the interface that a filesystem will see? No filesystem has
> a "metadata sync" method - is this going to fall through to some new
> convoluted combination of writeback flags to an inode/mapping
> that more filesystems than not can get wrong?

Good point, coupled with metadata/data ordering and your argument
below, a decent argument against exposing this interface.

> FWIW, sys_sync_file_range() is fundamentally broken for data
> integrity writeback - at no time does it call a filesystem method
> that can result in a barrier I/O being issued to disk after
> writeback is complete. So, unlike fsync() or fdatasync(), the data
> can still be lost after completion due to power failure on drives
> with volatile write caches....

Seems to be true.  I'm not currently concerned with sync_file_range
for data integrity, so I'm going to punt on this issue.

If the consensus is against exposing a "sync metadata" interface, I'm
fine with ext2 silently updating metadata alongside neighboring data
in *either* posix_fadvise() or sync_file_range.   Either way, does it
seem reasonable for posix_fadvise(DONTNEED) to call
__filemap_fdatawrite_range to do its work?  This is the same path that
sync_file_range uses.  I prefer this to the current behavior of
ignoring the passed range and initiating writeback on the entire file.

Chad
