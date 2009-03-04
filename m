Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbZCDADx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbZCDADx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbZCDADk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:03:40 -0500
Received: from h155.mvista.com ([63.81.120.158]:55716 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbZCDADj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:03:39 -0500
Message-ID: <49ADC559.7040705@ct.jp.nec.com>
Date: Tue, 03 Mar 2009 16:03:37 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: minyard@acm.org, linux-kernel@vger.kernel.org,
       openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH 4/5] IPMI: Add console oops catcher
References: <20090303152123.GD7777@minyard.local> <20090303132046.a8975963.akpm@linux-foundation.org>
In-Reply-To: <20090303132046.a8975963.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 03 Mar 2009 09:21:23 -0600
> Corey Minyard <minyard@acm.org> wrote:
> 
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> Console messages on oops or panic are very important to investigate problem.
>> Logging oops or panic messages to SEL is useful because SEL is a non
>> volatile memory.
>>
>> Implement a console driver to log messages to SEL when oops_in_progress is
>> not zero. The first message just after oops, panic or every 10 seconds from
>> last timestamp are logged as OEM event with timestamp, others are logged as
>> OEM event without timestamp.
>>
>> Enable config IPMI_OOPS_CONSOLE and add console=ttyIPMI to kernel command
>> line to log panic or oops messages to IPMI SEL.
>>
>> The number of entries for this output is limited by msg_limit paramter,
>> and the default value is 100.
>>
>>
>> ...
>>
>> +static void ipmi_oops_console_log_to_sel(int timestamp)
>> +{
>> +	struct ipmi_system_interface_addr si;
>> +	struct kernel_ipmi_msg msg;
>> +	unsigned int len;
>> +	unsigned char data[16];
>> +	unsigned char my_addr;
>> +
>> +	if (!oops_user || !msg_len || msg_count >= msg_limit)
>> +		return;
>> +
>> +	len = min((timestamp ? SEL_MSGSIZE_TIMESTAMP : SEL_MSGSIZE), msg_len);
>> +
>> +	si.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
>> +	si.channel = IPMI_BMC_CHANNEL;
>> +	si.lun = 0;
>> +
>> +	msg.netfn = IPMI_NETFN_STORAGE_REQUEST;
>> +	msg.cmd = IPMI_ADD_SEL_ENTRY_CMD;
>> +	msg.data = data;
>> +	msg.data_len = 16;
>> +
>> +	memset(data, 0, sizeof(data));
>> +	if (timestamp) {
>> +		len = min(SEL_MSGSIZE_TIMESTAMP, msg_len);
>> +		data[2] = 0xd1; /* OEM event with timestamp */
>> +		memcpy(data + 10, msg_ptr, len);
>> +		msg_jiffies = jiffies; /* save jiffies at timestamp */
>> +	} else {
>> +		len = min(SEL_MSGSIZE, msg_len);
>> +		data[2] = 0xf1; /* OEM event without timestamp */
>> +		memcpy(data + 3, msg_ptr, len);
>> +	}
>> +
>> +	preempt_disable();
> 
> This reader is unable to determine what the mystery preempt_disable()
> is here for.  It needs a comment, please.

I cannot recall why it's here. So a comment is really needed.
This preempt_disable() may not be needed.

> 
> 
>> +	if (ipmi_get_my_address(oops_user, 0, &my_addr))
>> +		goto out;
>> +
>> +	atomic_set(&oops_counter, 2);
> 
> What happens if two CPUs oops at the same time (which is fairly common)?

OK. I'll look at this.

> 
>> +	if (ipmi_request_supply_msgs(oops_user, (struct ipmi_addr *)&si,
>> +				     0, &msg, NULL, &oops_smi_msg,
>> +				     &oops_recv_msg, 1) < 0)
>> +		goto out;
>> +	while (atomic_read(&oops_counter) > 0) {
>> +		ipmi_poll_interface(oops_user);
>> +		cpu_relax();
>> +	}
> 
> It would be prudent to have a timeout in this loop.  The machine has
> crashed and subsystems and hardware and memory are in an unknown and
> possibly bad state.

Right.

> 
>> +	++msg_count;
>> +	msg_len -= len;
>> +	msg_ptr = msg_len ? &oops_msg[len] : oops_msg;
>> +out:
>> +	preempt_enable();
>> +}
>> +
>>
>> ...
>>
>> +static struct console oops_console = {
>> +	.name	= "ttyIPMI",
>> +	.write	= ipmi_oops_console_write,
>> +	.unblank = ipmi_oops_console_sync,
>> +	.index	= -1,
>> +};
> 
> This looks like we're abusing the "unblank" method.
> 
> If you think that the console subsystem is missing some capability
> which this driver needs then please do prefer to fix the console
> subsystem, rather than awkwardly making things fit.

OK. Will take a look about this point.

Thanks,
Hiroshi

