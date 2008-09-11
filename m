Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbYIKPim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbYIKPim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYIKPid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:38:33 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54869 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYIKPic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:38:32 -0400
Date: Thu, 11 Sep 2008 10:38:25 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, jeremy@goop.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC v3][PATCH 5/9] Memory managemnet (restore)
Message-ID: <20080911153825.GA26942@us.ibm.com>
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu> <Pine.LNX.4.64.0809040404060.5982@takamine.ncl.cs.columbia.edu> <1220551683.23386.32.camel@nimitz> <48C345D2.1020603@cs.columbia.edu> <1220892596.23386.166.camel@nimitz> <48C6113A.3080804@cs.columbia.edu> <1221082922.6781.62.camel@nimitz> <48C8CAC6.3090209@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C8CAC6.3090209@cs.columbia.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> 
> 
> Dave Hansen wrote:
> > On Tue, 2008-09-09 at 02:01 -0400, Oren Laadan wrote: 
> >>> Have you looked at mprotect_fixup()?  It deals with two things:
> >>> 1. altering the commit charge against RSS if the mapping is actually
> >>>    writable.
> >>> 2. Merging the VMA with an adjacent one if possible
> >>>
> >>> We don't want to do either of these two things.  Even if we do merge the
> >>> VMA, it will be a waste of time and energy since we'll just re-split it
> >>> when we mprotect() again.
> >> Your observation is correct; I chose this interface because it's really
> >> simple and handy. I'm not worried about the performance because such VMAs
> >> (read only but modified) are really rare, and the code can be optimized
> >> later on.
> > 
> > The worry is that it will never get cleaned up, and it is basically
> > cruft as it stands.  People may think that it is here protecting or
> > fixing something that it is not.
> 
> Let me start with the bottom line - since this creates too much confusion,
> I'll just switch to the alternative: will use get_user_pages() to bring
> pages in and copy the data directly. Hopefully this will end the discussion.
> 
> (Note, there there is a performance penalty in the form of extra data copy:
> instead of reading data directly to the page, we instead read into a buffer,
> kmap_atomic the page and copy into the page).
> 
> > 
> >>>>>> +	/* restore original protection for this vma */
> >>>>>> +	if (!(cr_vma->vm_flags & VM_WRITE))
> >>>>>> +		ret = cr_vma_writable(mm, cr_vma->vm_start, cr_vma->vm_end, 0);
> >>>>>> +
> >>>>>> + out:
> >>>>>> +	return ret;
> >>>>>> +}
> >>>>> Ugh.  Is this a security hole?  What if the user was not allowed to
> >>>>> write to the file being mmap()'d by this VMA?  Is this a window where
> >>>>> someone could come in and (using ptrace or something similar) write to
> >>>>> the file?
> >>>> Not a security hole: this is only for private memory, so it never
> >>>> modifies the underlying file. This is related to what I explained before
> >>>> about read-only VMAs that have modified pages.
> >>> OK, so a shared, read-only mmap() should never get into this code path.
> >>> What if an attacker modified the checkpoint file to pretend to have
> >>> pages for a read-only, but shared mmap().  Would this code be tricked?
> >> VMAs of shared maps (IPC, anonymous shared) will be treated differently.
> >>
> >> VMAs of shared files (mapped shared) are saved without their contents,
> >> as the contents remains available on the file system !  (yes, for that
> >> we will eventually need file system snapshots).
> >>
> >> As for an attack that provides an altered checkpoint image: since we
> >> (currently) don't escalate privileges, the attacker will not be able
> >> to modify something that it doesn't have access to in the first place.
> > 
> > I bugged Serge about this.  He said that this, at least, bypasses the SE
> > Linux checks that are normally done with an mprotect() system call.
> > That's a larger design problem that we need to keep in mind: we need to
> > be careful to keep existing checks in place.
> 
> I also discussed this with Serge, and I got the impression that he
> agreed that there was no security issue because it was all and only
> about private memory.

We will want the checks there eventually.  Now it's going to require new
selinux policy to deal with new denials, so in other words we're
basically going to be adding checks which people will be required to
work their way around :)  But we'll still need checks, because it is
bypassing selinux checks, and just because you need to bypass them to
be able to do restart (or run lisp) doesn't mean we can just drop the
checks.

-serge
