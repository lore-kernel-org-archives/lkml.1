Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbYEPCut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbYEPCut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 22:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYEPCui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 22:50:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:41826 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYEPCuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 22:50:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,494,1204531200"; 
   d="scan'208";a="282021439"
Subject: Re: [PATCH] kexec based hibernation: a prototype of kexec
	multi-stage load
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <m14p8zgf43.fsf@frodo.ebiederm.org>
References: <1210574441.30365.8.camel@caritas-dev.intel.com>
	 <20080513053408.GA5870@redhat.com>
	 <1210730266.23707.50.camel@caritas-dev.intel.com>
	 <20080514025607.GA19944@redhat.com>
	 <1210736275.23707.62.camel@caritas-dev.intel.com>
	 <m1lk2c4l4i.fsf@frodo.ebiederm.org>
	 <1210827473.23707.133.camel@caritas-dev.intel.com>
	 <m1lk2bs970.fsf@frodo.ebiederm.org>
	 <1210902114.23707.156.camel@caritas-dev.intel.com>
	 <m14p8zgf43.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 16 May 2008 10:56:15 +0800
Message-ID: <1210906575.23707.189.camel@caritas-dev.intel.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 16 May 2008 02:49:45.0392 (UTC) FILETIME=[7F9C3B00:01C8B6FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-15 at 19:25 -0700, Eric W. Biederman wrote:
> "Huang, Ying" <ying.huang@intel.com> writes:
> 
> > On Thu, 2008-05-15 at 11:39 -0700, Eric W. Biederman wrote:
> > [...]
> >> 2) After we figure out our address read the stack pointer from
> >>    a fixed location and simply set it.  (This is my preference)
> >
> > Just for confirmation (My English is poor).
> >
> > Do you mean that kernel A just read the stack top as re-entry point,
> > regardless of whether it is return address or argument 1?
> 
> What I was thinking was:
> 
> In kernel A()
> 
> relocate_new_kernel:
> 
>         ...
> 
>         call	*%eax
> 
> kexec_jump_back_entry:
>         /* This code should be PIC so figure out where we are */
>         call	1f
> 1:
>         popl	%edi
>         subl	$(1b - relocate_kernel), %edi
> 
>         /* Setup a safe stack */
>         leal    PAGE_SIZE(%edi), %esp
>         ...
> 
> 
> Then in purgatory we can read the address of kexec_jump_back_entry
> by examining 0(%esp) and export it in whatever fashion is sane.
> 
> However we reach kexec_jump_back_entry we should be fine.

I think it is reasonable to enable jumping back and forth more than one
time. So the following should be possible:

1. Jump from A to B (actually jump to purgatory, trigger the boot of B)
2. Jump from B to A
3. Jump from A to B again (jump to the kexec_jump_back_entry of B)
4. Jump from B to A
...

So it should be possible to get the re-entry point of kernel B in
kexec_jump_back_entry of kernel A too. So I think in
kexec_jump_back_entry, the caller's stack should be checked to get
re-entry point of peer. And the stack state is different depend on where
come from, from relocate_new_kernel() or return.

Best Regards,
Huang Ying

