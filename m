Return-Path: <linux-kernel-owner+w=401wt.eu-S1760104AbYDAVeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104AbYDAVeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757415AbYDAVeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:34:03 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:16548 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184AbYDAVeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:34:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=C7rQOCc9DdXJ2EfJc4CHW7gTUV05MpQ6YsEoCpXkaTKkfh3xaDdubSOg/OelTX+/F95HP5b+5W+Az6zGdk+UoONLyzxi3fhBipBfdrQQp6aT6cEsJXOFO8KvCJCB9CxkxPn9qG4eY+88b/36EHTPVHSlLMVFQ2HcJeyVYhmrTv4=
Message-ID: <8bd0f97a0804011434r4869fbe8t89ade12c04c97f2@mail.gmail.com>
Date: Tue, 1 Apr 2008 17:34:00 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Howells" <dhowells@redhat.com>, "Greg Ungerer" <gerg@snapgear.com>,
       "David McCullough" <David_Mccullough@securecomputing.com>
Subject: nommu: handling anonymous mmap clearing in userspace rather than kernel
Cc: LKML <linux-kernel@vger.kernel.org>, "Bryan Wu" <Bryan.Wu@analog.com>,
       "Bernd Schmidt" <bernds_cb1@t-online.de>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the problem: doing malloc() in userspace on no-mmu systems can take up
an inordinate amount of time merely due to kernel forcing anonymously
mapped memory to zero.  this is because the only way to implement
userspace malloc() on no-mmu systems is via mmap(MAP_ANONYMOUS), and
the kernel has an explicit memset() in mm/nommu.c:do_mmap_private()
when MAP_ANONYMOUS is in the mmap flags.  however, POSIX states that
memory returned from malloc() may be uninitialized, so this zeroing is
not wanted in that case.

the desire: be able to do a mmap(MAP_ANONYMOUS) to grab a chunk of
memory without the memset() call.  this may bring up other arguments
such as information leakage between kernels/processes, but on an
embedded no-mmu system, people are very willing to sacrifice that for
the very measurable performance gain.

a workaround: introduce a new no-mmu-only mmap flag MAP_UNINITIALIZE
to signal to the kernel that it should skip the memset().  this way,
userspace malloc() can do mmap(MAP_ANONYMOUS|MAP_UNINITIALIZE) to get
large chunks of memory without affecting any other anonymous mmap()
call.

another idea: move the memset() from the kernel to the system C
library.  make the kernel memset() controllable via a
no-mmu/embedded-only Kconfig option (with the default being retained:
the memset is called).  now the C library can easily control the
zero-ing of memory as required by POSIX, and you spend less time in
kernel space.  there are many places where the kernel<->user ABI is
not POSIX compliant and instead relies on the C library to provide the
little bit of POSIX glue, so this isnt a big deal.
-mike
