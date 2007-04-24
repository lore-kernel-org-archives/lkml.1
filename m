Return-Path: <linux-kernel-owner+w=401wt.eu-S1031066AbXDXI0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031066AbXDXI0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031053AbXDXIZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:25:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:41443 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbXDXIUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:20:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DkgqD70H/znwcJGIARLqqYsumQzoi5B3o41ITZ4lo4CtKyJc7Kwha2q9UvDp17z7r7EOpAekjC9aQn2Fo4q4b8uMML3XzdGTCz0NK6vFVPvaDcNBF1bL8qsBNdP9ui+EQhE9Fdnlu4KMTAEVsEhhan2e58dZe9oNBHytBzft1ak=
Message-ID: <462DBDB3.9010102@gmail.com>
Date: Tue, 24 Apr 2007 17:20:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [patch 5/7] genhd: send async notification on media change
References: <20070424074856.005152262@intel.com> <20070423170010.5514072e.kristen.c.accardi@intel.com>
In-Reply-To: <20070423170010.5514072e.kristen.c.accardi@intel.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Send an uevent to user space to indicate that a media change event has occurred.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> 
> Index: 2.6-git/block/genhd.c
> ===================================================================
> --- 2.6-git.orig/block/genhd.c
> +++ 2.6-git/block/genhd.c
> @@ -643,6 +643,25 @@ struct seq_operations diskstats_op = {
>  	.show	= diskstats_show
>  };
>  
> +static void media_change_notify_thread(struct work_struct *work)
> +{
> +	struct gendisk *gd = container_of(work, struct gendisk, async_notify);
> +	char event[] = "MEDIA_CHANGE=1";
> +	char *envp[] = { event, NULL };
> +
> +	/*
> +	 * set enviroment vars to indicate which event this is for
> +	 * so that user space will know to go check the media status.
> +	 */
> +	kobject_uevent_env(&gd->kobj, KOBJ_CHANGE, envp);
> +}
> +
> +void genhd_media_change_notify(struct gendisk *disk)
> +{
> +	schedule_work(&disk->async_notify);
> +}
> +EXPORT_SYMBOL_GPL(genhd_media_change_notify);

genhd might go away while async_notify work is in-flight.  You'll need
to either grab a reference or wait for the work to finish in release
routine.

-- 
tejun
