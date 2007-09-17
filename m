Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbXIQXJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbXIQXJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 19:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbXIQXJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 19:09:14 -0400
Received: from ozlabs.org ([203.10.76.45]:43318 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbXIQXJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 19:09:13 -0400
Subject: Re: [PATCH 048/104] KVM: Add and use pr_unimpl for standard
	formatting of unimplemented features
From: Rusty Russell <rusty@rustcorp.com.au>
To: Joe Perches <joe@perches.com>
Cc: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <1190045778.19708.211.camel@localhost>
References: <11900179463203-git-send-email-avi@qumranet.com>
	 <11900179481707-git-send-email-avi@qumranet.com>
	 <1190045778.19708.211.camel@localhost>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 09:08:20 +1000
Message-Id: <1190070500.7262.150.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-17 at 09:16 -0700, Joe Perches wrote:
> On Mon, 2007-09-17 at 10:31 +0200, Avi Kivity wrote:
> > diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
> > index cfda3ab..6d25826 100644
> > --- a/drivers/kvm/kvm.h
> > +++ b/drivers/kvm/kvm.h
> > @@ -474,6 +474,14 @@ struct kvm_arch_ops {
> >  
> >  extern struct kvm_arch_ops *kvm_arch_ops;
> >  
> > +/* The guest did something we don't support. */
> > +#define pr_unimpl(vcpu, fmt, ...)					\
> > + do {									\
> > +	if (printk_ratelimit())						\
> > +		printk(KERN_ERR "kvm: %i: cpu%i " fmt,			\
> > +		       current->tgid, (vcpu)->vcpu_id , ## __VA_ARGS__); \
> > + } while(0)
> > +
> >  #define kvm_printf(kvm, fmt ...) printk(KERN_DEBUG fmt)
> >  #define vcpu_printf(vcpu, fmt...) kvm_printf(vcpu->kvm, fmt)
> >  
> 
> This converts all KERN_<level> uses to KERN_ERR.
> It seems better to add a <level> argument to kvm_printf.
> pr_unimpl is perhaps a poor name choice.
> perhaps vcpu_printk_ratelimit(vcpu, level, fmt, ...)

Possibly, but remember that printk() is an admission of failure.  It's
only useful to developers, and the only reason for printk over
pr_debug() is for users to report to developers when guests crash.

pr_unimpl() means exactly what it says: the guest asked for something we
don't support.  If that turns out to be the last thing in the logs
before a crash, it's a clue.  The rest of the printks should probably
move to pr_debug().

Hope that helps,
Rusty.

