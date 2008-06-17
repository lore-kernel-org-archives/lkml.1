Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbYFQKvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbYFQKvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 06:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbYFQKvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 06:51:42 -0400
Received: from mout.perfora.net ([74.208.4.196]:64790 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbYFQKvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 06:51:41 -0400
Date: Tue, 17 Jun 2008 05:50:09 -0500 (CDT)
From: "R.L. Horn" <lists@eastcheap.org>
X-X-Sender: rlhorn@hani.compact.internal
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: serial problem (minicom)
In-Reply-To: <20080616111329.3ae97879@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LNX.1.00.0806170511270.11745@hani.compact.internal>
References: <alpine.LNX.1.00.0806131635260.1294@hani.compact.internal> <20080614102900.6830ed46@lxorguk.ukuu.org.uk> <alpine.LNX.1.00.0806150032050.1283@hani.compact.internal> <20080616111329.3ae97879@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Provags-ID: V01U2FsdGVkX18vzGQ7fvFb5NLlazASqexhQR1exCA0dGXhqg5
 UXIg30VQMjbmM/4/3OSjSte/4/asp+MA7a3sAzNpULk+dDrJEf
 6eVUi5DOV/WtweuKZDegg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008, Alan Cox wrote:

> Whatever it implies the behaviour should not have changed between 2.6.24 
> and 2.6.25.

Okay, I think I may have figured this out.

serial8250_set_termios() (8250.c) gets a baud rate using 
uart_get_baud_rate() (serial_core.c) which returns 9600 if the termios 
rate is B0.

The function does some stuff.

Right before returning, it calls tty_termios_encode_baud_rate() with the 
abovementioned rate.  That function obediently changes the c_cflag baud 
bits from B0 to B9600.  Presumably, this causes confusion in other 
functions (they never know that B0 was set).

I've now changed:

   tty_termios_encode_baud_rate(termios, baud, baud);

to:

   if ((termios->c_cflag & CBAUD) == B0)
       baud = 0;
   tty_termios_encode_baud_rate(termios, baud, baud);

And everybody's happy, I guess.

It looks like the DECstation DZ driver (drivers/serial/dz.c) will have the 
same problem, but I believe the others are okay (as of 2.6.25.6).
