Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbZLKRlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbZLKRlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 12:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756683AbZLKRk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 12:40:59 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:40498 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068AbZLKRk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 12:40:58 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATH 1/5 -v2] acpi, IO memory pre-mapping and atomic accessing
Date: Fri, 11 Dec 2009 10:36:14 -0700
User-Agent: KMail/1.9.10
Cc: lenb@kernel.org, ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1260429413.15264.393.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1260429413.15264.393.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912111036.15063.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see you posted a first version of this series a couple days
ago, but there weren't any responses (at least on linux-acpi),
and you didn't say anything about what you changed between
-v1 and -v2.

On Thursday 10 December 2009 12:16:53 am Huang Ying wrote:
> Some ACPI IO accessing need to be done in atomic context. For example,
> APEI ERST operations may be used for permanent storage in hardware
> error handler. That is, it may be called in atomic contexts such as
> IRQ or NMI, etc. And, ERST/EINJ implement their operations via IO
> memory/port accessing.  But the IO memory accessing method provided by
> ACPI (acpi_read/acpi_write) maps the IO memory during it is accessed,
> so it can not be used in atomic context. To solve the issue, the IO
> memory should be pre-mapped during EINJ/ERST initializing. A linked
> list is used to record which memory area has been mapped, when memory
> is accessed in hardware error handler, search the linked list for the
> mapped virtual address from the given physical address.

The ACPI CA has functions called acpi_hw_read() and acpi_hw_write()
that have similar prototypes and functionality (but of course, they
don't work in atomic context).  It'd be nice if your new functions
had similar names, e.g., acpi_hw_map(), acpi_hw_unmap(),
acpi_hw_read_atomic(), acpi_hw_write_atomic().

I think your code would be simpler if acpi_pre_map_gar() returned a
struct acpi_iomap pointer (from the caller's point of view, this would
be an opaque cookie).  Then you could just supply that cookie to
acpi_atomic_write(), and you wouldn't have to look it up again.  Maybe
you could even get rid of the list and all the fancy RCU & kref stuff
then, too.

> +/* In NMI handler, should set silent = 1 */
> +static int acpi_check_gar(struct acpi_generic_address *reg,
> +			  u64 *paddr, int silent)
> +{
> +	u32 width;
> +
> +	/* Handle possible alignment issues */
> +	memcpy(paddr, &reg->address, sizeof(*paddr));
> +	if (!*paddr) {
> +		if (!silent)
> +			pr_info(
> +			"Invalid physical address in GAR, firmware bug?\n");
> +		return -EINVAL;
> +	}
> +
> +	width = reg->bit_width;
> +	if ((width != 8) && (width != 16) && (width != 32) && (width != 64)) {
> +		if (!silent)
> +			pr_info(
> +			"Invalid bit width in GAR, firmware bug?\n");
> +		return -EINVAL;
> +	}
> +
> +	if (reg->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY &&
> +	    reg->space_id != ACPI_ADR_SPACE_SYSTEM_IO) {
> +		if (!silent)
> +			pr_info(
> +			"Invalid address space type in GAR, firmware bug?\n");

Error messages with constant text are nearly useless because they
don't give much of a clue about where to look for a problem.
Personally, for something this, I would just return failure and
never print anything.  If a map fails, the caller should notice
and you then have a good idea of where to look.

> +static int acpi_atomic_read_port(u64 port, u32 *val, u32 width)
> +{
> +	switch (width) {
> +	case 8:
> +		*val = inb(port);
> +		break;
> +	case 16:
> +		*val = inw(port);
> +		break;
> +	case 32:
> +		*val = inl(port);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}

Can you use acpi_os_read_port() and acpi_os_write_port() instead of
duplicating this code?

> +static int acpi_atomic_write_port(u64 port, u32 val, u32 width)
> +{
> +	switch (width) {
> +	case 8:
> +		outb(val, port);
> +		break;
> +	case 16:
> +		outw(val, port);
> +		break;
> +	case 32:
> +		outl(val, port);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}

Bjorn

