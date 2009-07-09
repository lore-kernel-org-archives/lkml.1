Return-Path: <linux-kernel-owner+w=401wt.eu-S1761758AbZGIPJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761758AbZGIPJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761434AbZGIPJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:09:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62297 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760965AbZGIPJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:09:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH] score: add regsets support for score
Date: Thu, 9 Jul 2009 17:08:54 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.95; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
References: <OF5282122C.261603C7-ON482575ED.003A86FA-482575ED.003C4AEE@sunplusct.com>
In-Reply-To: <OF5282122C.261603C7-ON482575ED.003A86FA-482575ED.003C4AEE@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907091708.54468.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19mdXBjsCMSOi+w7VfXVgh9x8i7XmwriWnkkL1
 LsSYWykrBaLZ+YdmE+cX0oBqFqA7O0fmERNz4SQjm0LrWracFe
 Ajjk3eZK639bbsMKJsSQw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 July 2009, liqin.chen@sunplusct.com wrote:
> ptrace.c add register sets support for score architecture.
> 
> - genregs_get(struct task_struct *target,
>                const struct user_regset *regset,
>                unsigned int pos, unsigned int count,
>                void *kbuf, void __user *ubuf)
>         Retrieve the contents of score userspace general registers.
> 
> - genregs_set(struct task_struct *target,
>                const struct user_regset *regset,
>                unsigned int pos, unsigned int count,
>                const void *kbuf, const void __user *ubuf)
>         Update the contents of the score userspace general registers.
> 
> Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
> ---
>  arch/score/include/asm/elf.h |    3 +-
>  arch/score/kernel/ptrace.c   |   78 
> ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 80 insertions(+), 1 deletions(-)

You still use an email client that breaks patches by adding line-wraps.
Please use a different mail client for sending patches. You could for
example use git-send-email with a random freemail account and still
set your corporate sender address.

The code you add looks ok to me, but it appears you forgot to hook
it up to the ptrace logic. Some architectures use it only for
PTRACE_{GET,SET}REGS, others also use it in PTRACE_{PEEK,POKE}USR,
I'm not sure what the right approach is for new architectures.
Should a new architecture actually implement both of those
interfaces?

Maybe Christoph (who was asking for the change) or Roland can comment
on that.

	Arnd <><

> diff --git a/arch/score/include/asm/elf.h b/arch/score/include/asm/elf.h
> index 8324363..d69668c 100644
> --- a/arch/score/include/asm/elf.h
> +++ b/arch/score/include/asm/elf.h
> @@ -2,7 +2,7 @@
>  #define _ASM_SCORE_ELF_H
>  
>  /* ELF register definitions */
> -#define ELF_NGREG      45
> +#define ELF_NGREG      42
>  #define ELF_NFPREG     33
>  #define EM_SCORE7      135
>  
> @@ -57,6 +57,7 @@ do { \
>  struct task_struct;
>  struct pt_regs;
>  
> +#define CORE_DUMP_USE_REGSET
>  #define USE_ELF_CORE_DUMP
>  #define ELF_EXEC_PAGESIZE      PAGE_SIZE
>  
> diff --git a/arch/score/kernel/ptrace.c b/arch/score/kernel/ptrace.c
> index 1db876b..9eec6a2 100644
> --- a/arch/score/kernel/ptrace.c
> +++ b/arch/score/kernel/ptrace.c
> @@ -23,11 +23,89 @@
>   * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  
> +#include <linux/elf.h>
>  #include <linux/kernel.h>
>  #include <linux/ptrace.h>
> +#include <linux/regset.h>
>  
>  #include <asm/uaccess.h>
>  
> +/*
> + * retrieve the contents of SCORE userspace general registers
> + */
> +static int genregs_get(struct task_struct *target,
> +                      const struct user_regset *regset,
> +                      unsigned int pos, unsigned int count,
> +                      void *kbuf, void __user *ubuf)
> +{
> +       const struct pt_regs *regs = task_pt_regs(target);
> +       int end_pos = sizeof(struct pt_regs) - 9 * sizeof(long);
> +       int ret;
> +
> +       ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +                                 regs->regs,
> +                                 offsetof(struct pt_regs, regs),
> +                                 end_pos);
> +       if (!ret)
> +               ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
> +                                               end_pos, -1);
> +
> +       return ret;
> +}
> +
> +/*
> + * update the contents of the SCORE userspace general registers
> + */
> +static int genregs_set(struct task_struct *target,
> +                      const struct user_regset *regset,
> +                      unsigned int pos, unsigned int count,
> +                      const void *kbuf, const void __user *ubuf)
> +{
> +       struct pt_regs *regs = task_pt_regs(target);
> +       int end_pos = sizeof(struct pt_regs) - 9 * sizeof(long);
> +       int ret;
> +
> +       ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +                                regs->regs,
> +                                offsetof(struct pt_regs, regs),
> +                                end_pos);
> +       if (!ret)
> +               ret = user_regset_copyin_ignore(&pos, &count, &kbuf, 
> &ubuf,
> +                                               end_pos, -1);
> +
> +       return ret;
> +}
> +
> +/*
> + * Define the register sets available on the score7 under Linux
> + */
> +enum score7_regset {
> +       REGSET_GENERAL,
> +};
> +
> +static const struct user_regset score7_regsets[] = {
> +       [REGSET_GENERAL] = {
> +               .core_note_type = NT_PRSTATUS,
> +               .n              = ELF_NGREG,
> +               .size           = sizeof(long),
> +               .align          = sizeof(long),
> +               .get            = genregs_get,
> +               .set            = genregs_set,
> +       },
> +};
> +
> +static const struct user_regset_view user_score_native_view = {
> +       .name           = "score7",
> +       .e_machine      = EM_SCORE7,
> +       .regsets        = score7_regsets,
> +       .n              = ARRAY_SIZE(score7_regsets),
> +};
> +
> +const struct user_regset_view *task_user_regset_view(struct task_struct 
> *task)
> +{
> +       return &user_score_native_view;
> +}
> +
>  static int is_16bitinsn(unsigned long insn)
>  {
>         if ((insn & INSN32_MASK) == INSN32_MASK)


