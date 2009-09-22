Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZIVKkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZIVKkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 06:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbZIVKkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 06:40:51 -0400
Received: from mx0.towertech.it ([213.215.222.73]:33605 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751084AbZIVKku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 06:40:50 -0400
Date: Tue, 22 Sep 2009 12:40:41 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       rtc-linux@googlegroups.com
Subject: Re: rtc_cmos oops in cmos_rtc_ioctl
Message-ID: <20090922124041.62abee25@i1501.lan.towertech.it>
In-Reply-To: <200909211553.38409.herton@mandriva.com.br>
References: <200909211553.38409.herton@mandriva.com.br>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009 15:53:38 -0300
Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:

> The problem here is the rtc char device being created early and acessible before
> rtc_cmos does dev_set_drvdata(dev, &cmos_rtc), so dev_get_drvdata in
> cmos_rtc_ioctl can return null, like in this example where hwclock is run right
> after char device creation that triggers the udev rule:
> ACTION=="add", SUBSYSTEM=="rtc", RUN+="/sbin/hwclock --hctosys --rtc=/dev/%k"
> And makes the oops possible, in this case hwclock looks to open and close the
> device fast enough.

 right. the best option would be to use the new irq api that was
 introduced after the creation of rtc_cmos (and thus remove the whole
 ioctl routine).

 [...]

> But I saw another issue: looks it could be possible that as cmos_rtc_ioctl
> (ioctl) can be run before rtc_device_register returns, the following call chain
> could happen in current code:
> cmos_rtc_ioctl->cmos_irq_{en,dis}able->cmos_checkintr->rtc_update_irq
> rtc_update_irq uses cmos->rtc, which is set only at return of
> rtc_device_register, and here we may have another problem... is it
> possible?

 this shouldn't happen, irqs are enabled only after everything
 has been setup to handle them.

 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

