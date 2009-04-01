Return-Path: <linux-kernel-owner+w=401wt.eu-S1758398AbZDABGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbZDABGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZDABGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:06:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:63063 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZDABGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:06:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ry/XYP1vVxZ3rNMS65GdkgNUJ1YPbrwQ+QnF4H8jjVl5xrT97doXotaAGAnE/mrTFK
         jfb13Xxny29qmzHPcH9GkVXz5pPSu0urzImu3kHNdj/o3YsUOlqeeu6tRziqSss4pGTK
         9TOQKXFkSh8LdvY+emilkdlpwAjwwTCFV2kes=
Date: Wed, 1 Apr 2009 05:13:44 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, dhowells@redhat.com,
       ebiederm@xmission.com, hch@lst.de
Subject: Re: + mm-remove-struct-mm_struct-exe_file-et-al.patch added to -mm
	tree
Message-ID: <20090401011344.GB22398@x200.localdomain>
References: <200903302344.n2UNi3xd027136@imap1.linux-foundation.org> <20090331144051.GA3951@redhat.com> <20090401003223.GH29821@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401003223.GH29821@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 05:32:23PM -0700, Matt Helsley wrote:
> On Tue, Mar 31, 2009 at 04:40:51PM +0200, Oleg Nesterov wrote:
> > s/mm-commits/lkml/
> > 
> > On 03/30, Andrew Morton wrote:
> > >
> > > From: Alexey Dobriyan <adobriyan@gmail.com>
> > >
> > > Commit 925d1c401fa6cfd0df5d2e37da8981494ccdec07 ("procfs task exe
> > > symlink").  introduced struct mm_struct::exe_file and struct
> > > mm_struct::num_exe_file_vmas.
> > >
> > > The rationale is weak: unifying MMU and no-MMU version of /proc/*/exe
> > > code.  For this a) struct mm_struct becomes bigger, b) mmap/munmap/exit
> > > become slower, c) patch adds more code than removes in fact.
> > >
> > > ->exe_file maybe well defined, but doesn't make sense always.  After
> > > original executable is unmapped, /proc/*/exe will still report it and,
> > > more importantly, pin corresponding struct file.
> > 
> > I never liked the change which introduced mm->exe_file, so I vote for
> > this patch.
> > 
> > But, as a advocatus diaboli... There was anotrher reason for ->exe_file,
> > iirc.
> > 
> > bprm->file->f_op->mmap() can change vma->vm_file, this means proc_exe_link()
> > can report the "wrong" path. The original file is not pinned in this case.
> > 
> > Matt?
> 
> That's _my_ reason for it. However no mainline code does that and hence it was
> not the reason Andrew accepted it.
> 
> I still prefer ->exe_file because I think it's a win not to walk the
> VMAs with mmap sem when doing a readlink on /proc/*/exe.

readlink on /proc/*/exe is rare, so nobody cares. ps(1) and top(1) here
don't readlink it, e. g. Number of vmas is usually small enough and, as
was mentioned, file is mapped low, so it'd be among the first VMAs.

> It's also less sensitive to the order in which VMAs appear should that ever
> change.
