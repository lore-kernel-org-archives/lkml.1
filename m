Return-Path: <linux-kernel-owner+w=401wt.eu-S1759390AbZFXOOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390AbZFXOOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZFXOOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:14:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61057 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZFXOOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:14:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] add checksum selftest
Date: Wed, 24 Jun 2009 16:14:02 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1245850289-6673-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1245850289-6673-1-git-send-email-vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906241614.02615.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19wRyoDTJbpww5k2l7zBqhndk10zzbLnYFob97
 1MizPAQSdCYYzRBpG0hmwNNuhAgzcZT3BC8KQ4m94tDlg+gqB8
 PJQAmWKttvIHPiKFBdYrw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009, Mike Frysinger wrote:
> Start a checksum internal testsuite for arch porters and people mucking
> about in the checksum code -- regressions are bad.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> Arnd: i've tested this on my Blackfin and it seems to work ... can you
> check for any places i missed little endian swapping ?

Endian swapping looks correct, and I like the patch a lot in general,
but:

> +
> +/*
> + * The do_csum() interface is "internal" to the generic checksum code.
> + * Do not require it if the arch has not switched over.
> + */
> +extern unsigned short do_csum(const unsigned char *buff, int len);

Just nitpicking: this prototype should to into asm-generic/checksum.h,
extern declarations have no place in .c files.

> +static unsigned char __initdata do_csum_data1[] = {
> +	0x20,
> +};
> +static unsigned char __initdata do_csum_data2[] = {
> +	0x0d, 0x0a,
> +};
> +static unsigned char __initdata do_csum_data3[] = {
> +	0xff, 0xfb, 0x01,
> +};

You define separate test vectors for each of the three
cases, which looks like it could be optimized by reusing
the same test vectors for each case.

> +static struct csum_partial_data __initdata csum_partial_data[] = {
> +	CSUM_PARTIAL_DATA(1,  0x00000074, 0x0),
> +	CSUM_PARTIAL_DATA(2,  0x00000a0d, 0x0),
> +	CSUM_PARTIAL_DATA(3,  0x0000fe00, 0x0),
> +	CSUM_PARTIAL_DATA(5,  0x00005084, 0x0),
> +	CSUM_PARTIAL_DATA(8,  0x1101eefe, 0x11016a80),
> +	CSUM_PARTIAL_DATA(8b, 0x00008781, 0x847e),
> +	CSUM_PARTIAL_DATA(9,  0x1101eefe, 0x11016b80),
> +};

For partial checksums, the result has to be folded into a 16-bit
number using csum_fold(), because csum_partial and other functions
return a 32-bit __wsum that can take many equivalent values taht
are all correct.

> +static int __init csum_tcpudp_nofold_selftest(void)
> +{
> +	int i, ret;
> +	unsigned short tret, eret;
> +
> +	ret = 0;
> +	for (i = 0; i < ARRAY_SIZE(csum_tcpudp_nofold_data); ++i) {
> +		eret = le16_to_cpu(csum_tcpudp_nofold_data[i].ret);
> +		tret = csum_tcpudp_nofold(
> +			csum_tcpudp_nofold_data[i].saddr,
> +			csum_tcpudp_nofold_data[i].daddr,
> +			csum_tcpudp_nofold_data[i].len,
> +			csum_tcpudp_nofold_data[i].proto,
> +			csum_tcpudp_nofold_data[i].sum);
> +		if (tret != eret) {
> +			pr_err("%s: test %i: %#x != %#x: FAIL\n",
> +				__func__, i, tret, eret);
> +			ret = 1;
> +		}
> +	}
> +
> +	return ret;
> +}

same here, but you can easily use csum_tcpudp_magic() instead of
csum_tcpudp_nofold here.

Thanks,

	Arnd <><
