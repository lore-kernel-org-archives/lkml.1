Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbYHaRqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbYHaRqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 13:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbYHaRqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 13:46:36 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:29717 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbYHaRqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 13:46:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iD18IcY5wwDjM5QXE+5PV70MvQO490J41ZjlCMnAdEUeKXHV/Awql6wbsL8yVx9Utk
         Wx1Npapi4XASoA4Xr95Iaq1Cc7tVnpj/8uSQ8z99cC4vA+gZ0t38Z16mbPIPlbXSDJG4
         k7O34cytPl0mtAzaQfdHebSJp3fQhkBnUtn0A=
Message-ID: <19f34abd0808311046g47907414wf3ef939d0a7bbfdb@mail.gmail.com>
Date: Sun, 31 Aug 2008 19:46:33 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] prevent ia64 from invoking irq handlers on offline CPUs
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, jes@sgi.com,
       manfred@colorfullife.com, akpm@linux-foundation.org
In-Reply-To: <20080831172814.GA15087@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080831172814.GA15087@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 7:28 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> Make ia64 refrain from clearing a given to-be-offlined CPU's bit in the
> cpu_online_mask until it has processed pending irqs.  This change
> prevents other CPUs from being blindsided by an apparently offline CPU
> nevertheless changing globally visible state.
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>
>  smpboot.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
> index bcea81e..7a90f42 100644
> --- a/arch/ia64/kernel/smpboot.c
> +++ b/arch/ia64/kernel/smpboot.c
> @@ -741,8 +741,6 @@ int __cpu_disable(void)
>                        return -EBUSY;
>        }
>
> -       cpu_clear(cpu, cpu_online_map);
> -
>        if (migrate_platform_irqs(cpu)) {
>                cpu_set(cpu, cpu_online_map);
>                return (-EBUSY);
> @@ -751,6 +749,7 @@ int __cpu_disable(void)
>        remove_siblinginfo(cpu);
>        cpu_clear(cpu, cpu_online_map);
>        fixup_irqs();
> +       cpu_clear(cpu, cpu_online_map);
>        local_flush_tlb_all();
>        cpu_clear(cpu, cpu_callin_map);
>        return 0;

Hm. Maybe my eyes are going bad. But isn't that now clearing the cpu
both before and after calling fixup_irqs()?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
