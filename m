Return-Path: <linux-kernel-owner+w=401wt.eu-S934034AbXCTTNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034AbXCTTNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 15:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934041AbXCTTNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 15:13:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934034AbXCTTNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 15:13:02 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <m1bqinsvy3.fsf@ebiederm.dsl.xmission.com> 
References: <m1bqinsvy3.fsf@ebiederm.dsl.xmission.com>  <m1wt1dvxzu.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0703152043290.24211@blonde.wat.veritas.com> <3378.1173204813@redhat.com> <Pine.LNX.4.64.0703051843030.10272@blonde.wat.veritas.com> <Pine.LNX.4.64.0703021646050.13167@blonde.wat.veritas.com> <20070216165042.GB409@lnx-holt.americas.sgi.com> <45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com> <20368.1171638335@redhat.com> <18817.1171656543@redhat.com> <29317.1172931029@redhat.com> <12852.1173449522@redhat.com> <12838.1173998825@redhat.com> <11772.1174388792@redhat.com> 
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Hugh Dickins <hugh@veritas.com>, bryan.wu@analog.com,
       Robin Holt <holt@sgi.com>,
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
Date: Tue, 20 Mar 2007 19:12:10 +0000
Message-ID: <4269.1174417930@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman <ebiederm@xmission.com> wrote:

> >> For shared mappings you share in some sense the page cache.
> >
> > Currently, no - not unless the driver does something clever as ramfs does.
> > Sharing through the page cache is a nice idea, but it has some limitations,
> > mainly that non-sharing then operates differently.
> 
> I don't quite what your limitations are

 (1) There's no MMU to provide write protection.  This can be worked around in
     various ways - such as returning ETXTBSY if one attempts to write() to a
     shared mapped file.

 (2) An NFS root changing.  ETXTBSY cannot be applied to the server just
     because a client has a file open.  Admittedly, this is a problem for
     MMU-mode too.

 (3) Keeping track of what memory a VMA is currently pinning.  This isn't
     normally necessary in MMU-mode, but it's very important in NOMMU-mode.

 (4) Mappings must be made on contiguous regions of CPU physical memory space.
     This leads to fun generating contiguous regions.  If someone reads, say,
     the first page of a file, then attempts to map the first meg, say, of the
     file (think ld.so loading a shared library), you need to make the first
     meg completely contiguous.  There can be problems with this:

     (a) Any pages that are already in the page cache (notably the first page)
     	 may need moving to a region that's big enough to hold the whole
     	 segment.

     (b) If a smaller mapping is already made, but can't be extended, then you
     	 can't make the bigger mapping unless you can decide not to share them.

     With ramfs on NOMMU, using truncate() to expand a zero length file
     attempts to get a contiguous region of the size specified which is then
     broken up and attached to the page cache for that file.  This is what
     makes POSIX and SYSV shared memory work on NOMMU.

 (5) PROT_WRITE/MAP_SHARED mappings are not practical on files that are on
     devices or filesystems that aren't directly mappable (disks and NFS vs
     memory and flash).

 (6) PROT_WRITE/MAP_PRIVATE mappings cannot practically be made to follow
     changes to the backing file.

Point (4) is the most difficult one, I think.

> but it is a fundamental assumption that the sharing happen in the page cache.

A fundamental assumption where?  There's no requirement for an O/S to work by
having a page cache.

> I.e. The pages that are in the page cache are the only ones that can be
> effectively shared.

That's not actually so.  Character devices don't generally exist in the page
cache, for example.  In fact, IIRC, SYSV SHM used to work without touching the
page cache (I may be wrong on that).

Remember also, you're on a NOMMU system: we might have to bend some of the
rules.

> As a corollary if a page is not in the page cache it should not be
> shared.  I guess this limits sharing to just those things in ramfs?

That's nasty, and also unnecessary.  It also prohibits XIP, btw.

> You obviously don't have the hardware to enforce this

The main point is not that you don't have h/w to enforce protection, it's that
you may not have h/w to do virtual address mappings.

> but at least you can define the sharing of anything else as undefined.

Why would I want to do that?

> Now I don't know what it takes from your data structures to achieve
> sharing of page cache pages.  Or what your underlying complications
> are.  Not having the page cache as the fundamental underlying sharing
> pool is strongly non-intuitive from the perspective of the rest
> of linux.

Again, you're on a NOMMU system.  Actually, as it stands, what I have here
seems to work pretty well.  There isn't much that doesn't work.  fork() doesn't
work (it's just too impractical) and it turns out that SYSV SHM only mostly
works (grrr).

> >> My gut feel says just keep a vma per process of the regions the process
> >> has and do the appropriate book keeping and all will be fine.
> >
> > I'm sure it will be, but at the cost of consuming extra memory.  I'm not
> > sure that the amount of extra memory is, however, all that significant.
> > Now that I think about it, I don't imagine that a lot of processes are
> > going to be running at once on a NOMMU system, and so the scope for sharing
> > isn't all that wide.
> 
> Sure.  But this is sharing with the kernel as well.

What do you mean by that?

> And you always have at least one kernel and one application.

Actually, that's not so.  I seem to recall some router thing where userspace
used to just exit completely, leaving the kernel to run alone.

> So if they can share the file buffers that is a win.

Yes, it's a win, but there are also problems with doing so, most particularly
contiguity.

> And what mmap of any file backed pages is expected to provide.

I think it's reasonable to say that a read-only MAP_PRIVATE mapping need not
follow the backing file in NOMMU mode.  Note that it's close to impossible to
do this for a writable MAP_PRIVATE mapping, even though that's the expected
behaviour if it hasn't been written through.

Out of interest, do you know of any application that relies on the behaviour in
which unwritten private mappings follow the backing file?

> Scratch the fork part.  You still aren't calling the open/close
> methods when they would normally be called, and that is where your
> problem lies.

As previously stated, yes, I do realise that.

I think the behaviour I have for sharing R/O private mappings is good enough,
especially as consolidating bits of the pagecache will be a pain, and mostly
unnecessary.

This is NOMMU mode.  Some things are going to have to be different, but almost
all of the MMU functionality is available, just as long as you don't look too
closely.

David
