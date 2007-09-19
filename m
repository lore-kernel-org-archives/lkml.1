Return-Path: <linux-kernel-owner+w=401wt.eu-S1760108AbXISOZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108AbXISOZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 10:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbXISOZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 10:25:23 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:39643 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753871AbXISOZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 10:25:22 -0400
Message-ID: <46F1314B.8040105@grupopie.com>
Date: Wed, 19 Sep 2007 15:25:15 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Gilboa Davara <gilboad@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Reduce __print_symbol/sprint_symbol stack usage.
References: <1189856129.18191.11.camel@gilboa-home-dev.localdomain>  <a781481a0709150602v6be754caw4fbe0f76c8db5beb@mail.gmail.com>  <1189869329.18191.77.camel@gilboa-home-dev.localdomain> <1189879681.18191.93.camel@gilboa-home-dev.localdomain> <alpine.LFD.0.999.0709190610540.26241@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0709190610540.26241@enigma.security.iitk.ac.in>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On Sat, 15 Sep 2007, Gilboa Davara wrote:
>>  	printk(fmt, buffer);
>> +
>> +	spin_unlock_irqrestore(&symbol_lock, flags);
> 
> But I still don't much like this :-(

I must say I agree with Satyam here.

Locking in the panic path might leave us without some critical debug 
information, which is much more important than all this.

Maybe it would be better to change the print_symbol interface to avoid 
having a "char buffer[KSYM_SYMBOL_LEN];" at all.

Most print_symbol callers use something like "yada yada %s" as the 
format string, with an optional "\n" in the end.

if we change the interface from "print_symbol(fmt, addr)" to 
"print_symbol(prefix, addr, int newline)" we can simply do:

printk(prefix);
printk_symbol(addr);
if (newline)
	printk("\n");

where "printk_symbol" is a new function that does the same as 
sprint_symbol, but does "printk" instead of "sprintf".

This should reduce immensely the stack usage of print_symbol without the 
need for locking.

Of course this requires changing _all_ callers of print_symbol to use 
the new interface, but these are less than 100 ;)

Comments?

-- 
Paulo Marques - www.grupopie.com

"You're just jealous because the voices only talk to me."
