Return-Path: <linux-kernel-owner+w=401wt.eu-S932371AbXJMSpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbXJMSpZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761390AbXJMSpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:45:14 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:30376 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbXJMSpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:45:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=AsFktI5yQF1r1p67golqd10OZ1n+odNhbLGZ/gQSI2+bnrDHMLeicW9z8fnx1uLtQV6SP3XNOQHA+q+J64SiD2VdS815jN/JMcNCkmwNZO4VbQrZ0eVR5Z/fRONYXvGHICBLBrI8xYP+hEPf0PwTqS6P7syaMSzsQR/BA802cGg=
Date: Sat, 13 Oct 2007 14:40:07 -0400
From: Joseph Fannin <jfannin@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Joseph Fannin <jfannin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Domen Puncer <domen.puncer@telargo.com>
Subject: Re: 2.6.23-mm1 pm_prepare() and _finish() w/ args vs. without
Message-ID: <20071013184006.GA2114@nineveh.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Joseph Fannin <jfannin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Domen Puncer <domen.puncer@telargo.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <20071013155010.GA11864@nineveh.local> <200710131922.49094.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200710131922.49094.rjw@sisk.pl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 07:22:48PM +0200, Rafael J. Wysocki wrote:
> On Saturday, 13 October 2007 17:50, Joseph Fannin wrote:
> > On Thu, Oct 11, 2007 at 09:31:26PM -0700, Andrew Morton wrote:
> > >
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> >
> >
> > Domen Puncer's change to support "MPC5200 low power mode" (in
> > powerpc-git, which is in Linus's tree now) adds new code calling
> > mpc52xx_pm_prepare and _finish with suspend_state_t as an argument,
> > while Rafael Wysocki's pm-rework-struct-platform_suspend_ops.patch
> > converts those to take no arguments.  So the build fails:
>
> Ouch.
>
> I think that the appended patch is needed.  Unfortunately, I can't test it here.
>

> --- linux-2.6.23-mm1.orig/include/asm-powerpc/mpc52xx.h
> +++ linux-2.6.23-mm1/include/asm-powerpc/mpc52xx.h
> @@ -267,9 +267,9 @@ extern int mpc52xx_set_wakeup_gpio(u8 pi
>  extern int __init lite5200_pm_init(void);
>
>  /* lite5200 calls mpc5200 suspend functions, so here they are */
> -extern int mpc52xx_pm_prepare(suspend_state_t);
> +extern int mpc52xx_pm_prepare(void);
>  extern int mpc52xx_pm_enter(suspend_state_t);
> -extern int mpc52xx_pm_finish(suspend_state_t);
> +extern void mpc52xx_pm_finish(void);

These declarations are extern, but
pm-rework-struct-platform_suspend_ops.patch makes the function
definitions static, which doesn't seem to be allowed.

After removing the static bits from those two functions in
mpc52xx_pm.c it builds, but there are lots of warnings, which seem to
be related:

  CC      arch/powerpc/kernel/prom.o
In file included from arch/powerpc/platforms/52xx/mpc52xx_pic.c:34:
include/asm/mpc52xx.h:271: warning: parameter names (without types) in function declaration
  CC      arch/powerpc/platforms/52xx/mpc52xx_common.o
arch/powerpc/kernel/prom.c: In function ‘early_init_dt_scan_chosen’:
arch/powerpc/kernel/prom.c:784: warning: assignment from incompatible pointer type
arch/powerpc/kernel/prom.c:788: warning: assignment from incompatible pointer type
In file included from arch/powerpc/platforms/52xx/mpc52xx_common.c:20:
include/asm/mpc52xx.h:271: warning: parameter names (without types) in function declaration
  CC      arch/powerpc/platforms/52xx/mpc52xx_pci.o
  CC      arch/powerpc/kernel/traps.o
In file included from arch/powerpc/platforms/52xx/mpc52xx_pci.c:16:
include/asm/mpc52xx.h:271: warning: parameter names (without types) in function declaration
arch/powerpc/platforms/52xx/mpc52xx_pci.c: In function ‘mpc52xx_pci_setup’:
arch/powerpc/platforms/52xx/mpc52xx_pci.c:262: warning: format ‘%x’ expects type ‘unsigned int’, but argument 2 has type ‘resource_size_t’
arch/powerpc/platforms/52xx/mpc52xx_pci.c:262: warning: format ‘%x’ expects type ‘unsigned int’, but argument 3 has type ‘resource_size_t’
arch/powerpc/platforms/52xx/mpc52xx_pci.c:276: warning: format ‘%x’ expects type ‘unsigned int’, but argument 2 has type ‘resource_size_t’
arch/powerpc/platforms/52xx/mpc52xx_pci.c:276: warning: format ‘%x’ expects type ‘unsigned int’, but argument 3 has type ‘resource_size_t’
arch/powerpc/platforms/52xx/mpc52xx_pci.c:295: warning: cast to pointer from integer of different size
arch/powerpc/platforms/52xx/mpc52xx_pci.c:295: warning: format ‘%x’ expects type ‘unsigned int’, but argument 2 has type ‘resource_size_t’
arch/powerpc/platforms/52xx/mpc52xx_pci.c:295: warning: format ‘%x’ expects type ‘unsigned int’, but argument 3 has type ‘resource_size_t’
  CC      arch/powerpc/platforms/52xx/efika.o
In file included from arch/powerpc/platforms/52xx/efika.c:36:
include/asm/mpc52xx.h:271: warning: parameter names (without types) in function declaration
  CC      arch/powerpc/kernel/setup-common.o
  CC      arch/powerpc/platforms/52xx/lite5200.o
In file included from arch/powerpc/platforms/52xx/lite5200.c:44:
include/asm/mpc52xx.h:271: warning: parameter names (without types) in function declaration


The build is moving though, and I don't actually have this platform --
I just can't avoid building it when building for powermac.  Thanks.

--
Joseph Fannin
jfannin@gmail.com
