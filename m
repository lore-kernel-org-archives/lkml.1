Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbYKERwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbYKERwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:52:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbYKERvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:51:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43701 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbYKERvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:51:50 -0500
Date: Wed, 5 Nov 2008 15:50:05 -0200
From: Eduardo Habkost <ehabkost@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/16] kvm: x86: set kdump virt_disable function on
	initialization
Message-ID: <20081105175004.GI5247@blackpad>
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com> <1225810364-8990-16-git-send-email-ehabkost@redhat.com> <m1od0u3wyq.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1od0u3wyq.fsf@frodo.ebiederm.org>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 09:26:53AM -0800, Eric W. Biederman wrote:
> Eduardo Habkost <ehabkost@redhat.com> writes:
> 
> > Finally implement the virt_disable function for kdump. It will call
> > kvm_x86_ops->crash_hardware_disable(), that will disable virtualization
> > extensions on the CPU if it is not disabled yet.
> >
> > Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> > ---
> >  arch/x86/kvm/x86.c |   19 ++++++++++++++++++-
> >  1 files changed, 18 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 049c6a0..9e61baf 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -40,6 +40,7 @@
> >  #include <asm/msr.h>
> >  #include <asm/desc.h>
> >  #include <asm/mtrr.h>
> > +#include <asm/virtext.h>
> >  
> >  #define MAX_IO_MSRS 256
> >  #define CR0_RESERVED_BITS						\
> > @@ -2581,6 +2582,13 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct
> > kvm_run *run, int in,
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_emulate_pio_string);
> >  
> > +/* Called at crash time, so we can disable virtualization if needed
> > + */
> > +static void crash_hardware_disable(void)
> > +{
> > +	kvm_x86_ops->crash_hardware_disable(NULL);
> > +}
> > +
> >  int kvm_arch_init(void *opaque)
> >  {
> >  	int r;
> > @@ -2605,9 +2613,15 @@ int kvm_arch_init(void *opaque)
> >  
> >  	kvm_x86_ops = ops;
> >  
> > +	r = set_virt_disable_func(crash_hardware_disable);
> 
> Can we make this say:
> set_virt_disable_func(kvm_x86_ops->crash_hardware_disable);
> 
> So we can avoid going through 2 levels of function pointers?
> I find that a little scary in code that might be running
> at the edge of stack overflow.

When I've checked this (on x86_64), gcc did tail recursion optimization
and the call was just a jump to the function, so stack usage shouldn't
be a problem.

But I am inclined to agree with you about the excess of abstraction.

-- 
Eduardo
