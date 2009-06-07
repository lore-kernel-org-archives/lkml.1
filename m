Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbZFGT2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbZFGT2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 15:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZFGT2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 15:28:07 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:39234 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbZFGT2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 15:28:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gf/+zveZk5b4nTbCg5k+F3TEGRw38KDOX5WJOEh9mW3YKh+MREjlyRnRXrUUxAE3rE
         FWbJkvtH9hF8V4B28UsQ96fGE1MvUARMGcc1lmDv7PIagWYusT2+uan+m6EZenZTetyj
         FQ/w/FHTEkJw352d7BZ39zogM1nByO0WIxjBs=
MIME-Version: 1.0
In-Reply-To: <20090607070136.GA4547@lenovo>
References: <20090606073737.GA3163@elte.hu> <4A2AEAC6.8060404@kernel.org>
	 <20090607070136.GA4547@lenovo>
Date: Sun, 7 Jun 2009 12:28:07 -0700
Message-ID: <86802c440906071228x489c3f79q2e1a49dc997e874@mail.gmail.com>
Subject: Re: [PATCH] x86: fix dummy apic read/write warning
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 7, 2009 at 12:01 AM, Cyrill Gorcunov<gorcunov@gmail.com> wrote:
> [Yinghai Lu - Sat, Jun 06, 2009 at 03:16:38PM -0700]
> | ingo got
> | [    0.000000] Using APIC driver default
> | [    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
> | [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
> | [    0.000000] APIC: disable apic facility
> | [    0.000000] ------------[ cut here ]------------
> | [    0.000000] WARNING: at arch/x86/kernel/apic/apic.c:254 native_apic_read_dummy+0x2d/0x3b()
> | [    0.000000] Hardware name: HP OmniBook PC
> |
> | we have wrong check in dummy read and write.
> | [we only test on system that have APIC with "disableapic"...]
> |
> | Signed-off-by: yinghai Lu <yinghai@kernel.org>
> |
> | ---
> |  arch/x86/kernel/apic/apic.c |    4 ++--
> |  1 file changed, 2 insertions(+), 2 deletions(-)
> |
> | Index: linux-2.6/arch/x86/kernel/apic/apic.c
> | ===================================================================
> | --- linux-2.6.orig/arch/x86/kernel/apic/apic.c
> | +++ linux-2.6/arch/x86/kernel/apic/apic.c
> | @@ -246,12 +246,12 @@ static int modern_apic(void)
> |   */
> |  static void native_apic_write_dummy(u32 reg, u32 v)
> |  {
> | -     WARN_ON_ONCE((cpu_has_apic || !disable_apic));
> | +     WARN_ON_ONCE((cpu_has_apic && !disable_apic));
> |  }
> |
> |  static u32 native_apic_read_dummy(u32 reg)
> |  {
> | -     WARN_ON_ONCE((cpu_has_apic || !disable_apic));
> | +     WARN_ON_ONCE((cpu_has_apic && !disable_apic));
> |       return 0;
> |  }
> |
> |
>
> No Yinghai, this is wrong. native_apic_write_dummy is not
> admissible to be called after apic->write has been NOP'ified.
>
> If a site calls for apic->write after apic_disable() it's
> a plain *bug* in caller. So we should continute warning if
> cpu_has_apic _or_ !disable_apic.

ok, just change it to

     WARN_ON_ONCE(1);

there.

>
> Though since for SMP compiled kernel we still rely on
> apic->read the snippet is to be changed to (cpu_has_apic && !disable_apic)
> indeed.

YH
