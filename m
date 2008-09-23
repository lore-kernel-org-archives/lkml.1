Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYIWV3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYIWV3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbYIWV30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:29:26 -0400
Received: from smtp8-g19.free.fr ([212.27.42.65]:55316 "EHLO smtp8-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538AbYIWV3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:29:25 -0400
Message-ID: <48D95FB2.4050108@free.fr>
Date: Tue, 23 Sep 2008 23:29:22 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080702 Iceape/1.1.11 (Debian-1.1.11-1)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Martin Doucha <next_ghost@quick.cz>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 11603] Re: ACPI PnP on Intel MU440EX
References: <48BA9B2C.7060007@quick.cz> <200809162339.40330.bjorn.helgaas@hp.com> <200809201659.19268.bjorn.helgaas@hp.com> <200809221701.13569.bjorn.helgaas@hp.com>
In-Reply-To: <200809221701.13569.bjorn.helgaas@hp.com>
Content-Type: multipart/mixed;
 boundary="------------040701070706080304090704"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040701070706080304090704
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Bjorn Helgaas wrote:
> Your logs are perfect, which makes me happy because it's the first
> time I've successfully used the byzantine ACPI debug infrastructure.
> 
>> Log with parport set to auto/bidirectional in BIOS for comparison. PNPBIOS does
>> detect it in this setting, ACPI doesn't. Same with auto/EPP which I used until
>> now.
> 
> I think this is a BIOS defect.
> 
> When you set the port to "enabled" in the BIOS, Linux finds and uses
> the parallel port with no problem.
> 
> When you set the port to "auto/bidirectional" or "auto/EPP" in the BIOS,
> the _STA methods on all the parallel devices return 0:
> 
>      bus-0117 [00] bus_get_status        : Device [LPT] status [00000000]
>      bus-0117 [00] bus_get_status        : Device [EPP] status [00000000]
>      bus-0117 [00] bus_get_status        : Device [ECP] status [00000000]
> 
> A zero _STA means the device is not present at all, so I think Linux
> is right to ignore the devices.
> 
If you want you could try to run the attached program on your pc in 
"auto/bidirectional" or "auto/EPP" mode.

This program does what _STA methods do.


Matthieu

--------------040701070706080304090704
Content-Type: text/x-csrc;
 name="lpc.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lpc.c"

#include <sys/io.h>

#define S707 0x0370
#define INDX S707
#define DATA S707+1


int R707(int Arg0)
{
	int ret;
	outb(0x55,INDX);
	outb(0x55,INDX);
	outb(Arg0,INDX);
	ret = inb(DATA);
	outb(0xAA,INDX);
	return ret;
}
void W707(int Arg0, int Arg1)
{
	outb(0x55,INDX);
	outb(0x55,INDX);
	outb(Arg0,INDX);
	outb(Arg1, DATA);
	outb(0xAA,INDX);
}



int GSTA()
{
	int ret;
	W707 (0x07, 0x03);
	ret = R707 (0xF0);
	printf("raw %d\n", ret);
	printf("LPT %d\n", (ret & 0x7) == 0);
	printf("EPP %d\n", (ret & 0x3) == 1);
	printf("ECP %d\n", (ret & 0x2) == 2);
	return ret;
}

int main()
{
	iopl(3);
	GSTA();
	return 0;
}

--------------040701070706080304090704--
