Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbZBFKo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbZBFKo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 05:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZBFKoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 05:44:20 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:36718 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbZBFKoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 05:44:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K8rHUWS/DJkiPN4ZDPG+3iXOHVzSczTayEoKNV41NcOW5dz5ZpB39ph1wVHM0S1f+q
         tfiDKB/cf2WExFo6dgSz7Le7IZjsx85RSckgile20sDX0HoCy0zPGRHokPW3itQmM5DG
         VDmn9xvAqyvluWaUiGBL+5LqVCzarmi0U5+z0=
MIME-Version: 1.0
In-Reply-To: <498B797C.4060202@gmail.com>
References: <56e1b5710902050641l5ece10e5hedd11fb3f4292886@mail.gmail.com>
	 <adak584jzw3.fsf@cisco.com> <498B797C.4060202@gmail.com>
Date: Fri, 6 Feb 2009 11:36:02 +0100
Message-ID: <56e1b5710902060236l549c0f21v38db9ab236b88505@mail.gmail.com>
Subject: Re: [PATCH]: Cleanup: Remove gcc format string warnings when 
	compiling with -Wformat-security
From: Floris Kraak <randakar@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, Sam Ravnborg <sam@ravnborg.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andreas Schwab <schwab@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 6, 2009 at 12:42 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> Roland Dreier wrote:
>>
>>  > Here's the patch that I get when I blindly patch every single location
>>  > that emits this warning.
>>
>> I would strongly prefer to do this with a little more care.  For example
>> the b43/main.c change:
>>
>>  > --- a/drivers/net/wireless/b43/main.c
>>  > +++ b/drivers/net/wireless/b43/main.c
>>  > @@ -2005,9 +2005,9 @@ static void b43_print_fw_helptext(struct b43_wl
>>  > *wl, bool error)
>>  >
>> "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
>>  >             "and download the latest firmware (version 4).\n";
>>  >      if (error)
>>  > -            b43err(wl, text);
>>  > +            b43err(wl, "%s", text);
>>  >      else
>>  > -            b43warn(wl, text);
>>  > +            b43warn(wl, "%s", text);
>>  >  }
>> would probably be better solved by doing
>>
>> --- a/drivers/net/wireless/b43/main.c
>> +++ b/drivers/net/wireless/b43/main.c
>> @@ -1999,11 +1999,11 @@ static void b43_release_firmware(struct b43_wldev
>> *dev)
>>   static void b43_print_fw_helptext(struct b43_wl *wl, bool error)
>>  {
>> -       const char *text;
>> +       static const char text[] =
>> +               "You must go to "
>> +
>> "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
>> +               "and download the latest firmware (version 4).\n";
>>  -       text = "You must go to "
>> -
>>  "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
>> -              "and download the latest firmware (version 4).\n";
>>        if (error)
>>                b43err(wl, text);
>>        else
>

Applied this to my tree.

> "const char* const" text would likely work as well..
>>
>> and in any case I'm not totally convinced that we want to add the bloat
>> for trivial cases like
>>
>>        char *safe = "foo";
>>        printk(safe);
>
> Well, in that case, printk("foo") would be the obvious solution :-)
>

Neither of that works for __initdata sections though.
Take for instance the patch below. Yes, it gets rid of the warning
without using %s .. but we lose the __initdata attribute.
I've tried using __initconst instead - but that doesn't remove the
warning either.

Signed-off-by: Floris Kraak <randakar@gmail.com>
---
diff --git a/drivers/char/hw_random/intel-rng.c
b/drivers/char/hw_random/intel-rng.c
index 5dcbe60..aa84183 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -304,15 +304,15 @@ static int __init intel_init_hw_struct(struct
intel_rng_hw *intel_rng_hw,
 	if ((intel_rng_hw->bios_cntl_val &
 	     (BIOS_CNTL_LOCK_ENABLE_MASK|BIOS_CNTL_WRITE_ENABLE_MASK))
 	    == BIOS_CNTL_LOCK_ENABLE_MASK) {
-		static __initdata /*const*/ char warning[] =
+
+		if (no_fwh_detect)
+			return -ENODEV;
+		printk(
 			KERN_WARNING PFX "Firmware space is locked read-only. If you can't or\n"
 			KERN_WARNING PFX "don't want to disable this in firmware setup, and if\n"
 			KERN_WARNING PFX "you are certain that your system has a functional\n"
-			KERN_WARNING PFX "RNG, try using the 'no_fwh_detect' option.\n";
+			KERN_WARNING PFX "RNG, try using the 'no_fwh_detect' option.\n");

-		if (no_fwh_detect)
-			return -ENODEV;
-		printk(warning);
 		return -EBUSY;
 	}
---
Regards,
Floris
---
"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."
  -- Ben Franklin

"The course of history shows that as a government grows, liberty
decreases."
  -- Thomas Jefferson
