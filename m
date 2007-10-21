Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbXJUEyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbXJUEyf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 00:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXJUEyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 00:54:15 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60945 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbXJUEyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 00:54:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: Re: [RFC][PATCH] block: Isolate the buffer cache in it's own mappings.
References: <200710151028.34407.borntraeger@de.ibm.com>
	<20071017213216.b2d0c4bd.akpm@linux-foundation.org>
	<m11wbqg5he.fsf@ebiederm.dsl.xmission.com>
	<200710211424.46650.nickpiggin@yahoo.com.au>
Date: Sat, 20 Oct 2007 22:53:16 -0600
In-Reply-To: <200710211424.46650.nickpiggin@yahoo.com.au> (Nick Piggin's
	message of "Sun, 21 Oct 2007 14:24:46 +1000")
Message-ID: <m16411dq6b.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> On Saturday 20 October 2007 07:27, Eric W. Biederman wrote:
>> Andrew Morton <akpm@linux-foundation.org> writes:
>> > I don't think we little angels want to tread here.  There are so many
>> > weirdo things out there which will break if we bust the coherence between
>> > the fs and /dev/hda1.
>>
>> We broke coherence between the fs and /dev/hda1 when we introduced
>> the page cache years ago,
>
> Not for metadata. And I wouldn't expect many filesystem analysis
> tools to care about data.

Well tools like dump certainly weren't happy when we made the change.

>> and weird hacky cases like 
>> unmap_underlying_metadata don't change that.
>
> unmap_underlying_metadata isn't about raw block device access at
> all, though (if you write to the filesystem via the blockdevice
> when it isn't expecting it, it's going to blow up regardless).

Well my goal with separating things is so that we could decouple two
pieces of code that have different usage scenarios, and where
supporting both scenarios simultaneously appears to me to needlessly
complicate the code.

Added to that we could then tune the two pieces of code for their
different users.

>> Currently only 
>> metadata is more or less in sync with the contents of /dev/hda1.
>
> It either is or it isn't, right? And it is, isn't it? (at least
> for the common filesystems).

ext2 doesn't store directories in the buffer cache.

Journaling filesystems and filesystems that do ordered writes
game the buffer cache.  Putting in data that should not yet
be written to disk.  That gaming is where reiserfs goes BUG
and where JBD moves the dirty bit to a different dirty bit.

So as far as I can tell what is in the buffer cache is not really
in sync with what should be on disk at any given movement except
when everything is clean.

My suspicion is that actually reading from disk is likely to
give a more coherent view of things.  Because there at least
we have the writes as they are expected to be seen by fsck
to recover the data, and a snapshot there should at least
be recoverable.  Whereas a snapshot provides not such guarantees.

Eric
