Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbYAJHV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbYAJHV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 02:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYAJHVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 02:21:22 -0500
Received: from koto.vergenet.net ([210.128.90.7]:33505 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbYAJHVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 02:21:21 -0500
Date: Thu, 10 Jan 2008 16:21:17 +0900
From: Simon Horman <horms@verge.net.au>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Magnus Damm <magnus.damn@gmail.com>,
       Ian Campbell <Ian.Campbell@xensource.com>
Subject: Re: [PATCH -mm 2/2] kexec/i386: kexec page table code clean up -
	page table setup in C
Message-ID: <20080110072117.GB26821@verge.net.au>
References: <1199847470.8126.16.camel@caritas-dev.intel.com> <20080110010531.GA23143@redhat.com> <1199930889.8752.7.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199930889.8752.7.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ CCing Ian Campbell who handles much of the maintenance of kexec in Xen ]

On Thu, Jan 10, 2008 at 10:08:09AM +0800, Huang, Ying wrote:
> On Wed, 2008-01-09 at 20:05 -0500, Vivek Goyal wrote:
> > On Wed, Jan 09, 2008 at 10:57:50AM +0800, Huang, Ying wrote:
> > > This patch transforms the kexec page tables setup code from asseumbler
> > > code to iC code in machine_kexec_prepare. This improves readability and
> > > reduces code line number.
> > > 
> > 
> > I think this will create issues for Xen. Initially page table setup
> > was in C but Xen Guests could not modify the page tables. I think Xen
> > folks implemented a hypercall where they passed all the page table pages
> > and the control pages and then hypervisor executed the control page(which
> > in turn setup the page tables). I think that's why page table setup
> > code is on the control page in assembly.
> > 
> > You might want to go through Xen kexec implementation and dig through
> > kexec mailing list archive.
> 
> OK, I will check the Xen kexec implementation.
> 
> > CCing Magnus and Horms. They had done the page tables related changes
> > for Xen.

I think that potentially there is a problem here, though weather or
not it manifests is another question.

In machine_kexec() a PAGE_SIZE blob of code starting at relocate_kernel
gets saved. I think that previously x86 Linux excuded this saved blob,
though the current code seems to execute relocate_kernel() directly -
then again perhaps I'm confusing things with ia64 which still executes
the saved blob.

In any case, in the case of xen, the hypervisor will execute this saved
blob. So I think that the crux of the issue is that the blob contains
all the instructions required to run relocate_kernel, then it should
work from inside xen, if and if it doesn't, then i'll blow up.

The code that you have seems to satisfy this requirement,
so relocate_kernel itself shouldn't be a problem. And as
long as the preparation work does exacltly what the removed
portions of relocate_kernel used to do, which it seems to,
things should be fine.

That said, this certainly warrants testing :-)

I'm all in favour of this kind of consolodation,
so hopefully we can bend Xen's will if it doesn't work as is.

Speaking of which, I strongly suspect machine_kexec_32.c and
machine_kexec_64.c an be consolidated a bit.

-- 
Horms

