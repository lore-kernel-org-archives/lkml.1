Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbXLODFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbXLODFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 22:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbXLODEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 22:04:54 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:51039 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbXLODEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 22:04:53 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX186bAD4peY4VjfYv8FFcu0K
Message-ID: <4763442A.5020507@reed.com>
Date: Fri, 14 Dec 2007 22:04:10 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <469578CD.3080609@reed.com>	<1184216528.12353.203.camel@chaos>	<1184218962.12353.209.camel@chaos>	<46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos>	<469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos>	<4761F193.7090400@reed.com>	<20071214131502.GA14359@elte.hu>	<4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu>
In-Reply-To: <20071214232955.545ab809@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a thought for a way to fix the "very early" timing needed to set up 
udelay to work in a way that works on all machines.  Perhaps we haven't 
exploited the BIOS enough:  The PC BIOS since the PC AT (286)  has 
always had a standard "countdown timer" way to delay for n microseconds, 
which as far as I know still works.   This can be used to measure the 
speed of a delay loop, without using ANY in/out instructions directly 
(the ones in the BIOS are presumably correctly delayed...).

So first thing in the boot sequence, one can calibrate a timing loop 
using this technique, and save the value to be used for all the "early" 
stuff.

Here's skeleton code from old ASM code I found lying around in my 
archives to use BIOS to measure how many unrolled short jumps can 
execute in 10 msec.  Note that it can run without knowing anything 
whatsoever about port timing.

haltbyte db 0

calibrate:
    les bx,haltbyte ; address of halt flag into es:bx
    mov ax,8300h
    sub cx,cx
    mov dx,10000 ; 10 msec. in cx:dx
    int 15h
    jc bad
    sub dx,dx
    sub cx,cx ; decrement counter in dx:cx
tloop:
    jmp short $+2 ; 10 short jmps
    jmp short $+2
    jmp short $+2
    jmp short $+2
    jmp short $+2
    jmp short $+2
    jmp short $+2
    jmp short $+2
    jmp short $+2
    test haltbyte
    loopz tloop
    jnz done
    dec dx
    jnz tloop

" overflowed 32 bits ... never happens, cancel BIOS event wait.
    mov ax,8301h
    int 15h
    jmp error
 
done:
    mov ax,cx
    negl
" here dx:ax contains 32 bit loop count corresponding to 10 msec.
    ret ; return 32-bit value


Doc on function 83h of int 15h should be available online.
   

Alan Cox wrote:
> On Fri, 14 Dec 2007 14:13:46 -0800
> "H. Peter Anvin" <hpa@zytor.com> wrote:
>
>   
>> Pavel Machek wrote:
>>     
>>> On Fri 2007-12-14 10:02:57, H. Peter Anvin wrote:
>>>       
>>>> Ingo Molnar wrote:
>>>>         
>>>>> wow, cool fix! (I remember that there were other systems as well that are 
>>>>> affected by port 0x80 muckery - i thought we had removed port 0x80 
>>>>> accesses long ago.)
>>>>> how about the simpler fix below, as a first-level approach? We can then 
>>>>> remove the _p in/out sequences after this.
>>>>>           
>>>> I believe this will suffer from the issue that was raised: this will use 
>>>> udelay() long before loop calibration (and no, we can't just "be 
>>>> conservative" since there is no "conservative" value we can use.)
>>>>         
>>> ?? Just initialize bogomips to 6GHz equivalent... and we are fine
>>> until 6GHz cpus come out.
>>>       
>> How long will that take to boot on a 386?
>>     
>
> Well the dumb approach to fix that would seem to be to initialise it to
>
> 	cpu->family   3 -> 50MHz 4 -> 300Mhz 5-> etc...
>
> Alan
>
>   
