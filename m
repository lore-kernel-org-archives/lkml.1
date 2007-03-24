Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbXCXFcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbXCXFcg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 01:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbXCXFcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 01:32:36 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:17083 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbXCXFcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 01:32:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=anXKw0wPtMsm09lXIljiYLVT1j+uhgq2ytKhSC27Xb0Aiu6F/XOsD4vYstmyyY/DXE9Ai8v8RIU3S6CYu5vkrxr/lrRQN0yQ4Efq/Kbrq34q/hrmkv3p6nK4uQA5bMDHCn8G5iP7jIZLqEQ3DPuje7IksZpNngZYwxXfbRdMepg=
Message-ID: <29495f1d0703232232o3e436c62lddccc82c4dd17b51@mail.gmail.com>
Date: Fri, 23 Mar 2007 22:32:31 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch] rfc: introduce /dev/hugetlb
Cc: "Ken Chen" <kenchen@google.com>, "Adam Litke" <agl@us.ibm.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Christoph Hellwig" <hch@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070323205810.3860886d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b040c32a0703230144r635d7902g2c36ecd7f412be31@mail.gmail.com>
	 <20070323205810.3860886d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 23 Mar 2007 01:44:38 -0700 "Ken Chen" <kenchen@google.com> wrote:
>
> > On 3/21/07, Adam Litke <agl@us.ibm.com> wrote:
> > > The main reason I am advocating a set of pagetable_operations is to
> > > enable the development of a new hugetlb interface.  During the hugetlb
> > > BOFS at OLS last year, we talked about a character device that would
> > > behave like /dev/zero.  Many of the people were talking about how they
> > > just wanted to create MAP_PRIVATE hugetlb mappings without all the fuss
> > > about the hugetlbfs filesystem.  /dev/zero is a familiar interface for
> > > getting anonymous memory so bringing that model to huge pages would make
> > > programming for anonymous huge pages easier.
> >
> > I think we have enough infrastructure currently in hugetlbfs to
> > implement what Adam wants for something like a /dev/hugetlb char
> > device (except we can't afford to have a zero hugetlb page since it
> > will be too costly on some arch).
> >
> > I really like the idea of having something similar to /dev/zero for
> > hugetlb page.  So I coded it up on top of existing hugetlbfs.  The
> > core change is really small and half of the patch is really just
> > moving things around.  I think this at least can partially fulfill the
> > goal.
>
> Standing back and looking at this...
>
> afaict the whole reason for this work is to provide a quick-n-easy way to
> get private mappings of hugetlb pages.  With the emphasis on quick-n-easy.

I agree.

> We can do the same with hugetlbfs, but that involves (horror) "fuss".

Yes.

> The way to avoid "fuss" is of course to do it once, do it properly then stick
> it in a library which everyone uses.

That's sort of what libhugetlbfs
(http://sourceforge.net/projects/libhugetlbfs for stable releases,
http://libhugetlbfs.ozlabs.org/ for development snapshots/git tree) is
for; while it currently only tries to abstract/provide functionality
via hugetlbfs, that's mostly because that is the only interface
available (or was, pending some sort of char dev being merged).

> But libraries are hard, for a number of distributional reasons.  It is
> easier for us to distribute this functionality within the kernel.  In fact,
> if Linus's tree included a ./userspace/libkernel/libhugetlb/ then we'd
> probably provide this functionality in there.

libhugetlbfs is available for both SLES10 and RHEL5.

> This comes up regularly, and it's pretty sad.

I agree. There is simply some functionality that is *very* closely
tied to the kernel.

> Probably the kernel team should be maintaining, via existing processes, a
> separate libkernel project, to fix these distributional problems.  The
> advantage in this case is of course that our new hugetlb functionality
> would be available to people on 2.6.18 kernels, not only on 2.6.22 and
> later.

That sounds like a good idea. For this hugetlb stuff, though, I plan
on simply taking advantage of /dev/hugetlb (or whatever it is called)
if it exists, and otherwise falling back to hugetlbfs (which
admittedly requires some admin intervention (mounting hugetlbfs,
permissions, and such), but then again, so does using hugepages in the
first place (either at boot-time or via /proc/sys/vm/nr_hugepages)).
Is that what you mean by available to 2.6.18 (falling back to
hugetlbfs) and 2.6.22 (using the chardev)?

> Am I wrong?

I don't think so. And hugepages are hard enough to use (and with
enough architecture specific quirks) that it was worth creating
libhugetlbfs. While having some nice features like segment remapping
and overriding malloc, it is also meant to provide an API that is
useful for general use of hugepages: we currently export
gethugepagesize(), hugetlbfs_test_path() (verify a path is a valid
hugetlbfs mount), hugetlbfs_find_path() (gives you the hugetlbfs
mount) and hugetlbfs_unlinked_fd() (gives you an unlinked file in the
hugetlbfs mount).

Then again, maybe I'm missing some much bigger picture here and you
meant something completely different -- sorry for the noise in that
case :/

Thanks,
Nish
