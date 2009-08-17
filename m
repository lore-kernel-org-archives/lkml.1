Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbZHQSEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbZHQSEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 14:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757884AbZHQSEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 14:04:08 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:48022 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819AbZHQSEG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 14:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fZMsQNaDSRR0Phij2lZ7PgWCuoMDAVHBST3inQYLnCOmn+gr0srY7ubkDJopV0vDMW
         riPUAqSknTN7ZEEF3ByPR+x0U+DMyPbqP0siCmA1jlTvgcGJKYKYJ37pS7isZFg/OcH6
         AfKzYvRbqsrZZdm5JzhmE7NIeAIb93PyQw4LI=
MIME-Version: 1.0
In-Reply-To: <4A89722A.1070407@s5r6.in-berlin.de>
References: <4A88F6BF.7090104@gmail.com> <4A89722A.1070407@s5r6.in-berlin.de>
Date: Mon, 17 Aug 2009 11:04:06 -0700
Message-ID: <dd18b0c30908171104o7ed67aa3x7cab741263de09c3@mail.gmail.com>
Subject: Re: ohci1396_dma=early nogo on an imac?
From: Justin Mattock <justinmattock@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 8:07 AM, Stefan
Richter<stefanr@s5r6.in-berlin.de> wrote:
> Justin P. Mattock wrote:
>> Seems the macbook shows the init ohci1394_dma
>> activating, but using this on an imac has no affects.
>> is this device supported yet or is this still in the process of being
>> developed?(event though the imac is 1394 800 port).
>>
>> At the moment my machine boots up 2.6.30.4 but will not bootup
>> the latest git. If the early dma option is possible with the imac9,1
>> I can send out a post with the error, and see if somebody might know.
>> (but if this isn't possible then Ill take the 40$
>> for the cable and and spend it on beer)...
>
> init_ohci1394_dma is supposed to work on all OHCI-1394 compliant
> controllers.  This includes all FireWire controllers in all iMac models
> ever made.  (However, init_ohci1394_dma's initialization is a
> trimmed-down version of ohci1394's, and is much much less widely tested
> than the ohci1394 driver, hence there may be things which work in the
> latter but not quite in the former.  If so, it should be fixed.)
>
> But note that there is an important limitation in init_ohci1394_dma:
> After it opened the DMA filters, there must be no subsequent FireWire
> bus reset.  When a bus reset happens, the controller immediately filters
> everything again ( = disallows remote DMA).  To compensate for that,
> init_ohci1394_dma would have to have an IRQ handler which handles bus
> reset IRQ events.  (And the CPU must not lock up before you need it to
> handle the IRQ.)
>
> Causes for a bus reset are:
>  - Something was plugged out or into the bus.
>  - One of the nodes on the bus changed its configuration (e.g.
>    a disk enclosure finished spinning up its drive mechanism after
>    power-on).
>  - One of the nodes on the bus (the one which volunteers to be the
>    so-called isochronous resource manager or bus manager) resets
>    the bus to enable or optimize some bus functions.
> To avoid all this, its best if you only have a single other node (as
> debugger console) plugged in, have it already powered on and running the
> 1394 driver stack at the moment when your test PC starts
> init_ohci1394_dma, you use the old ieee1394 + ohci1394 + raw1394 drivers
> on the debugger console, and set ieee1394's disable_irm=1 parameter
> there (disable isochronous resource manager).  The new replacement
> drivers firewire-core + firewire-ohci don't have such a parameter, i.e.
> always run some bus manager functions which might get in the way of
> remote DMA to an init_ohci1394_dma running node.
> --
> Stefan Richter
> -=====-==--= =--- =---=
> http://arcgraph.de/sr/
>

Thanks for the help.
I went out to apple and got the cable.
(not so bad 30$)

anyways I have  ieee1394 + ohci1394 + raw1394
loading as modules on both machines.

when using firescope I do this:
 sudo ./firescope -Aut /home/name/debug/System.map-2.6.30.4
(2.6.30.4 as a test until this is working).

seems I might have something missing.
in dmesg I see this:


[  660.190134] ieee1394: Current remote IRM is not 1394a-2000
compliant, resetting...
[  660.510613] ieee1394: Speed probe of node 0-00:1023 yields S400
[  661.060137] ieee1394: Current remote IRM is not 1394a-2000
compliant, resetting...
[  661.380418] ieee1394: Speed probe of node 0-00:1023 yields S400
[  661.920142] ieee1394: Current remote IRM is not 1394a-2000
compliant, resetting...
[  662.240405] ieee1394: Speed probe of node 0-00:1023 yields S400
[  662.790138] ieee1394: Current remote IRM is not 1394a-2000
compliant, resetting...
[  663.110416] ieee1394: Speed probe of node 0-00:1023 yields S400
[  663.650100] ieee1394: Current remote IRM is not 1394a-2000
compliant, resetting...
[  663.970457] ieee1394: Speed probe of node 0-00:1023 yields S400
[  664.510146] ieee1394: Current remote IRM is not 1394a-2000
compliant, resetting...
[  664.830454] ieee1394: Speed probe of node 0-00:1023 yields S400

keeps going.

with firescope I get this:

  sudo ./firescope -Aut /home/name/debug/System.map-2.6.30.4
Port 0 (ohci1394) opened, 2 nodes detected
Loaded system.map </home/name/debug/System.map-2.6.30.4> <1493445> bytes
2 nodes available, local node is: 1
 0: ffc0, uuid: <err: 11>
 1: ffc1, uuid: ffe31900 7ed82afe [LOCAL]
remote read failed, addr=7d65b8remote read failed, addr=7d659ckernel
buffer at phys 7fffffff len 4294967295
Cannot allocate log_buf shadow of 4294967295 bytes
No kernel log buffer
No kernel log buffer
No kernel log buffer
(keeps going)

any ideas?


-- 
Justin P. Mattock
