Return-Path: <linux-kernel-owner+w=401wt.eu-S1764961AbXJSQ6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764961AbXJSQ6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 12:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758571AbXJSQ61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 12:58:27 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55718 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757607AbXJSQ61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 12:58:27 -0400
Subject: Re: [kvm-devel] Use virtual cpu accounting if available for guest
	times.
From: Hollis Blanchard <hollisb@us.ibm.com>
Reply-To: Hollis Blanchard <hollisb@us.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Avi Kivity <avi@qumranet.com>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       Laurent Vivier <Laurent.Vivier@bull.net>, linux-kernel@vger.kernel.org
In-Reply-To: <200710181439.10390.borntraeger@de.ibm.com>
References: <47135D1B.1060004@bull.net>
	 <11926264852739-git-send-email-Laurent.Vivier@bull.net>
	 <200710181439.10390.borntraeger@de.ibm.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Fri, 19 Oct 2007 11:57:36 -0500
Message-Id: <1192813056.10451.6.camel@basalt>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-18 at 14:39 +0200, Christian Borntraeger wrote:
> Avi,
> 
> ppc and s390 offer the possibility to track process times precisely
> by looking at cpu timer on every context switch, irq, softirq etc.
> We can use that infrastructure as well for guest time accounting.
> We need to account the used time before we change the state. 
> This patch adds a call to account_system_vtime to kvm_guest_enter
> and kvm_guest exit. If CONFIG_VIRT_CPU_ACCOUNTING is not set,
> account_system_vtime is defined in hardirq.h as an empty function,
> which means this patch does not change the behaviour on other
> platforms.
> 
> I compile tested this patch on x86 and function tested the patch on
> s390.
> 
> Avi, please apply.
> 
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> ---
>  drivers/kvm/kvm.h |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: kvm/drivers/kvm/kvm.h
> ===================================================================
> --- kvm.orig/drivers/kvm/kvm.h
> +++ kvm/drivers/kvm/kvm.h
> @@ -7,6 +7,7 @@
>   */
> 
>  #include <linux/types.h>
> +#include <linux/hardirq.h>
>  #include <linux/list.h>
>  #include <linux/mutex.h>
>  #include <linux/spinlock.h>
> @@ -669,11 +670,13 @@ __init void kvm_arch_init(void);
> 
>  static inline void kvm_guest_enter(void)
>  {
> +	account_system_vtime(current);
>  	current->flags |= PF_VCPU;
>  }
> 
>  static inline void kvm_guest_exit(void)
>  {
> +	account_system_vtime(current);
>  	current->flags &= ~PF_VCPU;
>  }

I don't understand. Should kvm_guest_exit() be calling
account_user_vtime() (instead of account_system_vtime())?

-- 
Hollis Blanchard
IBM Linux Technology Center

