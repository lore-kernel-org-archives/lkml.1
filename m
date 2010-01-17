Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531Ab0AQTWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab0AQTWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 14:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404Ab0AQTWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 14:22:48 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:41881 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab0AQTWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 14:22:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QdUFEw66hoCGhMyGZpe/2Erdia3nrjGYxdUYRlr3G7XJIgc61vo1FF0i1ha+hcOZdk
         zxT2SBGpa4cuf+cuStMFasmk+vN55ShCzbvHdaTAnNSnk/Ysq7ezoDESEMgna5PS3CpA
         eg9tFlweD8WihjjedDW8qDq1Zglyqp6Ey497s=
Message-ID: <4B536383.7090609@gmail.com>
Date: Sun, 17 Jan 2010 13:22:43 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: Re: MSI broken in libata?
References: <64bb37e0912250122n4e0e1842q88c0dad7e99ec6a7@mail.gmail.com>	 <4B484829.6060405@kernel.org>	 <64bb37e1001092033r1f0b4defw46c1a07101bb2d1b@mail.gmail.com>	 <4B4A7BC7.6060106@kernel.org> <4B4A815A.60503@gmail.com> <64bb37e1001161358r79ea2da0u88e9894fa5987ef1@mail.gmail.com>
In-Reply-To: <64bb37e1001161358r79ea2da0u88e9894fa5987ef1@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2010 03:58 PM, Torsten Kaiser wrote:
> On Mon, Jan 11, 2010 at 2:39 AM, Robert Hancock<hancockrwd@gmail.com>  wrote:
>> On 01/10/2010 07:15 PM, Tejun Heo wrote:
>>>
>>> On 01/10/2010 01:33 PM, Torsten Kaiser wrote:
>>>>
>>>> I did try the patch from Robert Hancock in
>>>> http://lkml.org/lkml/2010/1/6/417 ,but without success.
>>>>
>>>> if you need any more information, or have something for me to try,
>>>> please just ask. I did look at the code and the documentation about
>>>> enabling MSI, but did not see anything (obvious) wrong, so I don't
>>>> know what to try next.
>>>
>>> Can you please try the attached patch?
>>>
>>> Thanks.
>>>
>>
>> It'd be interesting to see if it makes a difference, but I don't think the
>> patch is quite right.
>
> As written in the other mail: No, Tejuns patch also didn't work.
>
>> According to the datasheet, doing the MSI ack while
>> the interrupt source is still pending will cause a new MSI to be sent, so if
>> you do it before handling the interrupt you'll generate a spurious interrupt
>> after every real one.
>>
>> Though, apparently my patch that did the MSI ack after the handling didn't
>> help, so either that's wrong or the problem is unrelated. (I tend to suspect
>> the latter, given that sata_nv is also failing in the same way.)
>
> Reading http://www.siliconimage.com/docs/SiI-DS-0138-D.pdf a possible
> cause might have been, that this MSI ACK was never needed. Page 63 of
> this PDF says about 'Global Control': "If all interrupt conditions are
> removed subsequent to an MSI, it is not necessary to assert this
> Acknowledge; another MSI will be generated when an interrupt condition
> occurs."
>
> But I did not find anything that might explain my problem.
>
> Looking at my lspci output I noted the following:
> For the PCIe-bridges:
> 	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
> 		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s<64ns, L1<1us
> 			ExtTag- RBE+ FLReset-
> 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> 			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> 			MaxPayload 128 bytes, MaxReadReq 512 bytes
> For the tg3 onboard network chips:
> 	Capabilities: [d0] Express (v1) Endpoint, MSI 00
> 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s<4us, L1 unlimited
> 			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> 			MaxPayload 128 bytes, MaxReadReq 4096 bytes
> For the SiI chip:
> 	Capabilities: [70] Express (v1) Legacy Endpoint, MSI 00
> 		DevCap:	MaxPayload 1024 bytes, PhantFunc 0, Latency L0s<64ns, L1<1us
> 			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
> 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> 			MaxPayload 128 bytes, MaxReadReq 4096 bytes
>
> So the maximum payload for it is bigger then that of the nVidia bridge.
> As I don't have knowlegde of the PCI specs, I guess DevCap is what a
> device is physically capable and DevCtl is the value that the BIOS /
> kernel hat programmed into it for actual use.
> If my guess is correct, then the SiI should be correctly limited to
> 128 bytes payload and that it should work.
>
> BUT: Page 47 of the SiI-PDF says for 'Device Status and Control' the following:
> Bit [14:12]: Max Read Request Size (R/W) – Allowable values are 000B
> to 011B (128 to 1024 bytes).
> Default is 010B (512 bytes).
>
> So a MaxReadReq value of 4096 as indicated by lspci for my system
> would be out of bounds.
>
> Is is important? (Somehow it seems not: In the Not-MSI-case it is also
> 4096 bytes, but the system works fine...)
>
>
> Can I do anything else to help debug this?

I don't think the MaxReadReq difference would be an issue - it's the max 
request size that device is allowed to generate, not the max it can 
accept. In any case, not sure how it would affect MSI since those 
requests would be a write, not a read, and would be tiny. You could 
always try changing it (I think setpci should be able to do it, though 
you might need to dig through specs to find out which bits those are).

Unfortunately I don't have any great debug suggestions other than 
those.. My first suspect would still be some kind of HT-MSI mapping 
issue, but it's strange that only writes seem to be having problems..
