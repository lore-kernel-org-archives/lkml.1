Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbYEKMeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbYEKMeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 08:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbYEKMeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 08:34:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:48288 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbYEKMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 08:34:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=wc1b+GJ0E426RyYv47TVTTLPnuIo76T1gLzt5yU4Vkk67XUoNbFufqzOYIA772H3k8AxWqgizpIOoDGGWb3SRvPe/Gi3jRuw+6/5vQJ3hPkPesUyw3cR4he2EPdYxkSDLui1stlHRPKeTTod+lI+CFdUsjrW3K8YfkVINB8di6U=
Message-ID: <37219a840805110534r4865623y6f9510554e2716ac@mail.gmail.com>
Date: Sun, 11 May 2008 08:34:06 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] video: build fix for drivers/media/video/pvrusb2/
Cc: linux-kernel@vger.kernel.org,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Guennadi Liakhovetski" <g.liakhovetski@pengutronix.de>,
       "Mike Isely" <isely@pobox.com>
In-Reply-To: <20080511072137.GA16772@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080511072137.GA16772@elte.hu>
X-Google-Sender-Auth: 1f0d411d95fd2295
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 3:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> x86.git testing found the following build failure:
>
>  drivers/built-in.o: In function `pvr2_dvb_feed_thread':
>  pvrusb2-dvb.c:(.text+0x127e78): undefined reference to `dvb_dmx_swfilter'
>  drivers/built-in.o: In function `pvr2_dvb_adapter_exit':
>  pvrusb2-dvb.c:(.text+0x128357): undefined reference to `dvb_net_release'
>  pvrusb2-dvb.c:(.text+0x12836f): undefined reference to `dvb_dmxdev_release'
>  [...]
>
> with this config:
>
>  http://redhat.com/~mingo/misc/config-Sun_May_11_07_06_35_CEST_2008.bad
>
> the reason for the missing symbols is this combination:
>
>  CONFIG_VIDEO_PVRUSB2=y
>  CONFIG_DVB_CORE=m
>
> i.e. pvrusb2 is built-in, dvb-core is modular.
>
> This patch solves the problem by adding a dependency on DVB_CORE - this
> is used by other drivers such as au0828 as well. This way the pvrusb2
> driver can still be built, but if dvb-core is a module then it will
> correctly be a module as well and cannot be built-in.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/media/video/pvrusb2/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux/drivers/media/video/pvrusb2/Kconfig
> ===================================================================
> --- linux.orig/drivers/media/video/pvrusb2/Kconfig
> +++ linux/drivers/media/video/pvrusb2/Kconfig
> @@ -1,6 +1,6 @@
>  config VIDEO_PVRUSB2
>        tristate "Hauppauge WinTV-PVR USB2 support"
> -       depends on VIDEO_V4L2 && I2C
> +       depends on VIDEO_V4L2 && I2C && DVB_CORE
>        select FW_LOADER
>        select MEDIA_TUNER
>        select VIDEO_TVEEPROM
>

Ingo,

VIDEO_PVRUSB2 should not depend on DVB_CORE unless VIDEO_PVRUSB2_DVB
is selected, which already depends on DVB_CORE.

For example, if a user has VIDEO_PVRUSB2_DVB not selected, then your
patch would generate a false dependency on DVB_CORE.

Regards,

Mike Krufky
