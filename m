Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935628Ab0BZJFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:05:01 -0500
Received: from symlink.to.noone.org ([85.10.207.172]:59929 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935584Ab0BZJE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:04:57 -0500
Date: Fri, 26 Feb 2010 10:04:56 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-serial@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] serial: Add driver for the Altera JTAG UART
Message-ID: <20100226090456.GA32296@distanz.ch>
References: <1267108523-32767-1-git-send-email-tklauser@distanz.ch> <20100225152622.7eb479aa@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225152622.7eb479aa@lxorguk.ukuu.org.uk>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-02-25 at 16:26:22 +0100, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > +static void altera_jtaguart_set_termios(struct uart_port *port,
> > +					struct ktermios *termios,
> > +					struct ktermios *old)
> > +{
> > +}
> 
> Erm no .. it may be wrong in the code you are copying but please don't
> further that. The requirement is that the termios handed back reflects
> the actual settings not the requested ones.
> 
> Use tty_termios_copy_hw() to copy the old termios hardware settings back
> so that the caller sees it cannot set them.

Would the following be sufficient?

  if (old)
          tty_termios_copy_hw(termios, old);

> > +static void altera_jtaguart_rx_chars(struct altera_jtaguart *pp)
> > +{
> > +	struct uart_port *port = &pp->port;
> > +	unsigned char ch, flag;
> > +	unsigned long status;
> > +
> > +	while ((status = readl(port->membase + ALTERA_JTAGUART_DATA_REG)) &
> > +	       ALTERA_JTAGUART_DATA_RVALID_MSK) {
> > +		ch = status & ALTERA_JTAGUART_DATA_DATA_MSK;
> > +		flag = TTY_NORMAL;
> > +		port->icount.rx++;
> > +
> > +		if (uart_handle_sysrq_char(port, ch))
> > +			continue;
> > +		uart_insert_char(port, 0, 0, ch, flag);
> > +	}
> > +
> > +	tty_flip_buffer_push(port->state->port.tty);
> 
> port.tty needs to be protected here - you might race an unplug/hangup as
> far as I can see - I think you need to take the lock over a bigger area

So should we take port->lock in altera_jtaguart_interrupt already,
something like the following?

  spin_lock(&port->lock);

  if (isr & ALTERA_JTAGUART_CONTROL_RE_MSK)
          altera_jtaguart_rx_chars(pp);
  if (isr & ALTERA_JTAGUART_CONTROL_WE_MSK)
          altera_jtaguart_tx_chars(pp);

  spin_unlock(&port->lock);

And of course remove the lock/unlock from altera_jtaguart_tx_chars.

> [I'm working on switching this to krefs in all the drivers currently so
> that will end up cleaner]
> 
> Basically fine other than that. The proposed UART number clashes with
> some other pending patches but that will get sorted out when they get
> merged

Thanks a lot for your review.

Tobias
