Return-Path: <linux-kernel-owner+w=401wt.eu-S1764345AbYBCL0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764345AbYBCL0K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 06:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbYBCLZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 06:25:57 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:23429 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796AbYBCLZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:25:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y6V+dSil6Ol9/GARwW9GIWNA6X4UqNwbeCEoqTVEEPd1ywNDidHcfW8zoWt7FjpWYUXg8hZFiI8tVVPde3NA1uy9kyTMo+o6h+4B+IG4oyecqRYHjVp45mUHJFu1QqpVzC043Z7x1pm47ahC3KSWqmqlxCIFuu4ag3RRMN1zWLQ=
Message-ID: <804dabb00802030325v12cb95cen75179941fa4443cb@mail.gmail.com>
Date: Sun, 3 Feb 2008 19:25:52 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Wenji Huang" <wenji.huang@oracle.com>
Subject: Re: LPFC compilation error in 2.6.24-git12/git13
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <804dabb00802030320s5d60a871kbae9f48d67380384@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47A58B05.6010702@oracle.com>
	 <804dabb00802030320s5d60a871kbae9f48d67380384@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/3/08, Peter Teoh <htmldeveloper@gmail.com> wrote:
> On 2/3/08, Wenji Huang <wenji.huang@oracle.com> wrote:
> > Hi,
> >
> >  Found compilation error in 2.6.24-git12/git13:
> >
> >   CC [M]  drivers/scsi/lpfc/lpfc_mem.o
> >   CC [M]  drivers/scsi/lpfc/lpfc_sli.o
> >   CC [M]  drivers/scsi/lpfc/lpfc_ct.o
> >   CC [M]  drivers/scsi/lpfc/lpfc_els.o
> >   CC [M]  drivers/scsi/lpfc/lpfc_hbadisc.o
> >   CC [M]  drivers/scsi/lpfc/lpfc_init.o
> > drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_pci_probe_one':
> > drivers/scsi/lpfc/lpfc_init.c:1897: error: implicit declaration of
> > function 'pci_enable_device_bars'
> > make[3]: *** [drivers/scsi/lpfc/lpfc_init.o] Error 1
> > make[2]: *** [drivers/scsi/lpfc] Error 2
> > make[1]: *** [drivers/scsi] Error 2
> > make: *** [drivers] Error 2
> >
> > pci_enable_device_bars is removed in commit
> > 215e871aaa3d94540121a3809d80d0c5e5686e4f.
> >
> > Regards,
> > Wenji
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
>
> Removed by:
>
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg241836.html
>
> Following suggestions from:
>
> http://lkml.org/lkml/2007/12/17/422
> and
> http://www.gossamer-threads.com/lists/linux/kernel/873333
>
> This is my suggested patch:
>
>
> --- drivers/scsi/lpfc/lpfc_init.c       2008-02-03 19:26:42.000000000 +0800
> +++ lpfc_init.c.old     2008-02-03 19:26:20.000000000 +0800
> @@ -1894,7 +1894,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
>         uint16_t iotag;
>         int bars = pci_select_bars(pdev, IORESOURCE_MEM);
>
> -       if (pci_enable_device_io(pdev))
> +       if (pci_enable_device_bars(pdev, bars))
>                 goto out;
>         if (pci_request_selected_regions(pdev, bars, LPFC_DRIVER_NAME))
>                 goto out_disable_device;
>
> Is that correct?
>

Sorry got my order wrong :-):

--- lpfc_init.c.old     2008-02-03 19:26:20.000000000 +0800
+++ drivers/scsi/lpfc/lpfc_init.c       2008-02-03 19:26:42.000000000 +0800
@@ -1894,7 +1894,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
        uint16_t iotag;
        int bars = pci_select_bars(pdev, IORESOURCE_MEM);

-       if (pci_enable_device_bars(pdev, bars))
+       if (pci_enable_device_io(pdev))
                goto out;
        if (pci_request_selected_regions(pdev, bars, LPFC_DRIVER_NAME))
                goto out_disable_device;
