Return-Path: <linux-kernel-owner+w=401wt.eu-S1751455AbXCOWrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbXCOWrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXCOWrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:47:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbXCOWrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:47:48 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0703152043290.24211@blonde.wat.veritas.com> 
References: <Pine.LNX.4.64.0703152043290.24211@blonde.wat.veritas.com>  <3378.1173204813@redhat.com> <Pine.LNX.4.64.0703051843030.10272@blonde.wat.veritas.com> <Pine.LNX.4.64.0703021646050.13167@blonde.wat.veritas.com> <20070216165042.GB409@lnx-holt.americas.sgi.com> <45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com> <20368.1171638335@redhat.com> <18817.1171656543@redhat.com> <29317.1172931029@redhat.com> <12852.1173449522@redhat.com> 
To: Hugh Dickins <hugh@veritas.com>
Cc: bryan.wu@analog.com, Robin Holt <holt@sgi.com>,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, haoki@redhat.com,
       Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: Move to unshared VMAs in NOMMU mode? 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Thu, 15 Mar 2007 22:47:05 +0000
Message-ID: <12838.1173998825@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hugh@veritas.com> wrote:

> But if "the SYSV SHM problem" you mention at the beginning
> is just the "nattch" problem you mention at the end, I doubt
> that's worth such a redesign as you're considering here.

Yes, as far as I know that's the problem.  nattch is available to userspace and
seems to misbehave as far as userspace programs are concerned (I think the
program sees that it is 1 and assumes itself to be the last user).

> Actually, I'm rather surprised SHM needs any such nattch count,
> I'd expect it to deducible from file->f_count and mode&SHM_DEST
> (but haven't investigated whether that really works out at all).

Ummm...  Currently file->f_count doesn't count the number of shmats because the
VMAs are shared.  If they are no longer shared then the problem goes away.

There may be several VMLs for a particular process pointing to a VMA.

sys_shmdt() doesn't malfunction because it's not possible to split a VMA in
NOMMU mode, and so the whole VMA must match.

Actually, looking carefully at it, it might go wrong it someone does shmat(),
munmap(), shmdt().  do_munmap(), however, protects against too many munmaps (in
whatever form they're issued).

> If you just need a little CONFIG_MMU in ipc/shm.c to solve your
> problem, I don't think more is justified.

Hmmm... I'm not sure it's quite that simple.  SYSV SHM is provided by a chain
of shm -> tiny-shmem -> ramfs.  The mapping is actually managed by ramfs.

> Your struct vm_region idea does look more to my taste than what
> you presently have; yet if you pursue it, I think it would just
> make divergence worse wouldn't it?  NOMMU wanting vma to contain
> a pointer to vm_region, MMU wanting vm_region embedded in vma.

That bit of divergence is, in effect, already there.  In NOMMU-mode the VMA
owns the backing store; in MMU-mode it does not.  This would, at least, rectify
that: fixing it would mean that the backing store is no longer owned by the
VMA, and would permit more flexibility in overlapping mappings.

> I don't really understand why NOMMU chooses to share vmas, or
> vm_regions, rather than just sharing the data which they indicate.

Where would that data be?  How do you keep track of it?  How do you know when
to deallocate it?

I have considered co-opting the pagecache attached to the mapped inode (which
is exactly how I do shared-writable mappings on ramfs), but that only works for
shared mappings.  I still have to have a way to handle unshareable mappings.
At the moment, they're both the same way (unless overridden by the driver/fs),
and I just share the VMA.

> Just because you can use less memory that way?

That's one consideration.  The other is that it makes management of these
chunks of data simpler.  If the memory isn't attached to the VMA then it must
be managed in some other manner.

David
