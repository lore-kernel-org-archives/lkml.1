Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbZJOH7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbZJOH7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 03:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbZJOH7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 03:59:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:23844 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128AbZJOH7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 03:59:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,565,1249282800"; 
   d="scan'208";a="457643123"
From: "Wang, Shane" <shane.wang@intel.com>
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Date: Thu, 15 Oct 2009 15:57:21 +0800
Subject: RE: [PATCH] intel_txt: add s3 userspace memory integrity
	verification
Thread-Topic: [PATCH] intel_txt: add s3 userspace memory integrity
	verification
Thread-Index: AcpFJKulI4VaMumtT6yJkLui35CqzAHaXiOQ
Message-ID: <037F493892196B458CD3E193E8EBAD4F01EDB41C7E@pdsmsx502.ccr.corp.intel.com>
References: <4A9CE0B2.5060608@intel.com> <4ABF2B50.6070106@intel.com>
 <20091004185801.GC1378@ucw.cz>
In-Reply-To: <20091004185801.GC1378@ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

part of answers.
Pavel Machek wrote:
> On Sun 2009-09-27 17:07:28, Shane Wang wrote:
>> This patch added verification for userspace memory integrity after
>> s3 resume. Integrity verification for other memory (say kernel
>> itself) has been done by tboot. 
>> 
> 
> AFAICT, it verifies userspace _and_ kernel memory, that's why it does
> magic stack switching. Why not verify everything in tboot?
Because tboot only can access <4G mem and the memory is sparse.
Tboot likes to MAC the continuous mem.

> 
> Is kernel<->tboot abi described somewhere?
> 
>> @@ -168,6 +174,80 @@ static void tboot_create_trampoline(void  		   
>>  map_base, map_size); }
>> 
>> +static vmac_t mem_mac;
>> +static struct crypto_hash *tfm;
> 
> Could these be automatic?
We don't wish the memory is changing when MACing, including the static variables.

>> +void tboot_sx_resume(void)
>> +{
>> +	vmac_t mac;
>> +
>> +	if (!tboot_enabled())
>> +		return;
>> +
>> +	if (tboot_gen_mem_integrity(tboot->s3_key, &mac))
>> +		panic("tboot: vmac generation failed\n");
>> +	else if (mac != mem_mac)
>> +		panic("tboot: memory integrity was lost on resume\n"); +	else
>> +		pr_info("memory integrity OK\n");
> 
> So I corrupt memory, but also corrupt tboot_enabled() to return 0....
You corrupt the memory and tboot_enabled(). tboot MACing will find it.

 
> And... does panic kill the machine quickly enough that no 'bad stuff'
> happens? (Whats bad stuff in this context, anyway?).
Do you have some suggestions on it?

Shane