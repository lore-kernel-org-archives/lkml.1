Return-Path: <linux-kernel-owner+w=401wt.eu-S1760284AbYG3Kl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbYG3Kl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYG3KlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:41:20 -0400
Received: from imo-m25.mx.aol.com ([64.12.137.6]:62908 "EHLO
	imo-m25.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYG3KlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:41:19 -0400
Message-ID: <489044C8.7090006@aim.com>
Date: Wed, 30 Jul 2008 03:39:04 -0700
From: David W Studeman <avionicsdv@aim.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1a2pre) Gecko/2008072700 SeaMonkey/2.0a1pre
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Keyboard Jammed error patch 2.4.35-pre4
References: <g6jqud$t5e$1@ger.gmane.org> <20080729051558.GH29189@1wt.eu> <489016AB.6050309@aim.com> <20080730075101.GA31668@1wt.eu>
In-Reply-To: <20080730075101.GA31668@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AOL-IP: 71.112.171.94
X-Mailer: Unknown (No Version)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Wed, Jul 30, 2008 at 12:22:19AM -0700, David W Studeman wrote:
>    
>> No I can't use the nokeybd option as a Cobalt uses no bootloader on the
>> mbr. The arguments would have to be embedded into the flashrom image and
>> it isn't something most people want to deal with.
>>      
>
> OK, I was not talking about a solution but about a temporary workaround
> anyway :-)
>
>    
>>> Also, if you don't have any PC keyboard on your machines, you can
>>> build without support for any VT/keyboard. I'm already doing this
>>> on some embedded systems, and it works fine. If your platform still
>>> requires that some keyboard is enabled, you may want to try to enable
>>> CONFIG_DUMMY_KEYB which I've been using in the past.
>>>
>>>        
>> That didn't work either, what did save me was patching back to 2.4.34
>> for the dmi and keyboard headers and compiling without any keyboard
>> support at all. Also, since this is essentially a PC without a normal
>> bios, the kernel reports that there is no dmi present. The boot method
>> here reminds me of EFI but it isn't.
>>      
>
> Just so that I understand, when you say it is a PC, is it x86-based or
> a different arch ? I thought it was a mips, but now you're speaking about
> a PC I'm confused. If it's x86, I don't see why the patch caused a regression
> since it does not change the default behaviour for x86. If it's a mips, I don't
> see why the proposed patch does not work as it was supposed to revert to
> previous behaviour :-/
>
>    
>>> @@ -905,7 +908,7 @@ static char * __init initialize_kbd(void)
>>>
>>>   void __init pckbd_init_hw(void)
>>>   {
>>> -   if (!keyboard_controller_present) {
>>> +   if (!kbd_controller_present()) {
>>>          kbd_exists = 0;
>>>          return;
>>>      }
>>>
>>>        
>> The last hunk at 905 fails to apply, line 61 passes due to some fuzz
>> factor although I can't see what is different and why it needs to fuzz
>> but line 61 still passes. Here is a snip from the log:
>>      
>
> hmm sorry, I did it in a hurry against next 2.4.37-rc1. I'll check.
>
>    
>> patching file drivers/char/pc_keyb.c
>> Hunk #1 succeeded at 61 with fuzz 1.
>> Hunk #4 FAILED at 908.
>> 1 out of 4 hunks FAILED -- saving rejects to file drivers/char/pc_keyb.c.rej
>> make: *** [/usr/src/log/linux-2.4.36.6] Error 1
>>
>> And here is the pc_keyb.c.rej:
>>
>> ***************
>> *** 905,911 ****
>>
>>    void __init pckbd_init_hw(void)
>>    {
>> -    if (!keyboard_controller_present) {
>>           kbd_exists = 0;
>>           return;
>>       }
>> --- 908,914 ----
>>
>>    void __init pckbd_init_hw(void)
>>    {
>> +    if (!kbd_controller_present()) {
>>           kbd_exists = 0;
>>           return;
>>       }
>>      
>
> This was the important part. Did you fix it by hand ? If not, it would
> explain why it did not change the behaviour.
>
> Regards,
> Willy
>
>    
  It didn't change the behaviour because it would not apply cleanly, 
kernel compilation stopped there.

A raq/qube3, raq4, raq550, and xtr are all x86 based but they do not use 
a typical bios and a bootloader to start the boot process but that part 
is not important here. When I made the regression patch, I simply diffed 
the dmi scan and keyboard drivers between the two kernels. The stock 
2.4.36.6 kernel cannot be compiled for x86 with no keyboard and vt 
support and I need no dummy driver even though it would not compile by 
choosing the dummy driver by itself either. Regression patching to 
2.4.34 restored the ability to compile without keyboard and vt support. 
This is what it took:

Dave

--- linux-2.4.36/arch/i386/kernel/dmi_scan.c.orig    2008-01-01 
12:06:40.000000000 +0000
+++ linux-2.4.36/arch/i386/kernel/dmi_scan.c    2008-07-16 
03:36:01.000000000 +0000
@@ -524,21 +524,6 @@
   */


-/*      IBM bladeservers have a USB console switch. The keyboard type 
is USB
- *      and the hardware does not have a console keyboard. We disable the
- *      console keyboard so the kernel does not try to initialize one and
- *      spew errors. This can be used for all systems without a console
- *      keyboard like systems with just a USB or IrDA keyboard.
- */
-static __init int disable_console_keyboard(struct dmi_blacklist *d)
-{
-        extern int keyboard_controller_present;
-        printk(KERN_INFO "*** Hardware has no console keyboard 
controller.\n");
-        printk(KERN_INFO "*** Disabling console keyboard.\n");
-        keyboard_controller_present = 0;
-        return 0;
-}
-
  /*
   *    This will be expanded over time to force things like the APM
   *    interrupt mask settings according to the laptop
@@ -825,15 +810,6 @@
              MATCH(DMI_SYS_VENDOR, "IBM"),
              NO_MATCH, NO_MATCH, NO_MATCH
              } },
- /*
-         *      IBM Bladeservers
-         */
-
-        { disable_console_keyboard, "IBM Server Blade", {
-                        MATCH(DMI_SYS_VENDOR,"IBM"),
-                        MATCH(DMI_BOARD_NAME, "Server Blade"),
-                        NO_MATCH, NO_MATCH
-                        } },

  #ifdef    CONFIG_ACPI_BOOT
      /*

--- linux-2.4.36/drivers/char/pc_keyb.c.orig    2008-01-01 
12:06:40.000000000 +0000
+++ linux-2.4.36/drivers/char/pc_keyb.c    2008-07-16 03:37:26.000000000 
+0000
@@ -61,14 +61,6 @@
      "\r\000/";                    /* 0x60 - 0x6f */
  #endif

-int keyboard_controller_present __initdata = 1;
-static int __init removable_keyb(char *str)
-{
-        keyboard_controller_present = 0;
-        return 0;
-}
-__setup("nokeyb", removable_keyb);
-
  static void kbd_write_command_w(int data);
  static void kbd_write_output_w(int data);
  #ifdef CONFIG_PSMOUSE
@@ -77,8 +69,9 @@
  static int aux_reconnect = 0;
  #endif

-#define kbd_controller_present() keyboard_controller_present
-
+#ifndef kbd_controller_present
+#define kbd_controller_present()    1
+#endif
  static spinlock_t kbd_controller_lock = SPIN_LOCK_UNLOCKED;
  static unsigned char handle_kbd_event(void);

@@ -905,7 +898,7 @@

  void __init pckbd_init_hw(void)
  {
-    if (!keyboard_controller_present) {
+    if (!kbd_controller_present()) {
          kbd_exists = 0;
          return;
      }


