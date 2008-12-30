Return-Path: <linux-kernel-owner+w=401wt.eu-S1751987AbYL3GEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbYL3GEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 01:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbYL3GEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 01:04:33 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:7708 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYL3GEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 01:04:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=abJ53EUDdbN4P8HBNmjAgSLsmyJMOoZfz1SxVtBkx0QQCErZsI+mBfTf1ifyy44Bdz
         hWvLQ+c8adLpamJoKoN95T7l4RScsTYowVatfGGrfvig4bv+JOa+0Ycx7KGGl07KSqpK
         IlJhbbCD1edxWKsQwz+l8Vg9OpakIjubTrLUw=
Message-ID: <4959B9B7.2050800@gmail.com>
Date: Tue, 30 Dec 2008 11:03:35 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ru-RU; rv:1.8.1.19) Gecko/20081226 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Arjan Opmeer <arjan@opmeer.net>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: 2.6.28 thinks that my PS/2 mouse is a touchpad
References: <gj4r8h$okm$1@ger.gmane.org> <20081229185619.GA18394@adopmeer.homeip.net>
In-Reply-To: <20081229185619.GA18394@adopmeer.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan Opmeer wrote:
> On Sat, Dec 27, 2008 at 02:06:29PM +0500, Alexander E. Patrakov wrote:
>> elantech.c: Elantech version query result 0x00, 0x01, 0x64.
>> elantech.c: assuming hardware version 1, firmware version 0.100
>> elantech.c: Synaptics capabilities query result 0x00, 0x02, 0x64.
> 
> However, all version query results I have seen from Elantech touchpads have
> a non-zero first byte and a zero second byte. So we could test for that to
> prevent this mouse from being detected as a touchpad.
> 
> Dmitry, do you think something like this is sufficient?
> 
> --- elantech.c.ORIG	2008-12-29 19:35:01.000000000 +0100
> +++ elantech.c.NEW	2008-12-29 19:38:59.000000000 +0100
> @@ -618,6 +618,10 @@ int elantech_init(struct psmouse *psmous
>  	}
>  	pr_info("elantech.c: Elantech version query result 0x%02x, 0x%02x, 0x%02x.\n",
>  		param[0], param[1], param[2]);
> +	if (param[0] == 0 || param[1] != 0) {
> +		pr_info("elantech.c: Probably not a real Elantech touchpad. Aborting.\n");
> +		goto init_fail;
> +	}
>  	etd->fw_version_maj = param[0];
>  	etd->fw_version_min = param[2];

This is still slightly wrong. The mouse does work, but is misnamed in 
the dmesg output and in /proc/bus/input/devices:

psmouse serio1: ID: 10 00 64<6>elantech.c: Elantech version query result 
0x00, 0x01, 0x64.
elantech.c: Probably not a real Elantech touchpad. Aborting.
input: ImExPS/2 Elantech Touchpad as /class/input/input8

I: Bus=0011 Vendor=0002 Product=0006 Version=0000
N: Name="ImExPS/2 Elantech Touchpad"
P: Phys=isa0060/serio1/input0
S: Sysfs=/class/input/input8
U: Uniq=
H: Handlers=mouse1 event6
B: EV=7
B: KEY=1f0000 0 0 0 0 0 0 0 0
B: REL=143

-- 
Alexander E. Patrakov
