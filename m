Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbXC3Q1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbXC3Q1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 12:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbXC3Q1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 12:27:30 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48163 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbXC3Q13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 12:27:29 -0400
Date: Fri, 30 Mar 2007 09:26:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tasos Parisinos <t.parisinos@sciensis.com>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: RSA algorithm patch (kernel version
 2.6.21-rc5-git6)
Message-Id: <20070330092637.c931440f.randy.dunlap@oracle.com>
In-Reply-To: <460D100C.9090102@sciensis.com>
References: <460D100C.9090102@sciensis.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 16:26:36 +0300 Tasos Parisinos wrote:

Hi,

Just a few whitespace nits that you can fix with any other
comments that you get...

> +static char rsa_op_compare(rsa_op *l, rsa_op *r)
> +{
> +	int i;
> +	u32 *lbuf, *rbuf;
> +
> +	/* Compare the two operands based on sign */
> +	if (l->sign != r->sign)
> +		return (l->sign)? -1: 1;

                                  -1 : 1;

> +	/* Compare the two operands based on their size */
> +	if (l->size > r->size && rsa_op_clz(l) < (l->size - r->size) * 32)
> +		return 1;
> +	else if (r->size > l->size && rsa_op_clz(r) < (r->size - l->size) * 32)
> +		return -1;
> +
> +	/* Compare the two operands based on their hex values */
> +	lbuf = l->data;
> +	rbuf = r->data;
> +	for (i = min(l->size, r->size) - 1; i >= 0; i--)
> +		if (lbuf[i] > rbuf[i])
> +			return 1;
> +		else if (lbuf[i] < rbuf[i])
> +			return -1;
> +	return 0;
> +}
> +
> +static int rsa_op_shift(rsa_op **n, int bits)
> +{
> +	int i, distance, size, lz, retval;
> +	u32 *buf;
> +	rsa_op *handle;
> +
> +	if (!bits)
> +		return 0;
> +	handle = *n;
> +
> +	/* Shifting to the right, no resize needed */
> +	if (bits > 0) {
> +		/* Drop off one limb for each 32 bit shift */
> +		distance = bits / 32;
> +		size = handle->size;
> +		buf = handle->data;
> +		for (i = 0; i < size; i++)
> +			buf[i] = (i + distance >= size)? 0: buf[i + distance];

                                                         0 :

> +
> +		/* Shift the remaining 'bits' mod 32 */
> +		bits = bits % 32;
> +		if (bits) {
> +			size -= distance;
> +			distance = 32 - bits;
> +			for (i = 0; i < size; i++) {
> +				buf[i] = buf[i] >> bits;
> +				if (i < size - 1)
> +					buf[i] |=  buf[i + 1] << distance;
> +			}
> +		}
> +
> +		rsa_op_canonicalize(handle);
> +		return 0;
> +	}
> +
> +	bits = -bits;
> +	lz = rsa_op_clz(handle) + (handle->limbs - handle->size) * 32;
> +
> +	/*
> +	 * Shifting to the left.
> +	 * Reallocation is needed when the leading zeroes are less than
> +	 * the shift distance
> +	 */
> +	if (lz < bits) {
> +		/* Compute the size of the reallocation */
> +		size = (bits - lz + 31) / 32;
> +		retval = rsa_op_resize(n, handle->limbs + size);
> +		if (retval < 0)
> +			return retval;
> +		handle = *n;
> +	}
> +	else
> +		handle->size += ((bits - rsa_op_clz(handle) + 31) / 32);
> +
> +	buf = handle->data;
> +	distance = bits / 32;
> +	/* Shift data 1 byte to the left for each 32 bit shift */
> +	if (distance) {
> +		/* Shift bytes */
> +		for (i = handle->size - distance - 1; i >= 0; i--)
> +			buf[i + distance] = buf[i];
> +
> +		/* Zero the shifted in bytes */
> +		memset(handle->data, 0, distance * sizeof(u32));
> +	}
> +
> +	/* Shift the remaining 'bits' mod 32 */
> +	bits = bits % 32;
> +	distance = 32 - bits;
> +	if (bits)
> +		for (i = handle->size - 1; i >= 0; i--) {
> +			buf[i] = buf[i] << bits;
> +			if (i > 0)
> +				buf[i] |= (buf[i - 1] >> distance);
> +		}
> +
> +	return 0;
> +}
> +
> +
> +
> +
> +
> +
> +
> +/**
> +/**
> + * rsa_op_print - print the value of an rsa_op
> + * @n: pointer to the rsa_op to be printed
> + * @how: true to print canonicalized
> + */
> +void rsa_op_print(rsa_op *n, bool how)
> +{
> +	int i, j;
> +	u32 limb;
> +	u8 byte;
> +	bool started = false;
> +
> +	printk("Operand @ 0x%x, %d limbs in size, %d limbs allocated, value = ",
> +	       (u32)n, n->size, n->limbs);
> +
> +	/* Print the sign */
> +	printk("%s", (n->sign)? "-": " ");
> +
> +	/* Print the hex value */
> +	for (i = n->size - 1; i >= 0; i--) {
> +		limb = n->data[i];
> +
> +		/* Ignore leading zero limbs if canonicalization is selected */
> +		if (!limb && !started && how)
> +			continue;
> +
> +		/*
> +		 * Print each limb as though each of its nibbles was a character
> +		 * from the set '0' to '9' and 'a' to 'f'
> +		 */
> +		for (j = 28; j >= 0; j -= 4) {
> +			byte = (u8)((limb >> j) & 0x0F);
> +
> +			/*
> +			 * Ignore leading zero bytes if canonicalization
> +			 * is selected
> +			 */
> +			if (!byte && !started && how)
> +				continue;
> +
> +			started = true;
> +			byte += (byte <= 0x09)? '0': 'a' - 0x0A;
> +			printk("%c", byte);
> +		}
> +	}
> +
> +	if(!started)

space after "if"

> +		printk("0");
> +	printk("\n");


and then there's the introduction of a new typedef in a world
where we srongly try to limit new typedefs...

+typedef struct rsa_op {
+	u32 *data;
+	int sign;
+	int size;
+	int limbs;
+} rsa_op;

---
~Randy
