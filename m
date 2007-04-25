Return-Path: <linux-kernel-owner+w=401wt.eu-S2992546AbXDYKBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992546AbXDYKBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992549AbXDYKBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:01:22 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:44977 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992546AbXDYKBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:01:21 -0400
Date: Wed, 25 Apr 2007 11:59:15 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Jakub Jelinek <jakub@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Big reserved mappings on x86_64
In-Reply-To: <20070425113005.21bccfab.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.61.0704251155230.19711@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704251035480.19711@yvahk01.tjqt.qr>
 <20070425084931.GC355@devserv.devel.redhat.com> <20070425113005.21bccfab.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 25 2007 11:30, Eric Dumazet wrote:
>Jakub Jelinek <jakub@redhat.com> wrote:
>
>> On Wed, Apr 25, 2007 at 10:42:20AM +0200, Jan Engelhardt wrote:
>> > I actually took a look at `pmap $$`, which reveals that a lot of shared 
>> > libraries map 2044K or 2048K unreadable-unwritable-private 
>> > mappings...for _what_ purpose?
>> > 
>> > 10:37 opteron:~ > pmap $$
>> > 4403: bash
>> > START       SIZE     RSS   DIRTY PERM MAPPING
>> > 2ae6cca70000    212K    172K      0K r-xp /lib64/libreadline.so.5.2
>> > 2ae6ccaa5000   2044K      0K      0K ---p /lib64/libreadline.so.5.2 <--
>> > 2ae6ccca4000      4K      4K      4K r--p /lib64/libreadline.so.5.2
>> > 2ae6ccca5000     28K     28K     28K rw-p /lib64/libreadline.so.5.2
>> > 2ae6cccac000      8K      8K      8K rw-p [anon]
>> > 2ae6cccae000     28K     16K      0K r-xp /lib64/libhistory.so.5.2
>> > 2ae6cccb5000   2048K      0K      0K ---p /lib64/libhistory.so.5.2 <--
>> > 2ae6cceb5000      8K      8K      8K rw-p /lib64/libhistory.so.5.2
>> > 2ae6cceb7000    320K    208K      0K r-xp /lib64/libncurses.so.5.5
>> > 2ae6ccf07000   2048K      0K      0K ---p /lib64/libncurses.so.5.5 <--
>> > 2ae6cd107000     48K     48K     48K r--p /lib64/libncurses.so.5.5
>> > 2ae6cd113000     28K     28K     28K rw-p /lib64/libncurses.so.5.5
>> > [...]
>> > 
>> > What could these ominous mappings be? Does anyone else see that - 
>> > perhaps someone with x86_64 && !(opensuse 10.2)?
>> 
>> While i386 only supports 4KB pages, x86_64 ELF objects ought to support
>> up to 2MB pages.  The gap between read-only/executable and writable segments
>> is intentionally mapped PROT_NONE, so that other things aren't mapped in
>> between the segments.
>
>This makes sense for catching some programming errors, but it also
>has a cost for innocent users, since it adds one vm_area_struct per
>dll. It slows down all find_vma() operations that tend to be done
>quite frequently these days :( Even with a rbtree, adding 150
>vm_area_struct increase memory needs and cache misses. Maybe these
>PROT_NONE mappings could be done iff some LD_DEBUG or other ld.so
>variable says so ?

And even then, there should probably be one or two variables inside
the vma struct that defines a "padding" the must come before/after a
specific vma. I think that would get rid of these PROT_NONE vmas
while catching errors. Hey btw, are there any architectures that do
_not_ actually implement a read/write check? Having no vma mapped at
all might catch a bogus read/write attempt earlier than a prot_none
vma, does not it?

>BTW I dont see such mappings on my 32bit distro (Ubuntu 7.04, glibc-2.5)

It seems specific to x86_64. sparc64 looks like this:

f7d34000   1376K r-x--  /lib/libc-2.5.so
f7e8c000     56K -----  /lib/libc-2.5.so <-
f7e9a000      8K r----  /lib/libc-2.5.so
f7e9c000     16K rwx--  /lib/libc-2.5.so
f7ea0000      8K rwx--    [ anon ]
f7ea4000     16K r-x--  /lib/libdl-2.5.so
f7ea8000     56K -----  /lib/libdl-2.5.so <-
f7eb6000      8K r----  /lib/libdl-2.5.so
f7eb8000      8K rwx--  /lib/libdl-2.5.so
f7ebc000     16K r-x--  /lib/libtermcap.so.2.0.8
f7ec0000     56K -----  /lib/libtermcap.so.2.0.8 <-
f7ece000      8K rwx--  /lib/libtermcap.so.2.0.8


Jan
-- 
