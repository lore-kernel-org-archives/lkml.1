Return-Path: <linux-kernel-owner+w=401wt.eu-S1757170AbYE0Gfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbYE0Gfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYE0Gfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:35:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:8383 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbYE0Gfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:35:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QUO8xA9spVW/aT6WBKTJvcCWoglaYn8ALYHIJV+ieEHKrAdyj2aufVa5TUblhl6a4bJLU5LScL2mMF1PFWpHH1YMJlAzZ2inH0D8p1zBd+buY6yNqjj6Fnt0JX2mv+YWNEj94oa7Q7q7+WjGXmjFBxDhkGgh1zyCA3Gx+Twkv2A=
Message-ID: <aa79d98a0805262335lf5cd4e1p8f318d45dfe7ff92@mail.gmail.com>
Date: Tue, 27 May 2008 10:35:43 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Sitsofe Wheeler" <sitsofe@yahoo.com>
Subject: Re: [REGRESSION][BISECTED][X86] next-20080526 hangs on boot
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <g1f3ht$b9g$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <g1eg2q$81q$1@ger.gmane.org> <20080526161623.GC7305@cvg>
	 <g1f230$7bl$1@ger.gmane.org> <g1f3ht$b9g$1@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/08, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> <posted & mailed>
>
> Sitsofe Wheeler wrote:
>
> > Cyrill Gorcunov wrote:
> >
> >> [Sitsofe Wheeler - Mon, May 26, 2008 at 03:04:54PM +0100]
> >> | When using a 32 bit linux-next-20080526 the bootup process will hang at
> >> | a random point (not even sysrq helps) with no additional output on the
> >> | screen (whereas linux-next-20080523 did boot). Mysteriously, booting
> >> | with nmi_watchdog=2 allows the boot to finish (booting with
> >> | nmi_watchdog=1 still stalls). I have bisected it down to commit
> >> | [d1b946b97d71423f365fa797d1428e1847c0bec1]:
> >>
> >> Hi, so it helps by reverting only that commit? I mean all further commits
> >> are still appiled?
> >
> > Ah that I hadn't tested. I believe I might need to revert
> > 4b82b277707a39b97271439c475f186f63ec4692 too if later commits are applied
> > (but I'm still testing)
> >
> >> and, btw, could you post your config, please?
> >
> > http://sucs.org/~sits/test/config-20080526.txt
>
> OK applying the following patch (which is more or less a revert of
> [4b82b277707a39b97271439c475f186f63ec4692]) resolves the problem:
>
> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> index d99ee8a..c55519c 100644
> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c
> @@ -480,8 +480,12 @@ int proc_nmi_enabled(struct ctl_table *table, int write, struct file *file,
>                return -EIO;
>        }
>
> -       /* if nmi_watchdog is not set yet, then set it */
> -       nmi_watchdog_default();
> +       if (nmi_watchdog == NMI_DEFAULT) {
> +               if (lapic_watchdog_ok())
> +                       nmi_watchdog = NMI_LOCAL_APIC;
> +               else
> +                       nmi_watchdog = NMI_IO_APIC;
> +       }
>
>        if (nmi_watchdog == NMI_LOCAL_APIC) {
>                if (nmi_watchdog_enabled)
> diff --git a/include/asm-x86/nmi.h b/include/asm-x86/nmi.h
> index 1e8f34d..7cd5b6a 100644
> --- a/include/asm-x86/nmi.h
> +++ b/include/asm-x86/nmi.h
> @@ -38,9 +38,11 @@ static inline void unset_nmi_pm_callback(struct pm_dev *dev)
>
>  #ifdef CONFIG_X86_64
>  extern void default_do_nmi(struct pt_regs *);
> +extern void nmi_watchdog_default(void);
> +#else
> +#define nmi_watchdog_default() do {} while (0)
>  #endif
>
> -extern void nmi_watchdog_default(void);
>  extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
>  extern int check_nmi_watchdog(void);
>  extern int nmi_watchdog_enabled;
>
> The removal of extern void nmi_watchdog_default(void) and the inclusion
> of #define nmi_watchdog_default() do {} while (0) look suspicious (why
> would nmi_watchdog_default() need to be an infinite loop on 32 bit
> systems?).
>
> --
> Sitsofe | http://sucs.org/~sits/
>

Hi Sitsofe, actually I can't imagine how this revert have helped you
from hang. Newly introduced nmi_watchdog_default() didn't change
the logic of the code being used before this merge-series.

Thomas, Ingo, maybe I've overlooked something (hard to believe ;)?
Only the change is the adding of new call for nmi_watchdog_default()
which was say 'inlined' before.

The thread is started on http://lkml.org/lkml/2008/5/26/146
