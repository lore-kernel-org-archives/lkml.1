Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbZA3W2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbZA3W2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZA3W2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:28:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142AbZA3W2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:28:10 -0500
Date: Fri, 30 Jan 2009 14:27:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Hugh Dickins <hugh@veritas.com>, Greg KH <gregkh@suse.de>,
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
In-Reply-To: <1233351412.908.69.camel@lts-notebook>
Message-ID: <alpine.LFD.2.00.0901301426390.3150@localhost.localdomain>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>  <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>  <1233259410.2315.75.camel@lts-notebook>  <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain> 
 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>  <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com>  <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain>  <20090130055639.GA30950@suse.de>  <alpine.LFD.2.00.0901300811260.3150@localhost.localdomain>
  <Pine.LNX.4.64.0901301724010.1563@blonde.anvils>  <alpine.LFD.2.00.0901300946360.3150@localhost.localdomain>  <1233345190.908.36.camel@lts-notebook>  <alpine.LFD.2.00.0901301159500.3150@localhost.localdomain>  <Pine.LNX.4.64.0901302048360.18677@blonde.anvils>
 <1233351412.908.69.camel@lts-notebook>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 30 Jan 2009, Lee Schermerhorn wrote:
> 
> I just verified that adding VM_ACCOUNT to VM_MERGEABLE does allow the
> merge to happen with the test program.  And the system didn't come
> crashing down around me.  But, I wouldn't trust that simple test as the
> last word.  A short run of a stress load I use held up/still running,
> but I can't tell whether it's merging as expected there.   

Just ignoring VM_ACCOUNT for merging is not the right thing to do. It 
probably works in practice for just about everything, but at least in 
theory it does mean that mmap() can stop honoring MAP_NORESERVE.

Admittedly the circumstances where that happens are unlikely, and nobody 
probably even really uses MAP_NORESERVE in the first place, so I doubt you 
can ever see it as a real issue, but it's still technically wrong to merge 
vma's that can differ in VM_ACCOUNT.

Now, the particular test you have, VM_ACCOUNT differs only during that 
temporary window, and the vma's really do end up with the same VM_ACCOUNT 
state in the end, so merging them is correct, but if you were to privately 
map the same file (or private anonymous map) with the same permissions 
next to each other so that they -could- merge, but use MAP_NORESERVE on 
one and not on the other, then they shouldn't merge.

So VM_ACCOUNT does matter - just barely - for merging, and we just happen 
to currently hit it too much due to a very odd internal reason.

		Linus
