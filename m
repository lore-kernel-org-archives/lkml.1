Return-Path: <linux-kernel-owner+w=401wt.eu-S1758465AbZLOCk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465AbZLOCk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 21:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbZLOCk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 21:40:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56712 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbZLOCk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 21:40:57 -0500
Date: Tue, 15 Dec 2009 11:40:53 +0900 (JST)
Message-Id: <20091215.114053.193686180.d.hatayama@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jdike@addtoit.com, tony.luck@intel.com,
       mhiramat@redhat.com
Subject: [RFC, PATCH 0/4] elf_core_dump(): Add extended numbering support
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary
=======

The current ELF dumper can produce broken corefiles if program headers
exceed 65535. In particular, the program in 64-bit environment often
demands more than 65535 mmaps. If you google max_map_count, then you
can find many users facing this problem.

Solaris has already dealt with this issue, and other OSes have also
adopted the same method as in Solaris. Currently, Sun's document and
AMD 64 ABI include the description for the extension, where they call
the extension Extended Numbering. See Reference for further information.

I believe that linux kernel should adopt the same way as they did, so
I've written this patch.

I am also preparing for patches of GDB and binutils.

How to fix
==========

In new dumping process, there are two cases according to weather or
not the number of program headers is equal to or more than 65535.

 - if less than 65535, the produced corefile format is exactly the
   same as the ordinary one.

 - if equal to or more than 65535, then e_phnum field is set to newly
   introduced constant PN_XNUM(0xffff) and the actual number of
   program headers is set to sh_info field of the section header at
   index 0.

Compatibility Concern
=====================

 * As already mentioned in Summary, Sun and AMD64 has already adopted
   this. See Reference.

 * There are four combinations according to whether kernel and
   userland tools are respectively modified or not. The next table
   summarizes shortly for each combination.

                  ---------------------------------------------
                     Original Kernel    |   Modified Kernel   
                  ---------------------------------------------
    	            < 65535  | >= 65535 | < 65535  | >= 65535 
  -------------------------------------------------------------
   Original Tools |    OK    |  broken  |   OK     | broken (#)
  -------------------------------------------------------------
   Modified Tools |    OK    |  broken  |   OK     |    OK
  -------------------------------------------------------------

  Note that there is no case that `OK' changes to `broken'.

  (#) Although this case remains broken, O-M behaves better than
  O-O. That is, while in O-O case e_phnum field would be extremely
  small due to integer overflow, in O-M case it is guaranteed to be at
  least 65535 by being set to PN_XNUM(0xFFFF), much closer to the
  actual correct value than the O-O case.

Test Program
============

Here is a test program mkmmaps.c that is useful to produce the
corefile with many mmaps. To use this, please take the following
steps:

$ ulimit -c unlimited
$ sysctl vm.max_map_count=70000 # default 65530 is too small
$ sysctl fs.file-max=70000
$ mkmmaps 65535 # abort and then a corefile is generated

If failed, there are two cases according to the error message displayed.

 * If ``out of memory'' is displayed, it indicates that
   vm.max_map_count is still smaller.

 * If ``too many open files'' is displayed, it indicates that
   fs.file-max is still smaller.

So, please retry it after changeing it to a larger value.

mkmmaps.c
==
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
int main(int argc, char **argv)
{ 
	int maps_num;
	if (argc < 2) {
		fprintf(stderr, "mkmmaps [number of maps to be created]\n");
		exit(1);
	}
	if (sscanf(argv[1], "%d", &maps_num) == EOF) {
		perror("sscanf");
		exit(2);
	}
	if (maps_num < 0) {
		fprintf(stderr, "%d is invalid\n", maps_num);
		exit(3);
	}
	for (; maps_num > 0; --maps_num) {
		if (MAP_FAILED == mmap((void *)NULL, (size_t) 1, PROT_READ,
					MAP_SHARED | MAP_ANONYMOUS, (int) -1,
					(off_t) NULL)) {
			perror("mmap");
			exit(4);
		}    
	}
	abort();
	{
		char buffer[128];
		sprintf(buffer, "wc -l /proc/%u/maps", getpid());
		system(buffer);
	}
	return 0;
}

Patches
=======

I give four patches. The main patch is the fourth. The first two
patches are clean up. The third patch chnages dumping process slightly
for the forth patch.

diffstat output for a whole patches is as follows:

 include/linux/elf.h        |   28 ++++++++-
 fs/binfmt_elf.c            |  137 ++++++++++++++++++++++++++++++++++++++-------
 arch/ia64/kernel/Makefile  |    2 
 arch/ia64/kernel/elfcore.c |   91 +++++++++++++++++++++++++++++
 arch/um/sys-i386/Makefile  |    2 
 arch/um/sys-i386/elfcore.c |   96 +++++++++++++++++++++++++++++++
 6 files changed, 334 insertions(+), 22 deletions(-)

Question to Maintainers
========

I know these patches are conflicting with Hiramatsu-san's
(http://lkml.org/lkml/2009/11/28/143), so I am planning to remake
them. But now, I don't know what tree is sutable to send these
patches. Do you have any suggestions?

Reference
=========

 - Sun microsystems: Linker and Libraries.
   Part No: 817-1984-17, September 2008.
   URL: http://docs.sun.com/app/docs/doc/817-1984

 - System V ABI AMD64 Architecture Processor Supplement
   Draft Version 0.99., May 11, 2009.
   URL: http://www.x86-64.org/

Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
