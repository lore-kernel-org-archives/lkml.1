Return-Path: <linux-kernel-owner+w=401wt.eu-S1751831AbYCJPCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbYCJPCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYCJPCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:02:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbYCJPCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:02:31 -0400
Message-ID: <47D54C7E.3010304@redhat.com>
Date: Mon, 10 Mar 2008 09:58:06 -0500
From: Larry Woodman <lwoodman@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4.2) Gecko/20040301
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] extend sysrq-p functionality to cover all CPUs
References: <20080309221458.20642e48@bree.surriel.com> <20080309224759.6fead9af.akpm@linux-foundation.org>
In-Reply-To: <20080309224759.6fead9af.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>On Sun, 9 Mar 2008 22:14:58 -0400 Rik van Riel <riel@surriel.com> wrote:
>
>  
>
>>SysRP-P is not all that useful on SMP systems, since the sysrq
>>irq rarely ends up on the CPU that we actually want to investigate.
>>
>>This patch extends sysrq-p to print a backtrace for every CPU,
>>not just the lucky one that gets the sysrq irq.  With this patch,
>>"echo p > /proc/sysrq-trigger" does something useful.
>>
>>Signed-off-by: Rik van Riel <riel@redhat.com>
>>
>>diff -up linux-2.6.25-rc3-mm1/drivers/char/sysrq.c.multicpu linux-2.6.25-rc3-mm1/drivers/char/sysrq.c
>>--- linux-2.6.25-rc3-mm1/drivers/char/sysrq.c.multicpu	2008-03-09 20:22:17.000000000 -0400
>>+++ linux-2.6.25-rc3-mm1/drivers/char/sysrq.c	2008-03-09 21:54:02.000000000 -0400
>>@@ -196,11 +196,29 @@ static struct sysrq_key_op sysrq_showloc
>> #define sysrq_showlocks_op (*(struct sysrq_key_op *)0)
>> #endif
>> 
>>+static DEFINE_SPINLOCK(show_lock);
>>+static void showacpu(void *dummy)
>>+{
>>+	struct pt_regs *regs = get_irq_regs();
>>+
>>+	spin_lock(&show_lock);
>>+	printk("CPU%d:\n", smp_processor_id());
>>+	show_stack(NULL, NULL);
>>+	spin_unlock(&show_lock);
>>+}
>>+static void sysrq_showregs_othercpus(struct work_struct *dummy)
>>+{
>>+	smp_call_function(showacpu, NULL, 0, 0);
>>+}
>>+static DECLARE_WORK(sysrq_showregs, sysrq_showregs_othercpus);
>> static void sysrq_handle_showregs(int key, struct tty_struct *tty)
>> {
>> 	struct pt_regs *regs = get_irq_regs();
>>-	if (regs)
>>+	if (regs) {
>>+		printk("CPU%d:\n", smp_processor_id());
>> 		show_regs(regs);
>>+	}
>>+	schedule_work(&sysrq_showregs);
>> }
>> static struct sysrq_key_op sysrq_showregs_op = {
>> 	.handler	= sysrq_handle_showregs,
>>    
>>
>
>Doesn't everyone have a copy of this somewhere? ;)
>

Yes, but we use W instead of P.  Dont you want to keep the old AlsSysrq 
P and add
a new SPM version using a defferent letter ?

Larry

>
>However it does have the downside that info can scroll away on large cpu
>counts.  Maybe it should be a new sysrq command?
>
>  
>


