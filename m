Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbYIOTk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbYIOTk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 15:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbYIOTkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 15:40:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:49050 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbYIOTkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 15:40:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=HXUa/O1/RHVHT6SN02zzFwTd1eXvqL7sROxSWggiXCM6RdYrlppfWAV4VDMSVS8cjr
         mrZKHklvKbzB01pZvVkR//OsylfsqAQIlP/eedS/xhft0ajQ5GSb0evuWBHGHitL7Oxi
         3EW6fKcHt2iFv21+h9cz6Ccw40o3F2YJOJcoE=
Message-ID: <48CEBAAC.8070906@tuffmail.co.uk>
Date: Mon, 15 Sep 2008 19:42:36 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>,
       acpi4asus-user@lists.sourceforge.net
Subject: Re: Turning off camera also kills card reader on EeePC 900
References: <fa.AGK4P0BJyB1JXP0f1hBx9GtBh+c@ifi.uio.no> <fa.ifmgGzvpZjuOrzmMPG9PMGHUVn4@ifi.uio.no> <fa.jeJ+IlDCDZAKTug+iVXTMjdMIyk@ifi.uio.no> <48CE78F0.9050805@yahoo.com>
In-Reply-To: <48CE78F0.9050805@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:
>
> Alan Jenkins wrote:
>> Ok.  So the platform driver settings do match those in the BIOS.  My
>> guess would be the platform driver is fine and the BIOS screws up.
>
> I was afraid you were going to say that.
>
>> The "HC died" message is interesting.  Sounds like the controller for
>> these two USB devices stops working.  Maybe try unloading and reloading
>> the ehci module?  I don't think I can help any more though.
>
> I compiled the kernel without module support so unless there's some 
> sysfs trick that can be done...
>
Well, since you ask :-P.  Here's an equivalent incantation.  I hope it's 
not too brittle.  Don't forget to unmount the SD card first.

cd /sys/module/ehci_hcd/drivers/pci:ehci_hcd
echo -n 0000:00:1d.7 | sudo tee unbind; echo -n 0000:00:1d.7 | sudo tee bind

The magic number is the PCI ID for the USB Host Controller, taken from 
your error message.

If the manual "bind" works you should then see a symlink, "0000:00:1d.7" 
in that directory.
>> - Are any BIOS upgrades available?  None of them mention this problem,
>> but the descriptions often miss out details. [1][2]
>
> For some reason I thought I had once seen an 804 BIOS but I only see 
> 802 on the EeePC 900 page (link below) and the even older 704 BIOS on 
> ftp://ftp.asus.com/pub/ASUS/EeePC/EeePC900/ .
>
>> - It might be necessary to compare with the pre-installed OS
>>  - Is the pre-installed kernel any better (files might be under
>> /proc/acpi/asus instead)?  I guess you might not have the time or
>> resources to test that though.
>
> The Xandros 2.6.21.4-eeepc install has the following files in 
> /proc/acpi/asus/
> brn camera cardr cpufv disp hdps init type wlan
>
> I have no idea what cpufv, disp, hdps, init or type are. Doing echo 1 
> > camera && echo 0 > camera under this setup does NOT disappear the SD 
> card.
Rats.  So there is some secret the mainline driver is missing :-(.
> Additionally brn seems to really represent the current LCD brightness 
> (whereas it does not on a stock kernel and seems to always be set to -19)
It might have bitrotted on stock kernels?  The newer interface is under 
/sys/class/backlight.
> and the hotkeys (e.g. for brightness) seem to respond far more quickly 
> than the stock kernel too.
Heh heh.  I know all too much about that.  It's a problem with the ACPI 
Embedded Controller driver, a hardware bug which triggered a regression 
in 2.6.25.

I'm currently running... it claims to be 2.6.27-rc4 but it might be 
2.6.27-rc5 or something in between... which includes a fix.  I'm not 
confident that they haven't broken it again since then.  The problem is 
there are just so many different types of buggy EC's.  "Fixes" for some 
buggy hardware break other buggy hardware.  Very nasty.
>>  - The source code is... a 2Gb+ rar file someone would have to download
>> and pick apart.
>
> 2.6Gbytes of multipart RAR. Joy.
>
> > [1] Asus downloads <http://eeepc.asus.com/global/download.htm>
>
> This link seems to be for the 701 only.
>
> Does anyone know if the archives on
> http://support.asus.com/download/download_item_4.aspx?product=20&model=Eee%20PC%20900/Linux&SLanguage=en-us&os=5 
> (release dates appear to be 5th September 2008) are actually any 
> different?
>
Why do you say that?  Are the filesizes suspiciously identical?

Alan
