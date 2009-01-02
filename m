Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbZABUET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbZABUET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 15:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932183AbZABUDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 15:03:52 -0500
Received: from main.gmane.org ([80.91.229.2]:45867 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbZABUDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 15:03:50 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: compile time warnings
Date: Fri, 02 Jan 2009 14:03:36 -0600
Message-ID: <495E7318.4010904@shaw.ca>
References: <495d3100@wupperonline.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
In-Reply-To: <495d3100@wupperonline.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Brueckl wrote:
> Maybe somebody noticed already, with kernel 2.6.28 and gcc 4.3.2 there are a
> few compile time warnings:
>   drivers/acpi/tables/tbfadt.c: In function 'acpi_tb_create_local_fadt':
>   /usr/src/linux/arch/x86/include/asm/string_32.h:75: warning: array subscript is above array bounds

I noticed this as well. This one looks like the compiler's getting a bit 
confused.

	ACPI_MEMCPY(&acpi_gbl_FADT, table,
		    ACPI_MIN(length, sizeof(struct acpi_table_fadt)));

and somehow that falls into __constant_memcpy because somehow 
__builtin_constant_p() on the length parameter returns true. Huh? It's a 
non-static function where length is passed in, and ACPI_MIN is a simple 
(((a)<(b))?(a):(b)) expression. How can it think that's a compile time 
constant I don't know. Maybe it's not and just generating warnings from 
the code path it's seeing but not using?

The cause of the complaint might be the fact that the memcpy may appear 
to read past the end of the "table" structure which points to struct 
acpi_table_header. Presumably that memory is bigger than the actual 
struct acpi_table_header though. The text of the warning itself is 
bizarre though, as there is no array style access happening, and I don't 
see how the compiler can know what the actual bounds of the "array" are.

> 
>   drivers/usb/core/hcd.c: In function 'usb_hcd_poll_rh_status':
>   /usr/src/linux/arch/x86/include/asm/string_32.h:75: warning: array subscript is above array bounds

This one makes a little more sense. This is presumably:

			memcpy(urb->transfer_buffer, buffer, length);

where transfer_buffer is a void*, buffer is char[4] and length comes 
from hcd->driver->hub_status_data(hcd, buffer) which I assume fills in 
the buffer. It's true the memcpy could read past the end of the buffer 
array, but only if the hub_status_data could fill in and return a length 
greater than 4, which it hopefully can't..

