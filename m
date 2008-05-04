Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbYEDQgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbYEDQgX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 12:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYEDQgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 12:36:14 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:12866 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbYEDQgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 12:36:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=uO0h1ojqMfdfz5B5wNlW3NvKEoWYKEL8KhlQgVThyPCHOInvr1Rg/58et9KcdJniXomz/IQkxgpcIBGpZwFWSpLX8IuDW5/HPDqhjf39NJW4Qbz9JxSZ2fyxQWWOlBZWVxXNrAbTD/qOXxs6CIPxRpaYnsGDj0H4J4kX0z4Qoic=
Date: Sun, 4 May 2008 20:35:17 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] lib: add ascii hex helper functions
Message-ID: <20080504163517.GB6842@cvg>
References: <1209842847.26173.122.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209842847.26173.122.camel@brick>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Harvey Harrison - Sat, May 03, 2008 at 12:27:27PM -0700]
| Everyone rolls their own version around the tree, centralize
| in lib/hexdump.c.  Move the only existing users of hex_asc over
| to the hi/lo helpers.
| 
| Add helpers for reading binary values from a stream of hex chars.
| Most existing users want to know how many chars were read as well.
| This implementation chooses to return the number of chars read
| and takes a pointer to the value being read.
| 
| As an alternative, a char **buf could be passed and the value could
| be returned and the pointer updated by reference.
| 
| Fixed size helpers for u8, u16, u32 and u64 have been added with
| another helper that takes an argument specifying the max number of
| chars to read (capped to the size that will fit in an unsigned long)
| 
| Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
| ---
| Andrew, I've thought a little more about this, It's possible we could
| get away without the u8/u16 helpers, but it does make the api nicely
| complete, and they are pretty small.  Most users really want to read
| a long or an int, but many can be move to the u32/u64 versions to
| tighten up implicit assumptions being made about the length being
| read.
| 
| I'll wait for coment before fixing the previous series of patches to
| use these.
| 
|  drivers/pnp/support.c  |    8 ++--
|  include/linux/kernel.h |    6 ++-
|  lib/hexdump.c          |  139 +++++++++++++++++++++++++++++++++++++++++++++++-
|  3 files changed, 146 insertions(+), 7 deletions(-)
| 
| diff --git a/drivers/pnp/support.c b/drivers/pnp/support.c
| index 3eba85e..95b076c 100644
| --- a/drivers/pnp/support.c
| +++ b/drivers/pnp/support.c
| @@ -45,10 +45,10 @@ void pnp_eisa_id_to_string(u32 id, char *str)
|  	str[0] = 'A' + ((id >> 26) & 0x3f) - 1;
|  	str[1] = 'A' + ((id >> 21) & 0x1f) - 1;
|  	str[2] = 'A' + ((id >> 16) & 0x1f) - 1;
| -	str[3] = hex_asc((id >> 12) & 0xf);
| -	str[4] = hex_asc((id >>  8) & 0xf);
| -	str[5] = hex_asc((id >>  4) & 0xf);
| -	str[6] = hex_asc((id >>  0) & 0xf);
| +	str[3] = hex_asc_hi(id >> 8);
| +	str[4] = hex_asc_lo(id >> 8);
| +	str[5] = hex_asc_hi(id);
| +	str[6] = hex_asc_lo(id);
|  	str[7] = '\0';
|  }
|  
| diff --git a/include/linux/kernel.h b/include/linux/kernel.h
| index 4d46e29..20cae9a 100644
| --- a/include/linux/kernel.h
| +++ b/include/linux/kernel.h
| @@ -276,7 +276,11 @@ extern void print_hex_dump(const char *level, const char *prefix_str,
|  				const void *buf, size_t len, bool ascii);
|  extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
|  			const void *buf, size_t len);
| -#define hex_asc(x)	"0123456789abcdef"[x]
| +
| +extern const char hex_asc[];
| +extern int hex_to_int(char c);
| +#define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
| +#define hex_asc_hi(x)	hex_asc[((x) & 0xf0) >> 4]
|  
|  #define pr_emerg(fmt, arg...) \
|  	printk(KERN_EMERG fmt, ##arg)
| diff --git a/lib/hexdump.c b/lib/hexdump.c
| index 3435465..c5cfee0 100644
| --- a/lib/hexdump.c
| +++ b/lib/hexdump.c
| @@ -12,6 +12,141 @@
|  #include <linux/kernel.h>
|  #include <linux/module.h>
|  
| +const char hex_asc[] = "0123456789abcdef";
| +
| +/**
| + * hex_char_to_int - convert a single hex ASCII char to an integer value
| + * @ch: char to convert, not case sensitive [a-f][A-F][0-9]
| + *
| + * Returns -1 if the char is not a valid hexadecimal character
| + */
| +int hex_char_to_int(char ch)
| +{
| +	/*
| +	 * Make ch lower-case, works only for digits and letters
| +	 */
| +	ch |= 0x20;

hi Harvey, maybe we should use tolower() from ctype.h here?

| +	if (ch >= 'a' && ch <= 'f')
| +		return ch - 'a' + 10;
| +	if (ch >= '0' && ch <= '9')
| +		return ch - '0';
| +	return -1;
| +}
| +EXPORT_SYMBOL(hex_char_to_int);
| +
| +/**
| + * hex_to_val - read a unsigned long from an ascii hex buffer
| + * @buf: buffer containing text
| + * @val: result read form the buffer
| + * @maxchars: maximum number of ascii chars to read
| + *
| + * The number of valid hex chars read is returned. In the event that the
| + * first character read is not a valid hex char @val will be zeroed.
| + * The number of chars read is capped at sizeof(unsigned long) * 2.
| + */
| +int hex_to_val(const char *buf, unsigned long *val, unsigned int maxchars)
| +{
| +	int numread;
| +	int tmp;
| +	unsigned long res = 0;
| +
| +	if (maxchars > sizeof(unsigned long) * 2)
| +		maxchars = sizeof(unsigned long) * 2;
| +
| +	for (numread = 0; numread < maxchars; numread++) {
| +		tmp = hex_char_to_int(*buf++);
| +		if (tmp < 0)
| +			break;
| +		else
| +			res = (res << 4) | (tmp & 0x0f);
| +	}
| +	*val = res;
| +
| +	return numread;
| +}
| +EXPORT_SYMBOL(hex_to_val);
| +
| +/**
| + * hex_to_u8 - read a u8 from an ascii hex buffer
| + * @buf: buffer containing text
| + * @val: result read form the buffer
| + *
| + * The number of valid hex chars read is returned. In the event that the
| + * first character read is not a valid hex char @val will be zeroed.
| + */
| +int hex_to_u8(const char *buf, u8 *val)
| +{
| +	unsigned long temp;
| +	int numread = hex_to_val(buf, &temp, 2);
| +
| +	*val = (u8)temp;
| +	return numread;
| +}
| +EXPORT_SYMBOL(hex_to_u8);
| +
| +/**
| + * hex_to_u16 - read a u16 from an ascii hex buffer
| + * @buf: buffer containing text
| + * @val: result read form the buffer
| + *
| + * The number of valid hex chars read is returned. In the event that the
| + * first character read is not a valid hex char @val will be zeroed.
| + */
| +int hex_to_u16(const char *buf, u16 *val)
| +{
| +	unsigned long temp;
| +	int numread = hex_to_val(buf, &temp, 4);
| +
| +	*val = (u16)temp;
| +	return numread;
| +}
| +EXPORT_SYMBOL(hex_to_u16);
| +
| +/**
| + * hex_to_u32 - read a u32 from an ascii hex buffer
| + * @buf: buffer containing text
| + * @val: result read form the buffer
| + *
| + * The number of valid hex chars read is returned. In the event that the
| + * first character read is not a valid hex char @val will be zeroed.
| + */
| +int hex_to_u32(const char *buf, u32 *val)
| +{
| +	unsigned long temp;
| +	int numread = hex_to_val(buf, &temp, 8);
| +
| +	*val = (u32)temp;
| +	return numread;
| +}
| +EXPORT_SYMBOL(hex_to_u32);
| +
| +/**
| + * hex_to_u64 - read a u32 from an ascii hex buffer
| + * @buf: buffer containing text
| + * @val: result read form the buffer
| + *
| + * The number of valid hex chars read is returned. In the event that the
| + * first character read is not a valid hex char @val will be zeroed.
| + */
| +int hex_to_u64(const char *buf, u64 *val)
| +{
| +	int numread;
| +	int tmp;
| +	u64 res = 0;
| +
| +	for (numread = 0; numread < 16; numread++) {
| +		tmp = hex_char_to_int(*buf++);
| +		if (tmp < 0)
| +			break;
| +		else
| +			res = (res << 4) | (tmp & 0x0f);
| +	}
| +	*val = res;
| +
| +	return numread;
| +}
| +EXPORT_SYMBOL(hex_to_u64);
| +
|  /**
|   * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
|   * @buf: data blob to dump
| @@ -93,8 +228,8 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
|  		for (j = 0; (j < rowsize) && (j < len) && (lx + 4) < linebuflen;
|  		     j++) {
|  			ch = ptr[j];
| -			linebuf[lx++] = hex_asc(ch >> 4);
| -			linebuf[lx++] = hex_asc(ch & 0x0f);
| +			linebuf[lx++] = hex_asc_hi(ch);
| +			linebuf[lx++] = hex_asc_lo(ch);
|  			linebuf[lx++] = ' ';
|  		}
|  		ascii_column = 3 * rowsize + 2;
| -- 
| 1.5.5.1.350.gbbbf
| 
| 
| 
| --
| To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
| the body of a message to majordomo@vger.kernel.org
| More majordomo info at  http://vger.kernel.org/majordomo-info.html
| Please read the FAQ at  http://www.tux.org/lkml/
| 
		- Cyrill -
