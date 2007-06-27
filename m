Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbXF0Coc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbXF0Coc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 22:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbXF0CoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 22:44:21 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3552 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758218AbXF0CoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 22:44:20 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 26 Jun 2007 19:44:18 -0700
Subject: [patch 0/3] MAP_NOZERO - VM_NOZERO/MAP_NOZERO early summer madness
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.29496.1182912258.0>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was using oprofile to sample some userspace code I am working on,
and I was continuosly noticing  clear_page  in the top three entries
of the oprofile logs.
Also, a simple kernel build, in my Dual Opteron with 8GB of RAM,
shows  clear_page  as the first kernel entry, second only to the
userspace the  cc1  and  as.
Most of the userspace code uses malloc() (and anonymous mappings) in
such a way that the memory returned via kernel->glibc is immediately
written soon after. The POSIX malloc() definition itself also, does
not require the returned memory to be zeroed (as calloc() does).
So I implemented a rather quick hack that introduces a new mmap() flag
MAP_NOZERO (only valid for anonymous mappings) and the  vma  counter-part
VM_NOZERO. Also, a new sys_brk2() has been introduced to accept a new
flags  parameter. A brief description of the patches follows in the next
emails.
I first hacked Val's ebizzy to accept a new '-N' flag to make use of
MAP_NOZERO:

http://infohost.nmt.edu/~val/patches/ebizzy.tar.gz
http://www.xmailserver.org/ebizzy-nzmmap-0.2.diff

On my box,  ebizzy  performance jumped up from 10% to 15%.
The userspace code I am working on (uses malloc() quite heavily), saw
a performance jump of around 14%.
In both cases,  clear_page  dropped way down in the oprofile logs.
I then coded quick (and rather ugly) hacks for  glibc  and  gcc  to
make them use the new features (MAP_NOZERO and sys_brk2()):

http://www.xmailserver.org/glibc-nzmalloc-tweaks
http://www.xmailserver.org/gcc-nozero-hack

I then tried a 2.6.22-rc5 kernel build using the newly built  glibc
and  gcc  (with and w/out no-zero enabling options/env-vars), and
when using the no-zero mode,  clear_page  went way down in the oprofile
logs and build time dropped of about 2.5% to 3%.
I did not have time (and will) to tweak  as  and  ld  also.
These are some test utilities to verify the no-zero behaviour of MAP_NOZERO
(and sys_brk2()):

http://www.xmailserver.org/nzmmap-test.c
http://www.xmailserver.org/nzmalloc-test.c
http://www.xmailserver.org/smiffy.c

To run  nzmalloc-test  you need a patched glibc (using  glibc-nzmalloc-tweaks).
The  smiffy  one, should be run under a user that has no other processes
running and that owns no files on the system, and it verifies that all the
pages it gets from the kernel are zeroed (otherwise "Houston, we have a problem ...").
It is running on my system w/out barfing by more than two days.
How crazy is that?




- Davide



