Return-Path: <linux-kernel-owner+w=401wt.eu-S933463AbXCENDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463AbXCENDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933461AbXCENDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:03:43 -0500
Received: from lazybastard.de ([212.112.238.170]:53693 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933460AbXCENDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:03:41 -0500
Date: Mon, 5 Mar 2007 12:41:09 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ulrich Drepper <drepper@redhat.com>, Anton Altaparmakov <aia21@cam.ac.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
       alex@clusterfs.com, suzuki@in.ibm.com
Subject: Re: [RFC] Heads up on sys_fallocate()
Message-ID: <20070305114109.GA454@lazybastard.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <45EB4A55.3060908@redhat.com> <20070305001621.GB18691@lazybastard.org> <200703050136.37181.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200703050136.37181.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 March 2007 01:36:36 +0100, Arnd Bergmann wrote:
> 
> Using the current glibc implementation on a compressed file system ideally
> should be a very expensive no-op because you won't actually allocate much
> space for a file when writing zeroes to it. You also don't benefit of a
> contiguous allocation in logfs, since flash has uniform seek times over
> all the medium.
> 
> I'd suggest you implement posix_fallocate as an real nop and just return
> success without doing anything. You could also return ENOSPC in case
> the blocks requested by posix_fallocate don't fit on the medium without
> compression, but that is more or less just guesswork (like statfs is).

Quoting POSIX_FALLOCATE(3):
       The function posix_fallocate() ensures that disk space is allocated for
       the file referred to by the descriptor fd for the bytes  in  the range
       starting  at  offset  and continuing for len bytes.  After a successful
       call to posix_fallocate(), subsequent writes to bytes in the specified
       range are guaranteed not to fail because of lack of disk space.

       If  the  size  of  the  file  is less than offset+len, then the file is
       increased to this size; otherwise the file size is left unchanged.

Afaics, the (main) purpose of this function is not to decrease
fragmentation but to ensure mmap() won't cause any problems because the
medium fills up.  That problem exists for LogFS as well, once rw mmap()
is supported.

Simply returning success without doing anything would be a bug.  -ENOSPC
is a better choice, but still a lame implementation.  And falling back
on libc to write zeroes in a loop is an exercise in futility.

Does the allocation have to be persistent beyond lifetime of the file
descriptor?  It would be fairly simple to support the write guarantee
while the file is open (or rather the inode remains cached) and drop it
afterwards.

Jörn

-- 
"[One] doesn't need to know [...] how to cause a headache in order
to take an aspirin."
-- Scott Culp, Manager of the Microsoft Security Response Center, 2001
