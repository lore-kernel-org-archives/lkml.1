Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbZIFFr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbZIFFr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 01:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbZIFFrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 01:47:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56125 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbZIFFrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 01:47:55 -0400
Date: Sun, 6 Sep 2009 07:47:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Avi Kivity <avi@redhat.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Avi Kivity <avi@qumranet.com>
Subject: Re: [patch 14/48] KVM: Reduce kvm stack usage in
	kvm_arch_vm_ioctl()
Message-ID: <20090906054749.GB1431@ucw.cz>
References: <20090904200712.724048145@mini.kroah.org> <20090904200852.199656362@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904200852.199656362@mini.kroah.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-09-04 13:07:26, Greg KH wrote:
> 
> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Dave Hansen <dave@linux.vnet.ibm.com>
> 
> (cherry picked from commit f0d662759a2465babdba1160749c446648c9d159)
> 
> On my machine with gcc 3.4, kvm uses ~2k of stack in a few
> select functions.  This is mostly because gcc fails to
> notice that the different case: statements could have their
> stack usage combined.  It overflows very nicely if interrupts
> happen during one of these large uses.
> 
> This patch uses two methods for reducing stack usage.
> 1. dynamically allocate large objects instead of putting
>    on the stack.
> 2. Use a union{} member for all of the case variables. This
>    tricks gcc into combining them all into a single stack
>    allocation. (There's also a comment on this)

Are the 'reduce stack usage' patches suitable for stable? The rules
said that fix must be for 'serious problem', not 'theoretical
issue'...
 

> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: Avi Kivity <avi@qumranet.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  arch/x86/kvm/x86.c |   72 +++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 45 insertions(+), 27 deletions(-)
> 
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1630,6 +1630,15 @@ long kvm_arch_vm_ioctl(struct file *filp
>  	struct kvm *kvm = filp->private_data;
>  	void __user *argp = (void __user *)arg;
>  	int r = -EINVAL;
> +	/*
> +	 * This union makes it completely explicit to gcc-3.x
> +	 * that these two variables' stack usage should be
> +	 * combined, not added together.
> +	 */
> +	union {
> +		struct kvm_pit_state ps;
> +		struct kvm_memory_alias alias;
> +	} u;
>  
>  	switch (ioctl) {
>  	case KVM_SET_TSS_ADDR:

...plus this is really ugly hack. Just declare the variable inside the
case block that needs it?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
