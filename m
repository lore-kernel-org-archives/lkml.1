Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbXIZDz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbXIZDz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbXIZDzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:55:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56123 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701AbXIZDzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:55:49 -0400
Message-ID: <46F9D83D.5050305@garzik.org>
Date: Tue, 25 Sep 2007 23:55:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Matthew Wilcox <matthew@wil.cx>, FUJITA Tomonori <tomof@acm.org>,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: queued patches for SCSI for 2.6.24
References: <1190768402.8707.20.camel@localhost.localdomain>	 <20070925065233Q.tomof@acm.org>	 <1190770955.8707.23.camel@localhost.localdomain>	 <20070925073735U.tomof@acm.org> <46F9C5ED.6050505@garzik.org>	 <20070926025608.GA3899@parisc-linux.org>  <46F9D328.4030801@garzik.org> <1190778353.8707.29.camel@localhost.localdomain>
In-Reply-To: <1190778353.8707.29.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> This whole mess is generated basically because the zero default of the
> template should be treated as initiator.  How about this, which makes
> that manifest?
> 
> James
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index adc9559..7e26440 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -342,7 +342,11 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
>  	shost->use_clustering = sht->use_clustering;
>  	shost->ordered_tag = sht->ordered_tag;
> -	shost->active_mode = sht->supported_mode;
> +	if (sht->supported_mode == MODE_UNKNOWN)
> +		/* means we didn't set it ... default to INITIATOR */
> +		shost->active_mode = MODE_INITIATOR;
> +	else
> +		shost->active_mode = sht->supported_mode;
>  
>  	if (sht->max_host_blocked)
>  		shost->max_host_blocked = sht->max_host_blocked;
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 0088c4d..4965e9e 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -209,11 +209,13 @@ show_shost_mode(unsigned int mode, char *buf)
>  static ssize_t show_shost_supported_mode(struct class_device *class_dev, char *buf)
>  {
>  	struct Scsi_Host *shost = class_to_shost(class_dev);
> +	unsigned int supported_mode = shost->hostt->supported_mode;
>  
> -	if (shost->hostt->supported_mode == MODE_UNKNOWN)
> -		return snprintf(buf, 20, "unknown\n");
> -	else
> -		return show_shost_mode(shost->hostt->supported_mode, buf);
> +	if (supported_mode == MODE_UNKNOWN)
> +		/* by default this should be initiator */
> +		supported_mode = MODE_INITIATOR;
> +
> +	return show_shost_mode(shost->hostt->supported_mode, buf);
>  }
>  
>  static CLASS_DEVICE_ATTR(supported_mode, S_IRUGO | S_IWUSR, show_shost_supported_mode, NULL);


ACK

