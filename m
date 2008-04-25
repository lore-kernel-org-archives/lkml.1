Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbYDYJqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbYDYJqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 05:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbYDYJp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 05:45:56 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:62472 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbYDYJpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 05:45:55 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Priit Laes <plaes@plaes.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [REGRESSION] x86: support for new UV apic
From: Andi Kleen <andi@firstfloor.org>
References: <1209098600.3707.13.camel@localhost>
	<20080425064405.GA23043@elte.hu>
Date: Fri, 25 Apr 2008 11:45:26 +0200
In-Reply-To: <20080425064405.GA23043@elte.hu> (Ingo Molnar's message of "Fri, 25 Apr 2008 08:44:06 +0200")
Message-ID: <87abjixo7d.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Apr 2008 09:38:35.0815 (UTC) FILETIME=[2234FB70:01C8A6B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Priit Laes <plaes@plaes.org> wrote:
>
>> Hey,
>> 
>> I am getting two following warnings (probable one per each CPU core) 
>> using the latest Linus's git:
>> 
>> WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x30/0x62()
>> Modules linked in:
>> Pid: 1, comm: swapper Not tainted 2.6.25-03563-gf7288b1 #20
>
> thanks - could you check the patch below, does it fix the warnings?

I think it would have been better to change the WARN_ON to

WARN_ON(preemptible() && num_online_cpus() > 1)

Preemption is actually ok here because this runs before the other
CPUs are started

Alternative patch appended.

-Andi

---

Don't warn in read_apic_id() when preemptible but only one CPU online.

Signed-off-by: Andi Kleen <andi@firstfloor.org>

Index: linux/arch/x86/kernel/genapic_64.c
===================================================================
--- linux.orig/arch/x86/kernel/genapic_64.c
+++ linux/arch/x86/kernel/genapic_64.c
@@ -83,7 +83,7 @@ unsigned int read_apic_id(void)
 {
 	unsigned int id;
 
-	WARN_ON(preemptible());
+	WARN_ON(preemptible() && num_online_cpus() > 1);
 	id = apic_read(APIC_ID);
 	if (uv_system_type >= UV_X2APIC)
 		id  |= __get_cpu_var(x2apic_extra_bits);
