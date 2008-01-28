Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYA1SYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYA1SYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbYA1SYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:24:35 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:21346 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752486AbYA1SYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:24:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2+xaouDqQKC1BobzWmvekL7vQwnpVPhrk5EU7+6JUl80AbHUgBfEb11Ig6eeVwu4gQy/1c8P68EHDaso9mqrKqDFawtlWCIjU5Ht4kVcqCbuu1xKX+An1zzdLIwNuW1uyw062bdfJGREurxGUD6qx6byx6oll2rVdGmp7jcCkDs=  ;
X-YMail-OSG: 1TFly54VM1kSocBQ2Gn4P_.yA0l8yZzs6oDHs6kGmxBWPQWaGOdWAXeLOn2KfgtyS07ejDWHRQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: at91sam9260 wakeup on serial port
Date: Mon, 28 Jan 2008 10:21:57 -0800
User-Agent: KMail/1.9.6
Cc: michael <trimarchi@gandalf.sssup.it>, linux-kernel@vger.kernel.org,
       Andrew Victor <linux@maxim.org.za>
References: <479DB934.6090806@gandalf.sssup.it> <20080128145615.1d756025@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080128145615.1d756025@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281021.57317.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Haavard Skinnemoen wrote:
> On Mon, 28 Jan 2008 12:15:00 +0100
> michael <trimarchi@gandalf.sssup.it> wrote:
> 
> > Hi,
> > I implement a little patch (ndr just for a try) for the atmel serial 
> > driver atmel_serial.c to wakeup the system when it is in suspend-ram state.
> > I reconfigure the RXD pin as a gpio in suspend function and restore it 
> > in the resume function. It is the correct way?
> 
> I'm not sure...this is rather platform-specific, so I don't think it
> really belongs in the atmel_serial() driver. One solution might be to
> add a function pointer to struct atmel_uart_data that the driver can
> call from ->suspend() in order to let the platform code handle this as
> appropriate.

The core issue is that the system clock driving the baud rate generator
is no longer running fast enough to let the UART run.  (In "standby" the
clock is still driven by the PLL, so this issue doesn't come up.)  The
GPIO logic can catch the START bit though ... this technique is used on
some OMAP boards too.  

Agreed that knowing exactly which pin(s) should be remuxed (UARTn.RX to
GPIO in suspend then enabling it as a wakeup irq, then reversing that
on resume; maybe UARTn.DCD should work too..), and how (as A-peripheral?
or  B?) is chip-specific knowledge.  Such a function pointer could work.

What will AVR32 (AP7) need to do, when it supports system sleep states?

- Dave
