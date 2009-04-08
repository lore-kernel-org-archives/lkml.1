Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZDHPyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZDHPyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbZDHPy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:54:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:7859 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbZDHPy2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:54:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SWTpV1srFUQJ0Z75wD8jxFYgdbchm3gkN/t4gdwUGKoNh6Xc6viFt9bLRN1bXNag7T
         5vi4/2f2waJ1UMDmDlxoqqdvA5Gaz7hNF/1Om1GOfsvUhg3XBfr1BzY8kw4qHB7ad8eS
         RV9TxM4WB0NfzhHkRwiNtNlS9qYNW1JIlurbg=
MIME-Version: 1.0
In-Reply-To: <20090408125415.GJ18581@elte.hu>
References: <49D68FBC.7010602@kernel.org> <49D6900B.2020107@kernel.org>
	 <20090408125415.GJ18581@elte.hu>
Date: Wed, 8 Apr 2009 08:54:27 -0700
Message-ID: <86802c440904080854t6a8b6a68sf7ffe02a8752637b@mail.gmail.com>
Subject: Re: [PATCH 2/2] irq: only update affinity in chip set_affinity()
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 5:54 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> Impact: keep affinity consistent
>>
>> irq_set_affinity() and move_masked_irq() try to assign affinity
>> before calling chip set_affinity(). some archs are assigning again
>> in set_affinity again.
>>
>> something like:
>> cpumask_cpy(desc->affinity, mask);
>> desc->chip->set_affinity(mask);
>>
>> in the failing path, affinity should not be touched.
>>
>> also set_extra_move_desc() ( called by set_affinity) will rely on
>> the old affinity to decide if need to move irq_desc to different
>> node when logical flat apic mode is used.
>>
>> So try remove those assignment, and make some missed arch to
>> assign affinity in their set_affinity.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> --
>>  arch/alpha/kernel/sys_dp264.c         |    6 ++++--
>>  arch/alpha/kernel/sys_titan.c         |    3 ++-
>>  arch/arm/common/gic.c                 |    1 +
>>  arch/cris/arch-v32/kernel/irq.c       |    1 +
>>  arch/ia64/kernel/iosapic.c            |    3 +++
>>  arch/ia64/sn/kernel/irq.c             |    3 +++
>>  arch/mips/cavium-octeon/octeon-irq.c  |    6 ++++++
>>  arch/mips/sibyte/bcm1480/irq.c        |    2 ++
>>  arch/mips/sibyte/sb1250/irq.c         |    2 ++
>>  arch/powerpc/platforms/pseries/xics.c |    5 +++++
>>  arch/powerpc/sysdev/mpic.c            |    2 ++
>>  arch/sparc/kernel/irq_64.c            |    7 +++++++
>>  drivers/xen/events.c                  |    2 ++
>>  kernel/irq/manage.c                   |    6 ++----
>>  kernel/irq/migration.c                |    8 +++-----
>>  15 files changed, 45 insertions(+), 12 deletions(-)
>
> Hm, this spreads a lot of instances of identical lines:
>
>   cpumask_copy(irq_desc[irq].affinity, mask_val);
>
> all around architectures. How is that an improvement?
>

in failing path in set_affinity, for example it can not get vector in
specified cpu,
then affinity should not be changed.

YH
