Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbZCMOJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbZCMOJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 10:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbZCMOIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 10:08:55 -0400
Received: from esentire.com ([64.7.150.32]:64138 "EHLO eSentire.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbZCMOIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 10:08:54 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Mar 2009 10:08:54 EDT
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Transfer-Encoding: 7bit
Message-Id: <30C3FDF7-8830-4220-A207-A7C8417427D8@esentire.com>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
To: linux-kernel@vger.kernel.org
From: Andrew Malton <andrew.malton@esentire.com>
Subject: mixed protection flags for mmap() ?
Date: Fri, 13 Mar 2009 10:03:40 -0400
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A) I have a driver whcih (vm)allocates some space and writes data  
from its device there: user processes (readers) mmap the region read- 
only and to get at the data more quickly than using read(). Writing  
has priority but flags are placed to warn readers where writing is  
going on.  Lke this (some details omitted):

	vma->vm_flags = VM_READ;
	remap_vmalloc_range(vma,region,0)

B) For improving synchronization between the running parts of this I  
want to add a control section, which the readers can write to in  
order to communicate what they're doing to each other and to the  
writer (which is the driver itself).   Abstractly it seems that this  
control section should be "part of" being mmaped to the device... But  
mmap() is dispatched to the driver with only one vma_area_struct, and  
I need two because the flags are different (read, and read-write).   
Logically, I want to split the vma then map the two sections  
separately (checking that sizes match) and with different flags,  
roughly like this :

	// map part1 of size size1 and part2 of size size2
	split_vma(vma->vm_mm, vma, vma->vm_start + size1, 0);

	vma->vm_flags = VM_READ|VM_WRITE;
	remap_vmalloc_range(vma,part1,0)

	vma->vm_next->vm_flags = VM_READ;
	remap_vmalloc_range(vma->vm_next,part2,0)

I can't do this because split_vma is not exported.

1) If split_vma would work at this point, I'd consider a local patch  
to export it.  But does this work? The relevant lock in the mm seems  
to be held right through the mmap callback....  but I am probably  
missing something.

2) If it doesn't work, what is the right way to achieve (B)?

A Malton
eSentire, Inc.
