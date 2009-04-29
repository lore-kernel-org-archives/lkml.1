Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZD2NzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZD2NzC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:55:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbZD2Nyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:54:52 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:58434 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbZD2Nyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:54:51 -0400
Message-ID: <49F85C27.9000308@monstr.eu>
Date: Wed, 29 Apr 2009 15:54:47 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, John Williams <john.williams@petalogix.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Memory limits - mm_segment_t - MAKE_MM_SEG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I look at some things which I need to clear for MMU Microblaze patches and
I would like to know your opinion about.

First of all I found that almost all archs use MAKE_MM_SEG macro which should be good
to move to generic location (asm-generic/uaccess.h ? )
#define MAKE_MM_SEG(s) ((mm_segment_t) { (s) })


The second thing is about place where is stored limit for processes -> mm_segment_t structure

Where is the proper location for storing mm_segment_t? Some arch use thread_info some of them
thread_struct

For microblaze case are used both -> that's definitely not correct.

Here is the small table for cpus which are in linux kernel and location and type for them.
The most of them uses thread_info structure for it and name is addr_limit.
The location of mm_segment_t is different too -> we should move it to any generic location too.
What do you think?

        location                     name           location      struct mm_segment_t
s390:   processor.h/thread_struct    mm_segment     processor.h   __u32 ar4
alpha:  thread_info.h/thread_info    addr_limit     processor.h  unsigned long seg
x86:    thread_info.h/thread_info    addr_limit     processor.h  unsigned long seg
ia64:   thread_info.h/thread_info    addr_limit     processor.h  unsigned long seg
mips:   thread_info.h/thread_info    addr_limit     processor.h  unsigned long seg
um:     thread_info.h/thread_info    addr_limit     uaccess.h    unsigned long seg
frv:    thread_info.h/thread_info    addr_limit     segment.h    unsigned long seg
cris:   thread_info.h/thread_info    addr_limit     segment.h    unsigned long seg
sh:     thread_info.h/thread_info    addr_limit     segment.h    unsigned long seg
h8300:  not_used     not_used                       segment.h    unsigned long seg
nm10300:thread_info.h/thread_info    addr_limit     processor.h  unsigned long seg
arm:    thread_info.h/thread_info    addr_limit     thread_info.h  typedef unsigned long mm_segment_t;
parisc: thread_info.h/thread_info    addr_limit     processor.h  int seq
m32r:   thread_info.h/thread_info    addr_limit     processor.h  unsigned long seg
xtensa: thread_info.h/thread_info    addr_limit     segment.h    unsigned long seg
avr32:  not_used     not_used                       uaccess.h    unsigned int is_user_space;
sparc:  processor_32.h/thread_struct  current_ds    processor_32.h  int seg
m68k:   not_used     not_used                       segment.h    unsigned long seg
blackfin:thread_info.h/thread_info    addr_limit    thread_info.h  typedef unsigned long mm_segment_t;
powerpc: processor.h/thread_struct  current_ds     processor.h  unsigned long seg


There is really mess in it and I would like to have good solution for Microblaze and I think
that will be good to have any generic solution and remove code duplication.

Thanks for your comments,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
