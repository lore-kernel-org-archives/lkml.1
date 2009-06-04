Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbZFDILF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbZFDILF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZFDIKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:10:48 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39750 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZFDIKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:10:47 -0400
Date: Thu, 4 Jun 2009 01:10:46 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/9] exec_path 1/9: introduce ->exec_path and switch
	/proc/*/exe
Message-ID: <20090604081046.GV9285@us.ibm.com>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <20090603230422.GB853@x200.localdomain> <20090604075532.GU9285@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604075532.GU9285@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 12:55:32AM -0700, Matt Helsley wrote:
> On Thu, Jun 04, 2009 at 03:04:22AM +0400, Alexey Dobriyan wrote:
> > On Sun, May 31, 2009 at 03:19:53PM -0700, Andrew Morton wrote:
> > > On Mon, 1 Jun 2009 01:54:27 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > > 
> > > > And BTW, there is something unnatural when executable path is attached
> > > > to mm_struct(!) not task_struct,
> > > 
> > > mm_struct is the central object for a heavyweight process.  All threads
> > > within that process share the same executable path (don't they?) so
> > > attaching the executable path to the mm seems OK to me.
> > 
> > OK, let's try this:
> > 
> > 
> > [PATCH 1/9] exec_path 1/9: introduce ->exec_path and switch /proc/*/exe
> > 
> > ->exec_path marks executable which is associated with running task.
> > Binfmt loader decides which executable is such and can, in theory,
> > assign anything. Unlike current status quo when first VM_EXECUTABLE mapping is
> > sort of marks running executable.
> > 
> > If executable unmaps its all VM_EXECUTABLE mappings, /proc/*/exe ceases
> > to exists, ick! And userpsace can't even use MAP_EXECUTABLE.
> 
> Suprising but intentional and unavoidable. More below..
> 
> > 
> > Tasks which aren't created by running clone(2) and execve(2)
> > (read: kernel threads) get empty ->exec_path and
> > 
> > ->exec_path is copied on clone(2) and put at do_exit() time.
> 
> Doesn't this pin the vfs mount of the executable for the lifetime of
> the task?
> 
> That was one of Al Viro's objections to early revisions of the exe_file
> patches. It's the reason the exe_file patches kept track of the number of
> VM_EXECUTABLE mappings with num_exe_file_vmas.
> 
> I've cc'd Al so he can confirm/deny my recollection of this. Basically
> some programs need to be able to umount the filesystem that back their
> executables. Being able to unmap these regions was effectively a
> userspace API for unpinning these mounts. I needed to preserve that API,
> hence the VMA ugliness of exe_file that you object to with the exe_file
> patches.
> 
> I think patches 2-7 look great and could be adapted to use exe_file instead
> of ->exec_path.

Well, except 5 and 6.

Alternately, I think you could use the same VMA code with ->exec_path to avoid
pinning the vfs mount. However, then it would probably be best to move
it into the mm just like exe_file...

> 
> Cheers,
> 	-Matt Helsley
