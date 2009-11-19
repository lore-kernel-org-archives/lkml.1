Return-Path: <linux-kernel-owner+w=401wt.eu-S1752375AbZKSQmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbZKSQmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZKSQmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:42:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:38408 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZKSQmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:42:42 -0500
Date: Thu, 19 Nov 2009 08:42:33 -0800
From: Greg KH <gregkh@suse.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Armbruster <armbru@redhat.com>,
       Ian Jackson <ian.jackson@eu.citrix.com>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] Do not read IIR in serial8250_start_tx when
 UART_BUG_TXEN
Message-ID: <20091119164233.GA8476@suse.de>
References: <alpine.LSU.2.00.0911181101090.15039@wotan.suse.de>
 <alpine.LSU.2.00.0911191734570.15039@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0911191734570.15039@wotan.suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 05:38:55PM +0100, Jiri Kosina wrote:
> On Wed, 18 Nov 2009, Jiri Kosina wrote:
> 
> > The patch below has been lost several times (the last submission happened 
> > probably on [1]). I am currently aware of a real hardware which triggers 
> > this problem quite reliably, so we should rather have that really fixed.
> > 
> > [1] http://lkml.org/lkml/2009/3/12/379
> > 
> > 
> > 
> > 
> > From: Ian Jackson <ian.jackson@eu.citrix.com>
> > 
> > Do not read IIR in serial8250_start_tx when UART_BUG_TXEN
> > 
> > Reading the IIR clears some oustanding interrupts so it is not safe.
> > Instead, simply transmit immediately if the buffer is empty without
> > regard to IIR.
> > 
> > Signed-off-by: Ian Jackson <ian.jackson@eu.citrix.com>
> > Reviewed-by: Markus Armbruster <armbru@redhat.com>
> > Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> > 
> > ---
> >  drivers/serial/8250.c |    8 +++-----
> >  1 files changed, 3 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> > index 737b4c9..807042b 100644
> > --- a/drivers/serial/8250.c
> > +++ b/drivers/serial/8250.c
> > @@ -1339,14 +1339,12 @@ static void serial8250_start_tx(struct uart_port *port)
> >  		serial_out(up, UART_IER, up->ier);
> >  
> >  		if (up->bugs & UART_BUG_TXEN) {
> > -			unsigned char lsr, iir;
> > +			unsigned char lsr;
> >  			lsr = serial_in(up, UART_LSR);
> >  			up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
> > -			iir = serial_in(up, UART_IIR) & 0x0f;
> >  			if ((up->port.type == PORT_RM9000) ?
> > -				(lsr & UART_LSR_THRE &&
> > -				(iir == UART_IIR_NO_INT || iir == UART_IIR_THRI)) :
> > -				(lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT))
> > +				(lsr & UART_LSR_THRE) :
> > +				(lsr & UART_LSR_TEMT))
> >  				transmit_chars(up);
> >  		}
> >  	}
> 
> Does anyone have any comments about this please?
> 
> In a nutshell -- this is needed so that we make the UART_BUG_TXEN really 
> harmless (which I guess it originally inteded to be, but reading IIR has 
> some unwanted sideeffects and is in fact not needed).
> 
> We need to have this in to handle properly the cases in which BUG_TXEN is 
> misdetected, and we can't blacklist such systems as we do for some SoL 
> hardware (see commit b6adea334c6c (" 8250: fix boot hang with serial 
> console when using with Serial Over Lan port"). Also there doesn't seem to 
> be any straightforward way to workaround the misdetection, so this seems 
> to be proper fix, unbreaking all the possible scenarios.
> 
> Alan, Greg, any comments?

At first glance, it looks acceptable to me.  It's in my "to-apply" queue
that has gotten a bit big due to "real work" and a vacation I took last
week.

thanks,

greg k-h
