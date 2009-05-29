Return-Path: <linux-kernel-owner+w=401wt.eu-S1762636AbZE2RVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762636AbZE2RVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 13:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZE2RVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 13:21:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:58845 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbZE2RVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 13:21:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rGnaDfI54hjfvjnc2tUYgcBf3SWnnvCrfJZmsw1tOQXibg/aZ+3kD3R1vMG7KBD1RE
         +caLhHfH/FZWaHe8NmZc0z2wa4kdMN8xkf3SCDs+8LypSnVk8UCJMoQose+RpgQ51ioy
         CtStqbKUX0rnJ48kZ9AO36nQJp6juAr/hgops=
Date: Fri, 29 May 2009 21:21:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mingo@elte.hu, x86@kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86: apic, restore irqs on fail paths
Message-ID: <20090529172138.GC5176@lenovo>
References: <1243497289-18591-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243497289-18591-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jiri Slaby - Thu, May 28, 2009 at 09:54:47AM +0200]
|
| lapic_resume forgets to restore interrupts on fail paths.
| Fix that.

Good catch, Jiri!

Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

Though I really doubt if the system will be functional after such a fail :)
But it's definitely better then having it irq-locked.

Yinghai CC'ed just to be sure.

| 
| Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
| Cc: Ingo Molnar <mingo@redhat.com>
| Cc: Thomas Gleixner <tglx@linutronix.de>
| Cc: H. Peter Anvin <hpa@zytor.com>
| ---
|  arch/x86/kernel/apic/apic.c |   11 ++++++-----
|  1 files changed, 6 insertions(+), 5 deletions(-)
| 
| diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
| index 07cffc1..fc65544 100644
| --- a/arch/x86/kernel/apic/apic.c
| +++ b/arch/x86/kernel/apic/apic.c
| @@ -2029,7 +2029,7 @@ static int lapic_resume(struct sys_device *dev)
|  	unsigned int l, h;
|  	unsigned long flags;
|  	int maxlvt;
| -	int ret;
| +	int ret = 0;
|  	struct IO_APIC_route_entry **ioapic_entries = NULL;
|  
|  	if (!apic_pm_state.active)
| @@ -2040,14 +2040,15 @@ static int lapic_resume(struct sys_device *dev)
|  		ioapic_entries = alloc_ioapic_entries();
|  		if (!ioapic_entries) {
|  			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
| -			return -ENOMEM;
| +			ret = -ENOMEM;
| +			goto restore;
|  		}
|  
|  		ret = save_IO_APIC_setup(ioapic_entries);
|  		if (ret) {
|  			WARN(1, "Saving IO-APIC state failed: %d\n", ret);
|  			free_ioapic_entries(ioapic_entries);
| -			return ret;
| +			goto restore;
|  		}
|  
|  		mask_IO_APIC_setup(ioapic_entries);
| @@ -2099,10 +2100,10 @@ static int lapic_resume(struct sys_device *dev)
|  		restore_IO_APIC_setup(ioapic_entries);
|  		free_ioapic_entries(ioapic_entries);
|  	}
| -
| +restore:
|  	local_irq_restore(flags);
|  
| -	return 0;
| +	return ret;
|  }
|  
|  /*
| -- 
| 1.6.3
| 
| 
	-- Cyrill
