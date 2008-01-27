Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbYA0JmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbYA0JmB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYA0Jlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:41:52 -0500
Received: from 8bytes.org ([88.198.83.132]:44832 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbYA0Jlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:41:51 -0500
Date: Sun, 27 Jan 2008 10:41:47 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 8/8] SVM: add support for Nested Paging
Message-ID: <20080127094147.GA32677@8bytes.org>
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com> <1201294393-22613-9-git-send-email-joerg.roedel@amd.com> <479C464E.2060009@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479C464E.2060009@qumranet.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 10:52:30AM +0200, Avi Kivity wrote:
> Joerg Roedel wrote:
> > This patch contains the SVM architecture dependent changes for KVM to enable
> > support for the Nested Paging feature of AMD Barcelona and Phenom processors.
> >  
> > +#ifdef CONFIG_X86_64
> > +static bool npt_enabled = true;
> > +#else
> >  static bool npt_enabled = false;
> > +#endif
> >   
> 
> I think that i386 + pae can also support npt, with no changes, no?
> 
> So we should check CONFIG_X86_PAE, not X86_64.

Yes, I think that too. But its completly untested so I disabled it for
the first post of this patchset.

> > +
> > +	if (npt_enabled) {
> > +		/* Setup VMCB for Nested Paging */
> > +		control->nested_ctl = 1;
> > +		control->intercept_exceptions &= ~(1 << PF_VECTOR);
> > +		control->intercept_cr_read &= ~(INTERCEPT_CR0_MASK|
> > +						INTERCEPT_CR3_MASK|
> > +						INTERCEPT_CR4_MASK);
> > +		control->intercept_cr_write &= ~(INTERCEPT_CR0_MASK|
> > +						 INTERCEPT_CR3_MASK|
> > +						 INTERCEPT_CR4_MASK);
> >   
> 
> What happens to lazy fpu if we don't trap cr0 changes?
> 
> Perhaps it's worth disabling lazy fpu with npt.

It should be implicitly disabled with npt because accesses to cr3 are
not intercepted anymore. The svm_set_cr3 function is the only place
which disables fpu switching.

