Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbZI2B7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbZI2B7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 21:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZI2B7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 21:59:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55961 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbZI2B7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 21:59:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 29 Sep 2009 10:57:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: No more bits in vm_area_struct's vm_flags.
Message-Id: <20090929105735.06eea1ee.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0909282134100.11529@sister.anvils>
References: <4AB9A0D6.1090004@crca.org.au>
	<20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com>
	<4ABC80B0.5010100@crca.org.au>
	<20090925174009.79778649.kamezawa.hiroyu@jp.fujitsu.com>
	<4AC0234F.2080808@crca.org.au>
	<20090928120450.c2d8a4e2.kamezawa.hiroyu@jp.fujitsu.com>
	<20090928033624.GA11191@localhost>
	<20090928125705.6656e8c5.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0909281637160.25798@sister.anvils>
	<a0ea21a7cfe313202e2b51510aa5435a.squirrel@webmail-b.css.fujitsu.com>
	<Pine.LNX.4.64.0909282134100.11529@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009 22:00:20 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

>> On Tue, 29 Sep 2009, KAMEZAWA Hiroyuki wrote:
> > 
> > Every time I see long long in the kernel, my concern is
> > "do I need spinlock to access this for 32bit arch ? is it safe ?".
> > (And it makes binary=>disassemble=>C (by eyes) a bit difficult)
> > Then, I don't like long long personally.
> > 
> > Another reason is some other calls like test_bit() cannot be used against
> > long long. (even if it's not used _now_)
> > 
> > Maybe vm->vm_flags will not require extra locks because
> > it can be protected by bigger lock as mmap_sem.
> 
> I think that even as you wrote, you guessed I wouldn't be persuaded ;)
> It sounds like you've had a bad experience with a long long in the past.
> 
yes ;)


> We already have to have locking for vm_flags, of course we do: it's
> mmap_sem, yes, though I think you'll find some exceptions which know
> they have exclusive access without it.
> 
> We use ordinary logical operations on vm_flags, we don't need it to
> be atomic, we don't need an additional spinlock, we don't need to use
> test_bit().  It's very easy!  (But irritating in a few places which
> have to down_write mmap_sem for no other reason than to update vm_flags.)
> 
Okay, I'll have no objections. 

Just a notice from lines stripped by grep

(1) using "int"  will be never correct even on 32bit.
==
vm_flags          242 arch/mips/mm/c-r3k.c 	int exec = vma->vm_flags & VM_EXEC;
vm_flags          293 drivers/char/mem.c 	return vma->vm_flags & VM_MAYSHARE;
vm_flags           44 mm/madvise.c   	int new_flags = vma->vm_flags;
vm_flags          547 mm/memory.c    	unsigned long vm_flags = vma->vm_flags;

But yes, it will be not a terrible bug for a while.

(2) All vm macros should be defined with ULL suffix. for supporing ~ 
==
vm_flags           30 arch/x86/mm/hugetlbpage.c 	unsigned long vm_flags = vma->vm_flags & ~VM_LOCKED;

(3) vma_merge()'s vm_flags should be ULL.


Not so many places as I thought..




> > Then, please make it to be long long if its's recommended.
> > 
> > keeping vm_flags to be 32bit may makes vma_merge() ugly.
> > If so, long long is  a choice.
> 
> unsigned long long is certainly the natural choice: that way leaves
> freedom for people to add more flags in future without worrying about
> which flags variable to put them into.  I'd better explain some of my
> objections to Nigel's patch in a reply to him rather than here.
> 
> I have made up a patch to convert it to unsigned long long (not gone
> through all the arches yet though), mainly to try a build to see how
> it works out in practice.  I used a config which built most of the
> non-debugging objects in mm/, things like migration and mempolicy
> and memcg and ksm and so forth, but not kmemleak.
> 
> And I have to admit that the 834 bytes it added to i386 kernel text
> is more than I was expecting, more than I can just brush away as "in
> the noise".  I don't fully understand it yet.  There's a few silly
> "andl $0xffffffff"s from the compiler (4.3.2), but not enough to
> worry about.  Typically enlarged objects grow by 4 bytes, presumably
> clearing the upper half when setting vma->vm_flags, fair enough.
> 
> 300 bytes of growth is in mmap.o, 100 bytes of that in do_mmap_pgoff();
> yet I don't see why it needed to grow by more than, say, 12 bytes.
> 
> My current feeling is that unsigned long long is the right way to
> go, but given the bloat, we shouldn't convert over until we need to:
> right now we should look to save a few flags instead.

Okay,

Thanks,
-Kame
 

