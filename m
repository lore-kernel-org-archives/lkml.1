Return-Path: <linux-kernel-owner+w=401wt.eu-S934276AbXGaUgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934276AbXGaUgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765023AbXGaUgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:36:18 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48434 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759314AbXGaUgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:36:16 -0400
Subject: /proc/$pid/pagemap troubles
From: Dave Hansen <haveblue@us.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 13:36:14 -0700
Message-Id: <1185914174.18414.184.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since the pagemap code has a little header on it to help describe the
format, I wrote a little c program to parse its output.  I get some
strange results.  If I do this:

	fd = open("/proc/1/pagemap", O_RDONLY);
	count = read(fd, &endianness, 1);

count will always be 4.  

hexdump gets similar, but even worse results:
        
        qemu:~# strace hexdump -C /proc/self/pagemap 
        ...
        read(0, "\1\f\4\4\377\377\377\377\377\377\377\377\377\377\377\377"..., 16) = 20
        read(0, 0x804d39c, 4294967292)          = -1 EFAULT (Bad address)
        --- SIGSEGV (Segmentation fault) @ 0 (0) ---
        +++ killed by SIGSEGV +++

Note that the kernel returns 20 to the read request of 16.  I think the
kernel is actually copying over something important in hexdump's memory
which is adjacent to the buffer and causing it to segfault.

The code is basically organized not to output the right thing for any
unaligned access, and it apparently gets confused about exactly what
userspace has asked for.  I think this is largely due to its overwriting
of "count" in pagemap_read().

So, a couple of questions.  Don't we need to support non-sizeof(unsigned
long)-aligned reads?

Do we _really_ need that header in each and every file?

> * first byte:   0 for big endian, 1 for little

Do we ever have cases where userspace and kernel differ in their
endianness?  Or, are you hoping to dump these files raw on one
architecture and parse them on another?  I would think it makes more
sense to get this from elsewhere.  Or, should we just output in network
byte order and be done with it?

If anything, we could put it in /proc/$pid/status.

> * second byte:  page shift (eg 12 for 4096 byte pages)

This might actually (in theory) change on a per-process basis, so it
makes sense.  But, it seems more global to the process that just pagemap
output.  Would this always be the same as getpagesize()?   Or, should it
always map 1:1 with the amount of memory mapped by a kernel pte_t.  I
_think_ these can be slightly different because we have 64k PAGE_SIZE on
ppc64, but allow mappings to happen in 4k 

> * third byte:   entry size in bytes (currently either 4 or 8)

This one really boils down to "what is the kernel's sizeof(unsigned
long)" because we'll always store pfns in those.  It seems like we
should have a better way to go fetch that.

> * fourth byte:  header size

If we can get rid of the other three this, of course, goes away.

-- Dave

