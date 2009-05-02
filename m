Return-Path: <linux-kernel-owner+w=401wt.eu-S1759897AbZEBWIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897AbZEBWIO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 18:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757340AbZEBWH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 18:07:57 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:38347 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbZEBWH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 18:07:56 -0400
Date: Sun, 3 May 2009 00:10:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Helge Deller <deller@gmx.de>
Cc: Tim Abbott <tabbott@MIT.EDU>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Kyle McMartin <kyle@mcmartin.ca>,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH 3/5] parisc: use new macros for .data.init_task.
Message-ID: <20090502221006.GA4309@uranus.ravnborg.org>
References: <1241135719-9286-1-git-send-email-tabbott@mit.edu> <1241135719-9286-2-git-send-email-tabbott@mit.edu> <1241135719-9286-3-git-send-email-tabbott@mit.edu> <1241135719-9286-4-git-send-email-tabbott@mit.edu> <49FBD681.9080605@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FBD681.9080605@gmx.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 07:13:37AM +0200, Helge Deller wrote:
> Tim Abbott wrote:
> > .data.init_task should not need a separate output section; this change
> > moves it into the .data section.
> > 
> > Signed-off-by: Tim Abbott <tabbott@mit.edu>
> > Cc: Kyle McMartin <kyle@mcmartin.ca>
> > Cc: Helge Deller <deller@gmx.de>
> > Cc: linux-parisc@vger.kernel.org
> 
> 
> I think this patch is wrong, although it is theoretically correct.
> 
> IIRC, gcc on hppa is not able to provide an alignment >= 8k, which is
> why we have done the 16k alignment inside the linker script.
> So, I think this change will prevent the parisc kernel to boot up.
> Needs testing.

The patch does not do much...

> 
> Helge
> 
> > ---
> >  arch/parisc/kernel/init_task.c   |    2 +-
> >  arch/parisc/kernel/vmlinux.lds.S |   10 ++--------
> >  2 files changed, 3 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/parisc/kernel/init_task.c b/arch/parisc/kernel/init_task.c
> > index 1e25a45..8ee17ea 100644
> > --- a/arch/parisc/kernel/init_task.c
> > +++ b/arch/parisc/kernel/init_task.c
> > @@ -48,7 +48,7 @@ EXPORT_SYMBOL(init_mm);
> >   * "init_task" linker map entry..
> >   */
> >  union thread_union init_thread_union
> > -	__attribute__((aligned(128))) __attribute__((__section__(".data.init_task"))) =
> > +	__attribute__((aligned(128))) __init_task_data =
> >  		{ INIT_THREAD_INFO(init_task) };
This is a simple replacement with a nicer way to say "this belongs to
the .data.init_task section - no functional difference.


> >  
> >  #if PT_NLEVELS == 3
> > diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
> > index b5936c9..c8a528d 100644
> > --- a/arch/parisc/kernel/vmlinux.lds.S
> > +++ b/arch/parisc/kernel/vmlinux.lds.S
> > @@ -103,6 +103,8 @@ SECTIONS
> >  	. = ALIGN(L1_CACHE_BYTES);
> >  	/* Data */
> >  	.data : {
> > +		/* assembler code expects init_task to be 16k aligned */
> > +		INIT_TASK_DATA(16384)
> >  		NOSAVE_DATA
> >  		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
> >  		DATA_DATA
> > @@ -133,14 +135,6 @@ SECTIONS
> >  	}
> >  	__bss_stop = .;
> >  
> > -
> > -	/* assembler code expects init_task to be 16k aligned */
> > -	. = ALIGN(16384);
> > -	/* init_task */
> > -	.data.init_task : {
> > -		*(.data.init_task)
> > -	}
> > -
This part moves away from a specific output section to including this in the
.data output section - with the _same_ alignmnet.
So the only issue here is that we move init_task before NOSAVE_DATA etc.

I do not see why you think this changes alignmnet?

	Sam
