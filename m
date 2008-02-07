Return-Path: <linux-kernel-owner+w=401wt.eu-S1763379AbYBGXOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763379AbYBGXOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763652AbYBGXOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:14:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56694 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763466AbYBGXOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:14:23 -0500
Message-ID: <47AB90C7.2070205@zytor.com>
Date: Thu, 07 Feb 2008 15:14:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
References: <20080205190600.GB11613@elf.ucw.cz> <20080207222845.GA6096@elf.ucw.cz> <47AB8A41.3040008@zytor.com> <200802072357.33293.rjw@sisk.pl>
In-Reply-To: <200802072357.33293.rjw@sisk.pl>
Content-Type: multipart/mixed;
 boundary="------------060101040700030303080000"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060101040700030303080000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Okay, this uses the iodelay as the timesource... here is the total 
silliness (and totally untested, of course.)

	-hpa


--------------060101040700030303080000
Content-Type: text/x-csrc;
 name="beep.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="beep.c"

static inline void io_delay(void)
{
	outb(0, 0x80);
}

static void udelay(int loops)
{
	while (loops--)
		io_delay();	/* Approximately 1 us */
}

static void beep(unsigned int hz)
{
	u8 enable;

	if (!hz) {
		enable = 0x00;		/* Turn off speaker */
	} else {
		u16 div = 1193181/hz;

		outb(0xb6, 0x43);	/* Ctr 2, squarewave, load, binary */
		io_delay();
		outb(div, 0x42);	/* LSB of counter */
		io_delay();
		outb(div >> 8, 0x42);	/* MSB of counter */
		io_delay();

		enable = 0x03;		/* Turn on speaker */
	}
	inb(0x61);		/* Dummy read of System Control Port B */
	io_delay();
	outb(enable, 0x61);	/* Enable timer 2 output to speaker */
	io_delay();
}

#define DOT_HZ		880
#define DASH_HZ		587
#define US_PER_DOT	125000

/* Okay, this is totally silly, but it's kind of fun. */
void send_morse(const char *pattern)
{
	char s;

	while ((s = *pattern++)) {
		switch (s) {
		case '.':
			beep(DOT_HZ);
			udelay(US_PER_DOT);
			beep(0);
			udelay(US_PER_DOT);
			break;
		case '-':
			beep(DASH_HZ);
			udelay(US_PER_DOT*3);
			beep(0);
			udelay(US_PER_DOT);
			break;
		default:	/* Assume it's a space */
			udelay(US_PER_DOT*3);
			break;
		}
	}
}



--------------060101040700030303080000--
