Return-Path: <linux-kernel-owner+w=401wt.eu-S934012AbXFGSAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012AbXFGSAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 14:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbXFGR75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:59:57 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:4533 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147AbXFGR74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:59:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LTLBk/kX97t2HfTvs+3cbBpSy/4dWZ2Xxl03MHWJ2vr9deBonkLqhAcu5Uz+yMIPG3JSsGkZog4UuWVFutOZ+e8yUcpV4jZgk4LWLac3rOFujFRUCfomOqeNIyoiSKdQ0uO3PfSqZyoo0HgZGS0+mMKUz/26E0vhDRb/RaTSu8g=
Message-ID: <a781481a0706071059g7502f18co56cbb30477acf92f@mail.gmail.com>
Date: Thu, 7 Jun 2007 23:29:55 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] Make smp_call_function{_single} go WARNING and return -EINVAL on !SMP (was Re: [PATCH] i386/x86_64: NMI watchdog: Protect smp_call_function() within CONFIG_SMP)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Alan Cox" <alan@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>
In-Reply-To: <20070607175127.GA22844@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0706070848j2256cc1elea8723778ab7da5b@mail.gmail.com>
	 <a781481a0706070933ld67e06escaddf1b7be2b017@mail.gmail.com>
	 <20070607175127.GA22844@osiris.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > The smp_call_function{_single} functions are used to run
> > given function on all {or speicified} *other* CPUs. For
> > UP systems, "other" CPUs simply don't exist, so we flag
> > such incorrect usage of these functions using a WARNING.
>
> If other cpus don't exist then smp_call_function() should just do
> *nothing* (there is no other cpu right?). We don't want to sprinkle
> a ton of #ifdef CONFIG_SMP around each smp_call_function().

Yes, I suspected that, as mentioned on the other thread (ugh).

> > Also, -EBUSY is generally returned by arch implementations
> > when they find that target_cpu == current_cpu, which is not
> > a comparable case to the !SMP case. Use -EINVAL instead,
> > similar to what powerpc does for !cpu_online(target), which
> > is somewhat more analogous.
>
> No. Current semantics of smp_call_function_single() are that it
> returns -EBUSY if called on the *current* cpu. Since on !CONFIG_SMP the
> only possible cpu it can be called on is the current one, the only
> sane return value is -EBUSY.

The inherent assumption that on !SMP the only possible CPU it
can be called on is current (== 0) is precisely what I would want
to be asserted formally in the code over here. If so, then return
-EBUSY, else -EINVAL?
