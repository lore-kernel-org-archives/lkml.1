Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbYIRG6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbYIRG6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 02:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYIRG6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 02:58:10 -0400
Received: from smtp.extricom.com ([192.114.46.18]:50993 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752673AbYIRG6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 02:58:08 -0400
Message-ID: <48D1FC1C.90409@extricom.com>
Date: Thu, 18 Sep 2008 09:58:36 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 2.6.26] SERIAL DRIVER: Handle Multiple consecutive sysrq
 from the serial
References: <48591941.4070408@extricom.com>	<48A92E15.2080709@extricom.com>	<48A9901B.1080900@redhat.com>	<20080818154746.GA26835@Krystal>	<48A9AFA7.8080508@freescale.com>	<alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com>	<1219110814.8062.2.camel@pasglop>	<alpine.DEB.1.10.0808182208110.13401@gandalf.stny.rr.com>	<1219113549.8062.13.camel@pasglop>	<1219114600.8062.15.camel@pasglop>	<alpine.DEB.1.10.0808182304300.13401@gandalf.stny.rr.com>	<1219119431.8062.35.camel@pasglop>	<1219216705.21386.46.camel@pasglop>	<alpine.DEB.1.10.0808200913070.13132@gandalf.stny.rr.com>	<1219241819.26429.24.camel@jdub.homelinux.org>	<alpine.DEB.1.10.0808201022080.23571@gandalf.stny.rr.com>	<20080820105035.49f29509@zod.rchland.ibm.com>	<48CE8D8D.1070407@extricom.com> <20080917164615.945ff068.akpm@linux-foundation.org>
In-Reply-To: <20080917164615.945ff068.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 15 Sep 2008 19:30:05 +0300
> Eran Liberty <liberty@extricom.com> wrote:
>
>   
>> Dear Penguins,
>>
>> Let me start of by saying my particular hardware must be buggy in some 
>> way. When I issue a sysrq (Ctrl A+ F from minicom) I get a lot of sysrq 
>> triggers.
>>
>> I have worked around the problem and I think this workaround is a viable 
>> patch even for platforms which do not exhibit this peculiar behavior.
>>
>> upon getting numerous interrupts which request sysrq the function 
>> uart_handle_break in include/linux/serial_core.h is hit multiple times.
>> The current code which looks like this:
>>
>> static inline int uart_handle_break(struct uart_port *port)
>>  {
>>         struct uart_info *info = port->info;
>>  #ifdef SUPPORT_SYSRQ
>>         if (port->cons && port->cons->index == port->line) {
>>                if (!port->sysrq) {
>>                        port->sysrq = jiffies + HZ*5;
>>                        return 1;
>>                }
>>                port->sysrq = 0;
>>         }
>>  #endif
>>         if (port->flags & UPF_SAK)
>>                 do_SAK(info->tty);
>>        return 0;
>> }
>>
>> Will basicly toggle port->sysrq between a timeout value and zero. If you 
>> are lucky this penguin rullet will stop on timeout and the next 
>> character hit will trigger the sysrq in the function 
>> "uart_handle_sysrq_char". But if you are not so lucky the last sysrq 
>> interupt will toggle port->sysrq to zero and the next char hit will be 
>> ignored (not trigger sysrq).
>>
>> The suggested patch will do the next few things:
>>
>> 1. "port->sysrq" is now the time when the last sysrq was triggered and 
>> not the timeout for the the next char
>> 2. Stamped "port->sysrq" every time there is a sysrq rather then toggled 
>> it up and down.
>> 3. Always continue to consider UPF_SAK.
>> 4. "port->sysrq" is toggled back to zero only in uart_handle_break() and 
>> only if the a char has been accepted after the sysrq timeout (5 sec)
>> 5. uart_handle_break() will ignore extra chars received in super human 
>> speed after the last sysrq (0.01 sec)
>>
>>     
>
> yes, that could be irritating.
>
>   
>> Index: include/linux/serial_core.h
>> ===================================================================
>> --- include/linux/serial_core.h	(revision 119)
>> +++ include/linux/serial_core.h	(revision 120)
>>     
>
> We prefer patches in `patch -p1' form, please.
>
> Even after fixing that, none of it applied, so I typed it in again.
>   
So  should I resubmit or have you done then nasty work for me (thanks :) )?
>   
>> @@ -447,8 +447,8 @@
>>  uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
>>  {
>>  #ifdef SUPPORT_SYSRQ
>> -	if (port->sysrq) {
>> -		if (ch && time_before(jiffies, port->sysrq)) {
>> +	if (port->sysrq && time_after(jiffies, port->sysrq + (unsigned long)(HZ*0.01))) {
>> +		if (ch && time_before(jiffies, port->sysrq + HZ*5)) {
>>  			handle_sysrq(ch, port->info ? port->info->tty : NULL);
>>  			port->sysrq = 0;
>>  			return 1;
>> @@ -467,19 +467,17 @@
>>   */
>>  static inline int uart_handle_break(struct uart_port *port)
>>  {
>> +	int ret = 0;
>>  	struct uart_info *info = port->info;
>>  #ifdef SUPPORT_SYSRQ
>>  	if (port->cons && port->cons->index == port->line) {
>> -		if (!port->sysrq) {
>> -			port->sysrq = jiffies + HZ*5;
>> -			return 1;
>> -		}
>> -		port->sysrq = 0;
>> +		port->sysrq = jiffies;
>> +		ret = 1;
>>  	}
>>  #endif
>>  	if (port->flags & UPF_SAK)
>>  		do_SAK(info->tty);
>> -	return 0;
>> +	return ret;
>>  }
>>     
>
> The 0.01 is a big no-no.  Sometimes gcc like to go into stupid mode and
> starts doing floating point stuff.
>
> A suitable fix would be to use HZ/100.  But that assumes that HZ is
> always >= 100.  That's a pretty good assumption, and various parts of
> the kernel will explode if HZ is set too small.  However it's always
> good to ensure that someone else's stuff will explode before yours
> does, so how about we make it HZ/50?  Will that still work OK for you?
>   

HZ/50 is totally OK by me.


-- Liberty
