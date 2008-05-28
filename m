Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbYE1Eon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbYE1Eon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 00:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbYE1Eof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 00:44:35 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:32209 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751480AbYE1Eof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 00:44:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=SJu+lJxVbpDGkAicvO906f0TrFuubTe8FEGUKebQqh5QuxeiIQagjWwMfv0eLegCsKWbramJ1LVCCbLPke3BVVgpmbXxHNeDMpcv/O/VMOzn5qvqKG34KAc3mmAOsfrGAWgNsHZrCOUwlkXr9t9Qon4C06HWOh0H2htOtypVe/A=  ;
X-YMail-OSG: t86Md.4VM1ny5sV.PsGHKnfzUGUKomrm.FOB.UEj6r2VtIS8zA7J73DtLMO0TWdXNSUowl.OJ4RDTezDZhDQxyMgSx0MUpGLe7tn5edoJbs53OdabBtEVGGxOWePWOeUwf0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: Latest gpio gumph
Date: Tue, 27 May 2008 21:44:33 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <1211942475.27810.37.camel@moss.renham>
In-Reply-To: <1211942475.27810.37.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805272144.33334.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2008, Ben Nizette wrote:
> Hey David,
> 
> Have you got a git/quilt repo somewhere with all the latest gpiolib (and
> gpio framework) stuff glued in?  I've seen most of it hit -mm but
> developing against -mm on (especially on obscure archs like AVR32 as I
> do) is always fraught.

All the relevant stuff is now upstream (2.6.26-rc4) except:

  - the userspace sysfs interface (which is in MM, and ISTR
    you were cc'd on that)

  - an avr32 patch, appended (no response on the avr32 list)

Nothing else touches core code; if you're using AVR32, then
you won't care about at91 gpiolib and inlining support, or the
patch sent this AM on LKML (which I've not yet reviewed).

- Dave



====== CUT HERE
From: David Brownell <dbrownell@users.sourceforge.net>
Subject: AVR32: minor GPIO handling updates

 * gpio_direction_output() should disable the pullups just like
   at32_select_gpio(... AT32_GPIOF_OUTPUT) does, for consistency
   between those alternative initialization paths.

 * On the odd chance some code uses a pin as a GPIO IRQ without
   calling gpio_request() or gpio_direction_input(), the debug
   dump should still show its pin status.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 arch/avr32/mach-at32ap/pio.c |    3 +++
 1 files changed, 3 insertions(+)

--- a/arch/avr32/mach-at32ap/pio.c	2008-05-02 12:30:59.000000000 -0700
+++ b/arch/avr32/mach-at32ap/pio.c	2008-05-02 12:41:29.000000000 -0700
@@ -191,6 +191,7 @@ static int direction_output(struct gpio_
 		return -EINVAL;
 
 	gpio_set(chip, offset, value);
+	pio_writel(pio, PUDR, mask);
 	pio_writel(pio, OER, mask);
 	return 0;
 }
@@ -318,6 +319,8 @@ static void pio_bank_show(struct seq_fil
 		const char *label;
 
 		label = gpiochip_is_requested(chip, i);
+		if (!label && (imr & mask))
+			label = "[irq]";
 		if (!label)
 			continue;
 
