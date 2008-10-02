Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbYJBF0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbYJBF0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 01:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYJBF0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 01:26:16 -0400
Received: from gw-d.mimosa.com ([209.161.207.149]:50633 "EHLO gw-d.mimosa.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbYJBF0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 01:26:15 -0400
Date: Thu, 2 Oct 2008 01:26:14 -0400 (EDT)
From: "D. Hugh Redelmeier" <hugh@mimosa.com>
Reply-To: "D. Hugh Redelmeier" <hugh@mimosa.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: mtrr_cleanup safe to get more spare regs now
In-Reply-To: <bhxQY-5eL-11@gated-at.bofh.it>
Message-ID: <alpine.LRH.2.00.0810020047440.4688@redclaw.mimosa.com>
References: <bhxQY-5eL-11@gated-at.bofh.it>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008, Yinghai Lu wrote:

| results:

Thanks for posting all these examples.  More test cases for
mtrr-uncover.

I've made some changes to mtrr-uncover so that it comes up with
solutions for all of these without any hints (i.e. the user no longer
has to specify the address range for the MTRR that must be uncovered,
the program guesses).

ftp://ftp.cs.utoronto.ca/pub/hugh/mtrr-uncover-2008oct01.tgz

| 1. hpa
| reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
| reg01: base=0x13c000000 (5056MB), size=  64MB: uncachable, count=1
| reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
| reg03: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
| reg04: base=0xbf700000 (3063MB), size=   1MB: uncachable, count=1
| reg05: base=0xbf800000 (3064MB), size=   8MB: uncachable, count=1
| 
| will get
| Found optimal setting for mtrr clean up
| gran_size: 1M   chunk_size: 128M        num_reg: 6      lose RAM: 0M
| range0: 0000000000000000 - 00000000c0000000
| Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
| Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
| hole: 00000000bf700000 - 00000000c0000000
| Setting variable MTRR 2, base: 3063MB, range: 1MB, type UC
| Setting variable MTRR 3, base: 3064MB, range: 8MB, type UC
| range0: 0000000100000000 - 0000000140000000
| Setting variable MTRR 4, base: 4096MB, range: 1024MB, type WB
| hole: 000000013c000000 - 0000000140000000
| Setting variable MTRR 5, base: 5056MB, range: 64MB, type UC

 2' 0x000000000-0x07fffffff write-back
50' 0x080000000-0x0bfffffff write-back
         4  0x0bf700000-0x0bf7fffff uncachable
         5  0x0bf800000-0x0bfffffff uncachable
 3  0x100000000-0x13fffffff write-back
         1  0x13c000000-0x13fffffff uncachable

Solutions identical.

| 2. Dylan Taft
| reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
| reg01: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
| reg02: base=0x120000000 (4608MB), size= 256MB: write-back, count=1
| reg03: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
| reg04: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
| reg05: base=0xc7e00000 (3198MB), size=   2MB: uncachable, count=1
| reg06: base=0xc8000000 (3200MB), size= 128MB: uncachable, count=1
| 
| will get
| Found optimal setting for mtrr clean up
| gran_size: 1M   chunk_size: 4M  num_reg: 6      lose RAM: 0M
| range0: 0000000000000000 - 00000000c8000000
| Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
| Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
| Setting variable MTRR 2, base: 3072MB, range: 128MB, type WB
| hole: 00000000c7e00000 - 00000000c8000000
| Setting variable MTRR 3, base: 3198MB, range: 2MB, type UC
| rangeX: 0000000100000000 - 0000000130000000
| Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
| Setting variable MTRR 5, base: 4608MB, range: 256MB, type WB

 0' 0x000000000-0x07fffffff write-back
50' 0x080000000-0x0bfffffff write-back
51' 0x0c0000000-0x0c7ffffff write-back
         5  0x0c7e00000-0x0c7ffffff uncachable
 1  0x100000000-0x11fffffff write-back
 2  0x120000000-0x12fffffff write-back

Solutions identical.

| 3. Gabriel
| reg00: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
| reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
| reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
| reg03: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
| reg04: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
| reg05: base=0x128000000 (4736MB), size=  64MB: write-back, count=1
| reg06: base=0xcf600000 (3318MB), size=   2MB: uncachable, count=1
| 
| will get
| Found optimal setting for mtrr clean up
| gran_size: 1M   chunk_size: 16M         num_reg: 7      lose RAM: 0M
| range0: 0000000000000000 - 00000000d0000000
| Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
| Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
| Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
| hole: 00000000cf600000 - 00000000cf800000
| Setting variable MTRR 3, base: 3318MB, range: 2MB, type UC
| rangeX: 0000000100000000 - 000000012c000000
| Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
| Setting variable MTRR 5, base: 4608MB, range: 128MB, type WB
| Setting variable MTRR 6, base: 4736MB, range: 64MB, type WB

 2' 0x000000000-0x07fffffff write-back
50' 0x080000000-0x0bfffffff write-back
51' 0x0c0000000-0x0cfffffff write-back
         6  0x0cf600000-0x0cf7fffff uncachable
 3  0x100000000-0x11fffffff write-back
 4  0x120000000-0x127ffffff write-back
 5  0x128000000-0x12bffffff write-back

Solutions identical.

| 4. Mika Fischer
| reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
| reg01: base=0x00000000 ( 0MB), size=4096MB: write-back, count=1
| reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
| reg03: base=0xbf700000 (3063MB), size= 1MB: uncachable, count=1
| reg04: base=0xbf800000 (3064MB), size= 8MB: uncachable, count=1
| 
| will get
| Found optimal setting for mtrr clean up
| gran_size: 1M   chunk_size: 16M         num_reg: 5      lose RAM: 0M
| range0: 0000000000000000 - 00000000c0000000
| Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
| Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
| hole: 00000000bf700000 - 00000000c0000000
| Setting variable MTRR 2, base: 3063MB, range: 1MB, type UC
| Setting variable MTRR 3, base: 3064MB, range: 8MB, type UC
| rangeX: 0000000100000000 - 0000000140000000
| Setting variable MTRR 4, base: 4096MB, range: 1024MB, type WB

 1' 0x000000000-0x07fffffff write-back
50' 0x080000000-0x0bfffffff write-back
         3  0x0bf700000-0x0bf7fffff uncachable
         4  0x0bf800000-0x0bfffffff uncachable
 2  0x100000000-0x13fffffff write-back

Solutions identical.

It is slightly surprising to me that our two very different codes come
up with the same solutions.

BTW, the output uses the word "range" where /proc/mtrr uses "size".
Would it not be good to use the same terminology?

For numbers, I've been using hex, zero padded to 9 digits.  Why 9 and
not 8?  Because all the problems seem to come with machines that need
9 digits to express all their addresses.
