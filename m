Return-Path: <linux-kernel-owner+w=401wt.eu-S966395AbXFHGfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966395AbXFHGfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 02:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759733AbXFHGfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 02:35:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:58426 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264AbXFHGfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 02:35:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=KX4czDQddevID3b4RDWHH059BXpdtVsmyXS4JX9Z9KUDm5RBidM42mJYkoN5Mdw4eUlbzj+JeRqOvwP/bJJal5qVkNkO8Yc2rrYmYbSDMKFv3XsJWFFcbfX1J6IM7U3pUOTbkp7sHygK5GORn7/xnx6pFfXjJ9Hj5mU/ELLVbpE=
Message-ID: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
Date: Fri, 8 Jun 2007 02:35:22 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: JIT emulator needs
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, Linux isn't all that friendly to JIT emulators.
Here are the problems and suggestions to improve the situation.

There is an SE Linux execmem restriction that enforces W^X.
Assuming you don't wish to just disable SE Linux, there are
two ugly ways around the problem. You can mmap a file twice,
or you can abuse SysV shared memory. The mmap method requires
that you know of a filesystem mounted rw,exec where you can
write a very large temporary file. This arbitrary filesystem,
rather than swap space, will be the backing store. The SysV
shared memory method requires an undocumented flag and is
subject to some annoying size limits. Both methods create
objects that will fail to be deleted if the program dies
before marking the objects for deletion.

Processors often have annoying limits on the immediate values
in instructions. An x86 or x86_64 JIT can go a bit faster if
all allocations are kept to the low 2 GB of address space.
There are also reasons for a 32bit-to-x86_64 JIT to chose
a nearly arbitrary 2 GB region that lies above 4 GB.
Other archs have other limits, such as 32 MB or 256 MB.

Sometimes it is very helpful to have the read/write mapping
be a fixed offset from the read/exec mapping. A power of 2
can be especially desirable.

Emulators often need a cheap way to change page permissions.
One VMA per page is no good. Besides taking up space and making
many things generally slower, having one VMA per page causes
a huge performance loss for snapshot roll-back operations.
Just tearing down all those VMAs takes a good while.

Additions to better support JIT emulators:

a. sysctl to set IPC_RMID by default
b. shmget() flag to set IPC_RMID by default
c. open() flag to unlink a file before returning the fd
d. mremap() flag to always keep the old mapping
e. mremap() flag to get a read/write mapping of a read/exec one
f. mremap() flag to get a read/exec mapping of a read/write one
g. mremap() flag to make the 5th arg (new addr) be the upper limit
h. 6-bit wide mremap() "flag" to set the upper limit above given base
i. support the prot argument to remap_file_pages
j. a documented way (madvise?) to punch same-VMA zero-page holes
