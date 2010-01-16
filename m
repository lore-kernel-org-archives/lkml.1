Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697Ab0APV6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab0APV6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 16:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587Ab0APV6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 16:58:32 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:48624 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab0APV6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 16:58:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Swk+wzLYai4MxP5WryIoxfgavREAiIT1EqLEGnoTrP+2jsp2P090cU87pHNEnihsIO
         gnhRoLZpMGKArcHuSyfkV7ERxxXZs6ilKvXnmZ8XSIUosYVRG7PDf3MqSnsMH+zKpFb5
         kway6IWgP0wMeIX+aNk2/bL1jZPTSS8a9eiic=
MIME-Version: 1.0
In-Reply-To: <4B4A815A.60503@gmail.com>
References: <64bb37e0912250122n4e0e1842q88c0dad7e99ec6a7@mail.gmail.com>
	 <4B484829.6060405@kernel.org>
	 <64bb37e1001092033r1f0b4defw46c1a07101bb2d1b@mail.gmail.com>
	 <4B4A7BC7.6060106@kernel.org> <4B4A815A.60503@gmail.com>
Date: Sat, 16 Jan 2010 22:58:29 +0100
Message-ID: <64bb37e1001161358r79ea2da0u88e9894fa5987ef1@mail.gmail.com>
Subject: Re: MSI broken in libata?
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 2:39 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 01/10/2010 07:15 PM, Tejun Heo wrote:
>>
>> On 01/10/2010 01:33 PM, Torsten Kaiser wrote:
>>>
>>> I did try the patch from Robert Hancock in
>>> http://lkml.org/lkml/2010/1/6/417 ,but without success.
>>>
>>> if you need any more information, or have something for me to try,
>>> please just ask. I did look at the code and the documentation about
>>> enabling MSI, but did not see anything (obvious) wrong, so I don't
>>> know what to try next.
>>
>> Can you please try the attached patch?
>>
>> Thanks.
>>
>
> It'd be interesting to see if it makes a difference, but I don't think the
> patch is quite right.

As written in the other mail: No, Tejuns patch also didn't work.

> According to the datasheet, doing the MSI ack while
> the interrupt source is still pending will cause a new MSI to be sent, so if
> you do it before handling the interrupt you'll generate a spurious interrupt
> after every real one.
>
> Though, apparently my patch that did the MSI ack after the handling didn't
> help, so either that's wrong or the problem is unrelated. (I tend to suspect
> the latter, given that sata_nv is also failing in the same way.)

Reading http://www.siliconimage.com/docs/SiI-DS-0138-D.pdf a possible
cause might have been, that this MSI ACK was never needed. Page 63 of
this PDF says about 'Global Control': "If all interrupt conditions are
removed subsequent to an MSI, it is not necessary to assert this
Acknowledge; another MSI will be generated when an interrupt condition
occurs."

But I did not find anything that might explain my problem.

Looking at my lspci output I noted the following:
For the PCIe-bridges:
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
For the tg3 onboard network chips:
	Capabilities: [d0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
For the SiI chip:
	Capabilities: [70] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 1024 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes

So the maximum payload for it is bigger then that of the nVidia bridge.
As I don't have knowlegde of the PCI specs, I guess DevCap is what a
device is physically capable and DevCtl is the value that the BIOS /
kernel hat programmed into it for actual use.
If my guess is correct, then the SiI should be correctly limited to
128 bytes payload and that it should work.

BUT: Page 47 of the SiI-PDF says for 'Device Status and Control' the following:
Bit [14:12]: Max Read Request Size (R/W) – Allowable values are 000B
to 011B (128 to 1024 bytes).
Default is 010B (512 bytes).

So a MaxReadReq value of 4096 as indicated by lspci for my system
would be out of bounds.

Is is important? (Somehow it seems not: In the Not-MSI-case it is also
4096 bytes, but the system works fine...)


Can I do anything else to help debug this?

Torsten
