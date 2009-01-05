Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbZAELNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbZAELNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZAELMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:12:55 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:14042 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224AbZAELMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:12:54 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: Martin Schlemmer <Martin.Schlemmer@nwu.ac.za>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081223233410.GC6800@1wt.eu>
References: <49518245.3D93.006F.0@nwu.ac.za>  <20081223233410.GC6800@1wt.eu>
Content-Type: multipart/mixed; boundary="=-ruxvFHC0Vpyb8teFf43C"
Date: Mon, 05 Jan 2009 11:12:26 +0000
Message-Id: <1231153946.2648.49.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: Initramfs from existing vmlinuz
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=JzYRftmhNVArE4dJWhEA:9 a=5p7GOEtU2AEPwkFJWksTjvDPREwA:4 a=LY0hPdMaydYA:10 a=vU3ZCsmD3HzqK0PmRqoA:9 a=sg4XIRERkpBIakddMVUA:7 a=gvrDkPZrpfN3sezxVBB97HXPv2cA:4 a=Hh7NdPsCZosA:10 a=53bxwKahnOWAc7qk:21 a=D7jeBYeJ16ODGM_h:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ruxvFHC0Vpyb8teFf43C
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2008-12-24 at 00:34 +0100, Willy Tarreau wrote:
> You first have to extract and uncompress the ELF image from vmlinuz.
> For this, look for the gzip signature 1F 8B 08 in your vmlinuz, and
> feed all data starting from this point to zcat.

Since v2.6.26 (I think, it was v2.08 of the x86 bzImage format anyhow,
which was the same point the payload became ELF formatted) you can find
it directly using the payload_offset and payload_length fields in the
bzImage header. Attached bzexplode.c demonstrates this. e.g. "bzexplode
vmlinuz | zcat > vmlinux.elf"

Ian.

-- 
Ian Campbell
Current Noise: Electric Wizard - Saturn's Children

A likely impossibility is always preferable to an unconvincing possibility.
		-- Aristotle

--=-ruxvFHC0Vpyb8teFf43C
Content-Disposition: attachment; filename=bzexplode.c
Content-Type: text/x-csrc; name=bzexplode.c; charset=utf-8
Content-Transfer-Encoding: 7bit

#include <stdio.h>
#include <fcntl.h>
#include <stdint.h>
#include <unistd.h>

#include <inttypes.h>

#include <err.h>

#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>

int main(int argc, char **argv)
{
	int fd;
	struct stat sb;
	void *p;
	uint8_t *hdr;
	int setup_sectors;
	uint32_t compressed_payload_offset;
	uint32_t compressed_payload_length;

	if (argc != 2)
		errx(1, "usage: bzexplode <bzImage>");

	fd = open(argv[1], O_RDONLY);
	if (fd < 0)
		err(1, "open");

	if (fstat(fd, &sb) < 0)
		err(1, "fstat");

	p = mmap(0, sb.st_size, PROT_READ, MAP_SHARED, fd, 0);
	if (p == MAP_FAILED)
		err(1, "mmap");

	hdr = p;
	setup_sectors = hdr[0x1f1];
	compressed_payload_offset = *(uint32_t*)&hdr[0x248];

	fprintf(stderr, "setup sectors %d\n", setup_sectors);

	compressed_payload_offset += (setup_sectors+1) * 512;

	//compressed_payload_length = *(uint32_t*)(p + compressed_payload_offset - 4);
	compressed_payload_length = *(uint32_t*)&hdr[0x24c];

	fprintf(stderr, "compressed_payload_offset %"PRIx32" (abs)\n",
		compressed_payload_offset);
	fprintf(stderr, "compressed_payload_length %"PRIx32"\n",
		compressed_payload_length);

	write(1,
	      p + compressed_payload_offset,
	      compressed_payload_length);
	return 0;
}

--=-ruxvFHC0Vpyb8teFf43C--

