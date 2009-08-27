Return-Path: <linux-kernel-owner+w=401wt.eu-S1752509AbZH0UHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbZH0UHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 16:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZH0UHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 16:07:39 -0400
Received: from mail-px0-f174.google.com ([209.85.216.174]:61581 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbZH0UHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 16:07:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=XNbxp/VXvTPjED5KrIJZQD+nQuTkHp1oqluz2s0an4IV90brs3WwoIjFUM+7LpMq7C
         mmsILtAi5iAy2LHSI4p8FLOA/DnuI1P2HS6YEGR5xherxsu62eKfurqvvW5rHPnoTwAS
         3Dio43xDdry3p7kfYUalbjyG6cLCt6F/rTufE=
Date: Thu, 27 Aug 2009 13:07:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 7] PM: Add a switch for disabling/enabling asynchronous
	suspend/resume
References: <200908262217.19609.rjw@sisk.pl> <200908270025.34821.rjw@sisk.pl> <200908272117.52931.rjw@sisk.pl> <200908272119.47053.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908272119.47053.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090827203948.9CD25526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 09:19:46PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Add sysfs attribute kernel/power/pm_async allowing the user space to
> disable and enable async suspend/resume of devices.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/main.c  |   13 +++++++------
>  drivers/base/power/power.h |    6 +++---
>  kernel/power/main.c        |   28 +++++++++++++++++++++++++++-
>  3 files changed, 37 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6/kernel/power/main.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/main.c
> +++ linux-2.6/kernel/power/main.c
> @@ -44,6 +44,29 @@ int pm_notifier_call_chain(unsigned long
>  			== NOTIFY_BAD) ? -EINVAL : 0;
>  }
>  
> +/* If set, devices may be suspended and resumed asynchronously. */
> +int pm_async_enabled = 1;
> +
> +static ssize_t pm_async_show(struct kobject *kobj, struct kobj_attribute *attr,
> +			     char *buf)
> +{
> +	return sprintf(buf, "%d\n", pm_async_enabled);
> +}
> +
> +static ssize_t pm_async_store(struct kobject *kobj, struct kobj_attribute *attr,
> +			      const char *buf, size_t n)
> +{
> +	int val;
> +
> +	if (sscanf(buf, "%d", &val) == 1) {

I prefer more vigorous restrictions on the sysfs interfaces. Maybe:

	if (strict_strtoul(buf, 10, &val) || val > 1)
		return -EINVAL;

	pm_async_enabled = val;

?

-- 
Dmitry
