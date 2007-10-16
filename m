Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbXJPByo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbXJPByo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 21:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbXJPByg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 21:54:36 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:52492 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbXJPByf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 21:54:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ARHW9z+0Ul7PJhq9/ipDIbd3stDcrH6NjriPArz0LVz+bNlnmNo1e6+DgYJFJpNTT0xF1ZYeKUT95tPRgXt7YHghtfK+x2KLoSii1fn7S7G34gWjfQX3iK0QuuEfe/epQUM2vkZ8Y2CbWEov2Vk0XIkydGMXbkVcZ6ng9cqK9vc=
Message-ID: <5d6222a80710151854j1159296ese2b6c471c9deb4ad@mail.gmail.com>
Date: Mon, 15 Oct 2007 22:54:32 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH RFC 2/2] paravirt: clean up lazy mode handling
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <ak@suse.de>, "Zachary Amsden" <zach@vmware.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Avi Kivity" <avi@qumranet.com>,
       "Anthony Liguori" <anthony@codemonkey.ws>,
       "Nakajima, Jun" <jun.nakajima@intel.com>
In-Reply-To: <470FDBC4.4050306@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <470FDBC4.4050306@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> [ Changes since last post: fixed up lguest ]
>
> Currently, the set_lazy_mode pv_op is overloaded with 5 functions:
>  1. enter lazy cpu mode
>  2. leave lazy cpu mode
>  3. enter lazy mmu mode
>  4. leave lazy mmu mode
>  5. flush pending batched operations
>
> This complicates each paravirt backend, since it needs to deal with
> all the possible state transitions, handling flushing, etc. In
> particular, flushing is quite distinct from the other 4 functions, and
> seems to just cause complication.
>
> This patch removes the set_lazy_mode operation, and adds "enter" and
> "leave" lazy mode operations on mmu_ops and cpu_ops.  All the logic
> associated with enter and leaving lazy states is now in common code
> (basically BUG_ONs to make sure that no mode is current when entering
> a lazy mode, and make sure that the mode is current when leaving).
> Also, flush is handled in a common way, by simply leaving and
> re-entering the lazy mode.
>
> The result is that the Xen, lguest and VMI lazy mode implementations
> are much simpler.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Andi Kleen <ak@suse.de>
> Cc: Zach Amsden <zach@vmware.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Avi Kivity <avi@qumranet.com>
> Cc: Anthony Liguory <aliguori@us.ibm.com>
> Cc: "Glauber de Oliveira Costa" <glommer@gmail.com>
> Cc: "Nakajima, Jun" <jun.nakajima@intel.com>
>
> ---
>  arch/i386/kernel/paravirt.c |   58 +++++++++++++++++++++++++++++++++++++++----
>  arch/i386/kernel/vmi.c      |   45 +++++++++++++++++++--------------
>  arch/i386/xen/enlighten.c   |   44 ++++++++++----------------------
>  arch/i386/xen/mmu.c         |    2 -
>  arch/i386/xen/multicalls.h  |    2 -
>  arch/i386/xen/xen-ops.h     |    7 -----
>  drivers/lguest/lguest.c     |   34 ++++++++-----------------
>  include/asm-i386/paravirt.h |   52 ++++++++++++++++++++++++--------------
>  8 files changed, 140 insertions(+), 104 deletions(-)
>
> ===================================================================
> --- a/arch/i386/kernel/paravirt.c
> +++ b/arch/i386/kernel/paravirt.c
> @@ -266,6 +266,49 @@ int paravirt_disable_iospace(void)
>         }
>
>         return ret;
> +}
> +
> +static DEFINE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode) = PARAVIRT_LAZY_NONE;
> +
> +static inline void enter_lazy(enum paravirt_lazy_mode mode)
> +{
> +       BUG_ON(x86_read_percpu(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
> +       BUG_ON(preemptible());
Wouldn't it be better to WARN_ON, and simply not entering lazy mode?
It does not sound like a fatal condition.

> +void paravirt_leave_lazy(enum paravirt_lazy_mode mode)
> +{
> +       BUG_ON(x86_read_percpu(paravirt_lazy_mode) != mode);
> +       BUG_ON(preemptible());

Although this one seems like a fatal condition ;-)

> +void paravirt_enter_lazy_mmu(void)
> +{
> +       enter_lazy(PARAVIRT_LAZY_MMU);
> +}
> +
> +void paravirt_leave_lazy_mmu(void)
> +{
> +       paravirt_leave_lazy(PARAVIRT_LAZY_MMU);
> +}
> +
> +void paravirt_enter_lazy_cpu(void)
> +{
> +       enter_lazy(PARAVIRT_LAZY_CPU);
> +}
> +
> +void paravirt_leave_lazy_cpu(void)
> +{
> +       paravirt_leave_lazy(PARAVIRT_LAZY_CPU);
> +}
> +
> +enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
> +{
> +       return x86_read_percpu(paravirt_lazy_mode);
>  }

I am concerned that this is 32-bit specific.
But hey: We could wrap it here, but the best solution may be just to
define this macro for 64-bit, and make it everyone benefits. So yeah,
this is a concern here, but I don't think anything should be changed
in this patch to address it so... so... ok ;-)

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
