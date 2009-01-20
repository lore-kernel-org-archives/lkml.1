Return-Path: <linux-kernel-owner+w=401wt.eu-S1761738AbZATS1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761738AbZATS1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 13:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZATS04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 13:26:56 -0500
Received: from relay1.sgi.com ([192.48.179.29]:59200 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752152AbZATS0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 13:26:55 -0500
Message-ID: <4976176B.2090907@sgi.com>
Date: Tue, 20 Jan 2009 10:26:51 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ben Hutchings <bhutchings@solarflare.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       linux-net-drivers@solarflare.com
Subject: Re: [PATCH 4/5] cpumask: convert drivers/net/sfc [PATCH supplied]
References: <20090107195832.265117000@polaris-admin.engr.sgi.com> <20090107195832.871689000@polaris-admin.engr.sgi.com> <1232384910.31644.13.camel@achroite> <200901201209.34854.rusty@rustcorp.com.au>
In-Reply-To: <200901201209.34854.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tuesday 20 January 2009 03:38:30 Ben Hutchings wrote:
>> On Wed, 2009-01-07 at 11:58 -0800, Mike Travis wrote:
>>> From: Rusty Russell <rusty@rustcorp.com.au>
>>>
>>> Impact: reduce stack usage, use new cpumask API.
>>>
>>> Remove a cpumask from the stack.  Ben Hutchings indicated that printing
>>> a warning and returning 1 was acceptable for the corner case where allocation
>>> fails.
>>>
>>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>>> Signed-off-by: Mike Travis <travis@sgi.com>
>>> Cc: Ben Hutchings <bhutchings@solarflare.com>
>>> Cc: linux-net-drivers@solarflare.com
>> Acked-by: Ben Hutchings <bhutchings@solarflare.com>
>>
>> This seems to work.
>>
>>> ---
>>>  drivers/net/sfc/efx.c |   15 +++++++++++----
>>>  1 file changed, 11 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/sfc/efx.c b/drivers/net/sfc/efx.c
>>> --- a/drivers/net/sfc/efx.c
>>> +++ b/drivers/net/sfc/efx.c
>>> @@ -854,20 +854,27 @@ static void efx_fini_io(struct efx_nic *
>>>   * interrupts across them. */
>>>  static int efx_wanted_rx_queues(void)
>>>  {
>>> -	cpumask_t core_mask;
>>> +	cpumask_var_t core_mask;
>>>  	int count;
>>>  	int cpu;
>>>  
>>> -	cpus_clear(core_mask);
>>> +	if (!alloc_cpumask_var(&core_mask, GFP_KERNEL)) {
>>> +		printk(KERN_WARNING
>>> +		       "efx.c: allocation failure, irq balancing hobbled\n");
>> [...]
>>
>> This is an exceedingly unlikely error case so the error message is not
>> that important, but if you don't mind re-spinning this then please make
>> it "sfc: RSS disabled due to allocation failure\n".
> 
> OK, I'm away from all my machines, at linux.conf.au.  Mike, can you change
> this if you haven't already?
> 
> Thanks,
> Rusty.
> 

Subject: sfc: modify allocation error message

Impact: change error message when alloc_cpumask_var fails.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 drivers/net/sfc/efx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6-for-ingo.orig/drivers/net/sfc/efx.c
+++ linux-2.6-for-ingo/drivers/net/sfc/efx.c
@@ -858,9 +858,9 @@ static int efx_wanted_rx_queues(void)
 	int count;
 	int cpu;
 
-	if (!alloc_cpumask_var(&core_mask, GFP_KERNEL)) {
+	if (unlikely(!alloc_cpumask_var(&core_mask, GFP_KERNEL))) {
 		printk(KERN_WARNING
-		       "efx.c: allocation failure, irq balancing hobbled\n");
+		       "sfc: RSS disabled due to allocation failure\n");
 		return 1;
 	}
 


