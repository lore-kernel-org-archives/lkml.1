Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab0CIGVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 01:21:20 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60734 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0CIGVQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 01:21:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o/oAJuJc1CvQ7f2DOz73ZcVdYdciSPUO4+7tACPglbx5cuuggiWgwvEGnne0q0VpeO
         ze7vTPgO9oxOdX5ia4JadaG50N4oXDZfHCr36mCa9gPa+8q+b/WWDNrp74dxwEEm1g9w
         HEO03oworHS9WFfLf7giT59CtwnA4iXJ0PyRM=
MIME-Version: 1.0
In-Reply-To: <4B916169.5040303@oracle.com>
References: <201003050232.o252WD4K011798@imap1.linux-foundation.org>
	 <4B916169.5040303@oracle.com>
Date: Tue, 9 Mar 2010 12:21:15 +0600
Message-ID: <b9df5fa11003082221u4f8ad73mee4397f3cc0f9aa9@mail.gmail.com>
Subject: Re: [PATCH -mmotm] acpi/sbs: fix build for ACPI_SYSFS_POWER=n
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On 3/6/10, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> When CONFIG_ACPI_SYSFS_POWER is not enabled:
>
> drivers/acpi/sbs.c:640: error: implicit declaration of function
> 'acpi_battery_get_alarm'
> drivers/acpi/sbs.c:679: error: implicit declaration of function
> 'acpi_battery_set_alarm'
>
This problem is introduced by the patch
(http://lkml.org/lkml/2010/3/1/29) named
acpi-put-acpi_battery_get-set_alarm-into-config_acpi_sysfs_power.patch.
If we use CONFIG_ACPI_SYSFS_POWER=y then we are warned by the
following warning:

drivers/acpi/sbs.c:399: warning: ‘acpi_battery_get_alarm’ defined but not used
drivers/acpi/sbs.c:406: warning: ‘acpi_battery_set_alarm’ defined but not used

So, I think it's better that we wrap CONFIG_ACPI_SYSFS_POWER with
#ifdef and #else. Otherwise we have to face the above warning.

Thanks,
Rakib

>
> so move those functions outside of the ifdef/endif block for that
> config option.
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/acpi/sbs.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- mmotm-2010-0304-1805.orig/drivers/acpi/sbs.c
> +++ mmotm-2010-0304-1805/drivers/acpi/sbs.c
> @@ -412,8 +412,6 @@ static int acpi_ac_get_present(struct ac
>  	return result;
>  }
>
> -#ifdef CONFIG_ACPI_SYSFS_POWER
> -
>  static int acpi_battery_get_alarm(struct acpi_battery *battery)
>  {
>  	return acpi_smbus_read(battery->sbs->hc, SMBUS_READ_WORD,
> @@ -450,6 +448,8 @@ static int acpi_battery_set_alarm(struct
>  	return ret;
>  }
>
> +#ifdef CONFIG_ACPI_SYSFS_POWER
> +
>  static ssize_t acpi_battery_alarm_show(struct device *dev,
>  					struct device_attribute *attr,
>  					char *buf)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
