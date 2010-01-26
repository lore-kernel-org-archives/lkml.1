Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226Ab0AZMDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0AZMDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 07:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180Ab0AZMDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 07:03:09 -0500
Received: from server.by009.net ([74.81.86.233]:53736 "EHLO server.by009.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976Ab0AZMDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 07:03:07 -0500
X-Greylist: delayed 3246 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jan 2010 07:03:07 EST
X-MDAV-Processed: sigmae.nl, Tue, 26 Jan 2010 12:08:53 +0100
VBR-Info: md=sigmae.nl; mc=all; mv=vbr.emailcertification.org;
X-Spam-Processed: sigmae.nl, Tue, 26 Jan 2010 12:08:53 +0100
	(not processed: message from valid local sender)
X-MDOP-RefID: str=0001.0A0B0208.4B5ECD44.00F7,ss=1,fgs=0 (_st=1 _vt=0 _iwf=0)
X-Return-Path: prvs=1642dc60a7=k.schoenmakers@sigmae.nl
X-Envelope-From: k.schoenmakers@sigmae.nl
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: Kees Schoenmakers <k.schoenmakers@sigmae.nl>
Organization: Sigma_E
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [PATCH 24/79] tty: usb_serial_mos7720: Fix get_lsr_info
Date: Tue, 26 Jan 2010 12:08:51 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
References: <20090919213345.GB7668@kroah.com> <1253396244-7885-24-git-send-email-gregkh@suse.de>
In-Reply-To: <1253396244-7885-24-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001261208.51393.k.schoenmakers@sigmae.nl>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server.by009.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - sigmae.nl
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gentlemen,

As of version 2.6.32.5 this patch has not made it into the kernel sources.
Any reason for this? It is a pity for people who knowingly or unknowingly run 
into this effect in the driver.

kind regards

Kees


On Saturday 19 September 2009 23:36:29 Greg Kroah-Hartman wrote:
> From: Kees Schoenmakers <k.schoenmakers@sigmae.nl>
>
> I made a correction for get_lsr_info, now it returns some meaningful
> information. I tested it with two simultaneous simplex modem channels.
>
> it is attached
>
> Signed-off-by: Kees Schoenmakers <k.schoenmakers@sigmae.nl>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/usb/serial/mos7720.c |   19 +++++++++++++++----
>  1 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
> index 759cdd5..4342a8a 100644
> --- a/drivers/usb/serial/mos7720.c
> +++ b/drivers/usb/serial/mos7720.c
> @@ -378,10 +378,14 @@ static int mos7720_open(struct tty_struct *tty,
>  	 /* Initialize MCS7720 -- Write Init values to corresponding Registers
>  	  *
>  	  * Register Index
> +	  * 0 : THR/RHR
>  	  * 1 : IER
>  	  * 2 : FCR
>  	  * 3 : LCR
>  	  * 4 : MCR
> +	  * 5 : LSR
> +	  * 6 : MSR
> +	  * 7 : SPR
>  	  *
>  	  * 0x08 : SP1/2 Control Reg
>  	  */
> @@ -1250,15 +1254,22 @@ static void mos7720_set_termios(struct tty_struct
> *tty, static int get_lsr_info(struct tty_struct *tty,
>  		struct moschip_port *mos7720_port, unsigned int __user *value)
>  {
> -	int count;
> +	struct usb_serial_port *port = tty->driver_data;
>  	unsigned int result = 0;
> +	unsigned char data = 0;
> +	int port_number = port->number - port->serial->minor;
> +	int count;
>
>  	count = mos7720_chars_in_buffer(tty);
>  	if (count == 0) {
> -		dbg("%s -- Empty", __func__);
> -		result = TIOCSER_TEMT;
> +		send_mos_cmd(port->serial, MOS_READ, port_number,
> +							UART_LSR, &data);
> +		if ((data & (UART_LSR_TEMT | UART_LSR_THRE))
> +					== (UART_LSR_TEMT | UART_LSR_THRE)) {
> +			dbg("%s -- Empty", __func__);
> +			result = TIOCSER_TEMT;
> +		}
>  	}
> -
>  	if (copy_to_user(value, &result, sizeof(int)))
>  		return -EFAULT;
>  	return 0;



