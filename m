Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbXLCJsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbXLCJsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 04:48:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbXLCJr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 04:47:56 -0500
Received: from www.tglx.de ([62.245.132.106]:38819 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbXLCJrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 04:47:55 -0500
Subject: [PATCH][AT91] Fix compile error for at91rm9200 in latest git
From: Jan Altenberg <jan.altenberg@linutronix.de>
To: dbrownell@users.sourceforge.net
Cc: linux@maxim.org.za, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain
Date: Mon, 03 Dec 2007 10:45:22 +0100
Message-Id: <1196675122.3832.18.camel@bender.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

at91rm9200ek doesn't compile in latest git:

/here/workdir/linux-2.6/at91rm9200ek/src/arch/arm/mach-at91/board-ek.c: In function `ek_board_init':
/here/workdir/linux-2.6/at91rm9200ek/src/arch/arm/mach-at91/board-ek.c:148: error: `ek_i2c_devices' undeclared (first use in this function)
/here/workdir/linux-2.6/at91rm9200ek/src/arch/arm/mach-at91/board-ek.c:148: error: (Each undeclared identifier is reported only once
/here/workdir/linux-2.6/at91rm9200ek/src/arch/arm/mach-at91/board-ek.c:148: error: for each function it appears in.)
/here/workdir/linux-2.6/at91rm9200ek/src/arch/arm/mach-at91/board-ek.c:148: warning: type defaults to `int' in declaration of `type name'
/here/workdir/linux-2.6/at91rm9200ek/src/arch/arm/mach-at91/board-ek.c:148: warning: type defaults to `int' in declaration of `type name'
/here/workdir/linux-2.6/at91rm9200ek/src/arch/arm/mach-at91/board-ek.c:148: error: size of array `type name' is negative

The offending commit is:

[jan@bender linux-2.6]$ git-bisect good
f230d3f53d72d05bcb5666ab7e2eccd49c8b3a15 is first bad commit
commit f230d3f53d72d05bcb5666ab7e2eccd49c8b3a15
Author: Andrew Victor <andrew@sanpeople.com>
Date:   Mon Nov 19 13:47:20 2007 +0100

    [ARM] 4650/1: AT91: New-style init of I2C, support for i2c-gpio
    
    The AT91 I2C driver is currently marked as "broken" due to hardware
    issues.  This patch enables AT91-based platforms to also use the
    bitbanged GPIO for I2C.
    
    This updates platform setup logic (setting up an i2c-gpio device
    using the same pins as the i2c-at91 device, unless only the BROKEN
    driver is enabled).
    
    Also make use of the new-style initialization of I2C devices using
    i2c_register_board_info().
    
    Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
    Signed-off-by: Andrew Victor <andrew@sanpeople.com>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

This patch adds the missing i2c_board_info struct (grabbed from Andrew
Victor's tree).

Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>

---
diff --git a/arch/arm/mach-at91/board-ek.c b/arch/arm/mach-at91/board-ek.c
index d05b1b2..53a5ef9 100644
--- a/arch/arm/mach-at91/board-ek.c
+++ b/arch/arm/mach-at91/board-ek.c
@@ -109,6 +109,15 @@ static struct spi_board_info ek_spi_devices[] = {
 #endif
 };
 
+static struct i2c_board_info __initdata ek_i2c_devices[] = {
+	{
+		I2C_BOARD_INFO("ics1523", 0x26),
+	},
+	{
+		I2C_BOARD_INFO("dac3550", 0x4d),
+	}
+};
+
 #define EK_FLASH_BASE	AT91_CHIPSELECT_0
 #define EK_FLASH_SIZE	0x200000


