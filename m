Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbYAIPy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbYAIPy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 10:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYAIPyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 10:54:19 -0500
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4827 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYAIPyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 10:54:18 -0500
Date: Wed, 9 Jan 2008 16:54:12 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Cc: udovdh@xs4all.nl
Subject: Re: [RS232] setting trigger-level of fifo
Message-ID: <20080109155412.GX8331@vanheusden.com>
References: <20080109153242.GU8331@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109153242.GU8331@vanheusden.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Thu Jan 10 13:04:15 CET 2008
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In windows one can configure at what point the uart will trigger an
> interrupt. E.g. 1, 4, 8 or 14 bytes received. Setserial doesn't let you
> and I saw in the sources of the serial driver no hint that it is
> supported in linux at all. Also in MAINTAINERS I saw that sreial is
> orphaned. Can someone tell how I can proceed with this? Is it at all
> possible to do this setting? 

I think it must be something like this:

static void limit_fifo(struct uart_port *port)
{
        struct uart_8250_port *up = (struct uart_8250_port *)port;
        unsigned char cval, fcr = 0;
        unsigned long flags;

	/* hopefully not setting the UART_FCR_ENABLE_FIFO flag will
	 * set it to off. otherwhise the trigger_1 should make the
	 * uart trigger the interrupt immediately after the first
	 * byte comes in
	 */
        fcr = UART_FCR_TRIGGER_1;

        spin_lock_irqsave(&up->port.lock, flags);

        if (up->port.type == PORT_16750)
                serial_outp(up, UART_FCR, fcr);

        serial_outp(up, UART_LCR, cval);                /* reset DLAB */
        up->lcr = cval;                                 /* Save LCR */
        if (up->port.type != PORT_16750) {
                if (fcr & UART_FCR_ENABLE_FIFO) {
                        /* emulated UARTs (Lucent Venus 167x) need two steps */
                        serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO);
                }
                serial_outp(up, UART_FCR, fcr);         /* set fcr */
        }
        serial8250_set_mctrl(&up->port, up->port.mctrl);
        spin_unlock_irqrestore(&up->port.lock, flags);
}

But I don't know how to interface this to an ioctl or so.

All help is appreciated!


Folkert van Heusden

-- 
Looking for a cheap but fast webhoster with an excellent helpdesk?
http://keetweej.vanheusden.com/redir.php?id=1001
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
