Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0CGMka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 07:40:30 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:49801 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab0CGMk2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 07:40:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=geo+MroWJHhsATPMLKxQJTLuT0H9olkZXZHB7VcF4jFDAkL0ggFnma5m6LnL9CB+EA
         G9FDYCbs4IcX+XquL4xs5+a1MlNBn5n3bFbg1TCcW8puaG/eNeHdY3PmnLFMXPq5rNgE
         5s+iU4Ia+q5xJ5kq341V6wgfy1ZaudSwmWjbk=
MIME-Version: 1.0
In-Reply-To: <20091015083933.815963538@linutronix.de>
References: <20091015083906.716130653@linutronix.de>
	 <20091015083933.815963538@linutronix.de>
Date: Sun, 7 Mar 2010 13:40:27 +0100
X-Google-Sender-Auth: 2661c5837bff02e1
Message-ID: <10f740e81003070440q3697c089o72ff9f3abcf9d293@mail.gmail.com>
Subject: Re: [patch 2/7] m68k: Remove BKL from rtc implementations
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arnd Bergmann <arnd@arndb.de>, ALan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 09:42, Thomas Gleixner <tglx@linutronix.de> wrote:
> m68k does not support SMP. The access to the rtc is already serialized
> with local_irq_save/restore which is sufficient on UP.
>
> The open() protection in arch/m68k/mvme16x/rtc.c is not pretty but
> sufficient on UP and safe w/o the BKL.
>
> open() in arch/m68k/bvme6000/rtc.c can do with the same atomic logic
> as arch/m68k/mvme16x/rtc.c

Thx, applied.

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  arch/m68k/bvme6000/rtc.c |   29 +++++++++--------------------
>  arch/m68k/mvme16x/rtc.c  |   19 +++++--------------
>  2 files changed, 14 insertions(+), 34 deletions(-)
>
> Index: linux-2.6-tip/arch/m68k/bvme6000/rtc.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/m68k/bvme6000/rtc.c
> +++ linux-2.6-tip/arch/m68k/bvme6000/rtc.c
> @@ -10,7 +10,6 @@
>  #include <linux/errno.h>
>  #include <linux/miscdevice.h>
>  #include <linux/slab.h>
> -#include <linux/smp_lock.h>
>  #include <linux/ioport.h>
>  #include <linux/capability.h>
>  #include <linux/fcntl.h>
> @@ -36,10 +35,9 @@
>  static unsigned char days_in_mo[] =
>  {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
>
> -static char rtc_status;
> +static atomic_t rtc_status = ATOMIC_INIT(1);
>
> -static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
> -                    unsigned long arg)
> +static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>        volatile RtcPtr_t rtc = (RtcPtr_t)BVME_RTC_BASE;
>        unsigned char msr;
> @@ -133,29 +131,20 @@ static int rtc_ioctl(struct inode *inode
>  }
>
>  /*
> - *     We enforce only one user at a time here with the open/close.
> - *     Also clear the previous interrupt data on an open, and clean
> - *     up things on a close.
> + * We enforce only one user at a time here with the open/close.
>  */
> -
>  static int rtc_open(struct inode *inode, struct file *file)
>  {
> -       lock_kernel();
> -       if(rtc_status) {
> -               unlock_kernel();
> +       if (!atomic_dec_and_test(&rtc_status)) {
> +               atomic_inc(&rtc_status);
>                return -EBUSY;
>        }
> -
> -       rtc_status = 1;
> -       unlock_kernel();
>        return 0;
>  }
>
>  static int rtc_release(struct inode *inode, struct file *file)
>  {
> -       lock_kernel();
> -       rtc_status = 0;
> -       unlock_kernel();
> +       atomic_inc(&rtc_status);
>        return 0;
>  }
>
> @@ -164,9 +153,9 @@ static int rtc_release(struct inode *ino
>  */
>
>  static const struct file_operations rtc_fops = {
> -       .ioctl =        rtc_ioctl,
> -       .open =         rtc_open,
> -       .release =      rtc_release,
> +       .unlocked_ioctl = rtc_ioctl,
> +       .open           = rtc_open,
> +       .release        = rtc_release,
>  };
>
>  static struct miscdevice rtc_dev = {
> Index: linux-2.6-tip/arch/m68k/mvme16x/rtc.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/m68k/mvme16x/rtc.c
> +++ linux-2.6-tip/arch/m68k/mvme16x/rtc.c
> @@ -10,7 +10,6 @@
>  #include <linux/errno.h>
>  #include <linux/miscdevice.h>
>  #include <linux/slab.h>
> -#include <linux/smp_lock.h>
>  #include <linux/ioport.h>
>  #include <linux/capability.h>
>  #include <linux/fcntl.h>
> @@ -37,8 +36,7 @@ static const unsigned char days_in_mo[]
>
>  static atomic_t rtc_ready = ATOMIC_INIT(1);
>
> -static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
> -                    unsigned long arg)
> +static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>        volatile MK48T08ptr_t rtc = (MK48T08ptr_t)MVME_RTC_BASE;
>        unsigned long flags;
> @@ -121,22 +119,15 @@ static int rtc_ioctl(struct inode *inode
>  }
>
>  /*
> - *     We enforce only one user at a time here with the open/close.
> - *     Also clear the previous interrupt data on an open, and clean
> - *     up things on a close.
> + * We enforce only one user at a time here with the open/close.
>  */
> -
>  static int rtc_open(struct inode *inode, struct file *file)
>  {
> -       lock_kernel();
>        if( !atomic_dec_and_test(&rtc_ready) )
>        {
>                atomic_inc( &rtc_ready );
> -               unlock_kernel();
>                return -EBUSY;
>        }
> -       unlock_kernel();
> -
>        return 0;
>  }
>
> @@ -151,9 +142,9 @@ static int rtc_release(struct inode *ino
>  */
>
>  static const struct file_operations rtc_fops = {
> -       .ioctl =        rtc_ioctl,
> -       .open =         rtc_open,
> -       .release =      rtc_release,
> +       .unlocked_ioctl = rtc_ioctl,
> +       .open           = rtc_open,
> +       .release        = rtc_release,
>  };
>
>  static struct miscdevice rtc_dev=

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
