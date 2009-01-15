Return-Path: <linux-kernel-owner+w=401wt.eu-S1763347AbZAOKaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763347AbZAOKaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbZAOK34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:29:56 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:59354 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbZAOK3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:29:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=V5E5hdH86kITxsOpaC3ELsGcl+l+6EHFQ0hRLsOeRazW3ylwBK7tMM3EoLFD2VX6Zk
         2lt5YaXzXFScgAcP+fHR7UZhTgFiCTB84vtaOg0ilcy9oF6I5ZoPEFicnX51NYRqH9OR
         kNqqLaC2zEU6KE08wU3hlsWKFPAhXOHMI2Y68=
Message-ID: <25e057c00901150229g35d8e9bdn6a19585cbc9d15bd@mail.gmail.com>
Date: Thu, 15 Jan 2009 11:29:53 +0100
From: "roel kluin" <roel.kluin@gmail.com>
To: "Magnus Damm" <magnus.damm@gmail.com>
Subject: Re: [RESEND][PATCH] early platform drivers V2
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       lethal@linux-sh.org, johnstul@us.ibm.com, gregkh@suse.de,
       mingo@redhat.com, tglx@linutronix.de
In-Reply-To: <20090114105436.18974.45429.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090114105436.18974.45429.sendpatchset@rx1.opensource.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int __init early_platform_match(struct early_platform_driver *epdrv,
> +                                      struct platform_device **pdevs,
> +                                      int nr_pdevs, int id,
> +                                      struct platform_device **match)
> +{
> +       struct platform_device *pdev;
> +       int k, n, match_id;
> +
> +       if (id == -2)
> +               match_id = epdrv->requested_id;
> +       else
> +               match_id = id;
> +
> +       n = 0;
> +       *match = NULL;
> +       for (k = 0; k < nr_pdevs; k++) {
> +               pdev = pdevs[k];
> +               if (platform_match(&pdev->dev, &epdrv->pdrv->driver)) {

> +                       if (id != -2) /* skip previously checked device */
> +                               if (match_id == epdrv->requested_id)
> +                                       goto skip;
> +
> +                       if (pdev->id == match_id)
> +                               *match = pdev;
> +
> +skip:
> +                       if (pdev->id > match_id)
> +                               n++;

you can replace the 10 lines above by:

/* skip previously checked device */
if ((id == -2 || match_id != epdrv->requested_id) && pdev->id == match_id)
        *match = pdev;
else if (pdev->id > match_id)
        n++;

> +               }
> +       }
> +
> +       return n;
> +}

> +/**
> + * early_platform_driver_probe
> + * @class_str: string to identify early platform driver class
> + * @pdevs: platform devices to match against
> + * @nr_pdevs: number of platform devices to match against
> + * @nr_probe: number of platform devices to successfully probe before exiting
> + */
> +int __init early_platform_driver_probe(char *class_str,
> +                                      struct platform_device **pdevs,
> +                                      int nr_pdevs, int nr_probe)
> +{
> +       struct early_platform_driver *epdrv;
> +       struct platform_device *match;
> +       int k, n, i;
> +
> +       /* The "class_str" parameter may or may not be present on the kernel
> +        * command line. If it is present then there may be more than one
> +        * matching parameter.
> +        *
> +        * Since we register our early platform drivers using early_param()
> +        * we need to make sure that they also get registered in the case
> +        * when the parameter is missing from the kernel command line.
> +        *
> +        * We use parse_early_options() to make sure the early_param() gets
> +        * called at least once. The early_param() may be called more than
> +        * once since the name of the preferred device may be specified on
> +        * the kernel command line. early_platform_driver_register() handles
> +        * this case for us.
> +        */
> +       parse_early_options(class_str);
> +
> +       n = 0;
> +       list_for_each_entry(epdrv, &early_platform_driver_list, list) {
> +               /* only use drivers matching our class_str */
> +               if (strcmp(class_str, epdrv->class_str))
> +                       continue;
> +
> +               /* start with exact device match, continue with any device */
> +               k = 1;
> +               for (i = -2; k && n < nr_probe; i++) {
> +                       k = early_platform_match(epdrv, pdevs, nr_pdevs,
> +                                                i, &match);
> +                       if (!match)
> +                               continue;
> +
> +                       if (epdrv->pdrv->probe(match)) {

shouldn't this be

if (!epdrv->pdrv->probe(match)) {

> +                               pr_warning("%s: unable to probe %s early.\n",
> +                                          class_str, match->name);
> +                               continue;
> +                       }
> +                       n++;
> +               }
> +       }
> +
> +       if (!n)
> +               pr_warning("%s: no early platform devices found.\n", class_str);
> +
> +       return n;
> +}

I think k, n and i could get more descriptive names
