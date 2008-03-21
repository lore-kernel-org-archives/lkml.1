Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYCULRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYCULRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYCULRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:17:45 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:45583 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbYCULRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:17:44 -0400
Date: Fri, 21 Mar 2008 12:17:36 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, davej@redhat.com,
       sam@ravnborg.org, greg@kroah.com, randy.dunlap@oracle.com
Message-ID: <20080321111736.GC8959@enneenne.com>
References: <12048053463198-git-send-email-giometti@linux.it> <12048053473401-git-send-email-giometti@linux.it> <12048053471754-git-send-email-giometti@linux.it> <12048053471177-git-send-email-giometti@linux.it> <12048053473741-git-send-email-giometti@linux.it> <12048053472063-git-send-email-giometti@linux.it> <20080320130400.0b17e1fc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320130400.0b17e1fc.akpm@linux-foundation.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 5/7] PPS: serial clients support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 01:04:00PM -0700, Andrew Morton wrote:
> On Thu,  6 Mar 2008 13:09:04 +0100
> Rodolfo Giometti <giometti@linux.it> wrote:
> 
> > Adds support for the PPS sources connected with the CD (Carrier
> > Detect) pin of a serial port.
> > 
> > ...
> >
> > +#ifdef CONFIG_PPS_CLIENT_UART
> > +
> > +static int
> > +uart_register_pps_port(struct uart_state *state, struct uart_port *port)
> > +{
> > +	struct tty_driver *drv = port->info->tty->driver;
> > +	int ret;
> > +
> > +	state->pps_info.owner = THIS_MODULE;
> > +	state->pps_info.dev = port->dev;
> > +	snprintf(state->pps_info.name, PPS_MAX_NAME_LEN, "%s%d",
> > +		drv->driver_name, port->line);
> > +	snprintf(state->pps_info.path, PPS_MAX_NAME_LEN, "/dev/%s%d",
> > +		drv->name, port->line);
> 
> umm, why are we hard-wiring "/dev" into the kernel source?  Is it just for
> user-friendly printks?

Yes... :)

> > +	state->pps_info.mode = PPS_CAPTUREBOTH | \
> > +			PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
> > +			PPS_CANWAIT | PPS_TSFMT_TSPEC;
> > +
> > +	ret = pps_register_source(&state->pps_info, PPS_CAPTUREBOTH | \
> > +				PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
> > +	if (ret < 0) {
> > +		dev_err(port->dev, "cannot register PPS source \"%s\"\n",
> > +						state->pps_info.path);
> > +		return ret;
> > +	}
> > +	port->pps_source = ret;
> > +	dev_dbg(port->dev, "PPS source #%d \"%s\" added\n",
> > +		port->pps_source, state->pps_info.path);
> > +
> > +	return 0;
> > +}
> > +
> > +static void
> > +uart_unregister_pps_port(struct uart_state *state, struct uart_port *port)
> > +{
> > +	pps_unregister_source(port->pps_source);
> > +	dev_dbg(port->dev, "PPS source #%d \"%s\" removed\n",
> > +				port->pps_source, state->pps_info.path);
> > +}
> > +
> > +#else
> > +
> > +#define uart_register_pps_port(state, port)	do { } while (0)
> > +#define uart_unregister_pps_port(state, port)	do { } while (0)
> 
> Please never implement in cpp that which can be implemented in C.  These
> should have been static inlines.  That's nicer, matches the
> CONFIG_PPS_CLIENT_UART=y code and provides type checking.

Are you saying that I should do:

static inline int
uart_register_pps_port(struct uart_state *state, struct uart_port *port)
{
	/* Nop */
}

static inline void
uart_unregister_pps_port(struct uart_state *state, struct uart_port *port)
{
	/* Nop */
}

?

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
