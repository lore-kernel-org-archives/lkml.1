Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbXCEAcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbXCEAcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 19:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbXCEAcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 19:32:31 -0500
Received: from ppsw-3.csi.cam.ac.uk ([131.111.8.133]:34221 "EHLO
	ppsw-3.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbXCEAca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 19:32:30 -0500
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <20070305001621.GB18691@lazybastard.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org> <200703032345.33137.arnd@arndb.de> <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk> <45EB4A55.3060908@redhat.com> <20070305001621.GB18691@lazybastard.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <CDA7A0DF-D744-416F-83B1-76C148B46A5F@cam.ac.uk>
Cc: Ulrich Drepper <drepper@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
       alex@clusterfs.com, suzuki@in.ibm.com
Content-Transfer-Encoding: 8BIT
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 5 Mar 2007 00:32:14 +0000
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On 5 Mar 2007, at 00:16, Jörn Engel wrote:

> On Sun, 4 March 2007 14:38:13 -0800, Ulrich Drepper wrote:
>>
>> When you do it like this, who can the kernel/filesystem  
>> *guarantee* that
>> when the data is written there actually is room on the harddrive?
>>
>> What you described seems like using truncate/ftruncate to increase  
>> the
>> file's size.  That is not at all what posix_fallocate is for.
>> posix_fallocate must make sure that the requested blocks on the  
>> disk are
>> reserved (allocated) for the file's use and that at no point in the
>> future will, say, a msync() fail because a mmap(MAP_SHARED) page has
>> been written to.
>
> That actually causes an interesting problem for compressing  
> filesystems.
> The space consumed by blocks depends on their contents and how well it
> compresses.  At the moment, the only option I see to support
> posix_fallocate for LogFS is to set an inode flag disabling  
> compression,
> then allocate the blocks.
>
> But if the file already contains large amounts of compressed data, I
> have a problem.  Disabling compression for a range within a file is  
> not
> supported, so I can only return an error.  But which one?

I don't know how your compression algorithm works but at least on  
NTFS that bit is easy: you allocate the blocks and mark them as  
allocated then the compression engine will write non-compressed data  
to those blocks.  Basically it works like this "does compression  
block X have any sparse blocks?". If the answer is "yes" the block is  
treated as compressed data and if the answer is "no" the block is  
treated as uncompressed data.  This means that if the data cannot be  
compressed (and in some cases if the data compressed is bigger than  
the data uncompressed) the data is stored non-compressed.  That is  
the most space efficient method to do things.

An alternative would be to allocate blocks and then when the data is  
written perform the compression and free any blocks you do not need  
any more because the data has shrunk sufficiently.  Depending on the  
implementation details this could potentially create horrible  
fragmentation as you would allocate a large consecutive region and  
then go and drop random blocks from that region thus making the file  
fragmented.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


