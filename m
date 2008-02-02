Return-Path: <linux-kernel-owner+w=401wt.eu-S1762930AbYBBETO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762930AbYBBETO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 23:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYBBETD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 23:19:03 -0500
Received: from usermail.globalproof.net ([194.146.153.18]:56945 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbYBBETA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 23:19:00 -0500
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, wim@iguana.be
Subject: Re: kernel panic on 2.6.24/iTCO_wdt not rebooting machine
Date: Sat, 2 Feb 2008 06:18:49 +0200
Message-Id: <20080202030857.M61478@visp.net.lb>
In-Reply-To: <200802011539.08393.lenb@kernel.org>
References: <20080201151243.M2879@visp.net.lb> <200802011211.42089.lenb@kernel.org> <20080201191048.M59862@visp.net.lb> <200802011539.08393.lenb@kernel.org>
X-Mailer: OpenWebMail 2.52 
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think i found issue, but not able to understand how to fix it.

I did small patch to make sure, that code able to change TCO_EN(bit 13) to 0. 
It cannot change it, because TCO_LOCK bit is set. I

For example i did patch to see that:

--- /usr/src/linux-2.6.24/drivers/watchdog/iTCO_wdt.c   2008-01-25 
00:58:37.000000000 +0200
+++ /WORK/globalosii/linux-embedded/drivers/watchdog/iTCO_wdt.c 2008-02-02 
05:11:46.000000000 +0200
@@ -659,8 +659,13 @@
                goto out;
        }
        val32 = inl(SMI_EN);
+       printk(KERN_INFO PFX "TCO_EN was %04lX\n", val32);
        val32 &= 0xffffdfff;    /* Turn off SMI clearing watchdog */
+       printk(KERN_INFO PFX "TCO_EN will try to set %04lX\n", val32);
        outl(val32, SMI_EN);
+       val32 = inl(SMI_EN);
+       printk(KERN_INFO PFX "TCO_EN after set %04lX\n", val32);
+
        release_region(SMI_EN, 4);

        /* The TCO I/O registers reside in a 32-byte range pointed to by the 
TCOBASE value */

and i got in dmesg

[  589.913354] iTCO_wdt: TCO_EN was 0000203B
[  589.913356] iTCO_wdt: TCO_EN will try to set 0000003B
[  589.913360] iTCO_wdt: TCO_EN after set 0000203B

So this function will not work in some conditions, for example in my 
situation. It is a bit dangerous, because as i understand function is 
supposed to disable unexpected reboots during watchdog setup, so maybe must 
be added check for TCO_LOCK bit, or just to check if value really has been 
changed.

Also i dont understand code:
TCO1_STS for example, to clear bit's needs to write 1 to each one (it is not 
WRITE, it is WRITECLEAR almost all of them, except Bit 0 on TCO1_STS which is 
Read Only) (i read that in ICH9 datasheet). So outb(0, TCO1_STS), just will 
not do anything.

TCO2_STS, bit 0 is responsible Intruder Detect on ICH8 and ICH9!!! Probably 
it is not good to reset this bit.

Code:
       /* Clear out the (probably old) status */
        outb(0, TCO1_STS);
        outb(3, TCO2_STS);


But that all small issues, and doesn't explain why it doesn't work. I did 
small patch, and instead of resetting timer, i am getting current value of 
timer.

Patch looks like this:

@@ -483,6 +484,7 @@
 static ssize_t iTCO_wdt_write (struct file *file, const char __user *data,
                              size_t len, loff_t * ppos)
 {
+       unsigned int val16;
        /* See if we got the magic character 'V' and reload the timer */
        if (len) {
                if (!nowayout) {
@@ -503,7 +505,14 @@
                }

                /* someone wrote to us, we should reload the timer */
-               iTCO_wdt_keepalive();
+               //iTCO_wdt_keepalive();
+               spin_lock(&iTCO_wdt_private.io_lock);
+               val16 = inw(TCO_RLD);
+               val16 &= 0x3ff;
+               spin_unlock(&iTCO_wdt_private.io_lock);
+
+               printk(KERN_INFO PFX "Remaining time %d\n", (val16 * 6) / 10);
+


[ 2505.979453] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[ 2505.980073] iTCO_wdt: TCO_EN was 0000203B
[ 2505.980076] iTCO_wdt: TCO_EN will try to set 0000003B
[ 2505.980083] iTCO_wdt: TCO_EN after set 0000203B
[ 2505.980085] iTCO_wdt: Found a ICH9R TCO device (Version=2, TCOBASE=0x0460)
[ 2505.980088] iTCO_wdt: TCO1_STS was 0000
[ 2505.980090] iTCO_wdt: TCO2_STS was 0000
[ 2505.980664] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[ 2515.908192] iTCO_wdt: Remaining time 30
[ 2516.408459] iTCO_wdt: Remaining time 29
[ 2516.908687] iTCO_wdt: Remaining time 28
[ 2517.408917] iTCO_wdt: Remaining time 28
[ 2517.909144] iTCO_wdt: Remaining time 28
[ 2518.409373] iTCO_wdt: Remaining time 27
[ 2518.909601] iTCO_wdt: Remaining time 27
[ 2519.409829] iTCO_wdt: Remaining time 26
[ 2519.910057] iTCO_wdt: Remaining time 25
[ 2520.410287] iTCO_wdt: Remaining time 25
[ 2520.910515] iTCO_wdt: Remaining time 25
[ 2521.410745] iTCO_wdt: Remaining time 24
[ 2521.910972] iTCO_wdt: Remaining time 24
[ 2522.411201] iTCO_wdt: Remaining time 23
[ 2522.911429] iTCO_wdt: Remaining time 22
[ 2523.411658] iTCO_wdt: Remaining time 22
[ 2523.911886] iTCO_wdt: Remaining time 21
[ 2524.412115] iTCO_wdt: Remaining time 21
[ 2524.912343] iTCO_wdt: Remaining time 21
[ 2525.412573] iTCO_wdt: Remaining time 20
[ 2525.912801] iTCO_wdt: Remaining time 19
[ 2526.413030] iTCO_wdt: Remaining time 19
[ 2526.913258] iTCO_wdt: Remaining time 18
[ 2527.413487] iTCO_wdt: Remaining time 18
[ 2527.913715] iTCO_wdt: Remaining time 18
[ 2528.413944] iTCO_wdt: Remaining time 17
[ 2528.914172] iTCO_wdt: Remaining time 16
[ 2529.414401] iTCO_wdt: Remaining time 16
[ 2529.914629] iTCO_wdt: Remaining time 15
[ 2530.414859] iTCO_wdt: Remaining time 15
[ 2530.915087] iTCO_wdt: Remaining time 14
[ 2531.415315] iTCO_wdt: Remaining time 14
[ 2531.915544] iTCO_wdt: Remaining time 13
[ 2532.415773] iTCO_wdt: Remaining time 13
[ 2532.916001] iTCO_wdt: Remaining time 12
[ 2533.416230] iTCO_wdt: Remaining time 12
[ 2533.916459] iTCO_wdt: Remaining time 11
[ 2534.416688] iTCO_wdt: Remaining time 10
[ 2534.916916] iTCO_wdt: Remaining time 10
[ 2535.417144] iTCO_wdt: Remaining time 10
[ 2535.917373] iTCO_wdt: Remaining time 9
[ 2536.417602] iTCO_wdt: Remaining time 9
[ 2536.917830] iTCO_wdt: Remaining time 8
[ 2537.418059] iTCO_wdt: Remaining time 7
[ 2537.918287] iTCO_wdt: Remaining time 7
[ 2538.418516] iTCO_wdt: Remaining time 7
[ 2538.918744] iTCO_wdt: Remaining time 6
[ 2539.418973] iTCO_wdt: Remaining time 6
[ 2539.919201] iTCO_wdt: Remaining time 5
[ 2540.419431] iTCO_wdt: Remaining time 4
[ 2540.919658] iTCO_wdt: Remaining time 4
[ 2541.419888] iTCO_wdt: Remaining time 4
[ 2541.920116] iTCO_wdt: Remaining time 3
[ 2542.420345] iTCO_wdt: Remaining time 3
[ 2542.920573] iTCO_wdt: Remaining time 2
[ 2543.420802] iTCO_wdt: Remaining time 1
[ 2543.921030] iTCO_wdt: Remaining time 1
[ 2544.421259] iTCO_wdt: Remaining time 0
[ 2544.921487] iTCO_wdt: Remaining time 0
[ 2545.421716] iTCO_wdt: Remaining time 2
[ 2545.921945] iTCO_wdt: Remaining time 1
[ 2546.422173] iTCO_wdt: Remaining time 1
[ 2546.922402] iTCO_wdt: Remaining time 0
[ 2547.422631] iTCO_wdt: Remaining time 2
[ 2547.922859] iTCO_wdt: Remaining time 1
[ 2548.423088] iTCO_wdt: Remaining time 1

I tried to watch register each 100ms

[ 3525.608533] iTCO_wdt: Remaining ticks 3
[ 3525.709376] iTCO_wdt: Remaining ticks 3
[ 3525.810220] iTCO_wdt: Remaining ticks 3
[ 3525.911065] iTCO_wdt: Remaining ticks 3
[ 3526.011909] iTCO_wdt: Remaining ticks 2
[ 3526.112753] iTCO_wdt: Remaining ticks 2
[ 3526.213598] iTCO_wdt: Remaining ticks 2
[ 3526.314443] iTCO_wdt: Remaining ticks 2
[ 3526.415287] iTCO_wdt: Remaining ticks 2
[ 3526.516135] iTCO_wdt: Remaining ticks 2
[ 3526.616977] iTCO_wdt: Remaining ticks 1
[ 3526.717820] iTCO_wdt: Remaining ticks 1
[ 3526.818665] iTCO_wdt: Remaining ticks 1
[ 3526.919510] iTCO_wdt: Remaining ticks 1
[ 3527.020354] iTCO_wdt: Remaining ticks 1
[ 3527.121199] iTCO_wdt: Remaining ticks 4
[ 3527.222043] iTCO_wdt: Remaining ticks 4
[ 3527.322890] iTCO_wdt: Remaining ticks 4
[ 3527.423732] iTCO_wdt: Remaining ticks 4
[ 3527.524577] iTCO_wdt: Remaining ticks 4
[ 3527.625422] iTCO_wdt: Remaining ticks 4


Which means timer reaching 0... and, nothing happen! It goes again 2 and then 
again 0. I check even STS registers, they are still zero! Register just set 
back to default value 0004h.

Probably someone can help me with this? Or it is hardware bug of chipset?
I will try to look more docs, maybe i will be able to find whats wrong there.

On Fri, 1 Feb 2008 15:39:08 -0500, Len Brown wrote
> On Friday 01 February 2008 14:15, Denys Fedoryshchenko wrote:
> > 
> > On Fri, 1 Feb 2008 12:11:41 -0500, Len Brown wrote
> > > 
> > > What do you see if you build with CONFIG_HIGH_RES_TIMERS=n
> > > 
> > > Does it work better if you boot with "acpi=off"?
> > > if yes, how about with just pnpacpi=off?
> > > 
> > > thanks,
> > > -Len
> > 
> > It is not very easy to test. About bug - most probably it is related to 
third 
> > party ESFQ patch, i will drop it and then test more properly when i will 
be 
> > able to make watchdog work fine. But more important i notice - that 
iTCO_wdt 
> > is not working at all. I think hrtimers doesn't change anything on that.
> > About testing, i cannot take even small risk now(and near 3-5 days) by 
> > changing kernel options, i set now maximum available set of watchdogs, 
cause 
> > there is noone to maintain server, area is unreachable because of snow 
and 
> > bad weather.
> > 
> > Do you think reasonable to try acpi / pnpacpi with iTCO_wdt to make it 
work? 
> > Maybe just registers addresses or way how TCO watchdog activated changed 
on 
> > this chipset?
> 
> yes, i'm wondering if the changes in IO resource reservations
> in the PNPACPI layer are interfering with the native driver.
> 
> unfortunately, if you boot with acpi=off or pnpacpi=off, you may
> run into other, unrelated, issues (or not).
> 
> one way to isolate the problem is if you revert these two lines
> from their 2.6.24 values to their 2.6.23 values by applying this patch:
> ---
> diff --git a/include/linux/pnp.h b/include/linux/pnp.h
> index 2a6d62c..16b46aa 100644
> --- a/include/linux/pnp.h
> +++ b/include/linux/pnp.h
> @@ -13,8 +13,8 @@
>  #include <linux/errno.h>
>  #include <linux/mod_devicetable.h>
> 
> -#define PNP_MAX_PORT		40
> -#define PNP_MAX_MEM		12
> +#define PNP_MAX_PORT		8
> +#define PNP_MAX_MEM		4
>  #define PNP_MAX_IRQ		2
>  #define PNP_MAX_DMA		2
>  #define PNP_NAME_LEN		50


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

