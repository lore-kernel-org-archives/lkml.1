Return-Path: <linux-kernel-owner+w=401wt.eu-S935278AbYBAFBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935278AbYBAFBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935503AbYBAEx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:53:27 -0500
Received: from science.horizon.com ([192.35.100.1]:16768 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935500AbYBAExY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:53:24 -0500
Message-ID: <20080201045320.11859.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Thu, 31 Jan 2008 23:53:20 -0500
To: hpa@zytor.com, ijc@hellion.org.uk
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com
Subject: There are smaller ways to encode a CRC32 table...
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code to fill it in is smaller than the table itself.
Is it worth complicating things with some INIT code to reduce
the stored image size?  (The table is not compressible.)

#define CRC32POLY	0xedb88320	/* CRC32 polynomial, little-endian */

static uint32_t crctab32[256];

void
crc32init(void)
{
	unsigned i, j;
	uint32_t crc = 1;

	crctab32[0] = 0;

	for (i = 128; i; i >>= 1) {
		crc = (crc >> 1) ^ ((crc & 1) ? CRC32POLY : 0);
		for (j = 0; j < 256; j += 2*i)
			crctab32[i+j] = crc ^ crctab32[j];
	}
}

The above code basically computes the CRCs of the bytes 0x80, 0x40, ... 0x01,
and applies the identity crctab32[i^j] = crctab32[i] ^ crctab32[j].

And BTW, storing the inverse of the CRC only catches trailing (after the CRC)
all-zero padding.  If this is not a problem, it's not necessary, although you
still might want to do it just for consistency.  This inversion changes the
CRC of the entire image (body + CRC) from all-zero to a fixed non-zero value.
(To be precise, to the (non-inverted) CRC of 0xffffffff.)
