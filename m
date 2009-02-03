Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbZBCRLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbZBCRLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbZBCRLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:11:23 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:46004 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbZBCRLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:11:20 -0500
Date: Tue, 3 Feb 2009 17:10:08 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mikos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 file segments
In-Reply-To: <1233677610.15321.129.camel@lts-notebook>
Message-ID: <Pine.LNX.4.64.0902031659070.5131@blonde.anvils>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com> 
 <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain> 
 <1233259410.2315.75.camel@lts-notebook>  <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>
  <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain> 
 <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com> 
 <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain> 
 <20090130055639.GA30950@suse.de>  <alpine.LFD.2.00.0901300811260.3150@localhost.localdomain>
  <Pine.LNX.4.64.0901301724010.1563@blonde.anvils> 
 <alpine.LFD.2.00.0901300946360.3150@localhost.localdomain> 
 <1233345190.908.36.camel@lts-notebook>  <alpine.LFD.2.00.0901301159500.3150@localhost.localdomain>
  <Pine.LNX.4.64.0901302048360.18677@blonde.anvils>  <1233351412.908.69.camel@lts-notebook>
  <alpine.LFD.2.00.0901301426390.3150@localhost.localdomain> 
 <Pine.LNX.4.64.0901311216250.6763@blonde.anvils> <1233677610.15321.129.camel@lts-notebook>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, Lee Schermerhorn wrote:
> On Sat, 2009-01-31 at 12:35 +0000, Hugh Dickins wrote:
> > We need a way to communicate not-MAP_NORESERVE to shmem.c, and we don't
> > just need it in the explicit shmem_zero_setup() case, we also need it
> > for the (probably rare nowadays) case when mmap() is working on file
>           ^^^^^^^^^^^^^^^^^^^^^^^^
> > /dev/zero (drivers/char/mem.c mmap_zero()), rather than using MAP_ANON.
> 
> 
> This reminded me of something I'd seen recently looking
> at /proc/<pid>/[numa]_maps for <a large commercial database> on
> Linux/x86_64: 
>...
> 2adadf711000-2adadf721000 rwxp 00000000 00:0e 4072                       /dev/zero
> 2adadf721000-2adadf731000 rwxp 00000000 00:0e 4072                       /dev/zero
> 2adadf731000-2adadf741000 rwxp 00000000 00:0e 4072                       /dev/zero
> 
> <and so on, for another 90 lines until>
> 
> 7fffcdd36000-7fffcdd4e000 rwxp 7fffcdd36000 00:00 0                      [stack]
> ffffffffff600000-ffffffffffe00000 ---p 00000000 00:00 0                  [vdso]
> 
> For portability between Linux and various Unix-like systems that don't
> support MAP_ANON*, perhaps?
> 
> Anyway, from the addresses and permissions, these all look potentially
> mergeable.  The offset is preventing merging, right?  I guess that's one
> of the downsides of mapping /dev/zero rather than using MAP_ANONYMOUS?
> 
> Makes one wonder whether it would be worthwhile [not to mention
> possible] to rework mmap_zero() to mimic MAP_ANONYMOUS...

That's certainly an interesting observation, and thank you for sharing
it with us (hmm, I sound like a self-help group leader or something).

I don't really have anything to add to what Linus said (and hadn't
got around to realizing the significance of the "p" there before I
saw his reply).

Mmm, it's interesting, but I fear to add more hacks in there just
for this - I guess we could, but I'd rather not, unless it becomes
a serious issue.

Let's just tuck away the knowledge of this case for now.

Hugh
