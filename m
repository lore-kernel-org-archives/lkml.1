Return-Path: <linux-kernel-owner+w=401wt.eu-S934626AbXFFSDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934626AbXFFSDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbXFFSD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:03:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59454 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754698AbXFFSD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:03:28 -0400
Date: Wed, 6 Jun 2007 11:03:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2/2] UML - Fix kernel stack size on x86_64
Message-Id: <20070606110314.c64f8234.akpm@linux-foundation.org>
In-Reply-To: <20070606151134.GA5972@c2.user-mode-linux.org>
References: <20070605205055.GA9770@c2.user-mode-linux.org>
	<20070605170001.c8b2110e.akpm@linux-foundation.org>
	<20070606003752.GA11511@c2.user-mode-linux.org>
	<20070605182024.003502d4.akpm@linux-foundation.org>
	<20070606151134.GA5972@c2.user-mode-linux.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 11:11:34 -0400 Jeff Dike <jdike@addtoit.com> wrote:

> On Tue, Jun 05, 2007 at 06:20:24PM -0700, Andrew Morton wrote:
> > If you do
> > 
> > -	int "Kernel stack size order"
> > +	int
> > 
> > then this rule will no longer be offered to the user and `make oldconfig'
> > (actually anythingconfig) will override whatever happens to be in .config
> > for KERNEL_STACK_ORDER.
> 
> You're saying that making an option user-visible changes whether
> *config overrides .config?  That's non-intuitive.

Yeah, I thought so.  I discovered it by comparing the behaviour of your
patch against the behaviour of CONFIG_BASE_SMALL, fiddling around and
then saying "wtf".

> > I'm not sure if that's actually what you want, but if the current situation
> > is that a random CONFIG_KERNEL_STACK_ORDER=0 left over in .config will
> > break the kernel at runtime then I think something sterner than editing
> > defconfig is needed?
> 
> That's a good point, but I think I do want it user-visible.  If
> someone sees someething I suspect to be a stack overflow, I'd like to
> be able to tell them to bump KERNEL_STACK_ORDER and see if the problem
> goes away.
> 
> As for something sterner, it turns out that Kbuild provides some
> support for this.  So, drop the previous patch in favor of this one:
> 
> Force KERNEL_STACK_ORDER to be at least 1 on UML/x86_64.
> 
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> --
>  arch/um/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6.21-mm/arch/um/Kconfig
> ===================================================================
> --- linux-2.6.21-mm.orig/arch/um/Kconfig	2007-06-06 09:28:13.000000000 -0400
> +++ linux-2.6.21-mm/arch/um/Kconfig	2007-06-06 11:08:49.000000000 -0400
> @@ -278,6 +278,7 @@ config HIGHMEM
>  config KERNEL_STACK_ORDER
>  	int "Kernel stack size order"
>  	default 1 if 64BIT
> +	range 1 10 if 64BIT
>  	default 0 if !64BIT
>  	help
>  	This option determines the size of UML kernel stacks.  They will

heh, fair enough.
