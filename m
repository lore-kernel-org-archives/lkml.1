Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbZGEQvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbZGEQvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 12:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZGEQvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 12:51:25 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:2657 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271AbZGEQvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 12:51:20 -0400
X-IronPort-AV: E=Sophos;i="4.42,352,1243828800"; 
   d="scan'208";a="3456051"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, greg@kroah.com
Subject: Re: [PATCH 2/2] usb_serial: only allow sysrq on a console port
Date: Sun, 5 Jul 2009 12:54:41 -0400
User-Agent: KMail/1.9.5
CC: "Jason Wessel" <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <1243622057-17671-1-git-send-email-jason.wessel@windriver.com> <1243622057-17671-3-git-send-email-jason.wessel@windriver.com> <20090601143538.70b7a4e2@lxorguk.ukuu.org.uk>
In-Reply-To: <20090601143538.70b7a4e2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200907051254.41964.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 05 Jul 2009 16:51:22.0490 (UTC) FILETIME=[D3A825A0:01C9FD90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 1 Jun 2009 09:35, Alan Cox pondered:
> On Fri, 29 May 2009 13:34:17 -0500
> Jason Wessel <jason.wessel@windriver.com> wrote:
> 
> > The only time a sysrq should get processed is if the attached device
> > is a console.  This is intended to protect sysrq execution on a host
> > connected with a terminal program.
> 
> This doesn't seem to match any tree I can find ?

Alan:

If Jason's patch is necessary () - should this be fixed up for standard
UARTs too?

Make sure that only serial console (not _any_ serial port) responds to 
sysrq (or should something else be ensuring that this isn't set when 
the port !console? (I didn't see anything in serial_core.c?)

---

diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 23d2fb0..f8ab858 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -474,7 +474,7 @@ static inline int
 uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
 {
 #ifdef SUPPORT_SYSRQ
-       if (port->sysrq) {
+       if (port->sysrq && port->console) {
                if (ch && time_before(jiffies, port->sysrq)) {
                        handle_sysrq(ch, port->info->port.tty);
                        port->sysrq = 0;

----------

That brings up the next question...

The above patch would sync the (seemlying duplicated) code between
drivers/usb/serial/generic.c and include/linux/serial_core.h

Greg?

drivers/usb/serial/generic.c
int usb_serial_handle_sysrq_char(struct usb_serial_port *port, unsigned int ch)
{
        if (port->sysrq && port->console) {
                if (ch && time_before(jiffies, port->sysrq)) {
                        handle_sysrq(ch, tty_port_tty_get(&port->port));
                        port->sysrq = 0;
                        return 1;
                }
                port->sysrq = 0;
        }
        return 0;
}

include/linux/serial_core.h
static inline int
uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
{
#ifdef SUPPORT_SYSRQ
        if (port->sysrq) {
                if (ch && time_before(jiffies, port->sysrq)) {
                        handle_sysrq(ch, port->info->port.tty);
                        port->sysrq = 0;
                        return 1;
                }
                port->sysrq = 0;
        }
#endif
        return 0;
}

