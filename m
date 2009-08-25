Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZHYQoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZHYQoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 12:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbZHYQog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 12:44:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754789AbZHYQog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 12:44:36 -0400
Date: Tue, 25 Aug 2009 09:43:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Mikko C." <mikko.cal@gmail.com>
cc: Eric Paris <eparis@redhat.com>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, zdenek.kabelac@gmail.com,
       christoph.thielecke@gmx.de, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, grant.wilson@zen.co.uk
Subject: Re: [PATCH 2/3] inotify: do not BUG on idr entries at inotify
 destruction
In-Reply-To: <4A93CE2A.90509@gmail.com>
Message-ID: <alpine.LFD.2.01.0908250931170.3218@localhost.localdomain>
References: <20090824173524.14196.25992.stgit@paris.rdu.redhat.com>  <20090824173524.14196.25992.stgit@paris.rdu.redhat.com>  <20090824173812.14196.381.stgit@paris.rdu.redhat.com>  <200908242034.50885.elendil@planet.nl>  <1251140949.25096.16.camel@dhcp231-106.rdu.redhat.com>
  <alpine.LFD.2.01.0908241220590.3158@localhost.localdomain> <1251146166.25096.22.camel@dhcp231-106.rdu.redhat.com> <4A93CE2A.90509@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Aug 2009, Mikko C. wrote:
> 
> I just got this with -rc7, but it doesn't look related to what I was having
> before:
> 
> BUG: Bad page map in process kio_thumbnail  pte:ffff88006cc99128 pmd:6d3b1067
> addr:00007f9d4e3a5000 vm_flags:08000070 anon_vma:(null)
> mapping:ffff88007abe21a0 index:200
> vma->vm_ops->fault: filemap_fault+0x0/0x460
> vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x80
> Pid: 28022, comm: kio_thumbnail Not tainted 2.6.31-rc7 #1
> Call Trace:
>  [<ffffffff810afaf4>] ? print_bad_pte+0x1d4/0x2c0
>  [<ffffffff810afc79>] ? vm_normal_page+0x99/0xa0
>  [<ffffffff810b0c7d>] ? unmap_vmas+0x4cd/0x970
>  [<ffffffff810b6c74>] ? exit_mmap+0x104/0x1d0
>  [<ffffffff81043e0d>] ? mmput+0x4d/0x100
>  [<ffffffff81048d81>] ? exit_mm+0x101/0x150
>  [<ffffffff8104b240>] ? do_exit+0x6c0/0x750
>  [<ffffffff8104b326>] ? do_group_exit+0x56/0xd0
>  [<ffffffff8104b3c2>] ? sys_exit_group+0x22/0x40
>  [<ffffffff8100b7eb>] ? system_call_fastpath+0x16/0x1b
> Disabling lock debugging due to kernel taint
> 
> No lockups or anything.

That looks like a memory corruption bug. Your page table entry is bad: 
pte:ffff88006cc99128. It has the "special" bit set (one of the software 
bits), in a mapping that should not have special pages.

But that pte entry is odd in other ways too - it's _PAGE_PROTNONE, which 
is unusual (but not necessarily _wrong_) and _PAGE_BIT_ACCESSED. And it 
has the high bits set, which is really not ok for a page table entry. The 
PTE entry should look more like the pmd entry.

So it looks like the pte has been overwritten by some bogus value, 
presumably by a stale pointer. And it migth be related to your inotify 
problems that way.

		Linus
