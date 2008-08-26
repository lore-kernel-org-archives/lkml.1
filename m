Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbYHZIgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbYHZIgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYHZIgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:36:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:24167 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbYHZIgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:36:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EZZe4aJxvwYsnDcDOx5hbdoMQhKMcQGheFCUnNU9HlTf95p/3itJJsM+MK2EvLNB6U
         w3s3gtyDmngdWp4BS6bBvcl6TE78x1eWo9/y5XdHzZD410GLOEMGIh6j9EKxKAan2ltm
         D6vuhj+DejR9GI5W/pOHJU2WkV3eVaSxB0YpY=
Message-ID: <86802c440808260136t3a33a9c8if53b6f70ab9df9e2@mail.gmail.com>
Date: Tue, 26 Aug 2008 01:36:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Cc: "David Miller" <davem@davemloft.net>, torvalds@linux-foundation.org,
       Alan.Brunelle@hp.com, travis@sgi.com, tglx@linutronix.de, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       akpm@linux-foundation.org, arjan@linux.intel.com, rusty@rustcorp.com.au
In-Reply-To: <20080826075355.GA7596@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808251401590.3363@nehalem.linux-foundation.org>
	 <20080826072220.GB31876@elte.hu>
	 <20080826.004607.253712060.davem@davemloft.net>
	 <20080826075355.GA7596@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 12:53 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * David Miller <davem@davemloft.net> wrote:
>
>> From: Ingo Molnar <mingo@elte.hu>
>> Date: Tue, 26 Aug 2008 09:22:20 +0200
>>
>> > And i guess the next generation of 4K CPUs support should just get away
>> > from cpumask_t-on-kernel-stack model altogether, as the current model is
>> > not maintainable. We tried the on-kernel-stack variant, and it really
>> > does not work reliably. We can fix this in v2.6.28.
>>
>> I recenetly did some work on sparc64 to use cpumask pointers as much
>> as possible.
>>
>> The only case that didn't work was due to a limitation in arch
>> interfaces for the new generic smp_call_function() code. It passes a
>> cpumask_t instead of a pointer to one via
>> arch_send_call_function_ipi().
>>
>> But other than that, the whole sparc64 SMP stuff uses cpumask_t
>> pointers only.

wonder if could use "unsigned long *" directly.
so could dyn_array directly like

int cpumask_size;

unsigned long *online_cpu_map;
DEFINE_DYN_ARRAY(online_cpu_map, sizeof(unsigned long), cpumask_size,
PAGE_SIZE, NULL);

and after nr_cpu_ids is assigned, have
cpumask_size = (nr_cpu_ids + sizeof(unsigned long) - 1)/sizeof(unsigned long);

then we could NR_CPUS=4096 kernel to small system. ...

YH
