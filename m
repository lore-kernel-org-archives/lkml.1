Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbYEZToX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbYEZToX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 15:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbYEZToO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 15:44:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:36064 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbYEZToN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 15:44:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Ma5QDNeAxw9oH0uRkj0A1PoIAoCBMH2o9R1hRpqypj7i/HQa38jn6Zw6PtWNjCmdwTDrl4WZK74h7gxL+gJrEmyeaHM/r8FW++24UyEE7JHuwlqv0JPGDFR6K80yhPQ8BtSOYYnHDyu+KiFfqpqQH4b2n4dCRXOCld1laLjS/Gc=
Date: Mon, 26 May 2008 23:44:01 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [REGRESSION][BISECTED][X86] next-20080526 hangs on boot
Message-ID: <20080526194401.GJ7305@cvg>
References: <g1eg2q$81q$1@ger.gmane.org> <20080526161623.GC7305@cvg> <g1f230$7bl$1@ger.gmane.org> <g1f3ht$b9g$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g1f3ht$b9g$1@ger.gmane.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sitsofe Wheeler - Mon, May 26, 2008 at 08:36:54PM +0100]
| <posted & mailed>
| 
| Sitsofe Wheeler wrote:
| 
| > Cyrill Gorcunov wrote:
| > 
| >> [Sitsofe Wheeler - Mon, May 26, 2008 at 03:04:54PM +0100]
| >> | When using a 32 bit linux-next-20080526 the bootup process will hang at
| >> | a random point (not even sysrq helps) with no additional output on the
| >> | screen (whereas linux-next-20080523 did boot). Mysteriously, booting
| >> | with nmi_watchdog=2 allows the boot to finish (booting with
| >> | nmi_watchdog=1 still stalls). I have bisected it down to commit
| >> | [d1b946b97d71423f365fa797d1428e1847c0bec1]:
| >>
| >> Hi, so it helps by reverting only that commit? I mean all further commits
| >> are still appiled?
| > 
| > Ah that I hadn't tested. I believe I might need to revert
| > 4b82b277707a39b97271439c475f186f63ec4692 too if later commits are applied
| > (but I'm still testing)
| > 
| >> and, btw, could you post your config, please?
| > 
| > http://sucs.org/~sits/test/config-20080526.txt
| 
| OK applying the following patch (which is more or less a revert of 
| [4b82b277707a39b97271439c475f186f63ec4692]) resolves the problem:
| 
| diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
| index d99ee8a..c55519c 100644
| --- a/arch/x86/kernel/nmi.c
| +++ b/arch/x86/kernel/nmi.c
| @@ -480,8 +480,12 @@ int proc_nmi_enabled(struct ctl_table *table, int write, struct file *file,
|                 return -EIO;
|         }
|  
| -       /* if nmi_watchdog is not set yet, then set it */
| -       nmi_watchdog_default();
| +       if (nmi_watchdog == NMI_DEFAULT) {
| +               if (lapic_watchdog_ok())
| +                       nmi_watchdog = NMI_LOCAL_APIC;
| +               else
| +                       nmi_watchdog = NMI_IO_APIC;
| +       }
|  
|         if (nmi_watchdog == NMI_LOCAL_APIC) {
|                 if (nmi_watchdog_enabled)
| diff --git a/include/asm-x86/nmi.h b/include/asm-x86/nmi.h
| index 1e8f34d..7cd5b6a 100644
| --- a/include/asm-x86/nmi.h
| +++ b/include/asm-x86/nmi.h
| @@ -38,9 +38,11 @@ static inline void unset_nmi_pm_callback(struct pm_dev *dev)
|  
|  #ifdef CONFIG_X86_64
|  extern void default_do_nmi(struct pt_regs *);
| +extern void nmi_watchdog_default(void);
| +#else
| +#define nmi_watchdog_default() do {} while (0)
|  #endif
|  
| -extern void nmi_watchdog_default(void);
|  extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
|  extern int check_nmi_watchdog(void);
|  extern int nmi_watchdog_enabled; 
| 
| The removal of extern void nmi_watchdog_default(void) and the inclusion
| of #define nmi_watchdog_default() do {} while (0) look suspicious (why
| would nmi_watchdog_default() need to be an infinite loop on 32 bit
| systems?).
| 
| -- 
| Sitsofe | http://sucs.org/~sits/
| 
| 

Thanks a lot! Will take a look tomorrow!

And there was NOT an infinite loop - look more closer on that string
do { } while (0) - only *one* iteration is going (well, gcc will eliminate
it at all by optimization). Anyway, it was while (0), not while (1),
so it is ok ;)

		- Cyrill -
