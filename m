Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044Ab0AUArr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab0AUArr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 19:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077Ab0AUArq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 19:47:46 -0500
Received: from mail-iw0-f196.google.com ([209.85.223.196]:55980 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab0AUArp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 19:47:45 -0500
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jan 2010 19:47:45 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Mibz9TDXnVtgE3BxKOL8rFFV6cVbHiWm50tgFX6+6ImXtKyEYY0djs3prBxkr+vSQW
         f/E7X27nQS3HHYYWgH6DEgwxUp6OP8d1IjA0aOwk7YdHcNGJZYgmnLuTtvGG7xFy3sz3
         sWsEur6a0AesIJfqJn4gDOoyH5nxMZqPAaNmI=
Message-ID: <4B57A2D4.9030204@gmail.com>
Date: Wed, 20 Jan 2010 18:41:56 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Bastien Nocera <hadess@hadess.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
References: <1264011793.1735.3683.camel@localhost.localdomain>
In-Reply-To: <1264011793.1735.3683.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 12:23 PM, Bastien Nocera wrote:
> As those computers never had any i8042 controllers, and the
> current lookup code could potentially lock up/hang/wait for
> timeout for long periods of time.
>
> Fixes intermittent hangs on boot on a MacbookAir1,1
>
> Signed-off-by: Bastien Nocera<hadess@hadess.net>

I assume this is happening because of this code in 
drivers/input/serio/i8042-x86ia64io.h:

         if (!i8042_pnp_kbd_devices && !i8042_pnp_aux_devices) {
                 i8042_pnp_exit();
#if defined(__ia64__)
                 return -ENODEV;
#else
                 printk(KERN_INFO "PNP: No PS/2 controller found. 
Probing ports directly.\n");
                 return 0;
#endif

In other words, on x86, if PNP and/or ACPI don't indicate any PS/2 
controller exists, we randomly bang on the ports in the expectation 
they'll be there anyway. This seems rather misguided. It would seem like 
a better idea to fix this rather than adding yet another DMI list 
(especially since there likely are, or will be, machines without i8042 
other than Macs).

I can see continuing on and probing if PNP isn't present on the machine, 
but certainly if ACPI is enabled, I don't think we should be doing such 
things.
