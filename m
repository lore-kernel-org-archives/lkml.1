Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZFHRru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZFHRru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbZFHRrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:47:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:50020 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZFHRrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:47:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YRlGYry6FIpVweoh3pla1hlNmR/A0EKJFAPTjyD8U+ysQyL6+sOudyCz2OlzCLYm4H
         3LGEr6UWRsrCg9nUeBznPhqNNkrSWnRNYTy5aaumbETeh9E3BPItc7qGwVqAnN///n+8
         S2V4RFTKA+aNgx9QGK4kxa40+8ZZfl7lxlm6Y=
Date: Mon, 8 Jun 2009 21:47:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/numa] x86, apic: Fix dummy apic read operation
	together with broken MP handling
Message-ID: <20090608174734.GF5015@lenovo>
References: <20090607124840.GD4547@lenovo> <tip-103428e57be323c3c5545db8ad12667099bc6005@git.kernel.org> <86802c440906071223w3116f452n7ccd028d52f11c77@mail.gmail.com> <20090607203951.GF4547@lenovo> <86802c440906071559t7f2139c0s55fd15e8cd669cff@mail.gmail.com> <20090608151646.GB5015@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608151646.GB5015@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Mon, Jun 08, 2009 at 07:16:46PM +0400]
...
| | should be other case:
| | when MADT is right, but disablelapic is used.
| | will get cpu_has_apic == 0, and we are not using dummy apic read/write.
| | 
| | so don't need to check
| |         /*
| |          * If we couldn't find a local APIC, then get out of here now!
| |          */
| |         if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) &&
| |             !cpu_has_apic) {
| |                 if (!disable_apic) {
| |                         pr_err("BIOS bug, local APIC #%d not detected!...\n",
| |                                 boot_cpu_physical_apicid);
| |                         pr_err("... forcing use of dummy APIC emulation."
| |                                 "(tell your hw vendor)\n");
| |                 }
| |                 smpboot_clear_io_apic();
| |                 arch_disable_smp_support();
| |                 return -1;
| |         }
|
...

I've just emulated the situation where this if() triggered via
disable_apic boot option and without if (!disable_apic) we
have just a wrong message about BIOS bug (which is not since
we've disabled apic by hands). So no need to remove this
"if (!disable_apic)" snippet. In most cases it will be
always-true condition but for rare cases it'll be usefull
as well.

Now I'm trying to fake apic integrated case so we could
need additional check here...
 
	-- Cyrill
