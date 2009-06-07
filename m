Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbZFGVEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbZFGVEB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 17:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbZFGVDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 17:03:37 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:46303 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbZFGVDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 17:03:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=YFVDGj6Rd210d446/gRFiFDxLs+MCblLmwr7PWwPcVYtxRcpRF7Fpm3+Ia+vBWKkqk
         7F4EaE+UlH/c5gwxRs7iHgT8CAVxYhgoNgPRr92ZbVDd9YEga6YKDBhXoP9V8QUDxPPs
         OQPdxtqQB1kZHnpgLRETdsZ9nMVC5rQzQg+g4=
Date: Mon, 8 Jun 2009 01:03:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix dummy apic read/write warning
Message-ID: <20090607210337.GG4547@lenovo>
References: <20090606073737.GA3163@elte.hu> <4A2AEAC6.8060404@kernel.org> <20090607070136.GA4547@lenovo> <86802c440906071228x489c3f79q2e1a49dc997e874@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c440906071228x489c3f79q2e1a49dc997e874@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Sun, Jun 07, 2009 at 12:28:07PM -0700]
| On Sun, Jun 7, 2009 at 12:01 AM, Cyrill Gorcunov<gorcunov@gmail.com> wrote:
| > [Yinghai Lu - Sat, Jun 06, 2009 at 03:16:38PM -0700]
| > | ingo got
| > | [    0.000000] Using APIC driver default
| > | [    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
| > | [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
| > | [    0.000000] APIC: disable apic facility
| > | [    0.000000] ------------[ cut here ]------------
| > | [    0.000000] WARNING: at arch/x86/kernel/apic/apic.c:254 native_apic_read_dummy+0x2d/0x3b()
| > | [    0.000000] Hardware name: HP OmniBook PC
| > |
| > | we have wrong check in dummy read and write.
| > | [we only test on system that have APIC with "disableapic"...]
| > |
| > | Signed-off-by: yinghai Lu <yinghai@kernel.org>
| > |
| > | ---
| > |  arch/x86/kernel/apic/apic.c |    4 ++--
| > |  1 file changed, 2 insertions(+), 2 deletions(-)
| > |
| > | Index: linux-2.6/arch/x86/kernel/apic/apic.c
| > | ===================================================================
| > | --- linux-2.6.orig/arch/x86/kernel/apic/apic.c
| > | +++ linux-2.6/arch/x86/kernel/apic/apic.c
| > | @@ -246,12 +246,12 @@ static int modern_apic(void)
| > |   */
| > |  static void native_apic_write_dummy(u32 reg, u32 v)
| > |  {
| > | -     WARN_ON_ONCE((cpu_has_apic || !disable_apic));
| > | +     WARN_ON_ONCE((cpu_has_apic && !disable_apic));
| > |  }
| > |
| > |  static u32 native_apic_read_dummy(u32 reg)
| > |  {
| > | -     WARN_ON_ONCE((cpu_has_apic || !disable_apic));
| > | +     WARN_ON_ONCE((cpu_has_apic && !disable_apic));
| > |       return 0;
| > |  }
| > |
| > |
| >
| > No Yinghai, this is wrong. native_apic_write_dummy is not
| > admissible to be called after apic->write has been NOP'ified.
| >
| > If a site calls for apic->write after apic_disable() it's
| > a plain *bug* in caller. So we should continute warning if
| > cpu_has_apic _or_ !disable_apic.
| 
| ok, just change it to
| 
|      WARN_ON_ONCE(1);
| 
| there.

There was some scenario where we had legitime apic->write
on SMP kernel when cpu goes to halt. Will recheck tomorrow.
That is why we added conditional WARN to eliminate uglifying
by additional checks (ie we know that apic->write happens
but it's nothing serious). Thanks Yinghai!

| 
| >
| > Though since for SMP compiled kernel we still rely on
| > apic->read the snippet is to be changed to (cpu_has_apic && !disable_apic)
| > indeed.
| 
| YH
| 
	-- Cyrill
