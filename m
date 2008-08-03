Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981AbYHCEVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbYHCEVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 00:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYHCEVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 00:21:16 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:46825 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbYHCEVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 00:21:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wXPMbRNR17shSyw3j0aZSFigcLrbFQSOMqm8XHxyx0pg8QnAbDJEFxGE/A5lESG0o3
         e/vEyTMz2kWvXNJSEedPUbtGnWqawc0EQZeIyyAiGT6foKJPrCxeTLRmDqGT+uFYr367
         hvIZ0cooY1Z5k8QhNL2WTZB4I1qsRKbrTogTM=
Message-ID: <86802c440808022121u3dcdbda2s5ff463f4b330ca17@mail.gmail.com>
Date: Sat, 2 Aug 2008 21:21:14 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [PATCH 03/25] add dyn_array support
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <871w163fuw.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-2-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-3-git-send-email-yhlu.kernel@gmail.com>
	 <1217732365-16595-4-git-send-email-yhlu.kernel@gmail.com>
	 <871w163fuw.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 2, 2008 at 9:03 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
> Hi,
>
> Yinghai Lu <yhlu.kernel@gmail.com> writes:
>
>> could have crazy big arrays and allocate them in bootmem at init stage.
>> also also to allocate array according to size we need to use to avoid wasting
>> memory
>> use CONFIG_HAVE_DYN_ARRAY to enable it or not
>>
>> usage:
>>
>> |static struct irq_desc irq_desc_init __initdata = {
>> |       .status = IRQ_DISABLED,
>> |       .chip = &no_irq_chip,
>> |       .handle_irq = handle_bad_irq,
>> |       .depth = 1,
>> |       .lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
>> |#ifdef CONFIG_SMP
>> |       .affinity = CPU_MASK_ALL
>> |#endif
>> |};
>> |
>> |static void __init init_work(void *data)
>> |{
>> |       struct dyn_array *da = data;
>> |       struct  irq_desc *desc;
>> |       int i;
>> |
>> |       desc = *da->name;
>
> Where *da->name might be NULL...

you can not pass compiling

+#define DEFINE_DYN_ARRAY(nameX, sizeX, nrX, alignX, init_workX) \
+               static struct dyn_array __dyn_array_##nameX __initdata = \
+               {       .name = (void **)&nameX,\
+                       .size = sizeX,\
+                       .nr   = &nrX,\
+                       .align = alignX,\
+                       .init_work = init_workX,\
+               }; \
+               static struct dyn_array *__dyn_array_ptr_##nameX __used \
+               __attribute__((__section__(".dyn_array.init"))) = \
+                       &__dyn_array_##nameX
+

YH
