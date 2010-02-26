Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965362Ab0BZQgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:36:44 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:38760 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965305Ab0BZQgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:36:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=gtBVeMZs0FEnm1OvrwssOpU4nXWgtkopQ7JsOiGFNCgNvlAMBWNY1zvOf6cdg+AS7u
         oPbWvEERW1b4D7J9dr0w+oAcLROrZXX3oB3gOCP7Zl2VbeJmJFt/SpmK19Zd96RDyzCy
         Lk40qk8EGSwuoQEjoS6fxe0/9weju12BsgJgE=
MIME-Version: 1.0
Date: Fri, 26 Feb 2010 17:36:40 +0100
Message-ID: <3818d4521002260836u566155b5q28b6e4b3a48881f6@mail.gmail.com>
Subject: BUG: scheduling while atomic, highmem.h:80, i.e.: kunmap_atomic, 
	kdump/vmcore/crash analysis
From: Gilian Vancover <gilvannco@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I catched a vmcore and analyzed it with crash utility. In short, when
a machine is within a deep swap, it sometimes crashes with console
log:

BUG: scheduling while atomic: mytool/0xc817d200/11802
 [<c06156b7>] <2>BUG: recent printk recursion!
 at virtual address 00000034
BUG: unable to handle kernel NULL pointer dereference at virtual
address 000001aa

And with following backtrace from PID 11802:
crash> bt  	
PID: 11802  TASK: f656faa0  CPU: 4   COMMAND: "mytool"
 #0 [f6565dac] schedule at c0616008
 #1 [f6565e38] get_page_from_freelist at c0459846
 #2 [f6565e78] __alloc_pages at c04599cf
 #3 [f6565eb0] dev_ifsioc at c05bbc04
 #4 [f6565ec4] dev_ioctl at c05bc262
 #5 [f6565f30] do_ioctl at c04832cf
 #6 [f6565f44] vfs_ioctl at c0483860
 #7 [f6565fa0] sys_ioctl at c0483900
 #8 [f6565fb8] system_call at c0404f10

A few first line numbers:
crash> bt -l
PID: 11802  TASK: f656faa0  CPU: 4   COMMAND: "mytool"
 #0 [f6565dac] schedule at c0616008
 #1 [f6565e38] get_page_from_freelist at c0459846
    /usr/src/debug/kernel-2.6.18/linux-2.6.18.i686/include/linux/highmem.h: 80
 #2 [f6565e78] __alloc_pages at c04599cf
    /usr/src/debug/kernel-2.6.18/linux-2.6.18.i686/mm/page_alloc.c: 988
 #3 [f6565eb0] dev_ifsioc at c05bbc04
    /usr/src/debug/kernel-2.6.18/linux-2.6.18.i686/net/core/dev.c: 3066
 #4 [f6565ec4] dev_ioctl at c05bc262
    /usr/src/debug/kernel-2.6.18/linux-2.6.18.i686/net/core/dev.c: 3245

Parameters passed to get_page_from_freelist (42, 0, 280d2, 10):
crash> bt -f
#2 [f6565e78] __alloc_pages at c04599cf
    [RA: c05bbc06  SP: f6565e7c  FP: f6565eb0  SIZE: 56]
    f6565e7c: 00000042  00000000  000280d2  00000010
    f6565e8c: c5fe6840  00000042  31f40000  00000000

When I use some other backtrace method, I get:

crash> bt -t
PID: 11802  TASK: f656faa0  CPU: 4   COMMAND: "mytool"
      START: schedule at c0616008
  [f6565e04] apic_timer_interrupt at c04059d7
  [f6565e38] get_page_from_freelist at c045984b
  [f6565e64] wakeup_kswapd at c045c999
  [f6565e78] __alloc_pages at c04599d4
  [f6565ea8] e1000_ioctl at f8e703f0
  [f6565eb0] dev_ifsioc at c05bbc06

The highmem.h:80 line is kunmap* line (last line):
static inline void clear_highpage(struct page *page)
{
        void *kaddr = kmap_atomic(page, KM_USER0);
        clear_page(kaddr);
        kunmap_atomic(kaddr, KM_USER0); // linia 80
}

What do you think? Is apic_timer_interrupt causing to reschedule the
kunmap_atomic ? The machine has 1.2 GB swap consumed out of 1.9 GB. A
few other information about the problem:

Linux version 2.6.18-164.2.1.el5PAE
TOTAL HIGH   818766       3.1 GB   80% of TOTAL MEM
FREE HIGH     2216       8.7 MB    0% of TOTAL HIGH
TOTAL LOW   199365     778.8 MB   19% of TOTAL MEM
FREE LOW    46331       181 MB   23% of TOTAL LOW

#2 from bt -l points to:
        /*
         * Go through the zonelist again. Let __GFP_HIGH and allocations
         * coming from realtime tasks go deeper into reserves.
         *
         * This is the last chance, in general, before the goto nopage.
         * Ignore cpuset if GFP_ATOMIC (!wait) rather than fail alloc.
         * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
         */
        page = get_page_from_freelist(gfp_mask, order, zonelist, alloc_flags);
        if (page)
                goto got_pg;

First three entries from bt -f:

PID: 11802  TASK: f656faa0  CPU: 4   COMMAND: "mytool"
 #0 [f6565dac] schedule at c0616008
    [RA: c045984b  SP: f6565dac  FP: f6565e38  SIZE: 144]
    f6565dac: 00000004  00000003  1a354410  00019006
    f6565dbc: 0000000a  00000100  00019006  f656faa0
    f6565dcc: 00000004  c802e010  f656faa0  00000004
    f6565ddc: f6565e08  f6565de0  f6565de0  f6565e08
    f6565dec: 00000001  e465b2c0  00200046  c548cb60
    f6565dfc: c068d600  e465b2c0  c04059d7  c548cb60
    f6565e0c: 00000350  c068d600  c068d600  c71422b8
    f6565e1c: 00000080  c068fb34  fff48000  c5fe6840
    f6565e2c: c068e880  ffffffff  c5fe6860  c045984b
 #1 [f6565e38] get_page_from_freelist at c0459846
    [RA: c04599d4  SP: f6565e3c  FP: f6565e78  SIZE: 64]
    f6565e3c: 67885c88  a60f1e52  69af8ce2  000001f6
    f6565e4c: 0000004f  00000249  69af8ce2  67864288
    f6565e5c: 00000001  00000001  c045c999  c068fb34
    f6565e6c: 000280d2  c068fb28  f656faa0  c04599d4
 #2 [f6565e78] __alloc_pages at c04599cf
    [RA: c05bbc06  SP: f6565e7c  FP: f6565eb0  SIZE: 56]
    f6565e7c: 00000042  00000000  000280d2  00000010
    f6565e8c: c5fe6840  00000042  31f40000  00000000
    f6565e9c: 7f342067  f7780000  000089f4  f8e703f0
    f6565eac: f6565ef8  c05bbc06


Regards,
Gilian
