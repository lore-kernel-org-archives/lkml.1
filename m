Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbYKWFAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbYKWFAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 00:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbYKWFAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 00:00:05 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:30803 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750801AbYKWFAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 00:00:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=j2HHrBUTYebSVo5Q7gDXM8fnjhZyPMuBE8/me8vC7YXRxUTVw/iMvSJF6CygJS4BbOgQ9Unmg6SsNJ5mF3OqSRJ+W/5pRhGYDff6zqCGN9MVo0UdPXiiY1AFtKoi0GAjzNWfF8WsUEJuxClpQMUhJHV4CWVRS4KPhB8/ev31J9A=  ;
X-YMail-OSG: Kz_F5f8VM1nB7aIb7XqL1O1Is.txaAFV9UySuk_bcYDmLIcXmytuYI21HtQBvrmyYpKIiERdIfd1JlXEn3ll8t0LbwM42vMA5DP_TL4EeNYLtAGzgtBNz9Q1oNq4MgPUOSz6pgl.su9a2F47emKZKEpfBhqFijT5L.CBeuE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: [spi-devel-general] [patch 05/14] mfd: PCAP2 driver
Date: Sat, 22 Nov 2008 20:59:59 -0800
User-Agent: KMail/1.9.10
Cc: Stefan Schmidt <stefan@datenfreihafen.org>,
       spi-devel-general@lists.sourceforge.net,
       Stefan Schmidt <stefan@openmoko.org>, eric.y.miao@gmail.com,
       linux-kernel@vger.kernel.org, sameo@openedhand.com,
       linux-arm-kernel@lists.arm.linux.org.uk
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org> <200811221819.53186.david-b@pacbell.net> <1227411537.3148.22.camel@brutus>
In-Reply-To: <1227411537.3148.22.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200811222059.59806.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 November 2008, Daniel Ribeiro wrote:
> >  - You should make ezx_pcap_write() and ezx_pcap_read() switch
> >    over to spi_write_then_read(), to ensure it's never doing
> >    DMA to/from the stack.  I see a byte-order dependency too...
> 
> I tried spi_write_then_read before, but it didn't work. I supposed it
> was because it was doing 2 transfers as the second transfer rx_buf
> always came zeroed.

You may have been using it wrong.  Also, verify against
current kernels ... there have been bugfixes to pxa2xx_spi.


> I see that commit 
> f9b90e39cbc5c4d6ef60022fd1f25d541df0aad1 changed it to do a single
> transfer, so i will try it again.

Unless it needs the full duplex capability of SPI, then
you should be able to make write_then_read work ... on
the other hand, if you do need full duplex, then you
should address the DMA.  (And byteswapping, either way.)


> >  - If you're going to mark the probe() as __devinit, then mark
> >    the remove() as __devexit and use __devexit_p() in the driver
> >    struct.
> 
> Ok. Shouldn't i use __init instead?

I wouldn't.  There are ways that the probe() could be called
more than once -- e.g. after rebinding either of the relevant
SPI drivers through sysfs, or after rmmod/modprobe of the SPI
master controller driver -- and using an __init annotation
would make that point to memory that's unlikely to still hold
that code.

- Dave
