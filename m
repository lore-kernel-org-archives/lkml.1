Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbXJ3RqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbXJ3RqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757147AbXJ3RqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:46:05 -0400
Received: from smtp121.iad.emailsrvr.com ([207.97.245.121]:37471 "EHLO
	smtp121.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916AbXJ3RqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:46:03 -0400
Message-ID: <47276DCA.1000808@gentoo.org>
Date: Tue, 30 Oct 2007 17:45:46 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070805)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org> <20071030153417.59b9182c@the-village.bc.nu>
In-Reply-To: <20071030153417.59b9182c@the-village.bc.nu>
Content-Type: multipart/mixed;
 boundary="------------010809090001080805050404"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010809090001080805050404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Alan Cox wrote:
> Not immediately - but if you've got wrong transfer lengths its a
> candidate for this.
> 
> Ok lets start with the basics
> 
> If you mount a CD and use it does it work

Yep.

> If you use cdrecord does it work ?

Yep (tested with wodim from debburn, effectively the same thing)

> What vendor drive and does it seem to be a specific box/drive that
> triggers this ?

Device type    : Removable CD-ROM
Version        : 5
Response Format: 2
Capabilities   :
Vendor_info    : 'PHILIPS '
Identification : 'DVD+-RW SDVD8820'
Revision       : 'AD15'
Device seems to be: Generic mmc2 DVD-R/DVD-RW.
Using generic SCSI-3/mmc   CD-R/CD-RW driver (mmc_cdr).
Driver flags   : MMC-3 SWABAUDIO BURNFREE
Supported modes: TAO PACKET SAO SAO/R96P SAO/R96R RAW/R16 RAW/R96P RAW/R96R

This is on my laptop (Dell Inspiron 640m). I won't have access to 
another system to test this there until next week.

The nutty app I was using for burning is Brasero, a GNOME app which does 
some SG_IO directly with the drive. (I guess it has some bad error 
handling and doesn't realise when some I/O path has failed)

I have narrowed down the exact command submission which causes those 
nasty messages in dmesg. The function which submits this is named 
"brasero_medium_get_page_2A_write_speed_desc".

The test program that I've attached can now reproduce this error every 
time it is run. The output is:

	result 0
	check sense data:
	72 0b 47 00 00 00 00 0e 09 0c 00 00 00 02 00 00 00 0a 00

I get the same output and dmesg errors even when there is no media in 
the drive.

I have had a quick look at the SCSI command being submitted there, and 
don't see anything wrong.

What next?

Daniel

--------------010809090001080805050404
Content-Type: text/plain;
 name="testsg.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="testsg.c"

#include <stdio.h>
#include <scsi/sg.h>
#include <scsi/scsi.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(void)
{
	struct sg_io_hdr transport;
	unsigned char cmd[] = {
		0x5a, //opcode -- mode sense(10)
		0x08, //dbd, llbaa -- dbd=1
		0x2a, //page code -- BRASERO_SPC_PAGE_STATUS
		      // spc-3 says thats "CD capabilities and mechanical status"
			  //
		0x00, //brasero says reserved, spc3 says subpage code
		0x00, //reserved
		0x00, //reserved
		0x00, //alloc len
		0x0a, //alloc len
		0x00, //ctl
	};
	unsigned char buffer[10];
	unsigned char sense_data[19];
	int r;
	int i;
	int fd = open("/dev/sr0", O_RDONLY|O_NONBLOCK);
	if (fd < 0) {
		printf("open failed\n");
		exit(1);
	}

	memset(&transport, 0, sizeof(transport));
	memset(buffer, 0, sizeof(buffer));
	memset(sense_data, 0, sizeof(sense_data));

	transport.interface_id = 'S';
	transport.cmdp = cmd;
	transport.cmd_len = sizeof(cmd);
	transport.dxferp = buffer;
	transport.dxfer_len = sizeof(buffer);
	transport.sbp = sense_data;
	transport.mx_sb_len = sizeof(sense_data);
	transport.dxfer_direction = SG_DXFER_FROM_DEV;

	r = ioctl(fd, SG_IO, &transport);
	printf("result %d\n", r);
	if ((transport.masked_status & CHECK_CONDITION) && transport.sb_len_wr) {
		printf("check sense data:\n");
		for (i = 0; i < sizeof(sense_data); i++)
			printf("%02x ", sense_data[i]);
		printf("\n");
	}
}

--------------010809090001080805050404--
