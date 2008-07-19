Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbYGSIIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbYGSIIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 04:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbYGSIIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 04:08:07 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:34363 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbYGSIIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 04:08:05 -0400
Message-ID: <4881A161.7050902@keyaccess.nl>
Date: Sat, 19 Jul 2008 10:10:09 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [patch 1/3] fastboot: Create a "asynchronous" initlevel
References: <20080718151524.5ef9e29b@infradead.org> <20080718151608.46dc17c0@infradead.org> <48819D92.8050904@keyaccess.nl>
In-Reply-To: <48819D92.8050904@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-07-08 09:53, Rene Herman wrote:
> On 19-07-08 00:16, Arjan van de Ven wrote:
> 
>> +static void __init do_initcalls(void)
>> +{
>> +    initcall_t *call;
>> +    static DECLARE_WORK(async_work, do_async_initcalls);
>> +    int phase = 0; /* 0 = levels 0 - 6, 1 = level 6a, 2 = after level 
>> 6a */
>> +
>> +    async_init_wq = create_singlethread_workqueue("kasyncinit");
>> +
>> +    for (call = __initcall_start; call < __initcall_end; call++) {
>> +        if (phase == 0 && call >= __async_initcall_start) {
>> +            phase = 1;
>> +            queue_work(async_init_wq, &async_work);
>> +        }
>> +        if (phase == 1 && call >= __async_initcall_end)
>> +            phase = 2;
>> +        if (phase != 1)
>> +            do_one_initcall(*call);
>> +    }
> 
> I'm not sure about this comment, being not very sure about the semantics 
> of late_initcall but shouldn't late_initcall (level 7) wait for 6s to 
> have completed?

Following up on this myself -- see for example kernel/power/disk.c: 
power_suspend(). It's a late intitcall so that, as it comments, "all 
devices are discovered and initialized". However, your first followup 
patch makes the USB HCI init async meaning that any USB storage device 
might not be ready yet when it runs, no?

Rene.

