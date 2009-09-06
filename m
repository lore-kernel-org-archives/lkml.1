Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbZIFNnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbZIFNnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 09:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757950AbZIFNnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 09:43:11 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60391 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757730AbZIFNnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 09:43:10 -0400
Subject: Re: [patch 14/48] KVM: Reduce kvm stack usage in
 kvm_arch_vm_ioctl()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>, Avi Kivity <avi@qumranet.com>
In-Reply-To: <20090906054749.GB1431@ucw.cz>
References: <20090904200712.724048145@mini.kroah.org>
	 <20090904200852.199656362@mini.kroah.org>  <20090906054749.GB1431@ucw.cz>
Content-Type: text/plain
Date: Sun, 06 Sep 2009 06:43:09 -0700
Message-Id: <1252244589.14385.22402.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-06 at 07:47 +0200, Pavel Machek wrote:
> On Fri 2009-09-04 13:07:26, Greg KH wrote:
> > On my machine with gcc 3.4, kvm uses ~2k of stack in a few
> > select functions.  This is mostly because gcc fails to
> > notice that the different case: statements could have their
> > stack usage combined.  It overflows very nicely if interrupts
> > happen during one of these large uses.
> > 
> > This patch uses two methods for reducing stack usage.
> > 1. dynamically allocate large objects instead of putting
> >    on the stack.
> > 2. Use a union{} member for all of the case variables. This
> >    tricks gcc into combining them all into a single stack
> >    allocation. (There's also a comment on this)
> 
> Are the 'reduce stack usage' patches suitable for stable? The rules
> said that fix must be for 'serious problem', not 'theoretical
> issue'...

I guess some context got dropped at some point.  I was getting really
consistent oopses and goofy memory corruption when running KVM:

	http://lkml.org/lkml/2008/3/25/340

Not theoretical at all.  I think it cost me a few new gray hairs.
 
> > Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> > Signed-off-by: Avi Kivity <avi@qumranet.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> >  arch/x86/kvm/x86.c |   72 +++++++++++++++++++++++++++++++++--------------------
> >  1 file changed, 45 insertions(+), 27 deletions(-)
> > 
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1630,6 +1630,15 @@ long kvm_arch_vm_ioctl(struct file *filp
> >  	struct kvm *kvm = filp->private_data;
> >  	void __user *argp = (void __user *)arg;
> >  	int r = -EINVAL;
> > +	/*
> > +	 * This union makes it completely explicit to gcc-3.x
> > +	 * that these two variables' stack usage should be
> > +	 * combined, not added together.
> > +	 */
> > +	union {
> > +		struct kvm_pit_state ps;
> > +		struct kvm_memory_alias alias;
> > +	} u;
> >  
> >  	switch (ioctl) {
> >  	case KVM_SET_TSS_ADDR:
> 
> ...plus this is really ugly hack. Just declare the variable inside the
> case block that needs it?

Do we need to give that a better comment?  It's explained a bit better
here:

http://lkml.org/lkml/2008/7/17/12
http://lkml.org/lkml/2008/7/17/16

Would this comment help?

/*
 * gcc-3.x will sum the stack usage of two stack variables
 * if they are declared in two different case blocks.  This
 * union makes it explicit that their stack space can be
 * shared which greatly reduces stack usage.
 */

-- Dave

