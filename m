Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078Ab0AXAQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab0AXAQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 19:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732Ab0AXAP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 19:15:59 -0500
Received: from balrog.mythic-beasts.com ([93.93.130.6]:32840 "EHLO
	balrog.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab0AXAP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 19:15:58 -0500
X-Greylist: delayed 1152 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jan 2010 19:15:58 EST
Date: Sun, 24 Jan 2010 00:04:58 +0000 (GMT)
Message-Id: <20100124.000458.506212773266927716.mrs@deli>
To: linux-kernel@vger.kernel.org
Subject: futex() on vdso makes process unkillable
From: Mark Seaborn <mrs@mythic-beasts.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mythic-Sender-Verify: + host 93.93.130.6 accepted RCPT TO with '250 Accepted'
X-BlackCat-Spam-Score: -12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was experimenting with futexes and was a little surprised to
discover that futex() works on read-only pages.  This creates quite a
high bandwidth side channel that allows two processes to communicate
if, for example, they share a library.  (Mind you, this is not much
different from file locks, which also work on read-only file
descriptors.)

I also found a couple of differences between 2.6.24 (from Ubuntu
hardy) and 2.6.31 (from Ubuntu karmic).  The first is a definite bug
in 2.6.31:


1) On 2.6.31 i686, using futex() on the vdso causes the process to get
stuck, consuming CPU in an unkillable state.  Both FUTEX_WAIT and
FUTEX_WAKE cause the problem.  The problem doesn't occur on 2.6.24.
(BTW, I was testing to see whether futex() on the vdso allows any two
processes to communicate.  This appears not to be the case on 2.6.24.)

A test program is below.


2) Suppose a file is mapped into two processes with MAP_PRIVATE.  Can
the resulting mappings be used to communicate via futex()?  i.e. Does
futex() consider the mappings to be the same?

On 2.6.24, the futex wakeup is not transferred; pages must be mapped
with MAP_SHARED for futex to work.  On 2.6.31, the futex wakeup *is*
transferred; futex works with either MAP_SHARED or MAP_PRIVATE.

2.6.24's behaviour seems more correct, because the mappings are
logically different, even if the underlying memory pages are the same
before copy-on-write is triggered.  Is 2.6.31's behaviour a
regression, or is the kernel's behaviour here supposed to be
undefined?

Cheers,
Mark


/* Test futex() on the vdso, which the kernel maps on process startup. */

#include <stdio.h>
#include <stdlib.h>

#include <elf.h>
#include <linux/futex.h>
#include <sys/syscall.h>
#include <unistd.h>


#if __WORDSIZE == 32
#  define Elf(name) Elf32_##name
#elif __WORDSIZE == 64
#  define Elf(name) Elf64_##name
#endif

void *find_vdso(char **argv)
{
  /* Find auxv. */
  char **p = argv;
  /* Skip past argv. */
  while(*p)
    p++;
  p++;
  /* Skip past env. */
  while(*p)
    p++;
  p++;
  Elf(auxv_t) *auxv = (void *) p;
  for(; auxv->a_type; auxv++)
    if(auxv->a_type == AT_SYSINFO_EHDR)
      return (void *) auxv->a_un.a_val;
  fprintf(stderr, "vdso not found\n");
  exit(1);
}

int main(int argc, char **argv)
{
  int *vdso = find_vdso(argv);
  fprintf(stderr, "vdso found at %p\n", vdso);
  if(syscall(__NR_futex, vdso, FUTEX_WAKE, 1) < 0)
    perror("futex/WAKE");
  if(syscall(__NR_futex, vdso, FUTEX_WAIT, *vdso, NULL) < 0)
    perror("futex/WAIT");
  return 0;
}
