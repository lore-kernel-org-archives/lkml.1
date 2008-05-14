Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbYENXcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbYENXcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 19:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYENXcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 19:32:17 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:36201 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbYENXcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 19:32:16 -0400
Date: Thu, 15 May 2008 02:30:37 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Karol Lewandowski <lmctlx@gmail.com>
Subject: Re: [Bug #10670] BUG: linux-2.6.26-rc1 oops at
	thinkpad_acpi:led_set_status
Message-ID: <20080514233037.GB11439@cs181133002.pp.htv.fi>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.qfG.mv1JIB@chimera> <20080512041753.GA4543@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080512041753.GA4543@khazad-dum.debian.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 01:17:53AM -0300, Henrique de Moraes Holschuh wrote:
> On Sun, 11 May 2008, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10670
> > Subject		: BUG: linux-2.6.26-rc1 oops at thinkpad_acpi:led_set_status
> > Submitter	: Karol Lewandowski <lmctlx@gmail.com>
> > Date		: 2008-05-08 23:12 (4 days old)
> > References	: http://marc.info/?l=linux-kernel&amp;m=121028841527994&amp;w=4
> > Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> 
> It is related to:
> 
> 1. Debian gcc in stable being used to compile the kernel
> 2. unmodified led_set_status() function on thinkpad-acpi.c
> 3. kernel compiled in "optimize for size" mode
> 4. stack frames NOT being enabled.
> 
> Change one, and the bug is gone.
> 
> AFAIK, it means Debian stable's gcc is generating bad code.
>...


No, your code is buggy:


#define TPACPI_LED_NUMLEDS 8
static enum led_status_t tpacpi_led_state_cache[TPACPI_LED_NUMLEDS];


static int led_write(char *buf)
{
...
                if (sscanf(cmd, "%d", &led) != 1 || led < 0 || led > 7)
                        return -EINVAL;
...
                rc = led_set_status(led, s);
...
}

static int led_set_status(unsigned int led, enum led_status_t ledstatus)
{
...
        switch (led_supported) {
...
        case TPACPI_LED_OLD:
                        /* 600e/x, 770e, 770x, A21e, A2xm/p, T20-22, X20 */
----->                  led = 1 << led;
                        rc = ec_write(TPACPI_LED_EC_HLMS, led);
                        if (rc >= 0)
                                rc = ec_write(TPACPI_LED_EC_HLBL,
                                              led * led_exp_hlbl[ledstatus]);
                        if (rc >= 0)
                                rc = ec_write(TPACPI_LED_EC_HLCL,
                                              led * led_exp_hlcl[ledstatus]);
                        break;
...
        if (!rc)
                tpacpi_led_state_cache[led] = ledstatus;
...                                    ^^^
}


According to the assembler code "led" is in register EBX, and in the 
trace the value of EBX is 0x80.

0x80 = 1 << 7

What happens when you write to tpacpi_led_state_cache[0x80] is 
undefined, and it's not a surprise that random changes let the
bug seem to disappear.


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

