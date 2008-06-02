Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbYFBJ1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbYFBJ1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYFBJ1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:27:00 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:52315 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYFBJ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:27:00 -0400
Date: Mon, 2 Jun 2008 11:25:52 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-ID: <20080602092551.GC26854@enneenne.com>
References: <20080601161510.GA26854@enneenne.com> <20080602075113.60d0fdf8@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602075113.60d0fdf8@core>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: LinuxPPS low-level IRQs timestamps & ldisc
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 07:51:13AM +0100, Alan Cox wrote:
> > First I added a new dcd_change() ldisc method which can be used as
> > follow:
> 
> This looks good.

:)

> > 
> > static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status)
> > {
> >        int id = (int) tty->disc_data;
> >        struct timespec __ts;
> >        struct pps_ktime ts;
> > 
> >        /* First of all we get the time stamp... */
> >        getnstimeofday(&__ts);
> > 
> >        /* ... and translate it to PPS time data struct */
> >        ts.sec = __ts.tv_sec;
> >        ts.nsec = __ts.tv_nsec;
> > 
> >        /* Now do the PPS event report */
> >        pps_event(id, &ts,
> >                        status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR, tty);
> > 
> >        pr_debug("[STDev] PPS %s at %lu on source #%d\n",
> >                        status ? "assert" : "clear", jiffies, id);
> > }
> > 
> > However this solution gives very low precision timestamps so that's
> 
> Where are you calling it from, and how ?

>From serial_core.h as follow:

static inline void
uart_handle_dcd_change(struct uart_port *port, unsigned int status)
{
        struct uart_info *info = port->info;
        struct tty_ldisc *ld = tty_ldisc_ref(info->tty);

        if (ld->dcd_change)
                ld->dcd_change(info->tty, port->irq, status);
        tty_ldisc_deref(ld);

        port->icount.dcd++;

        if (info->flags & UIF_CHECK_CD) {
                if (status)
                        wake_up_interruptible(&info->open_wait);
                else if (info->tty)
                        tty_hangup(info->tty);
        }
}

> > 2) The new dcd_change() method is well implemented? Can I add the
> > "irq" parameter or I can find it somewhere?
> 
> Not all tty devices have an IRQ (I suspect those which do not are useless
> for PPS reporting however). 

Yes. Those devices are completely useless.

> Do you get decent reports if you change the tty driver to do
> 
> 	getnstimeofday(&ts);
> 	[blah blah lots of serial port I/O code]
> 	if (dcd ^ old_dcd)
> 		ld->dcd_change(tty, dcd, &ts);
> 
> ??

It could be a bit better... I did as above since I supposed that you
wished all PPS code should be removed from serial port code.

However, using your suggestion, I can do:

static inline void
uart_handle_dcd_change(struct uart_port *port, unsigned int status)
{
        struct uart_info *info = port->info;
        struct tty_ldisc *ld = tty_ldisc_ref(info->tty);
        struct pps_ktime ts;

#ifndef CONFIG_PPS_IRQ_EVENTS
        struct timespec __ts;  

        /* First of all we get the time stamp... */
        getnstimeofday(&__ts);

        /* ... and translate it to PPS time data struct */
        ts.sec = __ts.tv_sec;
        ts.nsec = __ts.tv_nsec;
#else
	/* Get the IRQ timestamp from system array */
	ts = pps_irq_ts[irq];
#endif

	if (ld->dcd_change)
		ld->dcd_change(info->tty, status, &ts);
	tty_ldisc_deref(ld);

	...

This is better then ever! :)

Thanks,

Rodolfo	

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@linux.it
Embedded Systems                     phone:	+39 349 2432127
UNIX programming                     skype:     rodolfo.giometti
