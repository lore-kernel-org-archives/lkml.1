Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbZJ2RHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbZJ2RHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 13:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbZJ2RHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 13:07:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:48049 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511AbZJ2RHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 13:07:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=rYFEOxcNC9gjCEi/rBd5WSVitxXiOtP4i/luEUBPK+r+1nBqJCXz4v+31NQ6wzsqkW
         pOAdD6cLV8wsZvhpyX84DMGaZPzLX5PS62pyQnIO7uH8XGE6g0BG/Seh8sIbt8IhMZ4C
         ogZqvJij+ibCah0+w432k/oYQkWdImGae7X1I=
Date: Thu, 29 Oct 2009 19:07:32 +0200
From: Shmulik Ladkani <jungoshmulik@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       shmulik@jungo.com
Subject: Re: [PATCH] serial: copy UART properties of UPF_FIXED_TYPE ports
 provisioned using early_serial_setup
Message-ID: <20091029190732.4907b97d@pixies.home.jungo.com>
In-Reply-To: <20091028224737.ac4279e7.akpm@linux-foundation.org>
References: <4AE57EDF.3040607@jungo.com>
	<20091028224737.ac4279e7.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009 22:47:37 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 26 Oct 2009 12:50:07 +0200 Shmulik Ladkani <shmulik@jungo.com> wrote:
> 
> > @@ -2704,6 +2704,14 @@ serial8250_register_ports(struct uart_dr
> >   		struct uart_8250_port *up = &serial8250_ports[i];
> > 
> >   		up->port.dev = dev;
> > +
> > +		if (up->port.flags & UPF_FIXED_TYPE) {
> > +			up->port.fifosize =
> > +				uart_config[up->port.type].fifo_size;
> > +			up->capabilities = uart_config[up->port.type].flags;
> > +			up->tx_loadsz = uart_config[up->port.type].tx_loadsz;
> > +		}
> > +
> >   		uart_add_one_port(drv, &up->port);
> >   	}
> >   }
> 
> Why don't we also initialise up->port.type here?
In the original place (serial8250_register_port) there's a new uart port
instance to be registered (the function's argument).
This new instance *replaces* one of the matched/unused ports in the
serial8250_ports array - hence, the port's type must be properly assigned.

However, in 'serial8250_register_ports' there's no new port to replace an
existing port; but still, the uart port instance has uninitialized
capabilities/tx_loadsz fields that must be set in the UPF_FIXED_TYPE case.
The up->port.type was already initialized by early_serial_setup, and the patch
uses this type as the index to the uart_config array.

An alternative apprach is to move the UPF_FIXED_TYPE initialization code
into early_serial_setup. Do you think it is better?

> Perhaps it would be neater to write a little function to do this rather
> than copy-n-paste?
Yep, I guess it would be. Re-submitting a neater version of the patch.

Signed-off-by: Shmulik Ladkani <shmulik@jungo.com>
---
diff -upr linux-2.6.32-rc5.clean/drivers/serial/8250.c linux-2.6.32-rc5/drivers/serial/8250.c
--- linux-2.6.32-rc5.clean/drivers/serial/8250.c	2009-10-16 02:41:50.000000000 +0200
+++ linux-2.6.32-rc5/drivers/serial/8250.c	2009-10-29 18:33:50.000000000 +0200
@@ -2688,6 +2688,15 @@ static void __init serial8250_isa_init_p
 	}
 }
 
+static void
+serial8250_init_fixed_type_port(struct uart_8250_port *up, unsigned int type)
+{
+	up->port.type = type;
+	up->port.fifosize = uart_config[type].fifo_size;
+	up->capabilities = uart_config[type].flags;
+	up->tx_loadsz = uart_config[type].tx_loadsz;
+}
+
 static void __init
 serial8250_register_ports(struct uart_driver *drv, struct device *dev)
 {
@@ -2704,6 +2713,10 @@ serial8250_register_ports(struct uart_dr
 		struct uart_8250_port *up = &serial8250_ports[i];
 
 		up->port.dev = dev;
+
+		if (up->port.flags & UPF_FIXED_TYPE)
+			serial8250_init_fixed_type_port(up, up->port.type);
+
 		uart_add_one_port(drv, &up->port);
 	}
 }
@@ -3114,12 +3127,8 @@ int serial8250_register_port(struct uart
 		if (port->dev)
 			uart->port.dev = port->dev;
 
-		if (port->flags & UPF_FIXED_TYPE) {
-			uart->port.type = port->type;
-			uart->port.fifosize = uart_config[port->type].fifo_size;
-			uart->capabilities = uart_config[port->type].flags;
-			uart->tx_loadsz = uart_config[port->type].tx_loadsz;
-		}
+		if (port->flags & UPF_FIXED_TYPE)
+			serial8250_init_fixed_type_port(uart, port->type);
 
 		set_io_from_upio(&uart->port);
 		/* Possibly override default I/O functions.  */

-- 
Shmulik Ladkani		Jungo Ltd.
