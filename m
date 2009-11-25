Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbZKYQqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbZKYQqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 11:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758825AbZKYQqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 11:46:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758823AbZKYQqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 11:46:00 -0500
Date: Wed, 25 Nov 2009 11:44:34 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Haley <aph@redhat.com>,
       "H.J. Lu" <hjl.tools@gmail.com>, rostedt@goodmis.org,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Guenther <richard.guenther@gmail.com>, gcc <gcc@gcc.gnu.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL][v2.6.32] tracing/x86: Add check to detect GCC messing with mcount prologue
Message-ID: <20091125164434.GS22813@hs20-bc2-1.build.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <1258736456.22249.1032.camel@gandalf.stny.rr.com> <4B06EF6F.2050507@redhat.com> <6dc9ffc80911220138y15bfa91agccf5c29f1c30e09a@mail.gmail.com> <4B0972C9.302@redhat.com> <6dc9ffc80911221530t38d83cf6je739743c8d756667@mail.gmail.com> <4B0BF119.4070704@redhat.com> <alpine.LFD.2.00.0911241555170.24119@localhost.localdomain> <20091124150604.GJ22813@hs20-bc2-1.build.redhat.com> <alpine.LFD.2.00.0911251604280.24119@localhost.localdomain> <20091125154452.GA9456@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125154452.GA9456@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 04:44:52PM +0100, Ingo Molnar wrote:
> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Tue, 24 Nov 2009, Jakub Jelinek wrote:
> > 
> > > On Tue, Nov 24, 2009 at 03:55:49PM +0100, Thomas Gleixner wrote:
> > > > > you should compile your code with -maccumulate-outgoing-args, and there's
> > > > > no need to use -mtune=generic.  Is that right?
> > > > 
> > > > Seems to work. What other side effects has that ?
> > > 
> > > Faster code, significant increase in code size though.  Note that on many
> > > architectures it is the only supported model.
> > 
> > Just checked on the affected -marchs. The increase in code size is 
> > about 3% which is not that bad and definitely acceptable for the 
> > tracing case. Will zap the -mtune=generic patch and use 
> > -maccumulate-outgoing-args instead.
> 
> hm, 3% sounds quite large :( dyn-ftrace is enabled in distro configs, so 
> 3% is a big deal IMO.

If you compile kernels 90%+ people out there run with -p on i?86/x86_64,
then certainly coming up with a new gcc switch and new profiling ABI is
desirable.  -p on i?86/x86_64 e.g. forces -fno-omit-frame-pointer, which
makes code on these register starved arches significantly worse.
Making GCC output profiling call before prologue instead of after prologue
is a 4 liner in generic code and a few lines in target specific code.
The important thing is that we shouldn't have 100 different profiling ABIs,
so it is desirable to agree on something that will be generally useful not
just for the kernel, but perhaps for other purposes.

	Jakub
