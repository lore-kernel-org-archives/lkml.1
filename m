Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbYHTIx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbYHTIx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 04:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYHTIxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 04:53:16 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:55441 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbYHTIxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 04:53:15 -0400
Date: Wed, 20 Aug 2008 10:53:03 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Message-ID: <20080820085303.GA17591@tekkaman>
References: <1219182612-13814-1-git-send-email-giometti@linux.it> <1219182612-13814-2-git-send-email-giometti@linux.it> <1219182612-13814-3-git-send-email-giometti@linux.it> <1219182612-13814-4-git-send-email-giometti@linux.it> <1219182612-13814-5-git-send-email-giometti@linux.it> <1219182612-13814-6-git-send-email-giometti@linux.it> <20080819225322.69f3215d@lxorguk.ukuu.org.uk> <20080819224930.GI21330@tekkaman> <20080819233857.41b756cc@lxorguk.ukuu.org.uk> <20080819230523.GJ21330@tekkaman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819230523.GJ21330@tekkaman>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 05/10] ldisc: new dcd_change() method for line
	disciplines.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 01:05:23AM +0200, Rodolfo Giometti wrote:

> Maybe I can solve the problem defining dcd_change() as follow:
> 
>    void (*dcd_change)(struct tty_struct *tty, unsigned int status,
>                         void *data)
> 
> and then passing the timestamp or struct uart_port pointer?

After sleeping this night :) I think is better defing the
uart_handle_dcd_change() into serial_core.h as follow:

uart_handle_dcd_change(struct uart_port *port, unsigned int status)
{
        struct uart_info *info = port->info;
        struct tty_ldisc *ld = tty_ldisc_ref(info->port.tty);
        struct timespec ts;

        if (ld->ops->dcd_change)
#ifdef CONFIG_PPS_IRQ_EVENTS
                ts = pps_irq_ts[port->irq];
#else
                getnstimeofday(&ts);
#endif

        port->icount.dcd++;
#ifdef CONFIG_HARD_PPS
        if ((port->flags & UPF_HARDPPS_CD) && status)
                hardpps();
#endif

        if (info->flags & UIF_CHECK_CD) {
                if (status)
                        wake_up_interruptible(&info->port.open_wait);
                else if (info->port.tty)
                        tty_hangup(info->port.tty);
        }

        if (ld->ops->dcd_change)
                ld->ops->dcd_change(info->port.tty, status, &ts);
        tty_ldisc_deref(ld);
}

This completely hides the (dirty) trick to the PPS clients and allow
using struct tty_struct as first parameter.

Is that acceptable?

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
