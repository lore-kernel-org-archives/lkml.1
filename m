Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbYEMEDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbYEMEDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 00:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbYEMEDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 00:03:13 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:34567 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYEMEDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 00:03:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BrO4qUuyXUV78PNhBzmfOzcvOSyVU3vthCxsW2LYVRhDX8PMLdq96THMglwOflnvTkf/3gomhWDlUa/b5GoMElsNlv9m2Cpia2Q8/3zch2SIM0UyiFcmBMWOnY8kfDDiAE2R9OtO94BlzwNglwjc0sCjUywE3rArpSzIkr/zUp4=
Message-ID: <37219a840805122103u2a74b050h95c006f99ff8690f@mail.gmail.com>
Date: Tue, 13 May 2008 00:03:02 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [patch] video: build fix for drivers/media/video/pvrusb2/
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Guennadi Liakhovetski" <g.liakhovetski@pengutronix.de>,
       "Mike Isely" <isely@pobox.com>
In-Reply-To: <20080512235445.3a56cea0@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080511072137.GA16772@elte.hu>
	 <37219a840805110534r4865623y6f9510554e2716ac@mail.gmail.com>
	 <20080512235445.3a56cea0@gaivota>
X-Google-Sender-Auth: 35119eb8f7b155e0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 10:54 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
>
> On Sun, 11 May 2008 08:34:06 -0400
>  "Michael Krufky" <mkrufky@linuxtv.org> wrote:
>
>  > On Sun, May 11, 2008 at 3:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
>  > >
>  > > x86.git testing found the following build failure:
>  > >
>  > >  drivers/built-in.o: In function `pvr2_dvb_feed_thread':
>  > >  pvrusb2-dvb.c:(.text+0x127e78): undefined reference to `dvb_dmx_swfilter'
>  > >  drivers/built-in.o: In function `pvr2_dvb_adapter_exit':
>  > >  pvrusb2-dvb.c:(.text+0x128357): undefined reference to `dvb_net_release'
>  > >  pvrusb2-dvb.c:(.text+0x12836f): undefined reference to `dvb_dmxdev_release'
>  > >  [...]
>  > >
>  > > with this config:
>  > >
>  > >  http://redhat.com/~mingo/misc/config-Sun_May_11_07_06_35_CEST_2008.bad
>  > >
>  > > the reason for the missing symbols is this combination:
>  > >
>  > >  CONFIG_VIDEO_PVRUSB2=y
>  > >  CONFIG_DVB_CORE=m
>  > >
>  > > i.e. pvrusb2 is built-in, dvb-core is modular.
>  > >
>  > > This patch solves the problem by adding a dependency on DVB_CORE - this
>  > > is used by other drivers such as au0828 as well. This way the pvrusb2
>  > > driver can still be built, but if dvb-core is a module then it will
>  > > correctly be a module as well and cannot be built-in.
>  > >
>  > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
>  > > ---
>  > >  drivers/media/video/pvrusb2/Kconfig |    2 +-
>  > >  1 file changed, 1 insertion(+), 1 deletion(-)
>  > >
>  > > Index: linux/drivers/media/video/pvrusb2/Kconfig
>  > > ===================================================================
>  > > --- linux.orig/drivers/media/video/pvrusb2/Kconfig
>  > > +++ linux/drivers/media/video/pvrusb2/Kconfig
>  > > @@ -1,6 +1,6 @@
>  > >  config VIDEO_PVRUSB2
>  > >        tristate "Hauppauge WinTV-PVR USB2 support"
>  > > -       depends on VIDEO_V4L2 && I2C
>  > > +       depends on VIDEO_V4L2 && I2C && DVB_CORE
>  > >        select FW_LOADER
>  > >        select MEDIA_TUNER
>  > >        select VIDEO_TVEEPROM
>  > >
>  >
>  > Ingo,
>  >
>  > VIDEO_PVRUSB2 should not depend on DVB_CORE unless VIDEO_PVRUSB2_DVB
>  > is selected, which already depends on DVB_CORE.
>  >
>  > For example, if a user has VIDEO_PVRUSB2_DVB not selected, then your
>  > patch would generate a false dependency on DVB_CORE.
>
>  Maybe we can make pvrusb2 dependent of VIDEO_MEDIA. This is a DVB_CORE ||
>  VIDEO_DEV. So, pvrusb should be 'm' in this case.

That sounds like it would be OK, although something like this would
probably be better:

 config VIDEO_PVRUSB2
       tristate "Hauppauge WinTV-PVR USB2 support"
-       depends on VIDEO_V4L2 && I2C
+       depends on VIDEO_V4L2 && I2C && (DVB_CORE if VIDEO_PVRUSB2_DVB)
       select FW_LOADER
       select MEDIA_TUNER
       select VIDEO_TVEEPROM

I don't know if that syntax works for "depends on" , but it does work
for select.

if "depends on FOO if BAR" doesnt work, would adding "select DVB_CORE
if VIDEO_PVRUSB2_DVB" solve the problem?

-Mike
