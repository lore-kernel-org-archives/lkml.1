Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbZGNIVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbZGNIVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 04:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZGNIVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 04:21:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:46376 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbZGNIVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 04:21:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=UMawxKWa1KVBzSTVmRiyfTgcc8lvBoV4Ff2wHzzfZUxSbeH1pKzpUHX7pypo/rAk7M
         tDghpOqRYM6hRnAqhU6Ti0Jo3RV7GP2ALwzWlls9Uk6ZJrKDRtepeekgDc6dMDIngzhG
         wJmUiXRLDvOA8SDrmFq2VmX+EB8+vL40ZBq6k=
Date: Tue, 14 Jul 2009 01:21:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
       linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kwangwoo.lee@gmail.com, Trilok Soni <soni.trilok@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] tsc2007: remove HR timer
Message-ID: <20090714082128.GF2822@dtor-d630.eng.vmware.com>
References: <4A40C288.2060702@mocean-labs.com> <20090714044957.GD2822@dtor-d630.eng.vmware.com> <20090714070806.GA1619@avionic-design.de> <4A5C3B06.7020207@mocean-labs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A5C3B06.7020207@mocean-labs.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 10:00:06AM +0200, Richard Röjfors wrote:
> On 7/14/09 9:08 AM, Thierry Reding wrote:
>> * Dmitry Torokhov wrote:
>>> Hi Richard,
>>>
>>> On Tue, Jun 23, 2009 at 01:54:48PM +0200, Richard Röjfors wrote:
>> [...]
>>> +static void tsc2007_free_irq(struct tsc2007 *ts)
>>> +{
>>> +	free_irq(ts->irq, ts);
>>> +	if (cancel_delayed_work_sync(&ts->work)) {
>>> +		/*
>>> +		 * Work was pending, therefore we need to enable
>>> +		 * IRQ here to balance the disable_irq() done in the
>>> +		 * interrupt handler.
>>> +		 */
>>> +		enable_irq(ts->irq);
>>> +	}
>>> +}
>> [...]
>>> -static int tsc2007_remove(struct i2c_client *client)
>>> +static int __devexit tsc2007_remove(struct i2c_client *client)
>>>   {
>>>   	struct tsc2007	*ts = i2c_get_clientdata(client);
>>> -	struct tsc2007_platform_data *pdata;
>>> +	struct tsc2007_platform_data *pdata = client->dev.platform_data;
>>>
>>> -	cancel_delayed_work_sync(&ts->work);
>>> +	free_irq(ts->irq, ts);
>>> +	if (cancel_delayed_work_sync(&ts->work)) {
>>> +		/*
>>> +		 * Work was pending, therefore we need to enable
>>> +		 * IRQ here to balance the disabel done in the
>>> +		 * interrupt handler.
>>> +		 */
>>> +		enable_irq(ts->irq);
>>> +	}
>>
>> Shouldn't this be tsc2007_free_irq(ts) as well?
>
> Is this really good enough? The work function might re-enable the IRQ.

I am pretty sure it is. cancel_delayed_work_sync() will terurn true if
there was work scheduled but not yet executed. In this case we know that
IRQ was disabled by interrupt handler and will re-enable it.

-- 
Dmitry
