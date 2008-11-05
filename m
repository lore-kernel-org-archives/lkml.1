Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbYKELOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbYKELOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 06:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbYKELOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 06:14:31 -0500
Received: from ik-out-1112.google.com ([66.249.90.177]:22368 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbYKELOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 06:14:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=JHkQ2WdYG/7bVWyzjL7Mzf+K6W72Z96Fd2JNtaaFqcEeBVZcxZw/xUArqKhvMNJbDu
         qMcYnXus7RnEFmcSq9p+KC32hl66UXfGpM298aXQyYWK2AE0Iok+tsmAJyWJJ4pCRaLp
         WFMRYsMgH+/zcexf/uOTGhcSXyUXNuBiTX6ac=
Message-ID: <49118010.20202@gmail.com>
Date: Wed, 05 Nov 2008 13:14:24 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: /proc/pid/maps containg anonymous maps that have PROT_NONE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that there are (quite large) entries in /proc/pid/maps that
have PROT_NONE, right after an existing mapping:
7fffe4000000-7fffe406a000 rw-p 7fffe4000000 00:00 0
7fffe406a000-7fffe8000000 ---p 7fffe406a000 00:00 0
7ffff76d1000-7ffff76e0000 r-xp 00000000 09:03 260750                    
/lib/libbz2.so.1.0.4
7ffff76e0000-7ffff78df000 ---p 0000f000 09:03 260750                    
/lib/libbz2.so.1.0.4

I don't mind that 2Mb map, but what is 7fffe406a000-7fffe8000000 ---p ?
(63M)

Is it coming from glibc mapping memory as PROT_NONE, and using
mprotect/madvise to make it writable, and then
caching the mappings for future use, rather than freeing them?

/proc/pid/smaps shows:
7fffe406a000-7fffe8000000 ---p 7fffe406a000 00:00 0
Size:              65112 kB
Rss:                   0 kB
Pss:                   0 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:         0 kB
Referenced:            0 kB
Swap:                  0 kB

I straced the program creating these, and I couldn't find anything with
7fffe406a000, but only before that address:

[pid 31928] mprotect(0x7fffe4000000, 135168, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe4021000, 131072, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe4041000, 32768, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe4049000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe404a000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe404b000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe404c000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe404d000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe404e000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe404f000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe4050000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe4051000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe4052000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe4053000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe4054000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe4055000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe4056000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe4057000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe4058000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe4059000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe405a000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe405b000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe405c000, 4096, PROT_READ|PROT_WRITE) = 0
[pid 31928] mprotect(0x7fffe405d000, 53248, PROT_READ|PROT_WRITE) = 0
[pid 31928] madvise(0x7fffe4069000, 4096, 0x4 /* MADV_??? */) = 0
[pid 31928] madvise(0x7fffe4021000, 294912, 0x4 /* MADV_??? */) = 0
[pid 31928] madvise(0x7fffe4021000, 4096, 0x4 /* MADV_??? */) = 0

There is an mprotect and madvise that end at 0x7fffe406a000.
Those mprotects and madvise are coming from glibc. Its strange that I
don't see the mmap only the mprotect, but I used strace -f.

This happens on:
Linux debian 2.6.26-1-amd64 #1 SMP Thu Oct 9 14:16:53 UTC 2008 x86_64
GNU/Linux

strace is here:
http://edwintorok.googlepages.com/log2.bz2

Best regards,
--Edwin
