Return-Path: <linux-kernel-owner+w=401wt.eu-S1756974AbZIDPXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbZIDPXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 11:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZIDPXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 11:23:04 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:22222 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZIDPXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 11:23:02 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Xiaotian Feng <dfeng@redhat.com>
Subject: Re: [PATCH] drivers/acpi: fix memory leak in acpi_device_set_id
Date: Fri, 4 Sep 2009 09:23:02 -0600
User-Agent: KMail/1.9.10
Cc: len.brown@intel.com, rui.zhang@intel.com, yakui.zhao@intel.com,
       ak@linux.intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1252047619-2924-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1252047619-2924-1-git-send-email-dfeng@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909040923.03457.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 September 2009 01:00:19 am Xiaotian Feng wrote:
> In acpi_device_set_id, if cid_list is allocated by ACPI_ALLOCATE_ZEROED,
> it is never freed. This patch fixes the memory leak. 

There are several recent changes to this code that remove this leak.
The current acpi-test version:

http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=blob;f=drivers/acpi/scan.c;h=e218ec5c6be046171e08a0f2d95a751aee2a9aec;hb=test

does not have the leak, as far as I can tell, because it doesn't have
the cid_list kmalloc().

If it's a serious issue, your patch might be appropriate for -stable,
but I don't think we'll need it in 2.6.32.

Bjorn

> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> ---
>  drivers/acpi/scan.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 781435d..a0102ad 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -1010,6 +1010,7 @@ static void acpi_device_set_id(struct acpi_device *device,
>  	struct acpi_compatible_id_list *cid_list = NULL;
>  	const char *cid_add = NULL;
>  	acpi_status status;
> +	int free_cid_list = 0;
>  
>  	switch (type) {
>  	case ACPI_BUS_TYPE_DEVICE:
> @@ -1098,6 +1099,7 @@ static void acpi_device_set_id(struct acpi_device *device,
>  				kfree(buffer.pointer);
>  				return;
>  			} else {
> +				free_cid_list = 1;
>  				cid_list->count = 0;
>  				cid_list->size = size;
>  			}
> @@ -1124,6 +1126,8 @@ static void acpi_device_set_id(struct acpi_device *device,
>  			printk(KERN_ERR PREFIX "Memory allocation error\n");
>  	}
>  
> +	if (free_cid_list)
> +		ACPI_FREE(cid_list);
>  	kfree(buffer.pointer);
>  }
>  


