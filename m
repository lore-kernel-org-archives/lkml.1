Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbZGNIUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbZGNIUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 04:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbZGNIUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 04:20:34 -0400
Received: from proxy1.bredband.net ([195.54.101.71]:35772 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZGNIUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 04:20:32 -0400
X-Greylist: delayed 1223 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jul 2009 04:20:32 EDT
X-SMTPAUTH-B2: 
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhB6AGfXW0pV5H3UPGdsb2JhbACBUZdRAQEBATe0XoQIBQ
X-IronPort-AV: E=Sophos;i="4.42,396,1243807200"; 
   d="scan'208";a="28851998"
Message-ID: <4A5C3B06.7020207@mocean-labs.com>
Date: Tue, 14 Jul 2009 10:00:06 +0200
From: =?UTF-8?B?UmljaGFyZCBSw7ZqZm9ycw==?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kwangwoo.lee@gmail.com, Trilok Soni <soni.trilok@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] tsc2007: remove HR timer
References: <4A40C288.2060702@mocean-labs.com> <20090714044957.GD2822@dtor-d630.eng.vmware.com> <20090714070806.GA1619@avionic-design.de>
In-Reply-To: <20090714070806.GA1619@avionic-design.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/14/09 9:08 AM, Thierry Reding wrote:
> * Dmitry Torokhov wrote:
>> Hi Richard,
>>
>> On Tue, Jun 23, 2009 at 01:54:48PM +0200, Richard Röjfors wrote:
> [...]
>> +static void tsc2007_free_irq(struct tsc2007 *ts)
>> +{
>> +	free_irq(ts->irq, ts);
>> +	if (cancel_delayed_work_sync(&ts->work)) {
>> +		/*
>> +		 * Work was pending, therefore we need to enable
>> +		 * IRQ here to balance the disable_irq() done in the
>> +		 * interrupt handler.
>> +		 */
>> +		enable_irq(ts->irq);
>> +	}
>> +}
> [...]
>> -static int tsc2007_remove(struct i2c_client *client)
>> +static int __devexit tsc2007_remove(struct i2c_client *client)
>>   {
>>   	struct tsc2007	*ts = i2c_get_clientdata(client);
>> -	struct tsc2007_platform_data *pdata;
>> +	struct tsc2007_platform_data *pdata = client->dev.platform_data;
>>
>> -	cancel_delayed_work_sync(&ts->work);
>> +	free_irq(ts->irq, ts);
>> +	if (cancel_delayed_work_sync(&ts->work)) {
>> +		/*
>> +		 * Work was pending, therefore we need to enable
>> +		 * IRQ here to balance the disabel done in the
>> +		 * interrupt handler.
>> +		 */
>> +		enable_irq(ts->irq);
>> +	}
>
> Shouldn't this be tsc2007_free_irq(ts) as well?

Is this really good enough? The work function might re-enable the IRQ.

Isn't it better to look at penstate, we know that the IRQ is enabled if 
the state is UP, else the IRQ is disabled.

--Richard
