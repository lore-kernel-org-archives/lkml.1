Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbZKWQxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbZKWQxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 11:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZKWQxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 11:53:21 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:56564 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbZKWQxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 11:53:20 -0500
Message-ID: <4B0ABE01.3030901@monstr.eu>
Date: Mon, 23 Nov 2009 17:53:21 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: benh@kernel.crashing.org, dmitchell@amcc.com
CC: Grant Likely <grant.likely@secretlab.ca>,
       John Williams <john.williams@petalogix.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Add UPF_FIXED_TYPE flag - eedacbf02df462d6c915d8d642b23fb450d485c7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben and David,

I have found one problem with input overrun. My problem is of course on 
Microblaze with uart16550.

Here is the behavior - I just pressed left arrow.

~ # fdasfdakjsdhfkajsdhfkjadklasdjfhajksdhfkahsdfjkahsdkjfhjkattyS0: 3 
input overrun(s)
[[DttyS0: 3 input overrun(s)
[[[[[DDDahsdk[[[[D[DDjfhjka[D          [[[DttyS0: 6 input 
overrun(s)jk[[D[D[[D[[
[[[[D[Dsd[[Dhfkah[[[[DD[[DDsdfjk[[D[D[[[[D[[[D[Dsd[[Dhfkah[[[[DD[[DDsdfjk[[D[D[[
D[[[[DDDahsdk[[[[D[DDjfhjka[D
-sh: 
fdasfdakjsdhfkajsdhfkjadklasdjfhajk[[D[[[D[Dsd[[Dhfkah[[[[DD[[DDsdfjk[[D[D[[D[[[[DDDahsdk[[[[D[DDjfhjka[D: 
not found


I bisected it and yours Subject patch caused my problems. It is really 
old patch and I was surprised how old it is.


Here is your diff
diff --git a/drivers/serial/of_serial.c b/drivers/serial/of_serial.c
index 02406ba..54483cd 100644
--- a/drivers/serial/of_serial.c
+++ b/drivers/serial/of_serial.c
@@ -67,7 +67,7 @@ static int __devinit of_platform_serial_setup(struct 
of_device *ofdev,
         port->type = type;
         port->uartclk = *clk;
         port->flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_IOREMAP
-               | UPF_FIXED_PORT | UPF_FIXED_TYPE;
+               | UPF_FIXED_PORT;
         port->dev = &ofdev->dev;
         /* If current-speed was set, then try not to change it. */
         if (spd)


If I trace port->type I am getting 3. (drivers/serial/8250.c:3089 
serial8250_register_port func 3118 - serial8250_register_port)
Grant: Could you please print that value on ppc?

Can you give me any hints what could be wrong? I will continue on it 
tomorrow.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
