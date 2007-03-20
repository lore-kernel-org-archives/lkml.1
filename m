Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbXCTQtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbXCTQtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXCTQtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:49:12 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35718 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbXCTQtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:49:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Howells <dhowells@redhat.com>
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
References: <m1wt1dvxzu.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0703152043290.24211@blonde.wat.veritas.com>
	<3378.1173204813@redhat.com>
	<Pine.LNX.4.64.0703051843030.10272@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0703021646050.13167@blonde.wat.veritas.com>
	<20070216165042.GB409@lnx-holt.americas.sgi.com>
	<45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com>
	<20368.1171638335@redhat.com> <18817.1171656543@redhat.com>
	<29317.1172931029@redhat.com> <12852.1173449522@redhat.com>
	<12838.1173998825@redhat.com> <11772.1174388792@redhat.com>
Date: Tue, 20 Mar 2007 10:48:04 -0600
In-Reply-To: <11772.1174388792@redhat.com> (David Howells's message of "Tue,
	20 Mar 2007 11:06:32 +0000")
Message-ID: <m1bqinsvy3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> As I understand your description for non-shared mappings the VMAs are
>> per process.
>
> Are you talking about the current state of play?  If so, not precisely.  In
> the current scheme of things, *all* VMAs are kept in a global tree and are
> globally available; it's just that any VMA that's not shareable will not be
> shared, and so, in effect, is per-process.
>
> In my suggested revamp, VMAs revert to being per-process objects only, and
> sharing is effected by indirection.

Ok, and I do think per process VMAs are the way to go if you are
going to stay anywhere close to the rest of linux.

>> For shared mappings you share in some sense the page cache.
>
> Currently, no - not unless the driver does something clever as ramfs does.
> Sharing through the page cache is a nice idea, but it has some limitations,
> mainly that non-sharing then operates differently.

I don't quite what your limitations are but it is a fundamental
assumption that the sharing happen in the page cache.  I.e. The pages
that are in the page cache are the only ones that can be effectively
shared.

As a corollary if a page is not in the page cache it should not be
shared.  I guess this limits sharing to just those things in ramfs?

You obviously don't have the hardware to enforce this but at least
you can define the sharing of anything else as undefined.

Now I don't know what it takes from your data structures to achieve
sharing of page cache pages.  Or what your underlying complications
are.  Not having the page cache as the fundamental underlying sharing
pool is strongly non-intuitive from the perspective of the rest
of linux.

>> My gut feel says just keep a vma per process of the regions the
>> process has and do the appropriate book keeping and all will be fine.
>
> I'm sure it will be, but at the cost of consuming extra memory.  I'm not sure
> that the amount of extra memory is, however, all that significant.  Now that I
> think about it, I don't imagine that a lot of processes are going to be
> running at once on a NOMMU system, and so the scope for sharing isn't all that
> wide.

Sure.  But this is sharing with the kernel as well.  And you always
have at least one kernel and one application.  So if they can share
the file buffers that is a win.  And what mmap of any file backed
pages is expected to provide.

>> For shm_nattach it looks like you simply are not calling the
>> open/close methods on fork (because you have a shared pool of vmas).
>
> There is no fork.

Scratch the fork part.  You still aren't calling the open/close
methods when they would normally be called, and that is where your
problem lies.

> No, the problem is that sys_shmat() relies on do_mmap_pgoff() to call the VMA
> open() method.  However, this assumes that a new VMA will be made
> per process.

Exactly.

Eric

