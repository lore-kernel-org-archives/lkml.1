Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbZI1VAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbZI1VAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 17:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZI1VAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 17:00:24 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:65487 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751901AbZI1VAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 17:00:24 -0400
X-Trace: 263746126/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.126.168/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.126.168
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFADfAwEpPRX6o/2dsb2JhbACBUdVlhB4F
X-IronPort-AV: E=Sophos;i="4.44,468,1249254000"; 
   d="scan'208";a="263746126"
Date: Mon, 28 Sep 2009 22:00:20 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Wu Fengguang <fengguang.wu@intel.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: No more bits in vm_area_struct's vm_flags.
In-Reply-To: <a0ea21a7cfe313202e2b51510aa5435a.squirrel@webmail-b.css.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0909282134100.11529@sister.anvils>
References: <4AB9A0D6.1090004@crca.org.au>    <20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com>
    <4ABC80B0.5010100@crca.org.au>    <20090925174009.79778649.kamezawa.hiroyu@jp.fujitsu.com>
    <4AC0234F.2080808@crca.org.au>    <20090928120450.c2d8a4e2.kamezawa.hiroyu@jp.fujitsu.com>
    <20090928033624.GA11191@localhost>    <20090928125705.6656e8c5.kamezawa.hiroyu@jp.fujitsu.com>
    <Pine.LNX.4.64.0909281637160.25798@sister.anvils>
 <a0ea21a7cfe313202e2b51510aa5435a.squirrel@webmail-b.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009, KAMEZAWA Hiroyuki wrote:
> Hugh Dickins wrote:
> > On Mon, 28 Sep 2009, KAMEZAWA Hiroyuki wrote:
> >>
> >> What I dislike is making vm_flags to be long long ;)
> >
> > Why?
> I'm sorry if my "dislike" sounds too strong.

No, not at all, I like the honesty with which you say "dislike".

> 
> Every time I see long long in the kernel, my concern is
> "do I need spinlock to access this for 32bit arch ? is it safe ?".
> (And it makes binary=>disassemble=>C (by eyes) a bit difficult)
> Then, I don't like long long personally.
> 
> Another reason is some other calls like test_bit() cannot be used against
> long long. (even if it's not used _now_)
> 
> Maybe vm->vm_flags will not require extra locks because
> it can be protected by bigger lock as mmap_sem.

I think that even as you wrote, you guessed I wouldn't be persuaded ;)
It sounds like you've had a bad experience with a long long in the past.

We already have to have locking for vm_flags, of course we do: it's
mmap_sem, yes, though I think you'll find some exceptions which know
they have exclusive access without it.

We use ordinary logical operations on vm_flags, we don't need it to
be atomic, we don't need an additional spinlock, we don't need to use
test_bit().  It's very easy!  (But irritating in a few places which
have to down_write mmap_sem for no other reason than to update vm_flags.)

> Then, please make it to be long long if its's recommended.
> 
> keeping vm_flags to be 32bit may makes vma_merge() ugly.
> If so, long long is  a choice.

unsigned long long is certainly the natural choice: that way leaves
freedom for people to add more flags in future without worrying about
which flags variable to put them into.  I'd better explain some of my
objections to Nigel's patch in a reply to him rather than here.

I have made up a patch to convert it to unsigned long long (not gone
through all the arches yet though), mainly to try a build to see how
it works out in practice.  I used a config which built most of the
non-debugging objects in mm/, things like migration and mempolicy
and memcg and ksm and so forth, but not kmemleak.

And I have to admit that the 834 bytes it added to i386 kernel text
is more than I was expecting, more than I can just brush away as "in
the noise".  I don't fully understand it yet.  There's a few silly
"andl $0xffffffff"s from the compiler (4.3.2), but not enough to
worry about.  Typically enlarged objects grow by 4 bytes, presumably
clearing the upper half when setting vma->vm_flags, fair enough.

300 bytes of growth is in mmap.o, 100 bytes of that in do_mmap_pgoff();
yet I don't see why it needed to grow by more than, say, 12 bytes.

My current feeling is that unsigned long long is the right way to
go, but given the bloat, we shouldn't convert over until we need to:
right now we should look to save a few flags instead.

Hugh
