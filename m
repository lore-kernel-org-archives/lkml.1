Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbYKERxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbYKERxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbYKERxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:53:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43741 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478AbYKERxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:53:12 -0500
Date: Wed, 5 Nov 2008 15:52:35 -0200
From: Eduardo Habkost <ehabkost@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/16] x86: Emergency virtualization disable function
Message-ID: <20081105175235.GJ5247@blackpad>
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com> <1225810364-8990-9-git-send-email-ehabkost@redhat.com> <m1bpwu3wod.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bpwu3wod.fsf@frodo.ebiederm.org>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 09:33:06AM -0800, Eric W. Biederman wrote:
> Eduardo Habkost <ehabkost@redhat.com> writes:
> 
> > +int set_virt_disable_func(void (*fn)(void))
> > +{
> > +	int r = 0;
> > +
> > +	spin_lock(&virt_disable_lock);
> > +	if (!virt_disable_fn)
> > +		rcu_assign_pointer(virt_disable_fn, fn);
> > +	else
> > +		r = -EEXIST;
> > +	spin_unlock(&virt_disable_lock);
> > +
> > +	return r;
> > +}
> > +EXPORT_SYMBOL(set_virt_disable_func);
> 
> EXPORT_SYMBOL_GPL?
> 
> > +EXPORT_SYMBOL(clear_virt_disable_func);
> EXPORT_SYMBOL_GPL?
> 
> We are talking a core internal api that should not even
> be exported if KVM is compiled into the kernel.
> 
> I have had to tell people NO too many times by that
> wanted to shove code on the kexec on panic path that
> had no business there.  I do not want to give
> the least little impression that this is an ok hook
> for the to use.  The very specific name helps in
> that regard thank you for that.  Having the symbol
> exported GPL would help even more.

Agreed. I will change that if nobody else objects.

> 
> Overall I think the code is just barely ok.
> 
> I don't like the fact that to run 2-3 instructions per cpu we are two
> function pointers deep.  It feels like we have an excess of
> abstraction here on the kvm side.
> 
> Is it possible to have the individual kvm modules call
> set_virt_disable_func and clear_virt_disable_func?  Instead
> of going through the x86_kvm_ops?
> 
> It really feels like we have an excess of abstraction here.

We could move the set_virt_disable_func() calls to vmx.c and svm.c (on
hardware_setup/hardware_unsetup). One could argue that it is sort of a
coincidence that we need the code for both vmx and svm.

Avi, what do you think?

-- 
Eduardo
