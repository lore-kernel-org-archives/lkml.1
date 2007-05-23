Return-Path: <linux-kernel-owner+w=401wt.eu-S1764496AbXEWJiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764496AbXEWJiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 05:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757530AbXEWJiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 05:38:14 -0400
Received: from twin.jikos.cz ([213.151.79.26]:34173 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756996AbXEWJiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 05:38:13 -0400
Date: Wed, 23 May 2007 11:38:07 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Renato Golin <rengolin@gmail.com>
cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] joydev.c automatic re-calibration
In-Reply-To: <d9b9d95f0705221733l46de4262qd9c3f5047c53667@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705231130540.27422@twin.jikos.cz>
References: <d9b9d95f0705221733l46de4262qd9c3f5047c53667@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Dmitry to CC so that he doesn't miss it.

Also, if you'd like to get your patch merged, you should add proper 
Signed-off-by line.

Thanks)

On Wed, 23 May 2007, Renato Golin wrote:

> This small patch adds the automatic recalibration feature without
> spoiling previously calibrated devices. It's a fix for those joysticks
> that report faulty range, specially Saitek Cyborg Evo Force.
> 
> File: drivers/input/joydev.c
> Fix:
> - extracted code from joydev_connect to method
> joydev_calculate_correction to be able to call it from both
> joydev_event upon recalibration and joydev_connect during first
> connection.
> - on joydev_connect check ranges and zero calibration if found out of range
> - on joydev_event, every time found out of range, update min/max and
> recalculate the correction
> 
> Patch below and attached.
> 
> cheers,
> --renato
> 
> == PATCH BEGIN ==
> 
> --- joydev.c.original   2007-05-22 22:23:43.000000000 +0100
> +++ joydev.c    2007-05-23 01:24:04.000000000 +0100
> @@ -53,6 +53,8 @@
>        __u8 absmap[ABS_MAX + 1];
>        __u8 abspam[ABS_MAX + 1];
>        __s16 abs[ABS_MAX + 1];
> +       __s16 absmin[ABS_MAX + 1];
> +       __s16 absmax[ABS_MAX + 1];
> };
> 
> struct joydev_list {
> @@ -67,6 +69,19 @@
> 
> static struct joydev *joydev_table[JOYDEV_MINORS];
> 
> +static void joydev_calculate_correction(int min, int max, int axis,
> struct joydev *joydev)
> +{
> +       int t, j = joydev->abspam[axis];
> +       int flat = joydev->handle.dev->absflat[j];
> +
> +       joydev->corr[axis].coef[0] = (max + min) / 2 - flat;
> +       joydev->corr[axis].coef[1] = (max + min) / 2 + flat;
> +       if (!(t = ((max - min) / 2 - 2 * flat)))
> +               return;
> +       joydev->corr[axis].coef[2] = (1 << 29) / t;
> +       joydev->corr[axis].coef[3] = (1 << 29) / t;
> +}
> +
> static int joydev_correct(int value, struct js_corr *corr)
> {
>        switch (corr->type) {
> @@ -103,6 +118,14 @@
>                case EV_ABS:
>                        event.type = JS_EVENT_AXIS;
>                        event.number = joydev->absmap[code];
> +                       /* recalibration if needed */
> +                       if (value < joydev->absmin[code]) {
> +                               joydev->absmin[code] = value;
> +                               joydev_calculate_correction(value,
> joydev->absmax[code], code, joydev);
> +                       } else if (value > joydev->absmax[code]) {
> +                               joydev->absmax[code] = value;
> +
> joydev_calculate_correction(joydev->absmin[code], value, code,
> joydev);
> +                       }
>                        event.value = joydev_correct(value,
> joydev->corr + event.number);
>                        if (event.value == joydev->abs[event.number])
>                                return;
> @@ -470,7 +493,7 @@
> {
>        struct joydev *joydev;
>        struct class_device *cdev;
> -       int i, j, t, minor;
> +       int i, j, minor;
> 
>        for (minor = 0; minor < JOYDEV_MINORS && joydev_table[minor]; minor++);
>        if (minor == JOYDEV_MINORS) {
> @@ -515,19 +538,21 @@
> 
>        for (i = 0; i < joydev->nabs; i++) {
>                j = joydev->abspam[i];
> -               if (dev->absmax[j] == dev->absmin[j]) {
> +               joydev->absmin[i] = dev->absmin[j];
> +               joydev->absmax[i] = dev->absmax[j];
> +               if (joydev->absmax[i] == joydev->absmin[i]) {
>                        joydev->corr[i].type = JS_CORR_NONE;
>                        joydev->abs[i] = dev->abs[j];
>                        continue;
>                }
>                joydev->corr[i].type = JS_CORR_BROKEN;
>                joydev->corr[i].prec = dev->absfuzz[j];
> -               joydev->corr[i].coef[0] = (dev->absmax[j] +
> dev->absmin[j]) / 2 - dev->absflat[j];
> -               joydev->corr[i].coef[1] = (dev->absmax[j] +
> dev->absmin[j]) / 2 + dev->absflat[j];
> -               if (!(t = ((dev->absmax[j] - dev->absmin[j]) / 2 - 2 *
> dev->absflat[j])))
> -                       continue;
> -               joydev->corr[i].coef[2] = (1 << 29) / t;
> -               joydev->corr[i].coef[3] = (1 << 29) / t;
> +
> +               if (dev->abs[j] > joydev->absmax[i] || dev->abs[j] <
> joydev->absmin[i]) {
> +                       printk("Joydev: Bad axis range, recalibrating
> automatically\n");
> +                       joydev_calculate_correction(0, 0, i, joydev);
> +               } else
> +                       joydev_calculate_correction(joydev->absmin[i],
> joydev->absmax[i], i, joydev);
> 
>                joydev->abs[i] = joydev_correct(dev->abs[j], joydev->corr + i);
>        }
> 
> == PATCH END ==
> 
> 

-- 
Jiri Kosina
