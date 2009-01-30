Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbZA3OoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbZA3OoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 09:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZA3OoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 09:44:11 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:48697 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbZA3OoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 09:44:10 -0500
Message-ID: <4983122F.1010909@linux.vnet.ibm.com>
Date: Fri, 30 Jan 2009 12:43:59 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080722)
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, jmorris@namei.org, zohar@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] TPM: sysfs functions consolidation
References: <cover.1233060433.git.srajiv@linux.vnet.ibm.com> <83b938103ecea5b82372cf55c722d7e986959f62.1233269000.git.srajiv@linux.vnet.ibm.com> <1233274749.12333.38.camel@localhost>
In-Reply-To: <1233274749.12333.38.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Helsley wrote:
> On Thu, 2009-01-29 at 21:01 -0200, Rajiv Andrade wrote:
>   
>> According to Dave Hansen's comments on the tpm_show_*, some of these functions
>> present a pattern when allocating data[] memory space and also when setting its
>> content. A new function was created so that this pattern could be consolidated.
>> Also, replaced the data[] command vectors and its indexes by meaningful structures
>> as pointed out by Matt Helsley too.
>>
>> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
>> ---
>>  drivers/char/tpm/tpm.c |  410 +++++++++++++++++-------------------------------
>>  drivers/char/tpm/tpm.h |  117 ++++++++++++++
>>  2 files changed, 258 insertions(+), 269 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
>> index 9c47dc4..58ea16f 100644
>> --- a/drivers/char/tpm/tpm.c
>> +++ b/drivers/char/tpm/tpm.c
>>     
>
> <snip>
>
>   
>> -	rc = transmit_cmd(chip, data, sizeof(data),
>> +	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
>>  			"attempting to determine the timeouts");
>>  	if (rc)
>>  		goto duration;
>>
>> -	if (be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_SIZE_IDX)))
>> +	if (be32_to_cpu(tpm_cmd.header.out.length)
>>  	    != 4 * sizeof(u32))
>>  		goto duration;
>>
>> +	timeout_cap = &tpm_cmd.params.getcap_out.cap.timeout;
>>  	/* Don't overwrite default if value is 0 */
>> -	timeout =
>> -	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_1_IDX)));
>> +	timeout = be32_to_cpu(timeout_cap->a);
>>  	if (timeout)
>>  		chip->vendor.timeout_a = usecs_to_jiffies(timeout);
>> -	timeout =
>> -	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_2_IDX)));
>> +	timeout = be32_to_cpu(timeout_cap->b);
>>  	if (timeout)
>>  		chip->vendor.timeout_b = usecs_to_jiffies(timeout);
>> -	timeout =
>> -	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_3_IDX)));
>> +	timeout = be32_to_cpu(timeout_cap->c);
>>  	if (timeout)
>>  		chip->vendor.timeout_c = usecs_to_jiffies(timeout);
>> -	timeout =
>> -	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_4_IDX)));
>> +	timeout = be32_to_cpu(timeout_cap->d);
>>  	if (timeout)
>>  		chip->vendor.timeout_d = usecs_to_jiffies(timeout);
>>     
>
> Are jiffies really the appropriate units of time for the needs of this
> driver? I could easily be wrong but I thought most drivers were
> discouraged from using jiffies since HZ is configurable...
>
>   
The timeout is converted from usecs to jiffies before assigning it to 
chip->vendor.timeout_*, so even with boxes with different configured HZ, 
those values would be the same in usecs.
Hopefully there's no way to modify HZ in runtime.
>>  duration:
>> -	memcpy(data, tpm_cap, sizeof(tpm_cap));
>> -	data[TPM_CAP_IDX] = TPM_CAP_PROP;
>> -	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_TIS_DURATION;
>> +	tpm_cmd.header.in = tpm_getcap_header;
>> +	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
>> +	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
>> +	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_DURATION;
>>
>> -	rc = transmit_cmd(chip, data, sizeof(data),
>> +	rc = transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
>>  			"attempting to determine the durations");
>>  	if (rc)
>>  		return;
>>
>> -	if (be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_SIZE_IDX)))
>> +	if (be32_to_cpu(tpm_cmd.header.out.return_code)
>>  	    != 3 * sizeof(u32))
>>  		return;
>> -
>> +	timeout_cap = &tpm_cmd.params.getcap_out.cap.timeout;
>>  	chip->vendor.duration[TPM_SHORT] =
>> -	    usecs_to_jiffies(be32_to_cpu
>> -			     (*((__be32 *) (data +
>> -					    TPM_GET_CAP_RET_UINT32_1_IDX))));
>> +	    usecs_to_jiffies(be32_to_cpu(timeout_cap->a));
>>  	/* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
>>  	 * value wrong and apparently reports msecs rather than usecs. So we
>>  	 * fix up the resulting too-small TPM_SHORT value to make things work.
>> @@ -565,13 +578,9 @@ duration:
>>  		chip->vendor.duration[TPM_SHORT] = HZ;
>>
>>  	chip->vendor.duration[TPM_MEDIUM] =
>> -	    usecs_to_jiffies(be32_to_cpu
>> -			     (*((__be32 *) (data +
>> -					    TPM_GET_CAP_RET_UINT32_2_IDX))));
>> +	    usecs_to_jiffies(be32_to_cpu(timeout_cap->b));
>>  	chip->vendor.duration[TPM_LONG] =
>> -	    usecs_to_jiffies(be32_to_cpu
>> -			     (*((__be32 *) (data +
>> -					    TPM_GET_CAP_RET_UINT32_3_IDX))));
>> +	    usecs_to_jiffies(be32_to_cpu(timeout_cap->c));
>>     
>
> OK, so it looks like these timeouts are short, medium, and long-duration
> timeouts and those correspond to "a", "b", and "c". What's "d"? Also
> this suggests slightly-better names for these fields. If you can think
> of short names suggesting why these separate, varying-length timeouts
> are needed that could be even better.
>
> <snip>
>
>   
Yes, the timeout_cap struct isn't appropriate here to read the 
TIS_DURATION capability, which has a different meaning from the timeout 
one and hasn't a forth field to be assigned. I'll write the duration_cap 
struct and make use of it here and resubmit this patch.
>> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>> index 8e30df4..867987d 100644
>> --- a/drivers/char/tpm/tpm.h
>> +++ b/drivers/char/tpm/tpm.h
>>     
>
> <snip>
>
>   
>> +struct	timeout_t {
>> +	__be32	a;
>> +	__be32	b;
>> +	__be32	c;
>> +	__be32	d;
>> +}__attribute__((packed));
>>     
>
> As I pointed out above I think these could use better names. I also
> noticed that there are timeout_a, timeout_b, etc. fields of another
> struct (somewhere under "chips" if I recall..). Perhaps similar naming
> -- maybe even this struct -- should be (re)used?
>   
> <snip>
>
>   
Yes, it's inside tpm_vendor_specific struct, but this one has __be32 
fields. The tpm_vendor_specific struct has these timeout fields and  but 
also a bunch of others, so unfortunately no reuse could be done.

Thanks reviewing it,
Rajiv

