Return-Path: <linux-kernel-owner+w=401wt.eu-S1760161AbZAMNW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbZAMNW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759567AbZAMNWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:22:05 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:31372 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833AbZAMNWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:22:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZpCYptlX2MzDfiAQyD9l4YtFemN4R73zASVRy89+yRgl1wYfyoz8a0YscgjmBRhcbl
         US8GhuLG8gJV4ng7H67BY5eNx2aV2vGlvdzMeQYdOEfZO+GPPB3DDmXAcF5k6cIbEafE
         zqDybxN7hpbVEgh6TG6uYuznAOjJ4NezLduoI=
Message-ID: <4142f31c0901130522n5273fb67j41cf1aaf7b32853c@mail.gmail.com>
Date: Tue, 13 Jan 2009 14:22:00 +0100
From: "Mischa Jonker" <m.d.s.x.jonker@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] serial: pnx8xxx_uart: Fix break signal handling
Cc: "Jonker M.D.S.X." <nlv14114@e3.nl-htc01.nxp.com>,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090113121135.5565b302@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901131109.n0DB9DRJ010712@pc67243907.ddns.nl-htc01.nxp.com>
	 <20090113121135.5565b302@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 1:11 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Tue, 13 Jan 2009 12:09:13 +0100
> "Jonker M.D.S.X." <nlv14114@e3.nl-htc01.nxp.com> wrote:
>
>> From: Mischa Jonker <mischa.jonker@nxp.com>
>>
>> When a break signal is detected, the next character should be ignored.
>> This was not implemented correctly for the pnx8xxx_uart driver.
>>
>> Signed-off-by: Mischa Jonker <mischa.jonker@nxp.com>
>> ---
>>
>> diff --git a/drivers/serial/pnx8xxx_uart.c b/drivers/serial/pnx8xxx_uart.c
>> index 22e30d2..1bb8f1b 100644
>> --- a/drivers/serial/pnx8xxx_uart.c
>> +++ b/drivers/serial/pnx8xxx_uart.c
>> @@ -187,7 +187,7 @@ static void pnx8xxx_rx_chars(struct pnx8xxx_port *sport)
>>       status = FIFO_TO_SM(serial_in(sport, PNX8XXX_FIFO)) |
>>                ISTAT_TO_SM(serial_in(sport, PNX8XXX_ISTAT));
>>       while (status & FIFO_TO_SM(PNX8XXX_UART_FIFO_RXFIFO)) {
>> -             ch = serial_in(sport, PNX8XXX_FIFO);
>> +             ch = serial_in(sport, PNX8XXX_FIFO) & 0xff;
>
> This appears to be unrelated.
>

Correct, you can look to it as two separate bugs:
a) the next character is not ignored while it should;
b) the status bits 31-8 are copied to the 'ch' variable while they shouldn't.

Both bugs prevent correct break signal handling (and therefore correct
behaviour of the magic SysRq key). Bug b didn't cause too much trouble
earlier because in most situations the status bits are all zero; for
this case they unfortunately aren't.

I can split them up if you like, or we can keep them together, as they
are in fact related.

Thanks,

Mischa Jonker
