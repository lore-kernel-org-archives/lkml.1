Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbXJ0Mwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbXJ0Mwo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 08:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbXJ0Mwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 08:52:38 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:39035 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbXJ0Mwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 08:52:36 -0400
Date: Sat, 27 Oct 2007 14:52:33 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmc_spi stopped working
Message-ID: <20071027145233.39e986e3@poseidon.drzeus.cx>
In-Reply-To: <200710241537.10566.david-b@pacbell.net>
References: <20071017211923.31fde15e@poseidon.drzeus.cx>
	<20071017193713.38D3923A5D5@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20071022200335.7c1eca12@poseidon.drzeus.cx>
	<200710241537.10566.david-b@pacbell.net>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_hera.drzeus.cx-24970-1193489518-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-24970-1193489518-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, 24 Oct 2007 15:37:10 -0700
David Brownell <david-b@pacbell.net> wrote:

> On Monday 22 October 2007, Pierre Ossman wrote:
> > 
> > I've been testing a bit more here, and I can't get this particular bug.
> 
> It's not just a bug, it's a regression ... a new bug which
> was introduced by some patch.  ;)
> 

It's a bug in the card, which is what I was referring to. ;)

> 
> SPI works fine on all the MMC and SD cards I've got here,
> other than the minor glitch fixed by the "don't just probe"
> patch I sent.
> 

Lucky you. :)

> As you know, to be spec-conformant they *must* support SPI.

I never recall which of the different specs require SPI (not all do).

> Agreed, there are too many vendors who don't appear to value
> following specs.  If those cards which are using the MMC or
> SD trade marks, you might notify the relevant consortium and
> asking them to fix those vendors.  ;)
> 

Hah! The SD and MMC boys seem to have no interest in people following the specs, considering all the shite that is out there.

> 
> > As for your card, could you send me a dump as I'm unable to produce
> > the issue here? 
> 
> I'm not sure what you mean by "dump", but appended the sysfs attributes
> produced after I disabled that new "just probe" mechanism.
> 

A dmesg with MMC_DEBUG so that I can see just how the card misbehaves.

Also, I see you're dying for my decodecid and decodecsd progs. ;)
I've included both.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

--=_hera.drzeus.cx-24970-1193489518-0001-2
Content-Type: text/x-csrc; name="crc7.c"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=crc7.c

#include "crc7.h"

#define CRC7_POLYNOMIAL 0x89 /* x^7 + x^3 + 1 */

static unsigned char crc7_syndrome_table[256];

/*
 * Generate a table of CRC-7 syndromes for x^7 * each possible input byte
 */
void
gen_crc7_syndrome_table (void)
{
  int i, j, syndrome;
  for (i = 0;  i < 256;  ++i)
    {
      syndrome = ((i & 0x80) != 0)? i ^ CRC7_POLYNOMIAL : i;
      for (j = 0;  j < 7;  ++j)
        {
          if (((syndrome <<= 1) & 0x80) != 0)
            {
              syndrome ^= CRC7_POLYNOMIAL;
            }
        }
      crc7_syndrome_table[i] = (unsigned char) syndrome;
    }
}

unsigned char
calc_crc7(unsigned long* resp)
{
	unsigned char crc7_accum = 0;
	unsigned char byte;
	int i, j;
	
	for (i = 0;i < 4;i++)
	{
		for (j = 0;j < 4;j++)
		{
			if ((i == 3) && (j == 3))
				break;
			byte = resp[i] >> (24 - 8 * j);
			crc7_accum = crc7_syndrome_table[(crc7_accum << 1) ^ byte];
		}
	}
	
	return crc7_accum;
}

--=_hera.drzeus.cx-24970-1193489518-0001-2
Content-Type: text/x-chdr; name="crc7.h"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=crc7.h

void gen_crc7_syndrome_table (void);
unsigned char calc_crc7(unsigned long* resp);

--=_hera.drzeus.cx-24970-1193489518-0001-2
Content-Type: text/x-chdr; name="decode.h"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=decode.h


#define UNSTUFF_BITS(resp,start,size)					\
	({								\
		const unsigned long __mask = (1 << (size)) - 1;			\
		const int __off = 3 - ((start) / 32);			\
		const int __shft = (start) & 31;			\
		unsigned long __res;						\
									\
		__res = resp[__off] >> __shft;				\
		if ((size) + __shft >= 32)				\
			__res |= resp[__off-1] << (32 - __shft);	\
		__res & __mask;						\
	})

--=_hera.drzeus.cx-24970-1193489518-0001-2
Content-Type: text/x-csrc; name="decodecid.c"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=decodecid.c

#include <stdlib.h>
#include <stdio.h>

#include "crc7.h"
#include "decode.h"

int main(int argc, char** argv)
{
	int i, j;
	int temp, e, m;
	char ch;
	unsigned long resp[4];
	
	if (argc != 2)
		return -1;
	
	if (strlen(argv[1]) != 8 * 4)
		return -1;
	
	for (i = 0;i < 4;i++)
	{
		resp[i] = 0;
		for (j = 0;j < 8;j++)
		{
			resp[i] <<= 4;
			ch = tolower(argv[1][i * 8 + j]);
			if (isdigit(ch))
				resp[i] |= ch - '0';
			else if (isxdigit(ch))
				resp[i] |= ch - 'a' + 0xA;
			else
				return -1;
		}
	}

	printf("Manufacturer ID: %d\n", UNSTUFF_BITS(resp, 120, 8));
	printf("OEM/Application ID: %d\n", UNSTUFF_BITS(resp, 104, 16));
	
	printf("Product name: %c%c%c%c%c%c\n",
		(char)UNSTUFF_BITS(resp, 96, 8),
		(char)UNSTUFF_BITS(resp, 88, 8),
		(char)UNSTUFF_BITS(resp, 80, 8),
		(char)UNSTUFF_BITS(resp, 72, 8),
		(char)UNSTUFF_BITS(resp, 64, 8),
		(char)UNSTUFF_BITS(resp, 56, 8));

	printf("Product revision: %d:%d\n",
		UNSTUFF_BITS(resp, 52, 4),
		UNSTUFF_BITS(resp, 48, 4));

	printf("Serial: %08x\n", UNSTUFF_BITS(resp, 16, 32));

	printf("Manufacturing date: %d/%d\n",
		UNSTUFF_BITS(resp, 12, 4) + 1997,
		UNSTUFF_BITS(resp, 8, 4));
	
	gen_crc7_syndrome_table();
	printf("CRC: ");
	if (UNSTUFF_BITS(resp, 1, 7) == calc_crc7(resp))
		printf("OK");
	else
		printf("Fail");
	printf("\n");

	return 0;
}

--=_hera.drzeus.cx-24970-1193489518-0001-2
Content-Type: text/x-csrc; name="decodecsd.c"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=decodecsd.c

#include <stdlib.h>
#include <stdio.h>

#include "crc7.h"
#include "decode.h"

static const unsigned int tran_exp[] = {
	10000,		100000,		1000000,	10000000,
	0,		0,		0,		0
};

static const unsigned char tran_mant[] = {
	0,	10,	12,	13,	15,	20,	25,	30,
	35,	40,	45,	50,	55,	60,	70,	80,
};

static const unsigned int tacc_exp[] = {
	1,	10,	100,	1000,	10000,	100000,	1000000, 10000000,
};

static const unsigned int tacc_mant[] = {
	0,	10,	12,	13,	15,	20,	25,	30,
	35,	40,	45,	50,	55,	60,	70,	80,
};

static const unsigned int min_cur[] = {
	5,	10,	50,	100,	250,	350,	600,	1000,
};

static const unsigned int max_cur[] = {
	10,	50,	100,	250,	350,	450,	800,	2000,
};

int main(int argc, char** argv)
{
	int i, j;
	int temp, e, m;
	char ch;
	unsigned long resp[4];

	if (argc != 2)
		return -1;

	if (strlen(argv[1]) != 8 * 4)
		return -1;

	for (i = 0;i < 4;i++)
	{
		resp[i] = 0;
		for (j = 0;j < 8;j++)
		{
			resp[i] <<= 4;
			ch = tolower(argv[1][i * 8 + j]);
			if (isdigit(ch))
				resp[i] |= ch - '0';
			else if (isxdigit(ch))
				resp[i] |= ch - 'a' + 0xA;
			else
				return -1;
		}
	}

	printf("CSD Version: ");
	temp = UNSTUFF_BITS(resp, 126, 2);
	switch (temp)
	{
	case 0:
		printf("v1.0");
		break;
	case 1:
		printf("v1.1");
		break;
	case 2:
		printf("v1.2");
		break;
	default:
		printf("Unknown [%d]", temp);
	}
	printf("\n");

	printf("MMCA Version: ");
	temp = UNSTUFF_BITS(resp, 122, 4);
	switch (temp)
	{
	case 0:
		printf("v1.0 to v1.2");
		break;
	case 1:
		printf("v1.4");
		break;
	case 2:
		printf("v2.0 to v2.2");
		break;
	case 3:
		printf("v3.1 to v3.3");
		break;
	default:
		printf("Unknown [%d]", temp);
	}
	printf("\n");

	m = UNSTUFF_BITS(resp, 115, 4);
	e = UNSTUFF_BITS(resp, 112, 3);
	printf("TACC: %d ns\n", (tacc_exp[e] * tacc_mant[m] + 9) / 10);
	printf("NSAC: %d clks\n", UNSTUFF_BITS(resp, 104, 8) * 100);

	m = UNSTUFF_BITS(resp, 99, 4);
	e = UNSTUFF_BITS(resp, 96, 3);
	printf("Max rate: %d kHz\n", tran_exp[e] * tran_mant[m] / 1000);

	printf("Command classes: ");
	temp = UNSTUFF_BITS(resp, 84, 12);
	for (i = 0;i < 12;i++)
	{
		if (temp & (1 << i))
		{
			switch (i)
			{
			case 0:
				printf("basic, ");
				break;
			case 1:
				printf("stream read, ");
				break;
			case 2:
				printf("block read, ");
				break;
			case 3:
				printf("stream write, ");
				break;
			case 4:
				printf("block write, ");
				break;
			case 5:
				printf("erase, ");
				break;
			case 6:
				printf("write prot., ");
				break;
			case 7:
				printf("lock, ");
				break;
			case 8:
				printf("app. specific, ");
				break;
			case 9:
				printf("I/O mode, ");
				break;
			default:
				printf("class %d, ", i);
			}
		}
	}
	printf("\n");

	temp = 1 << UNSTUFF_BITS(resp, 80, 4);
	printf("Read block size: %d bytes\n", temp);

	temp = 1 << UNSTUFF_BITS(resp, 22, 4);
	printf("Write block size: %d bytes\n", temp);

	printf("Partial read: ");
	if (UNSTUFF_BITS(resp, 79, 1))
		printf("Yes");
	else
		printf("No");
	printf("\n");

	printf("Partial write: ");
	if (UNSTUFF_BITS(resp, 21, 1))
		printf("Yes");
	else
		printf("No");
	printf("\n");

	printf("Read misalign: ");
	if (UNSTUFF_BITS(resp, 77, 1))
		printf("Yes");
	else
		printf("No");
	printf("\n");

	printf("Write misalign: ");
	if (UNSTUFF_BITS(resp, 78, 1))
		printf("Yes");
	else
		printf("No");
	printf("\n");

	printf("DSR: ");
	if (UNSTUFF_BITS(resp, 76, 1))
		printf("Yes");
	else
		printf("No");
	printf("\n");

	e = UNSTUFF_BITS(resp, 47, 3);
	m = UNSTUFF_BITS(resp, 62, 12);
	printf("Capacity: %d blocks %d %d\n", ((1 + m) << (e + 2)), m, e);

	printf("Min read current: %0.1f mA\n",
		(float)min_cur[UNSTUFF_BITS(resp, 59, 3)]/10);
	printf("Max read current: %0.1f mA\n",
		(float)max_cur[UNSTUFF_BITS(resp, 56, 3)]/10);

	printf("Min write current: %0.1f mA\n",
		(float)min_cur[UNSTUFF_BITS(resp, 53, 3)]/10);
	printf("Max write current: %0.1f mA\n",
		(float)max_cur[UNSTUFF_BITS(resp, 50, 3)]/10);

	m = UNSTUFF_BITS(resp, 42, 5);
	e = UNSTUFF_BITS(resp, 37, 5);
	printf("Erase group size: %d blocks\n", (m+1) * (e+1));

	printf("WP group size: %d erase group(s)\n", UNSTUFF_BITS(resp, 32, 5));

	printf("WP enable: ");
	if (UNSTUFF_BITS(resp, 31, 1))
		printf("Yes");
	else
		printf("No");
	printf("\n");

	printf("R2W factor: %d\n", UNSTUFF_BITS(resp, 26, 3));

	printf("Content protect: ");
	if (UNSTUFF_BITS(resp, 16, 1))
		printf("Yes");
	else
		printf("No");
	printf("\n");

	printf("File format: ");
	if (UNSTUFF_BITS(resp, 15, 1))
		printf("Reserved");
	else
	{
		switch (UNSTUFF_BITS(resp, 10, 2))
		{
		case 0:
			printf("Hard disk");
			break;
		case 1:
			printf("Floppy");
			break;
		case 2:
			printf("Universal");
			break;
		case 3:
			printf("Unknown");
			break;
		}
	}
	printf("\n");

	printf("Copy: ");
	if (UNSTUFF_BITS(resp, 14, 1))
		printf("Yes");
	else
		printf("No");
	printf("\n");

	printf("Perm write protect: ");
	if (UNSTUFF_BITS(resp, 13, 1))
		printf("Yes");
	else
		printf("No");
	printf("\n");

	printf("Tmp write protect: ");
	if (UNSTUFF_BITS(resp, 12, 1))
		printf("Yes");
	else
		printf("No");
	printf("\n");

	printf("ECC: ");
	switch (UNSTUFF_BITS(resp, 8, 2))
	{
	case 0:
		printf("none");
		break;
	case 1:
		printf("BCH(512,512)");
		break;
	default:
		printf("Reserved");
	}
	printf("\n");

	gen_crc7_syndrome_table();
	printf("CRC: ");
	if (UNSTUFF_BITS(resp, 1, 7) == calc_crc7(resp))
		printf("OK");
	else
		printf("Fail");
	printf("\n");

	return 0;
}

--=_hera.drzeus.cx-24970-1193489518-0001-2
Content-Type: application/octet-stream; name=Makefile
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=Makefile

YWxsOiBkZWNvZGVjc2QgZGVjb2RlY2lkCgpkZWNvZGVjc2Q6IGNyYzcubyBjcmM3LmggZGVjb2Rl
LmgKZGVjb2RlY2lkOiBjcmM3Lm8gY3JjNy5oIGRlY29kZS5oCgpjcmM3Lm86IGNyYzcuYyBjcmM3
LmgK

--=_hera.drzeus.cx-24970-1193489518-0001-2--
