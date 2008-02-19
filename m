Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbYBSWuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbYBSWuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761829AbYBSWty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:49:54 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38180 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761702AbYBSWtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:49:52 -0500
Date: Wed, 20 Feb 2008 00:49:15 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: usb/serial/io_ti.c: inconsequent NULL checking
Message-ID: <20080219224915.GN31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following inconsequent NULL checking 
introduced by commit d5f5bcd425b771c0b7ff5a650b2ce061ac8bbb87:

<--  snip  -->

static int edge_open (struct usb_serial_port *port, struct file * filp)
{
...
        if (port->tty)   <---------------------------------------------
                port->tty->low_latency = low_latency;

        port_number = port->number - port->serial->minor;
        switch (port_number) {
                case 0:
                        edge_port->uart_base = UMPMEM_BASE_UART1;
                        edge_port->dma_address = UMPD_OEDB1_ADDRESS;
                        break;
                case 1:
                        edge_port->uart_base = UMPMEM_BASE_UART2;
                        edge_port->dma_address = UMPD_OEDB2_ADDRESS;
                        break;
                default:
                        dev_err (&port->dev, "Unknown port number!!!\n");
                        return -ENODEV;
        }

        dbg ("%s - port_number = %d, uart_base = %04x, dma_address = %04x",
             __FUNCTION__, port_number, edge_port->uart_base, edge_port->dma_address);

        dev = port->serial->dev;

        memset (&(edge_port->icount), 0x00, sizeof(edge_port->icount));
        init_waitqueue_head (&edge_port->delta_msr_wait);

        /* turn off loopback */
        status = TIClearLoopBack (edge_port);
        if (status) {
                dev_err(&port->dev,"%s - cannot send clear loopback command, %d\n",
                        __FUNCTION__, status);
                return status;
        }
        
        /* set up the port settings */
        edge_set_termios (port, port->tty->termios);
...                             ^^^^^^^^^^^^^^^^^^

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

