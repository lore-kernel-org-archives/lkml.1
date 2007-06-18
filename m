Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbXFRE50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbXFRE50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 00:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbXFRE5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 00:57:19 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:21199 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbXFRE5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 00:57:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=cy6551L/YcJ8pwo5mNNVGvhjuGpwqL46f24N7D8UCos6Wq1MqQVjB6dZOQqg07vUG7KUrFlxKCiI+989I2DKEi1VAT3GJgJ4oHElVYnDWjMyAoWjTc7ryT94rdYkAttS3e2lZkAxMcNJXHe3bvl6U8UQSsLq0T4ZwFzmcUtkS+E=
Date: Mon, 18 Jun 2007 12:58:11 +0000
From: Dave Young <hidave.darkstar@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cdrom_sysctl_info fix
Message-ID: <20070618125811.GA1692@darkstar.te-china.tietoenator.com>
References: <20070614142430.GA2388@darkstar.te-china.tietoenator.com> <20070615132657.GW6149@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615132657.GW6149@kernel.dk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi jens,
Thanks for rework this patch.But it has some bugs, results kernel oops.

On Fri, Jun 15, 2007 at 03:26:57PM +0200, Jens Axboe wrote:
> On Thu, Jun 14 2007, Dave Young wrote:
> > Hi,
> > 
> > Fix the cdrom_sysctl_info possible buffer overwrite bug. Somd
> > codingstyle fixes are included as well. 
> 
> How about something like this? The current code is actually racy,
> because there's no protection against adding/removing a cdrom while it
> runs. This patch is largely based on yours, just abstracted the printing
> and looping into a function and bail when we run out of room (and print
> a message to that effect).
You are right
> 
> If you could test it and verify that it does the right thing (eg prints
> the same as before), that would be great!
> 
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index 3625a05..ae5a475 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -302,7 +302,7 @@ module_param(lockdoor, bool, 0);
>  module_param(check_media_type, bool, 0);
>  module_param(mrw_format_restart, bool, 0);
>  
> -static DEFINE_SPINLOCK(cdrom_lock);
> +static DEFINE_MUTEX(cdrom_mutex);
>  
>  static const char *mrw_format_status[] = {
>  	"not mrw",
> @@ -438,10 +438,10 @@ int register_cdrom(struct cdrom_device_info *cdi)
>  		cdo->generic_packet = cdrom_dummy_generic_packet;
>  
>  	cdinfo(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
> -	spin_lock(&cdrom_lock);
> +	mutex_lock(&cdrom_mutex);
>  	cdi->next = topCdromPtr; 	
>  	topCdromPtr = cdi;
> -	spin_unlock(&cdrom_lock);
> +	mutex_unlock(&cdrom_mutex);
>  	return 0;
>  }
>  #undef ENSURE
> @@ -452,7 +452,7 @@ int unregister_cdrom(struct cdrom_device_info *unreg)
>  	cdinfo(CD_OPEN, "entering unregister_cdrom\n"); 
>  
>  	prev = NULL;
> -	spin_lock(&cdrom_lock);
> +	mutex_lock(&cdrom_mutex);
>  	cdi = topCdromPtr;
>  	while (cdi && cdi != unreg) {
>  		prev = cdi;
> @@ -460,7 +460,7 @@ int unregister_cdrom(struct cdrom_device_info *unreg)
>  	}
>  
>  	if (cdi == NULL) {
> -		spin_unlock(&cdrom_lock);
> +		mutex_unlock(&cdrom_mutex);
>  		return -2;
>  	}
>  	if (prev)
> @@ -468,7 +468,7 @@ int unregister_cdrom(struct cdrom_device_info *unreg)
>  	else
>  		topCdromPtr = cdi->next;
>  
> -	spin_unlock(&cdrom_lock);
> +	mutex_unlock(&cdrom_mutex);
>  
>  	if (cdi->exit)
>  		cdi->exit(cdi);
> @@ -3289,103 +3289,112 @@ static struct cdrom_sysctl_settings {
>  	int	check;			/* check media type */
>  } cdrom_sysctl_settings;
>  
> +static int cdrom_print_int(const char *header, int val, char *info, int *pos)
> +{
The val is diffrent for every devices, isn't it?
> +	const int max_size = sizeof(cdrom_sysctl_settings.info);
> +	struct cdrom_device_info *cdi;
> +	int ret;
> +
> +	ret = scnprintf(info + *pos, max_size, header);
> +	if (!ret)
> +		return 1;
> +
> +	*pos += ret;
> +
> +	for (cdi = topCdromPtr; cdi; cdi = cdi->next) {
> +		ret = scnprintf(info + *pos, max_size, "\t%d", val);
The max_size should be max_size - *pos
> +		if (!ret)
> +			return 1;
> +		*pos += ret;
> +	}
> +
> +	return 0;
> +}
> +
>  static int cdrom_sysctl_info(ctl_table *ctl, int write, struct file * filp,
>                             void __user *buffer, size_t *lenp, loff_t *ppos)
>  {
> -        int pos;
> +	int pos;
>  	struct cdrom_device_info *cdi;
>  	char *info = cdrom_sysctl_settings.info;
> +	const int max_size = sizeof(cdrom_sysctl_settings.info);
>  	
>  	if (!*lenp || (*ppos && !write)) {
>  		*lenp = 0;
>  		return 0;
>  	}
>  
> +	mutex_lock(&cdrom_mutex);
> +
>  	pos = sprintf(info, "CD-ROM information, " VERSION "\n");
>  	
> -	pos += sprintf(info+pos, "\ndrive name:\t");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%s", cdi->name);
> -
> -	pos += sprintf(info+pos, "\ndrive speed:\t");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", cdi->speed);
> -
> -	pos += sprintf(info+pos, "\ndrive # of slots:");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", cdi->capacity);
> -
> -	pos += sprintf(info+pos, "\nCan close tray:\t");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_CLOSE_TRAY) != 0);
> -
> -	pos += sprintf(info+pos, "\nCan open tray:\t");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_OPEN_TRAY) != 0);
> -
> -	pos += sprintf(info+pos, "\nCan lock tray:\t");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_LOCK) != 0);
> -
> -	pos += sprintf(info+pos, "\nCan change speed:");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_SELECT_SPEED) != 0);
> -
> -	pos += sprintf(info+pos, "\nCan select disk:");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_SELECT_DISC) != 0);
> -
> -	pos += sprintf(info+pos, "\nCan read multisession:");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MULTI_SESSION) != 0);
> -
> -	pos += sprintf(info+pos, "\nCan read MCN:\t");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MCN) != 0);
> -
> -	pos += sprintf(info+pos, "\nReports media changed:");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MEDIA_CHANGED) != 0);
> -
> -	pos += sprintf(info+pos, "\nCan play audio:\t");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_PLAY_AUDIO) != 0);
> -
> -	pos += sprintf(info+pos, "\nCan write CD-R:\t");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_CD_R) != 0);
> -
> -	pos += sprintf(info+pos, "\nCan write CD-RW:");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_CD_RW) != 0);
> -
> -	pos += sprintf(info+pos, "\nCan read DVD:\t");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD) != 0);
> -
> -	pos += sprintf(info+pos, "\nCan write DVD-R:");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_R) != 0);
> -
> -	pos += sprintf(info+pos, "\nCan write DVD-RAM:");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_RAM) != 0);
> -
> -	pos += sprintf(info+pos, "\nCan read MRW:\t");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MRW) != 0);
> -
> -	pos += sprintf(info+pos, "\nCan write MRW:\t");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MRW_W) != 0);
> -
> -	pos += sprintf(info+pos, "\nCan write RAM:\t");
> -	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
> -	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_RAM) != 0);
> -
> -	strcpy(info+pos,"\n\n");
> -		
> -        return proc_dostring(ctl, write, filp, buffer, lenp, ppos);
> +	pos += scnprintf(info + pos, max_size - pos, "\ndrive name:\t");
> +	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next)
> +		pos += scnprintf(info + pos, max_size - pos, "\t%s", cdi->name);
> +
> +	if (cdrom_print_int("\ndrive speed:\t", cdi->speed, info, &pos))
Now the cdi is NULL
> +		goto done;
> +	if (cdrom_print_int("\ndrive # of slots:", cdi->capacity, info, &pos))
> +		goto done;
> +	if (cdrom_print_int("\nCan close tray:\t",
> +				CDROM_CAN(CDC_CLOSE_TRAY) != 0, info, &pos))
> +		goto done;
> +	if (cdrom_print_int("\nCan open tray:\t",
> +				CDROM_CAN(CDC_OPEN_TRAY) != 0, info, &pos))
> +		goto done;
> +	if (cdrom_print_int("\nCan lock tray:\t",
> +				CDROM_CAN(CDC_LOCK) != 0, info, &pos))
> +		goto done;
> +	if (cdrom_print_int("\nCan change speed:\t",
> +				CDROM_CAN(CDC_SELECT_SPEED) != 0, info, &pos))
> +		goto done;
> +	if (cdrom_print_int("\nCan select disk:\t",
> +				CDROM_CAN(CDC_SELECT_DISC) != 0, info, &pos))
> +		goto done;
> +	if (cdrom_print_int("\nCan read multisession:",
> +				CDROM_CAN(CDC_MULTI_SESSION) != 0, info, &pos))
> +		goto done;
> +	if (cdrom_print_int("\nCan read MCN:",
> +				CDROM_CAN(CDC_MCN) != 0, info, &pos))
> +		goto done;
> +	if (cdrom_print_int("\nReports media changed:",
> +				CDROM_CAN(CDC_MEDIA_CHANGED) != 0, info, &pos))
> +		goto done;
> +	if (cdrom_print_int("\nCan play audio:",
> +				CDROM_CAN(CDC_PLAY_AUDIO) != 0, info, &pos))
> +		goto done;
> +	if (cdrom_print_int("\nCan write CD-R:\t",
> +				CDROM_CAN(CDC_CD_R) != 0, info, &pos))
> +		goto done;
> +	if (cdrom_print_int("\nCan write CD-RW:\t",
> +				CDROM_CAN(CDC_CD_RW) != 0, info, &pos))
> +		goto done;
> +	if (cdrom_print_int("\nCan read DVD:\t",
> +				CDROM_CAN(CDC_DVD) != 0, info, &pos))
> +		goto done;
> +	if (cdrom_print_int("\nCan write DVD-R:\t",
> +				CDROM_CAN(CDC_DVD_R) != 0, info, &pos))
> +		goto done;
> +	if (cdrom_print_int("\nCan write DVD-RAM:\t",
> +				CDROM_CAN(CDC_DVD_RAM) != 0, info, &pos))
> +		goto done;
> +	if (cdrom_print_int("\nCan read MRW:\t",
> +				CDROM_CAN(CDC_MRW) != 0, info, &pos))
> +		goto done;
> +	if (cdrom_print_int("\nCan write MRW:\t",
> +				CDROM_CAN(CDC_MRW_W) != 0, info, &pos))
> +		goto done;
> +	if (cdrom_print_int("\nCan write RAM:\t",
> +				CDROM_CAN(CDC_RAM) != 0, info, &pos))
> +		goto done;
> +	if (!scnprintf(info + pos, max_size - pos, "\n\n"))
> +		goto done;
> +doit:
> +	mutex_unlock(&cdrom_mutex);
> +	return proc_dostring(ctl, write, filp, buffer, lenp, ppos);
> +done:
> +	printk(KERN_INFO "cdrom: info buffer too small\n");
> +	goto doit;
>  }
>  
>  /* Unfortunately, per device settings are not implemented through
> 
> -- 
> Jens Axboe
And there's several more '\t' in the printed strings. so the result not aligned right.

I rewite the patch according to yours, please help to check. Pass the cdrom_print_info function one more argument for diffrent type printing, do you have better solutions for this? thanks for replying :)


Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
diff -upr linux/drivers/cdrom/cdrom.c linux.new/drivers/cdrom/cdrom.c
--- linux/drivers/cdrom/cdrom.c	2007-06-18 12:36:40.000000000 +0000
+++ linux.new/drivers/cdrom/cdrom.c	2007-06-18 12:38:51.000000000 +0000
@@ -302,7 +302,7 @@ module_param(lockdoor, bool, 0);
 module_param(check_media_type, bool, 0);
 module_param(mrw_format_restart, bool, 0);
 
-static DEFINE_SPINLOCK(cdrom_lock);
+static DEFINE_MUTEX(cdrom_mutex);
 
 static const char *mrw_format_status[] = {
 	"not mrw",
@@ -438,10 +438,10 @@ int register_cdrom(struct cdrom_device_i
 		cdo->generic_packet = cdrom_dummy_generic_packet;
 
 	cdinfo(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
-	spin_lock(&cdrom_lock);
+	mutex_lock(&cdrom_mutex);
 	cdi->next = topCdromPtr; 	
 	topCdromPtr = cdi;
-	spin_unlock(&cdrom_lock);
+	mutex_unlock(&cdrom_mutex);
 	return 0;
 }
 #undef ENSURE
@@ -452,7 +452,7 @@ int unregister_cdrom(struct cdrom_device
 	cdinfo(CD_OPEN, "entering unregister_cdrom\n"); 
 
 	prev = NULL;
-	spin_lock(&cdrom_lock);
+	mutex_lock(&cdrom_mutex);
 	cdi = topCdromPtr;
 	while (cdi && cdi != unreg) {
 		prev = cdi;
@@ -460,7 +460,7 @@ int unregister_cdrom(struct cdrom_device
 	}
 
 	if (cdi == NULL) {
-		spin_unlock(&cdrom_lock);
+		mutex_unlock(&cdrom_mutex);
 		return -2;
 	}
 	if (prev)
@@ -468,7 +468,7 @@ int unregister_cdrom(struct cdrom_device
 	else
 		topCdromPtr = cdi->next;
 
-	spin_unlock(&cdrom_lock);
+	mutex_unlock(&cdrom_mutex);
 
 	if (cdi->exit)
 		cdi->exit(cdi);
@@ -3289,103 +3289,137 @@ static struct cdrom_sysctl_settings {
 	int	check;			/* check media type */
 } cdrom_sysctl_settings;
 
+enum cdrom_print_option {
+	CTL_NAME,
+	CTL_SPEED,
+	CTL_SLOTS,
+	CTL_CAPABILITY
+};
+
+static int cdrom_print_info(const char *header, int val, char *info,
+				int *pos, enum cdrom_print_option option)
+{
+	const int max_size = sizeof(cdrom_sysctl_settings.info);
+	struct cdrom_device_info *cdi;
+	int ret;
+
+	ret = scnprintf(info + *pos, max_size - *pos, header);
+	if (!ret)
+		return 1;
+
+	*pos += ret;
+
+	for (cdi = topCdromPtr; cdi; cdi = cdi->next) {
+		switch (option) {
+		case CTL_NAME:
+			ret = scnprintf(info + *pos, max_size - *pos,
+					"\t%s", cdi->name);
+			break;
+		case CTL_SPEED:
+			ret = scnprintf(info + *pos, max_size - *pos,
+					"\t%d", cdi->speed);
+			break;
+		case CTL_SLOTS:
+			ret = scnprintf(info + *pos, max_size - *pos,
+					"\t%d", cdi->capacity);
+			break;
+		case CTL_CAPABILITY:
+			ret = scnprintf(info + *pos, max_size - *pos,
+					"\t%d", CDROM_CAN(val) != 0);
+			break;
+		default:
+			printk(KERN_INFO "cdrom: invalid option%d\n", option);
+			return 1;
+		}
+		if (!ret)
+			return 1;
+		*pos += ret;
+	}
+
+	return 0;
+}
+
 static int cdrom_sysctl_info(ctl_table *ctl, int write, struct file * filp,
                            void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-        int pos;
-	struct cdrom_device_info *cdi;
+	int pos;
 	char *info = cdrom_sysctl_settings.info;
+	const int max_size = sizeof(cdrom_sysctl_settings.info);
 	
 	if (!*lenp || (*ppos && !write)) {
 		*lenp = 0;
 		return 0;
 	}
 
+	mutex_lock(&cdrom_mutex);
+
 	pos = sprintf(info, "CD-ROM information, " VERSION "\n");
 	
-	pos += sprintf(info+pos, "\ndrive name:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%s", cdi->name);
-
-	pos += sprintf(info+pos, "\ndrive speed:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", cdi->speed);
-
-	pos += sprintf(info+pos, "\ndrive # of slots:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", cdi->capacity);
-
-	pos += sprintf(info+pos, "\nCan close tray:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_CLOSE_TRAY) != 0);
-
-	pos += sprintf(info+pos, "\nCan open tray:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_OPEN_TRAY) != 0);
-
-	pos += sprintf(info+pos, "\nCan lock tray:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_LOCK) != 0);
-
-	pos += sprintf(info+pos, "\nCan change speed:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_SELECT_SPEED) != 0);
-
-	pos += sprintf(info+pos, "\nCan select disk:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_SELECT_DISC) != 0);
-
-	pos += sprintf(info+pos, "\nCan read multisession:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MULTI_SESSION) != 0);
-
-	pos += sprintf(info+pos, "\nCan read MCN:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MCN) != 0);
-
-	pos += sprintf(info+pos, "\nReports media changed:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MEDIA_CHANGED) != 0);
-
-	pos += sprintf(info+pos, "\nCan play audio:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_PLAY_AUDIO) != 0);
-
-	pos += sprintf(info+pos, "\nCan write CD-R:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_CD_R) != 0);
-
-	pos += sprintf(info+pos, "\nCan write CD-RW:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_CD_RW) != 0);
-
-	pos += sprintf(info+pos, "\nCan read DVD:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD) != 0);
-
-	pos += sprintf(info+pos, "\nCan write DVD-R:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_R) != 0);
-
-	pos += sprintf(info+pos, "\nCan write DVD-RAM:");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_RAM) != 0);
-
-	pos += sprintf(info+pos, "\nCan read MRW:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MRW) != 0);
-
-	pos += sprintf(info+pos, "\nCan write MRW:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MRW_W) != 0);
-
-	pos += sprintf(info+pos, "\nCan write RAM:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_RAM) != 0);
-
-	strcpy(info+pos,"\n\n");
-		
-        return proc_dostring(ctl, write, filp, buffer, lenp, ppos);
+	if (cdrom_print_info("\ndrive name:\t", 0, info, &pos, CTL_NAME))
+		goto done;
+	if (cdrom_print_info("\ndrive speed:\t", 0, info, &pos, CTL_SPEED))
+		goto done;
+	if (cdrom_print_info("\ndrive # of slots:", 0, info, &pos, CTL_SLOTS))
+		goto done;
+	if (cdrom_print_info("\nCan close tray:\t",
+				CDC_CLOSE_TRAY, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan open tray:\t",
+				CDC_OPEN_TRAY, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan lock tray:\t",
+				CDC_LOCK, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan change speed:",
+				CDC_SELECT_SPEED, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan select disk:",
+				CDC_SELECT_DISC, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan read multisession:",
+				CDC_MULTI_SESSION, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan read MCN:\t",
+				CDC_MCN, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nReports media changed:",
+				CDC_MEDIA_CHANGED, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan play audio:\t",
+				CDC_PLAY_AUDIO, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write CD-R:\t",
+				CDC_CD_R, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write CD-RW:",
+				CDC_CD_RW, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan read DVD:\t",
+				CDC_DVD, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write DVD-R:",
+				CDC_DVD_R, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write DVD-RAM:",
+				CDC_DVD_RAM, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan read MRW:\t",
+				CDC_MRW, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write MRW:\t",
+				CDC_MRW_W, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (cdrom_print_info("\nCan write RAM:\t",
+				CDC_RAM, info, &pos, CTL_CAPABILITY))
+		goto done;
+	if (!scnprintf(info + pos, max_size - pos, "\n\n"))
+		goto done;
+doit:
+	mutex_unlock(&cdrom_mutex);
+	return proc_dostring(ctl, write, filp, buffer, lenp, ppos);
+done:
+	printk(KERN_INFO "cdrom: info buffer too small\n");
+	goto doit;
 }
 
 /* Unfortunately, per device settings are not implemented through
Only in linux/drivers/cdrom: cdrom.old


--
Regards
dave
