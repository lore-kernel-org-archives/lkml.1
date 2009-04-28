Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbZD1Sd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbZD1Sd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbZD1SdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:33:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41539 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbZD1SdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:33:18 -0400
Message-ID: <49F74B9E.30105@zytor.com>
Date: Tue, 28 Apr 2009 11:31:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Borislav Petkov <borislav.petkov@amd.com>, greg@kroah.com,
       linux-kernel@vger.kernel.org, dougthompson@xmission.com,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 14/21] amd64_edac: add msr accessors operating on all
 cpus
References: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>	<1240931173-17477-15-git-send-email-borislav.petkov@amd.com> <20090428112107.af44e6db.akpm@linux-foundation.org>
In-Reply-To: <20090428112107.af44e6db.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>  
>> +/* stolen from msr.c - the calls in msr.c could be exported */
> 
> It would be preferable to export the functions from msr.c!  We do have a number
> of exported MSR manipulation functions in x86.
> 

Even better would be to add these functions to lib/msr.c.

>> +
>> +static void do_rdmsr(int cpu, u32 reg, u32 *eax, u32 *edx)
>> +{
>> +	struct msr_command cmd;
>> +
>> +	cmd.cpu = raw_smp_processor_id();
>> +	cmd.reg = reg;
>> +	on_each_cpu(smp_rdmsr, &cmd, 1);
>> +	*eax = cmd.data[0];
>> +	*edx = cmd.data[1];
>> +}
> 
> I'm all confused.  We interrupt _all_ CPUs and get each one of them to
> write to cmd.data[0] and cmd.data[1].  So what we end up returning is
> the result which was provided by the last CPU which got there,
> whichever CPU that was.
> 
> Am I mising something, or is this all totally screwy?
> 

For reads, certainly... the only sane way to do this would be to return
this into a array with per-CPU slots (since it's transient I don't think
we want to use a percpu varaible.)

For writes, what is there is fine, although perhaps less flexible than
it needs to be.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

