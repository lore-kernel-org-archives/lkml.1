Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbYFDLA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbYFDLA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 07:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbYFDLAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 07:00:20 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:28362 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbYFDLAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 07:00:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=KrleePNjF67bOayTkS62PsG2alGPdcHiNnNUsyD6TwrxpKDOWPdFrxrTI89yRWSrfV
         mfqtuzzPzteyRsgtTJd20ecbj8K3hGmLN0hxlvGCOPf07UoQk19kqetyetz2VgzehNc8
         jKP9RhDRmcV8LLrDy1ZnOS7bYtuilnNSLJV0A=
Message-ID: <c384c5ea0806040400j35236d5fo3854ce2ed30cd755@mail.gmail.com>
Date: Wed, 4 Jun 2008 13:00:19 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
Subject: Locking in the (now generic) GPIO infrastructure?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

compare void gpio_line_set() in

arch/arm/plat-iop/gpio.c:
void gpio_line_set(int line, int value)
{
	unsigned long flags;

	local_irq_save(flags);
	if (value == GPIO_LOW) {
		*IOP3XX_GPOD &= ~(1 << line);
	} else if (value == GPIO_HIGH) {
		*IOP3XX_GPOD |= 1 << line;
	}
	local_irq_restore(flags);
}

with

include/asm-arm/arch-ixp4xx/platform.h:
static inline void gpio_line_set(u8 line, int value)
{
	if (value == IXP4XX_GPIO_HIGH)
	    *IXP4XX_GPIO_GPOUTR |= (1 << line);
	else if (value == IXP4XX_GPIO_LOW)
	    *IXP4XX_GPIO_GPOUTR &= ~(1 << line);
}

Under a Linux kernel where multiple drivers are accessing GPIO, the
latter does not seem safe against preemption (assuming the memory
read-modify-write is not atomic).

Shouldn't GPIO access be protected against concurrent access here?

Documentation/gpio.txt does not really mention the locking mechanism
assumed to modify GPIO lines.

And I think I am running into an issue with this under -rt kernels,
but that needs more analysis from my side.

Regards,
-- 
Leon
