Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbZBCBJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbZBCBJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbZBCBJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:09:01 -0500
Received: from mail.gmx.net ([213.165.64.20]:60947 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753078AbZBCBJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:09:00 -0500
X-Authenticated: #31060655
X-Provags-ID: V01U2FsdGVkX19iOcJh3I1igSI0IMYpTRlXM0s4NPuZ2vlVKiThbq
	VcN1cDWSb9BH9X
Message-ID: <49879928.8060501@gmx.net>
Date: Tue, 03 Feb 2009 02:08:56 +0100
From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20080922 SUSE/1.1.12-0.1 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Wolfgang Denk <wd@denx.de>
CC: Grant Erickson <gerickson@nuovations.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Add Alternative Log Buffer Support for printk Messages
References: <C5A8B8CD.143B5%gerickson@nuovations.com> <20090131095901.E1D1583644C3@gemini.denx.de>
In-Reply-To: <20090131095901.E1D1583644C3@gemini.denx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.01.2009 10:59, Wolfgang Denk wrote:
> Dear Grant & Andrew,
>
> In message <C5A8B8CD.143B5%gerickson@nuovations.com> you wrote:
>   
>>> We have an external log buffer, into which stuff was written by (say)
>>> the boot prom code.
>>>       
>
> Correct. Typically we use this in U-Boot to pass Power-On Self Test
> results to applications running under Linux, using the standard syslog
> tools.
>
> Another are of use is to save the log buffer over a reset (crash)  of
> the  system,  so  that  it can be read either rom the boot loader or,
> after a reboot, from Linux.
>   

That part is not yet implemented in coreboot, but it certainly is useful.


>>> We want that to come out on the console during bootup.
>>>       
>
> Not necessarily. The main function is to feed it into the syslog
> processing.
>   

Indeed.


>>> So what we do is to divert the normal printk log buffer so that it
>>> starts writing at the tail of that existing external buffer.  We emit
>>> the entire buffer some time during bootup.  We henceforth continue to
>>> use that external buffer in the normal manner. If so, why do it this way?
>>>       
>
> Do you have a better approach how to share  the  log  buffer  between
> Linux  and  a boot loader in such a way that the content will survive
> crahses and reboots?
>
>
>   
>> I believe this to be a useful feature for the embedded system space;
>> however, I am not wedded in any way to the current implementation and am
>> happy to evolve it as needed to meet the needs of key stakeholders.
>>     
>
> Indeed we use this heavily in embedded systems, mainly to process POST
> results under Linux (for example, to disable certain functions when
> the POST results indicate hardware issues, etc.).
>   

For coreboot, the feature is used to avoid long delays for serial output
and to make the coreboot POST logs available on machines where you don't
want to or can't store the POST logs. Coreboot POST logs at maximum
verbosity are roughly 61kB large on my machine and may be bigger on
others. Default verbosity still has a few dozen lines in the log.


>>> Why not just copy the external buffer's contents into the normal buffer during
>>> bootup?  ie: printk("%s", external_buffer).
>>>       
>
> For two reasons:
>
> 1) Additional copy operation (ok, that's cheap).
>   

Indeed. It probably won't take more than a few microseconds if the
external buffer is already in DRAM.


> 2) We would lose the capability that the buffer content even survives 
>    a reset / crash / reboot.
>
>    This is a feature can be very useful in embedded systems where
>    there is (at least normally) nobody looking at any console
>    messages; being able to see the kernel's crash messages after a
>    reboot in the normal syslog messages can be really helpful.
>   

This benefit is a bit debatable on x86 due to the lack of non-volatile
fast memory with decent sizes. (Yes, you can store the log in the flash
ROM, but it will wear out.)
Coreboot can try to preserve RAM contents, but depending on the
particular hardware all bets are off.


>>> I think a quite bad part of this feature is that it renders the
>>> kernel's log_buf_len boot parameter (and its Kconfig defult)
>>> ineffective.  That's a pretty useful feature - people often set it to
>>> 1MB or more during problem diagnosis, and the new unalterable 16kbytes
>>> is very very small.
>>>       
>
> Yes, we are aware of this, but it's a compromise. Basicly it depends
> on hardware capabilities. In most cases, it is sufficient to keep the
> syslog buffer in RAM. But if you really have to guarantee that the
> content of the buffer remains stable, this cannot be used because
> during a processor reset there will be usually a too long pause until
> the memory controller gets re-initialized and RAM refresh continues -
> we might lose data in this time. In most cases it just works fine,
> but it's out of spec. In such situations, when such a guarantee is
> needed, we can use any SRAM that may be available on the board, or we
> can use some on-chip-memory (OCM, basicly also SRAM) that might be on
> the processor.
>
> The OCM on the processors in question is 16 kB, hence the limitation
> there.
>   

I'd like to have the buffer location at least configurable to use that
feature on regular desktop and server x86 machines.


> But note that the code is general enough to support the other options
> (other, bigger SRAM, or arbitrarily sized buffer in RAM), too.
>   

Good.


>> Agreed; however, I'm not sure how often this technique is employed in
>> embedded systems versus desktop systems.
>>     
>
> I haven't seen this ever used in desktop systems yet. And I doubt if
> there is any x86 with a boot loader that supports somehting like this.
>   

Coreboot v3 (free x86 firmware, formerly known as LinuxBIOS) does this.


> But there is for example a pretty large number of mobile cranes all
> over the world which are using this feature :-)
>
>   
>> I'd be happy to keep the existing log buffer and perform a prepend from the
>> boot buffer to it rather than an append of the kernel buffer to the boot
>> buffer. Thoughts?
>>     
>
> Please don't - this would implement only the way to pass the buffer
> from the boot loader too Linux, but not the way back.
>   

It would be great if the location of that buffer could be retrieved
either via ACPI or e820 tables on x86. Hardcoded locations do not make
sense for x86 because coreboot tries to keep memory as unfragmented as
possible and stores the buffer at the top of memory (well, you can
hardcode the buffer location in coreboot but that is just a hack).


Unless I misread the code, it assumes no wraparound has occured in the
firmware log buffer. With full verbosity in coreboot, such wraparounds
can happen.

The coreboot log buffer struct is really simple:
struct printk_buffer {
        int len;
        int readoffset;
        int writeoffset;
        char buffer[];
};

The buffer is implemented as a ring buffer with variable size. The size
is determined from a few runtime variables for minimum RAM waste, so
hardcoding it to some fixed value would be suboptimal.

Can we coordinate to make sure both U-Boot and coreboot can use the feature?


Regards,
Carl-Daniel

-- 
http://www.hailfinger.org/

