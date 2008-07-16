Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbYGPTwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbYGPTwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 15:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbYGPTwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 15:52:15 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:7720 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842AbYGPTwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 15:52:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DF6JH+55pklR1yUdVTgZqK2uvzb6UwjOEiYfiUYJIvUGWeo8xH3ci1nl9vjq3i3BsE
         kAVjyr65EjSn/xyAKNNB+RQQqR9EU6P5S8S+VSI6BTMdOoElva6LUnXDoRfqLW79ieG+
         Pk2pJtxGo/c9L6Qq8ZthPqZSVAXli+p3DGG40=
Message-ID: <86802c440807161252j54fee5d3tc572574f083f4735@mail.gmail.com>
Date: Wed, 16 Jul 2008 12:52:12 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: sekharan@us.ibm.com
Subject: Re: rdac and aac
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Mark Salyzyn" <mark_salyzyn@adaptec.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Linux-Scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <1216233961.27507.225.camel@chandra-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440807161051r7632c1d3qeb73c3cc1a124ed6@mail.gmail.com>
	 <1216233961.27507.225.camel@chandra-ubuntu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 11:46 AM, Chandra Seetharaman
<sekharan@us.ibm.com> wrote:
> Please test with the attached patch and see if it works.
>
> regards,
>
> chandra
>
> ---------------------
>
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> --
>
> Index: linux2.6.26-git3/drivers/scsi/device_handler/scsi_dh_rdac.c
> ===================================================================
> --- linux2.6.26-git3.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
> +++ linux2.6.26-git3/drivers/scsi/device_handler/scsi_dh_rdac.c
> @@ -608,12 +608,17 @@ static int rdac_bus_notify(struct notifi
>                            unsigned long action, void *data)
>  {
>        struct device *dev = data;
> -       struct scsi_device *sdev = to_scsi_device(dev);
> +       struct scsi_device *sdev;
>        struct scsi_dh_data *scsi_dh_data;
>        struct rdac_dh_data *h;
>        int i, found = 0;
>        unsigned long flags;
>
> +       if (!scsi_is_sdev_device(dev))
> +               return 0;
> +
> +       sdev = to_scsi_device(dev);
> +
>        if (action == BUS_NOTIFY_ADD_DEVICE) {
>                for (i = 0; rdac_dev_list[i].vendor; i++) {
>                        if (!strncmp(sdev->vendor, rdac_dev_list[i].vendor,
> Index: linux2.6.26-git3/drivers/scsi/device_handler/scsi_dh_emc.c
> ===================================================================
> --- linux2.6.26-git3.orig/drivers/scsi/device_handler/scsi_dh_emc.c
> +++ linux2.6.26-git3/drivers/scsi/device_handler/scsi_dh_emc.c
> @@ -416,12 +416,17 @@ static int clariion_bus_notify(struct no
>                                unsigned long action, void *data)
>  {
>        struct device *dev = data;
> -       struct scsi_device *sdev = to_scsi_device(dev);
> +       struct scsi_device *sdev;
>        struct scsi_dh_data *scsi_dh_data;
>        struct clariion_dh_data *h;
>        int i, found = 0;
>        unsigned long flags;
>
> +       if (!scsi_is_sdev_device(dev))
> +               return 0;
> +
> +       sdev = to_scsi_device(dev);
> +
>        if (action == BUS_NOTIFY_ADD_DEVICE) {
>                for (i = 0; clariion_dev_list[i].vendor; i++) {
>                        if (!strncmp(sdev->vendor, clariion_dev_list[i].vendor,
> Index: linux2.6.26-git3/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> ===================================================================
> --- linux2.6.26-git3.orig/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> +++ linux2.6.26-git3/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> @@ -131,11 +131,16 @@ static int hp_sw_bus_notify(struct notif
>                            unsigned long action, void *data)
>  {
>        struct device *dev = data;
> -       struct scsi_device *sdev = to_scsi_device(dev);
> +       struct scsi_device *sdev;
>        struct scsi_dh_data *scsi_dh_data;
>        int i, found = 0;
>        unsigned long flags;
>
> +       if (!scsi_is_sdev_device(dev))
> +               return 0;
> +
> +       sdev = to_scsi_device(dev);
> +
>        if (action == BUS_NOTIFY_ADD_DEVICE) {
>                for (i = 0; hp_sw_dh_data_list[i].vendor; i++) {
>                        if (!strncmp(sdev->vendor, hp_sw_dh_data_list[i].vendor,

it works. Thanks

YH
