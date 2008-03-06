Return-Path: <linux-kernel-owner+w=401wt.eu-S1762998AbYCFNPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762998AbYCFNPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYCFNPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:15:03 -0500
Received: from vz1vps6.cineteck.net ([213.218.133.185]:43714 "EHLO
	vz1vps6.cineteck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYCFNPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:15:00 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2008 08:14:59 EST
Message-ID: <47CFECC1.2070404@csie.fr>
Date: Thu, 06 Mar 2008 14:08:17 +0100
From: Herve Spitz <spitz.herve@csie.fr>
User-Agent: Thunderbird 1.5.0.10 (X11/20070305)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem with a driver using the serial core
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm developping a serial driver for a PowerPC target wih a specific uart 
device, and I've some problem with the use of the serial core.
I've already developed a basic driver for it with simple open, close, 
read and write functions, but it seems that it's not enough for 
launching a busybox on this serial port.
So I've decided to try to use the serial core, but the startup function 
is never reached when I open the device with the open system call in a C 
program, altough the returned file descriptor is good. I've tried a lot 
of things and done some searches on the Internet, but I didn't find 
anywhere the solution of this issue.
I'm using the 2.6.22.6 kernel, and I tried to learn how to use this 
serial core with the help of a Linux Journal article ( 
http://www.linuxjournal.com/article/6331 ) and of course with the 
sources of the built-in serial driver from the kernel.
Here is a part of the code of my driver :

--------- Start of the code ---------
static int epicea_uart_startup(struct uart_port * port){
 printk(KERN_INFO "Driver serial: Startup\n");

  /* create our timer and submit it */
  if (!timer) {
    timer = kmalloc (sizeof (*timer), GFP_KERNEL);
    if (!timer)
      return -ENOMEM;
  }
  init_timer(timer);
  timer->data = (unsigned long) port;
  timer->expires = jiffies + DELAY_TIME;
  timer->function = epicea_uart_timer;
  add_timer (timer);
 
  return 0;
}

static struct uart_ops epicea_uart_ops = {
  .tx_empty    = epicea_uart_tx_empty,
  .set_mctrl    = epicea_uart_set_mctrl,
  .get_mctrl    = epicea_uart_get_mctrl,
  .stop_tx    = epicea_uart_stop_tx,
  .start_tx    = epicea_uart_start_tx,
  .stop_rx    = epicea_uart_stop_rx,
  .enable_ms    = epicea_uart_enable_ms,
  .break_ctl    = epicea_uart_break_ctl,
  .startup    = epicea_uart_startup,
  .shutdown    = epicea_uart_shutdown,
  .set_termios    = epicea_uart_change_speed,
  .type        = epicea_uart_type,
  .release_port    = epicea_uart_release_port,
  .request_port    = epicea_uart_request_port,
  .config_port    = epicea_uart_config_port,
  .verify_port    = epicea_uart_verify_port,
};

static struct uart_port epicea_uart_port = {
  .ops = &epicea_uart_ops,
};

static struct uart_driver epicea_uart_reg = {
  .owner       = THIS_MODULE,
  .driver_name = "driver_serial",
  .dev_name    = EPICEA_UART_DEVNAME,
  .major       = EPICEA_UART_MAJOR,
  .minor       = 1,
  .nr          = 1,
};

static int __init epicea_uart_init(void){
  int result;

  printk(KERN_INFO "Driver serial: Module init...");

  result = uart_register_driver(&epicea_uart_reg);
  if (result){
    printk(KERN_INFO "     [FAILED]\nDriver serial: Uart register driver 
failed\n");
    return result;
  }

  result = uart_add_one_port(&epicea_uart_reg,&epicea_uart_port);
  if (result){
    printk(KERN_INFO "     [FAILED]\nDriver serial: Uart add one port 
failed\n");
    return result;
  }

  printk(KERN_INFO "     [  OK  ]\n");
  return result;
}
--------- End of the code ---------

Any idea ?

Thanks in advance for your help.

Best regards,

Hervé Spitz
