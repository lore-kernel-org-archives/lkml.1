Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbZKEUst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbZKEUst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 15:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758858AbZKEUst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 15:48:49 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37515 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758848AbZKEUss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:48:48 -0500
Date: Thu, 5 Nov 2009 15:48:43 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
	external to a process (v7)
Message-ID: <20091105204843.GA2980@hmsreliant.think-freely.org>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091012161342.GA32088@hmsreliant.think-freely.org> <20091012201304.GG32088@hmsreliant.think-freely.org> <20091020005214.GA8886@localhost.localdomain> <20091102152520.GG23776@elte.hu> <20091102175407.GE4075@hmsreliant.think-freely.org> <20091102185137.GA28803@elte.hu> <20091103002355.GB19891@localhost.localdomain> <20091104112632.GA9243@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104112632.GA9243@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.9 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 12:26:32PM +0100, Ingo Molnar wrote:
> 
> * Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > On Mon, Nov 02, 2009 at 07:51:37PM +0100, Ingo Molnar wrote:
> > > 
> > > * Neil Horman <nhorman@tuxdriver.com> wrote:
> > > 
> > > > > Have you ensured that no rlimit gets propagated during task init 
> > > > > into some other value - under the previously correct assumption that 
> > > > > rlimits dont change asynchronously under the feet of tasks?
> > > > 
> > > > I've looked, and the only place that I see the rlim array getting 
> > > > copied is via copy_signal when we're in the clone path.  The 
> > > > entire rlim array is copied from old task_struct to new 
> > > > task_struct under the protection of the current->group_leader task 
> > > > lock, which I also hold when updating via sys_setprlimit, so I 
> > > > think we're safe in this case.
> > > 
> > > I mean - do we set up any data structure based on a particular 
> > > rlimit, that can get out of sync with the rlimit being updated?
> > > 
> > > A prominent example would be the stack limit - we base address 
> > > layout decisions on it. Check arch/x86/mm/mmap.c. RLIM_INFINITY has 
> > > a special meaning plus we also set mmap_base() based on the rlim.
> > 
> > Ah, I didn't consider those.  Yes it looks like some locking might be 
> > needed for cases like that.  what would you suggest, simply grabbing 
> > the task lock before looking at the rlim array?  That seems a bit 
> > heavy handed, especially if we want to use the locking consistently.  
> > What if we just converted the int array of rlimit to atomic_t's?  
> > Would that be sufficient, or still to heavy?

Just to provide a quick update on this, it appears that (unbeknowst to me), 
Jiri Slaby got almost this exact same feature in via the linux-next tree:
commits
ba9ba971a9241250646091935d77d2f31b7c15af
4a4a4e5f51d866284db401ea4d8ba5f0c91cc1eb
c1b9b7eaf7386a7f142d59a2bb433ac8217b0ad1

It still likely needs an audit to make sure theres no race with task access on
the rlimit array, but it doesn't currently require additional security checks
because the only access for a process to another processes limits is by writing
to the /proc/<pid>/limits file, as I had initial proposed.  I think theres still
value in the sysscall, so I'll keep going with that aspect, but the rest of the
work appears done.

Regards

Neil

