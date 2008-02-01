Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbYBAVK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbYBAVK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757904AbYBAVKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:10:53 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:59698 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757785AbYBAVKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:10:51 -0500
Message-ID: <47A38AD9.1060305@web.de>
Date: Fri, 01 Feb 2008 22:10:49 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Jason Wessel <jason.wessel@windriver.com>,
       kgdb-bugreport@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Kgdb-bugreport] [PATCH 4/5] KGDB-8250: refactor configuration
References: <479FBAE8.3070809@web.de> <479FC57D.5030104@web.de> <47A325BC.6030305@ru.mvista.com>
In-Reply-To: <47A325BC.6030305@ru.mvista.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/Z+PJkKv5+tBw3JMQ7tUxgndNyu2CoPwOH83x4
	Mo1l/ieqsbf/VJCEyNGcOlnKwGynEeOnrR5EBrezV+qwfgcN0l
	CzobjZ89A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Hello.
> 
> Jan Kiszka wrote:
> 
>> Sorry, previous version was missing some __init[data] attributes which
>> were dropped in an intermediate stage. Here comes an updated patch:
> 
>> <---snip--->
> 
>> This major refactoring of the quite complex kgdb8250 configuration does
>> the following:
> 
>>  - ensures that static configurations according to SERIAL_PORT_DFNS are
>>    always loaded first
>>  - tries to pull more accurate configuration via serial8250_get_port_def
>>    if simple-config is used
>>  - detects empty/invalid simple-configs
>>  - enforces KGDB_PORT_NUM <= SERIAL_8250_NR_UARTS at kconfig level
>>  - removes kgdb8250_add_port and its hook in serial_core (calling
>>    serial8250_get_port_def in demand should provide us the same
>>    information)
> 
>    You left powerpc-lite.patch broken with this change as it has
> multiple calls to kgdb8250_add_port()...

I see. But I wonder if there ever was a real need for these hooks (in
2.4 times?): If I look at bamboo_early_serial_map() e.g., I find it
calling into early_serial_setup() which fills serial8250_ports[] - and
that content is now retrieved via serial8250_get_port_def() when we
parse the runtime or build-time provided parameters (port number &
baudrate).

> 
>> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
> 
>> Index: b/drivers/serial/serial_core.c
>> ===================================================================
>> --- a/drivers/serial/serial_core.c
>> +++ b/drivers/serial/serial_core.c
> [...]
>> @@ -2370,12 +2369,6 @@ int uart_add_one_port(struct uart_driver
>>       */
>>      port->flags &= ~UPF_DEAD;
>>  
>> -#if defined(CONFIG_KGDB_8250)
>> -    /* Add any 8250-like ports we find later. */
>> -    if (port->type <= PORT_MAX_8250)
>> -        kgdb8250_add_port(port->line, port);
>> -#endif
>> -
> 
>    I'm afraid this wasn't correct from the very start since this can add
> ports with .iotype that 8250_kgdb.c does not support. So, nothing to
> regret here...

I think a lot of cruft piled up in the kgdb patches over their long life. :)

Thanks for your feedback!

Jan
