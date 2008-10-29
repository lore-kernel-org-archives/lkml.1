Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYJ2Q2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYJ2Q2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbYJ2Q2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:28:37 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:52622 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbYJ2Q2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:28:36 -0400
Date: Wed, 29 Oct 2008 11:28:17 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, morgan@kernel.org, arjan@infradead.org
Subject: Re: [PATCH] Capabilities: BUG when an invalid capability is
	requested
Message-ID: <20081029162817.GB14705@us.ibm.com>
References: <1225294932.23736.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225294932.23736.28.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> If an invalid (large) capability is requested the capabilities system
> may panic as it is dereferencing an array of fixed (short) length.  Its
> possible (and actually often happens) that the capability system
> accidentally stumbled into a valid memory region but it also regularly
> happens that it hits invalid memory and BUGs.  If such an operation does
> get past cap_capable then the selinux system is sure to have problems as
> it already does a (simple) validity check and BUG.  This is known to
> happen by the broken and buggy firegl driver.
> 
> This patch cleanly checks all capable calls and BUG if a call is for an
> invalid capability.  This will likely break the firegl driver for some
> situations, but it is the right thing to do.  Garbage into a security
> system gets you killed/bugged
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

I really don't like this, but I'm not sure we really have a choice.

Acked-by: Serge Hallyn <serue@us.ibm.com>

I suppose we can think later about whether it's worthwhile (a) having a
separate capable() function exported, keeping one without the check for
compiled-in use only, and/or (b) changing the cap_valid() definition to
be "(((unsigned int)cap) <= CAP_LAST_CAP)" which seems to work and shave
one whopping instruction.  I suspect the answer will be no to both.

Thanks, Eric.

-serge

> 
> ---
> 
>  kernel/capability.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 33e51e7..50d9d99 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -498,6 +498,11 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
>   */
>  int capable(int cap)
>  {
> +	if (unlikely(!cap_valid(cap))) {
> +		printk(KERN_CRIT "capable() called with invalid cap=%u\n", cap);
> +		BUG();
> +	}
> +
>  	if (has_capability(current, cap)) {
>  		current->flags |= PF_SUPERPRIV;
>  		return 1;
> 
