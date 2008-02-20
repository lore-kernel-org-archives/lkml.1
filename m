Return-Path: <linux-kernel-owner+w=401wt.eu-S1757846AbYBTECt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbYBTECt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 23:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYBTECj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 23:02:39 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:52424 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYBTECi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 23:02:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LdxlUT6Qm4lCjDijT37JQj9INgnxNrFSvSwmbcRMGWYOOYBcnQhU1bVsenEFCwR0caRUHmSRtbb2ZLpvFs9SQ02M2d9Fkb9++TNELCGYn/9VzU7OLDIlJTYJYHOnU+9d/Tbug+IKXDZtANCMoCp8Tlm0VCZ0k0utDpO2cS8todg=
Message-ID: <8bd0f97a0802192002o3446901dh9140dd166af0f1e@mail.gmail.com>
Date: Tue, 19 Feb 2008 23:02:35 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Matt Helsley" <matthltc@us.ibm.com>
Subject: Re: [PATCH] procfs task exe symlink
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, "Oleg Nesterov" <oleg@tv-sign.ru>,
       "David Howells" <dhowells@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Christoph Hellwig" <chellwig@de.ibm.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>, "Hugh Dickins" <hugh@veritas.com>,
       "Bryan Wu" <Bryan.Wu@analog.com>
In-Reply-To: <1203458065.7408.27.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202348669.9062.271.camel@localhost.localdomain>
	 <8bd0f97a0802160412ve49103cya446b89d8560458b@mail.gmail.com>
	 <1203458065.7408.27.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 4:54 PM, Matt Helsley <matthltc@us.ibm.com> wrote:
> On Sat, 2008-02-16 at 07:12 -0500, Mike Frysinger wrote:
> > On Feb 6, 2008 8:44 PM, Matt Helsley <matthltc@us.ibm.com> wrote:
> > > The kernel implements readlink of /proc/pid/exe by getting the file from the
> > > first executable VMA. Then the path to the file is reconstructed and reported as
> > > the result.
> > >
> > > Because of the VMA walk the code is slightly different on nommu systems. This
> > > patch avoids separate /proc/pid/exe code on nommu systems. Instead of walking
> > > the VMAs to find the first executable file-backed VMA we store a reference to
> > > the exec'd file in the mm_struct.
> > >
> > > That reference would prevent the filesystem holding the executable file from
> > > being unmounted even after unmapping the VMAs. So we track the number of
> > > VM_EXECUTABLE VMAs and drop the new reference when the last one is unmapped.
> > > This avoids pinning the mounted filesystem.
> > >
> > > Andrew, these are the updates I promised. Please consider this patch for
> > > inclusion in -mm.
> >
> > mm/nommu.c wasnt compiled tested, it's trivially broken:
>
> Thanks for the report. I've looked into this and the "obvious" fix,
> using vma->vm_mm, isn't correct since it's never set. This means the
> portions of the procfs task exe symlink patch using vma->vm_mm in
> mm/nommu.c are incorrect.
>
> The patch below attempts to fix this by using current->mm during mmap
> and passing the current mm to put_vma() as well.
>
> Mike, does this patch fix the compile problem(s)?

thanks, that does fix compiling.

> Mike, I don't have a nommu compile or test environment. I have yet
> to to generate a good CONFIG_MMU=n config on i386 (got one?). Since I
> don't have any nommu hardware I'm also looking into using qemu. It looks
> like I may need to build my own image from scratch. Do you have any
> recommendations on testing nommu configs without hardware?

it should be easy to cross-compile a kernel for the Blackfin
processor, but there is no qemu port.  the Blackfin port is the only
one ive done with no-mmu, so i cant comment on any other port.
-mike
