Return-Path: <linux-kernel-owner+w=401wt.eu-S1756607AbZA3Enu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbZA3Enu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 23:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZA3Enl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 23:43:41 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:23828 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbZA3Enl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 23:43:41 -0500
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent
	VM_LOCKED file segments
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0901291448360.3054@localhost.localdomain>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>
	 <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>
	 <1233259410.2315.75.camel@lts-notebook>
	 <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>
	 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>
	 <Pine.LNX.4.64.0901292200220.17808@blonde.anvils>
	 <alpine.LFD.2.00.0901291448360.3054@localhost.localdomain>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 29 Jan 2009 23:43:40 -0500
Message-Id: <1233290620.2315.113.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 15:02 -0800, Linus Torvalds wrote:
> 
> On Thu, 29 Jan 2009, Hugh Dickins wrote:
> > 
> > The problem has always been that file->f_op->mmap(file, vma) on a
> > special file can do various strange things, changing surprising
> > fields of the struct vma passed to it, changing its mergeability.
> 
> Ahh, you're right. That's somewhat bogus, but it does explain why we have 
> those two separate merge_vma() calls.
> 
> And as you also point out:
> 
> > Now it may well be that every driver which does something strange
> > there already sets one of the VM_SPECIAL flags which prevent merging,
> > or can easily be fixed to do so, or otherwise clearly cannot pose a
> > problem.
> 
> .. and I think this is the right answer. If a device driver really does 
> something as odd as play games with the offset that would make merging 
> wrong, it had better set some of the VM_SPECIAL bits (presumably VM_IO) in 
> order to never merge at all.

Just want to note that install_special_mappings()--used for, e.g., the
vdso--sets VM_DONTEXPAND [one of the VM_SPECIAL flags] which, if we want
to prevent merging, makes a lot of sense to me.  It appears that
get_user_pages() will balk at addresses in vmas with VM_IO [and
VM_PFNMAP] which might not be what one wants.  For example, you can't
pre-populate the ptes via make_pages_present() with this flag.

Lee

