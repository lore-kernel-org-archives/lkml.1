Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbZCSQhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbZCSQhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbZCSQhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:37:05 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:38909 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751032AbZCSQhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:37:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=znPc0h7i+YkC7f8a+lr3ubmF2dkLWMPycfypoDH5x+grf7ZwAVgF89ph6hmSBLBvCqOg8h4R3VTc+5d5CRHZf5kiFPSXTM2nOq5p+pkx66resKhrUUGD2EhqmJSny5gAlUemTOuaExbRLSTod1xHxzH6UmbGxADb3354VGFpyHY=  ;
X-YMail-OSG: LK6pvkEVM1kpBi703SdRNXr9FyomfJ.Cbb0m_0EKTe04Pb_4isczFk3tKB1iHoXtHxZlxS5CcRj7k6HU27BBpzRFCg7cdxURVa5XdQC7c_UlStVDGEbXwF9Hw_unPASWspWjvFuHNc3bjgaNzwqC45OYDWdTgyDrWYrF260t2T8.ZlZoQbIE_a1qF36NOIWd0ysfqQt4evr6Ab4kK2WguLE6OaMp18YFrNlTg6YMBdgq
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
Date: Fri, 20 Mar 2009 03:36:52 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Ying Han <yinghan@google.com>, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-mm" <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com> <200903200248.22623.nickpiggin@yahoo.com.au> <1237479361.24626.23.camel@twins>
In-Reply-To: <1237479361.24626.23.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903200336.53545.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 March 2009 03:16:01 Peter Zijlstra wrote:
> On Fri, 2009-03-20 at 02:48 +1100, Nick Piggin wrote:
> > On Thursday 19 March 2009 10:54:33 Ying Han wrote:
> > > On Wed, Mar 18, 2009 at 4:36 PM, Linus Torvalds
> > >
> > > <torvalds@linux-foundation.org> wrote:
> > > > On Wed, 18 Mar 2009, Ying Han wrote:
> > > >> > Can you say what filesystem, and what mount-flags you use? Iirc,
> > > >> > last time we had MAP_SHARED lost writes it was at least partly
> > > >> > triggered by the filesystem doing its own flushing independently
> > > >> > of the VM (ie ext3 with "data=journal", I think), so that kind of
> > > >> > thing does tend to matter.
> > > >>
> > > >> /etc/fstab
> > > >> "/dev/hda1 / ext2 defaults 1 0"
> > > >
> > > > Sadly, /etc/fstab is not necessarily accurate for the root
> > > > filesystem. At least Fedora will ignore the flags in it.
> > > >
> > > > What does /proc/mounts say? That should be a more reliable indication
> > > > of what the kernel actually does.
> > >
> > > "/dev/root / ext2 rw,errors=continue 0 0"
> >
> > No luck with finding the problem yet.
> >
> > But I think we do have a race in __set_page_dirty_buffers():
> >
> > The page may not have buffers between the mapping->private_lock
> > critical section and the __set_page_dirty call there. So between
> > them, another thread might do a create_empty_buffers which can
> > see !PageDirty and thus it will create clean buffers. The page
> > will get dirtied by the original thread, but if the buffers are
> > clean it can be cleaned without writing out buffers.
> >
> > Holding mapping->private_lock over the __set_page_dirty should
> > fix it, although I guess you'd want to release it before calling
> > __mark_inode_dirty so as not to put inode_lock under there. I
> > have a patch for this if it sounds reasonable.
>
> When I first did those dirty tracking patches someone (I think Andrew)
> commented no the fact that I did set_page_dirty() under one of these
> inner locks..
>
> /me frobs around in archives for a bit..
>
>  - fs/buffers.c try_to_free_buffers(): remove clear_page_dirty() from under
>    ->private_lock. This seems to be save, since ->private_lock is used to
>    serialize access to the buffers, not the page itself.
>
> Hmm, that's a slightly different issue...
>
> But yeah, your scenario makes heaps of sense.
>
> Can't we do the TestSetPageDirty() before private_lock ? It's currently
> done before tree_lock as well.

I think there might be issues with having a clean page but dirty buffers
if you do it that way... At any rate, if we can solve the race without
swapping the order, I think that would be safer.

