Return-Path: <linux-kernel-owner+w=401wt.eu-S2992450AbXBIR23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992450AbXBIR23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992451AbXBIR23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:28:29 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:19464 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992450AbXBIR21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:28:27 -0500
In-Reply-To: <20070209033133.GA18400@wotan.suse.de>
References: <20070208105437.26443.35653.sendpatchset@linux.site> <20070208105446.26443.35864.sendpatchset@linux.site> <20070208194953.GA4118@infradead.org> <20070209014626.GB17334@wotan.suse.de> <5c49b0ed0702081803o6d2ba99ct5703f76465c524f4@mail.gmail.com> <20070209033133.GA18400@wotan.suse.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A45C279B-2105-4FDA-9C14-E37158858176@oracle.com>
Cc: Nate Diller <nate.diller@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [patch 1/3] fs: add an iovec iterator
Date: Fri, 9 Feb 2007 12:28:06 -0500
To: Nick Piggin <npiggin@suse.de>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What I have there is not actually a full-blown file io descriptor,  
> because
> there is no file or offset. It is just an iovec iterator (so maybe  
> I should
> rename it to iov_iter, rather than iodesc).
>
> I think it might be a nice idea to keep this iov_iter as a standalone
> structure, and it could be embedded into a struct file_io?

Yeah, maybe.

I'm not sure we need something as generic as a "file_io" struct.

To recap, I've hoped for the expression of the state of an iovec  
array with a richer structure to avoid the multiple walks of the  
array at different parts of the kernel that previously only had  
access to the raw iovec * and size_t count.

Stuff like the alignment checks in __blockdev_direct_IO() and the  
pages_in_io accounting in direct_io_worker().

I imagined building up the state in this 'iodesc' structure as we  
first copied and verified the structure from userspace.  (say in  
rw_copy_check_uvector()).

If as we copied we, say, stored in the bits of the buffer and length  
fields then by the time we got to __blockdev_direct_IO() we'd just  
test the bits for misalignment instead of iterating over the array  
again.

It starts to get gross as some paths currently modify the kernel copy  
of the array as they process it :/.

- z
