Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbZI2UFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbZI2UFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 16:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZI2UFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 16:05:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbZI2UFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 16:05:24 -0400
Date: Tue, 29 Sep 2009 13:05:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, don@syst.com.br,
       linux-acpi@vger.kernel.org, cascardo@holoscopio.com
Subject: Re: [PATCH] cmpc_acpi: Added support for Classmate PC ACPI devices.
Message-Id: <20090929130522.ecf4d5ec.akpm@linux-foundation.org>
In-Reply-To: <1254188280-29155-1-git-send-email-cascardo@holoscopio.com>
References: <1254188280-29155-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009 22:38:00 -0300
Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:

> This add supports for devices like keyboard, backlight, tablet and
> accelerometer.
> 
> This work is supported by International Syst S/A.
> 

I need to have a big whine about the coding style.

> +static acpi_status cmpc_start_accel(acpi_handle handle)
> +{
> +	union acpi_object param[2];
> +	struct acpi_object_list input;
> +	acpi_status status;
> +	param[0].type = ACPI_TYPE_INTEGER;
> +	param[0].integer.value = 0x3;
> +	param[1].type = ACPI_TYPE_INTEGER;
> +	input.count = 2;
> +	input.pointer = param;
> +	status = acpi_evaluate_object(handle, "ACMD", &input, NULL);
> +	return status;
> +}

To the jaded kernel developer's eye, this is quite hard to read.  Every
function here squishes the declarations of the locals up against the
start of the code.  It's a small thing, but this:

static acpi_status cmpc_start_accel(acpi_handle handle)
{
	union acpi_object param[2];
	struct acpi_object_list input;
	acpi_status status;

	param[0].type = ACPI_TYPE_INTEGER;
	param[0].integer.value = 0x3;
	param[1].type = ACPI_TYPE_INTEGER;
	input.count = 2;
	input.pointer = param;
	status = acpi_evaluate_object(handle, "ACMD", &input, NULL);
	return status;
}

puts a smile on our faces.

>
> ...
>
> +static ssize_t cmpc_accel_sense_store(struct device *dev,
> +				      struct device_attribute *attr,
> +				      const char *buf, size_t count)
> +{
> +	struct acpi_device *acpi;
> +	int sense;
> +	acpi = to_acpi_device(dev);
> +	if (sscanf(buf, "%d", &sense) <= 0)
> +		return -EINVAL;
> +	cmpc_accel_set_sense(acpi->handle, sense);
> +	return strnlen(buf, count);
> +}

This will treat input of the form "42foo" as a valid decimal number. 
That's a bit sloppy.  Can we use strict_strtoul() here?

