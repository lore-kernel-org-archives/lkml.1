Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbYJaWu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbYJaWu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 18:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYJaWut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 18:50:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43304 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbYJaWus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 18:50:48 -0400
Message-ID: <490B8BB2.3070105@zytor.com>
Date: Fri, 31 Oct 2008 15:50:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 1/4] Check for serial key in dmi_name_in_vendors
References: <1224894097.28224.71.camel@alok-dev1>
In-Reply-To: <1224894097.28224.71.camel@alok-dev1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> Add serial key as a field to check for in dmi_name_in_vendors.
> 
> From: Alok N Kataria <akataria@vmware.com>
> 
> In some user configured cases, VMware may choose not to put a VMware specific
> DMI string, but the serial key is always there and is VMware specific.
> Add that too to check for in the dmi_name_in_vendors function.
> 
> Signed-off-by: Alok N Kataria <akataria@vmware.com>
> ---
> 
>  drivers/firmware/dmi_scan.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index 3e526b6..14fcb52 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -476,7 +476,8 @@ int dmi_name_in_vendors(const char *str)
>  {
>  	static int fields[] = { DMI_BIOS_VENDOR, DMI_BIOS_VERSION, DMI_SYS_VENDOR,
>  				DMI_PRODUCT_NAME, DMI_PRODUCT_VERSION, DMI_BOARD_VENDOR,
> -				DMI_BOARD_NAME, DMI_BOARD_VERSION, DMI_NONE };
> +				DMI_BOARD_NAME, DMI_BOARD_VERSION, DMI_PRODUCT_SERIAL,
> +				DMI_NONE };
>  	int i;
>  	for (i = 0; fields[i] != DMI_NONE; i++) {
>  		int f = fields[i];
> 

On reviewing this, I'm quite nervous about this patch.
dmi_name_in_vendors() is matched against short strings like "IBM" which
could end up in the serial number of another product by pure chance if
some vendor uses alpha serial numbers.

In fact, the *only* instance of dmi_name_in_vendors() in the upstream
kernel tree that "git grep" can find is:

drivers/misc/thinkpad_acpi.c:   if (dmi_name_in_vendors("IBM"))
drivers/misc/thinkpad_acpi.c:   else if (dmi_name_in_vendors("LENOVO"))

I think matching against the serial number would be just plain wrong here.

Since there is only one user, we could change that user, perhaps to take
a bitmask or pointer to one of several canned lists as an argument, or
we can introduce another entry point.

	-hpa
