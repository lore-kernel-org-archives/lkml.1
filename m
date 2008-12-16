Return-Path: <linux-kernel-owner+w=401wt.eu-S1757090AbYLPLp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbYLPLp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYLPLpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:45:17 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:3920 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbYLPLpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:45:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=WICfOUcyg6ZoHaSxLwCTpP6dclx9QVDjf+RfMYZXhjXWAFmINNGe+kK7QVIggaO+IL
         W8NZbQvlM8gEob3EFtIMDb6u/mPInqqHZmcaP6l+xini6jzKIkBG2tr1tAB5+qBLkcuS
         LUkqZx/IpuboKYbyfCZlgOzaVCjGA+597WGks=
Message-ID: <2f11576a0812160345t1cca65eg34064dbbcafcd280@mail.gmail.com>
Date: Tue, 16 Dec 2008 20:45:14 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [mmotm and linux-next][PATCH] irq: enclose irq_desc_lock_class in CONFIG_LOCKDEP
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>
In-Reply-To: <20081216112019.GE4299@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081216170635.DBB8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081216003428.43d37b6b.akpm@linux-foundation.org>
	 <20081216101827.GB27481@elte.hu> <20081216102340.GA1003@elte.hu>
	 <2f11576a0812160315g3dea988ayfadba2117e172a2c@mail.gmail.com>
	 <20081216112019.GE4299@elte.hu>
X-Google-Sender-Auth: c555d6f36a14eccb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > actually, this breaks the build on !SPARSEIRQ because we will use that
>> > class in the non-sparseirq case. So we've converted a build warning to
>> > a build failure ;-)
>>
>> Please give me your .config and tell me your arch. my ia64 box (ia64 is
>> !SPARSEIRQ) can build the akpm patch.
>
> The expected build failure is obvious from reading the code:
>
>  #ifdef CONFIG_TRACE_IRQFLAGS
>  void early_init_irq_lock_class(void)
>  {
>  #ifndef CONFIG_SPARSE_IRQ
>         struct irq_desc *desc;
>         int i;
>
>         for_each_irq_desc(i, desc) {
>                 if (!desc)
>                         continue;
>
>                 lockdep_set_class(&desc->lock, &irq_desc_lock_class);
>
> Note that it's an #ifndef sparseirq, not an #ifdef sparseirq condition.

I see. thanks.
It seems my first proposal is better.

or, following #ifdef ?

#if defined(CONFIG_SPARSE_IRQ) || defined(CONFIG_TRACE_IRQFLAGS)

 /*
 * lockdep: we want to handle all irq_desc locks as a single lock-class:
 */
 static struct lock_class_key irq_desc_lock_class;

#endif
