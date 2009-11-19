Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbZKSQiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbZKSQiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757657AbZKSQiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:38:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbZKSQiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:38:50 -0500
Date: Thu, 19 Nov 2009 17:38:55 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Armbruster <armbru@redhat.com>,
       Ian Jackson <ian.jackson@eu.citrix.com>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] Do not read IIR in serial8250_start_tx when
 UART_BUG_TXEN
In-Reply-To: <alpine.LSU.2.00.0911181101090.15039@wotan.suse.de>
Message-ID: <alpine.LSU.2.00.0911191734570.15039@wotan.suse.de>
References: <alpine.LSU.2.00.0911181101090.15039@wotan.suse.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009, Jiri Kosina wrote:

> The patch below has been lost several times (the last submission happened 
> probably on [1]). I am currently aware of a real hardware which triggers 
> this problem quite reliably, so we should rather have that really fixed.
> 
> [1] http://lkml.org/lkml/2009/3/12/379
> 
> 
> 
> 
> From: Ian Jackson <ian.jackson@eu.citrix.com>
> 
> Do not read IIR in serial8250_start_tx when UART_BUG_TXEN
> 
> Reading the IIR clears some oustanding interrupts so it is not safe.
> Instead, simply transmit immediately if the buffer is empty without
> regard to IIR.
> 
> Signed-off-by: Ian Jackson <ian.jackson@eu.citrix.com>
> Reviewed-by: Markus Armbruster <armbru@redhat.com>
> Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> 
> ---
>  drivers/serial/8250.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index 737b4c9..807042b 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -1339,14 +1339,12 @@ static void serial8250_start_tx(struct uart_port *port)
>  		serial_out(up, UART_IER, up->ier);
>  
>  		if (up->bugs & UART_BUG_TXEN) {
> -			unsigned char lsr, iir;
> +			unsigned char lsr;
>  			lsr = serial_in(up, UART_LSR);
>  			up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
> -			iir = serial_in(up, UART_IIR) & 0x0f;
>  			if ((up->port.type == PORT_RM9000) ?
> -				(lsr & UART_LSR_THRE &&
> -				(iir == UART_IIR_NO_INT || iir == UART_IIR_THRI)) :
> -				(lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT))
> +				(lsr & UART_LSR_THRE) :
> +				(lsr & UART_LSR_TEMT))
>  				transmit_chars(up);
>  		}
>  	}

Does anyone have any comments about this please?

In a nutshell -- this is needed so that we make the UART_BUG_TXEN really 
harmless (which I guess it originally inteded to be, but reading IIR has 
some unwanted sideeffects and is in fact not needed).

We need to have this in to handle properly the cases in which BUG_TXEN is 
misdetected, and we can't blacklist such systems as we do for some SoL 
hardware (see commit b6adea334c6c (" 8250: fix boot hang with serial 
console when using with Serial Over Lan port"). Also there doesn't seem to 
be any straightforward way to workaround the misdetection, so this seems 
to be proper fix, unbreaking all the possible scenarios.

Alan, Greg, any comments?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
