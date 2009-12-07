Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbZLGSoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbZLGSoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758555AbZLGSoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:44:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44078 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758503AbZLGSod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:44:33 -0500
Date: Mon, 7 Dec 2009 18:44:38 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/19] untangling do_mremap(), part 1
Message-ID: <20091207184438.GH14381@ZenIV.linux.org.uk>
References: <E1NHUdk-0007ul-Oc@ZenIV.linux.org.uk> <alpine.LFD.2.00.0912070911290.3560@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912070911290.3560@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 09:17:40AM -0800, Linus Torvalds wrote:
> 
> Al, 
>  just checking: do you think this is ready for merging now? The lack of 
> RFC seems to imply it is, but I don't see the Ack's from David from your 
> previous series, for example.

Which David? ;-)  All sparc-related bits seem to have been ACKed by
davem.

Hugetlbfs tests seem to be OK with this series, but there's an odd
thing going on - expanding mremap() crossing into hugepage range on
ppc takes a while to convert it into 4Kb pages.  Fair enough, but
it seems to work _much_ faster if the process is ptraced.  NFI why;
waiting for dgw to get around to profiling it...

I'd love to see comments from ia64 and s390 folks, actually.

Known issues:
	* expand_stack() one.  Missing checks, not obvious which way to
deal with that.  Same as in mainline.  Itanic and sparc32 are killable
by that, on itanic with hw 32bit support it looks even nastier (likely
escalation to execution of user code in ring 0).
	* remap_file_pages() seems to ignore any alignment rules; it
is OK wrt to address range (it works on existing vma), but cache
coherency might be buggered.  Same as in mainline.
	* spufs (ppc cell stuff) does 64Kb-paged mappings; what happens
upon mremap() and friends?  VM_HUGETLB will *not* be set on it, so the
usual checks in mm/* are going to miss.  _Probably_ unchanged compared
to mainline, but I'd really like to understand how it's supposed to work.
