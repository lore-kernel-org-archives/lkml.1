Return-Path: <linux-kernel-owner+w=401wt.eu-S967687AbXEHDHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967687AbXEHDHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 23:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967681AbXEHDHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 23:07:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:49117 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S967671AbXEHDHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 23:07:01 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+WSpEb2VaWLnHW3vGIc1pkLzOOUlvNGkNC94vZe9
	xdfhRV5htCzvNK
Date: Tue, 8 May 2007 05:06:57 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Lennart Poettering <lennart@poettering.net>
Cc: linux-kernel@vger.kernel.org, grekh@suse.de, kay.sievers@vrfy.org
Subject: Re: [PATCH] DMI-based module autoloading
Message-ID: <20070508030657.GA28491@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Lennart Poettering <lennart@poettering.net>,
	linux-kernel@vger.kernel.org, grekh@suse.de, kay.sievers@vrfy.org
References: <20070508005429.GA19182@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070508005429.GA19182@tango.0pointer.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.05.08 02:54:29 +0200, Lennart Poettering wrote:
> From: Lennart Poettering <mzxreary@0pointer.de>
> +#define DEFINE_DMI_ATTR_WITH_SHOW(_name, _mode, _field)					\

Hm, too many tabs here? Wraps for me with tabsize=8.

> +static ssize_t sys_dmi_##_name##_show(struct device *dev,				\
> +				      struct device_attribute *attr, char *page)	\
> +{											\
> +	ssize_t len;									\
> +	len = snprintf(page, PAGE_SIZE, "%s\n", dmi_get_system_info(_field));		\
> +	page[PAGE_SIZE-2] = '\n';							\
> +	page[PAGE_SIZE-1] = 0;								\
> +	return min_t(ssize_t, len, PAGE_SIZE);						\
> +}											\

If you return PAGE_SIZE here, that includes the trailing 0, while len
does not. Seems not to cause any problems, but scnprintf already handles
that, so how about this?

ssize_t len;
len = scnprintf(page, PAGE_SIZE, "%s\n", dmi_get_system_info(_field));
page[len - 1] = '\n';
return len;

> +DEFINE_DMI_ATTR(_name, _mode, sys_dmi_##_name##_show);
> +
> +DEFINE_DMI_ATTR_WITH_SHOW(bios_vendor,	     0444, DMI_BIOS_VENDOR);
> +DEFINE_DMI_ATTR_WITH_SHOW(bios_version,	     0444, DMI_BIOS_VERSION);
> +DEFINE_DMI_ATTR_WITH_SHOW(bios_date,	     0444, DMI_BIOS_DATE);
> +DEFINE_DMI_ATTR_WITH_SHOW(sys_vendor,	     0444, DMI_SYS_VENDOR);
> +DEFINE_DMI_ATTR_WITH_SHOW(product_name,	     0444, DMI_PRODUCT_NAME);
> +DEFINE_DMI_ATTR_WITH_SHOW(product_version,   0444, DMI_PRODUCT_VERSION);
> +DEFINE_DMI_ATTR_WITH_SHOW(product_serial,    0400, DMI_PRODUCT_SERIAL);
> +DEFINE_DMI_ATTR_WITH_SHOW(product_uuid,	     0400, DMI_PRODUCT_UUID);
> +DEFINE_DMI_ATTR_WITH_SHOW(board_vendor,	     0444, DMI_BOARD_VENDOR);
> +DEFINE_DMI_ATTR_WITH_SHOW(board_name,	     0444, DMI_BOARD_NAME);
> +DEFINE_DMI_ATTR_WITH_SHOW(board_version,     0444, DMI_BOARD_VERSION);
> +DEFINE_DMI_ATTR_WITH_SHOW(board_serial,	     0400, DMI_BOARD_SERIAL);
> +DEFINE_DMI_ATTR_WITH_SHOW(board_asset_tag,   0444, DMI_BOARD_ASSET_TAG);
> +DEFINE_DMI_ATTR_WITH_SHOW(chassis_vendor,    0444, DMI_CHASSIS_VENDOR);
> +DEFINE_DMI_ATTR_WITH_SHOW(chassis_type,	     0444, DMI_CHASSIS_TYPE);
> +DEFINE_DMI_ATTR_WITH_SHOW(chassis_version,   0444, DMI_CHASSIS_VERSION);
> +DEFINE_DMI_ATTR_WITH_SHOW(chassis_serial,    0400, DMI_CHASSIS_SERIAL);
> +DEFINE_DMI_ATTR_WITH_SHOW(chassis_asset_tag, 0444, DMI_CHASSIS_ASSET_TAG);

Mixed tab/space alignment.

> +static void ascii_filter(char *d, const char *s)
> +{
> +	/* Filter out characters we don't want to see in the modalias string */
> +	for (; *s; s++)
> +		if (*s > ' ' && *s < 127 && *s != ':')
> +			*(d++) = *s;
> +
> +	*d = 0;
> +}
> +
> +static ssize_t get_modalias(char *buffer, size_t buffer_size)
> +{
> +	struct mafield {
> +		const char *prefix;
> +		int field;
> +	};
> +	

Trailing whitespace (also in a few more places)

> +	static const struct mafield fields[] = {
> +		{ "bvn", DMI_BIOS_VENDOR },
> +		{ "bvr", DMI_BIOS_VERSION },
> +		{ "bd",	 DMI_BIOS_DATE },
> +		{ "svn", DMI_SYS_VENDOR },
> +		{ "pn",	 DMI_PRODUCT_NAME },
> +		{ "pvr", DMI_PRODUCT_VERSION },
> +		{ "rvn", DMI_BOARD_VENDOR },
> +		{ "rn",	 DMI_BOARD_NAME },
> +		{ "rvr", DMI_BOARD_VERSION },
> +		{ "cvn", DMI_CHASSIS_VENDOR },
> +		{ "ct",	 DMI_CHASSIS_TYPE },
> +		{ "cvr", DMI_CHASSIS_VERSION },
> +		{ NULL,	 DMI_NONE }

Mixed tab/space alignment.

> +	};
> +
> +	ssize_t l, left;
> +	char *p;
> +	const struct mafield *f;
> +
> +	strcpy(buffer, "dmi");
> +	p = buffer + 3; left = buffer_size-5;
> +	
> +	for (f = fields; f->prefix && left > 0; f++) {
> +		const char *c;
> +		char *t;
> +
> +		c = dmi_get_system_info(f->field);
> +		if (!c)
> +			continue;
> +		
> +		t = kmalloc(strlen(c), GFP_KERNEL);
> +		if (!t)
> +			break;
> +		ascii_filter(t, c);
> +		l = snprintf(p, left, ":%s%s", f->prefix, t);

Looks like a candidate for scnprintf, too, avoids the l > left
comparison below.

> +		kfree(t);
> +
> +		if (l > left)
> +			l = left;
> +
> +		p += l;
> +		left -= l;
> +	}
> +
> +	snprintf(p, left, ":");

I assume that the colon is strictly required as -5 is used above to
calculate how much space is left. But "left" might be 0 if the above
snprintf had to truncate a string, thus the colon would not be written,
although there's space left. Fails for left == 1, too.

Björn
