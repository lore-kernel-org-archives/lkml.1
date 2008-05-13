Return-Path: <linux-kernel-owner+w=401wt.eu-S1758418AbYEMPya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbYEMPya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbYEMPyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:54:22 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:1873 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYEMPyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:54:21 -0400
Message-ID: <4829B999.2090108@linuxtv.org>
From: mkrufky@linuxtv.org
To: mchehab@infradead.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, g.liakhovetski@pengutronix.de,
       isely@pobox.com
Subject: Re: [patch] video: build fix for drivers/media/video/pvrusb2/
Date: Tue, 13 May 2008 11:54:01 -0400
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
in-reply-to: <20080513124630.111c465b@gaivota>
x-originalarrivaltime: 13 May 2008 15:50:00.0670 (UTC) FILETIME=[00737FE0:01C8B511]
user-agent: Thunderbird 2.0.0.14 (Windows/20080421)
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> On Tue, 13 May 2008 00:03:02 -0400
> "Michael Krufky" <mkrufky@linuxtv.org> wrote:
>
>   
>> On Mon, May 12, 2008 at 10:54 PM, Mauro Carvalho Chehab
>> <mchehab@infradead.org> wrote:
>>     
>>> On Sun, 11 May 2008 08:34:06 -0400
>>>  "Michael Krufky" <mkrufky@linuxtv.org> wrote:
>>>
>>>  > On Sun, May 11, 2008 at 3:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>>  > >
>>>  > > x86.git testing found the following build failure:
>>>  > >
>>>  > >  drivers/built-in.o: In function `pvr2_dvb_feed_thread':
>>>  > >  pvrusb2-dvb.c:(.text+0x127e78): undefined reference to
`dvb_dmx_swfilter'
>>>  > >  drivers/built-in.o: In function `pvr2_dvb_adapter_exit':
>>>  > >  pvrusb2-dvb.c:(.text+0x128357): undefined reference to
`dvb_net_release'
>>>  > >  pvrusb2-dvb.c:(.text+0x12836f): undefined reference to
`dvb_dmxdev_release'
>>>  > >  [...]
>>>  > >
>>>  > > with this config:
>>>  > >
>>>  > >
http://redhat.com/~mingo/misc/config-Sun_May_11_07_06_35_CEST_2008.bad
>>>  > >
>>>  > > the reason for the missing symbols is this combination:
>>>  > >
>>>  > >  CONFIG_VIDEO_PVRUSB2=y
>>>  > >  CONFIG_DVB_CORE=m
>>>  > >
>>>  > > i.e. pvrusb2 is built-in, dvb-core is modular.
>>>  > >
>>>  > > This patch solves the problem by adding a dependency on DVB_CORE -
this
>>>  > > is used by other drivers such as au0828 as well. This way the
pvrusb2
>>>  > > driver can still be built, but if dvb-core is a module then it will
>>>  > > correctly be a module as well and cannot be built-in.
>>>  > >
>>>  > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>>  > > ---
>>>  > >  drivers/media/video/pvrusb2/Kconfig |    2 +-
>>>  > >  1 file changed, 1 insertion(+), 1 deletion(-)
>>>  > >
>>>  > > Index: linux/drivers/media/video/pvrusb2/Kconfig
>>>  > > ===================================================================
>>>  > > --- linux.orig/drivers/media/video/pvrusb2/Kconfig
>>>  > > +++ linux/drivers/media/video/pvrusb2/Kconfig
>>>  > > @@ -1,6 +1,6 @@
>>>  > >  config VIDEO_PVRUSB2
>>>  > >        tristate "Hauppauge WinTV-PVR USB2 support"
>>>  > > -       depends on VIDEO_V4L2 && I2C
>>>  > > +       depends on VIDEO_V4L2 && I2C && DVB_CORE
>>>  > >        select FW_LOADER
>>>  > >        select MEDIA_TUNER
>>>  > >        select VIDEO_TVEEPROM
>>>  > >
>>>  >
>>>  > Ingo,
>>>  >
>>>  > VIDEO_PVRUSB2 should not depend on DVB_CORE unless VIDEO_PVRUSB2_DVB
>>>  > is selected, which already depends on DVB_CORE.
>>>  >
>>>  > For example, if a user has VIDEO_PVRUSB2_DVB not selected, then your
>>>  > patch would generate a false dependency on DVB_CORE.
>>>
>>>  Maybe we can make pvrusb2 dependent of VIDEO_MEDIA. This is a DVB_CORE
||
>>>  VIDEO_DEV. So, pvrusb should be 'm' in this case.
>>>       
>> That sounds like it would be OK, although something like this would
>> probably be better:
>>
>>  config VIDEO_PVRUSB2
>>        tristate "Hauppauge WinTV-PVR USB2 support"
>> -       depends on VIDEO_V4L2 && I2C
>> +       depends on VIDEO_V4L2 && I2C && (DVB_CORE if VIDEO_PVRUSB2_DVB)
>>        select FW_LOADER
>>        select MEDIA_TUNER
>>        select VIDEO_TVEEPROM
>>     
>
> This doesn't look to be a good idea, since VIDEO_PVRUSB2_DVB depends on
> VIDEO_PVRUSB2. So, you'll create a circular dependency. The syntax I've
> proposed seems cleaner. Of course, it needs to be tested. IMO, all hybrid
> devices should be dependent of VIDEO_MEDIA. This will help to avoid this
kind
> of issue.
>
>   
>> I don't know if that syntax works for "depends on" , but it does work
>> for select.
>>
>> if "depends on FOO if BAR" doesnt work, would adding "select DVB_CORE
>> if VIDEO_PVRUSB2_DVB" solve the problem?
>>     
>
> Also, this leads into a circular reference.
Mauro,

You're right -- I didn't consider the circular dependency.

Your suggestion (depends on VIDEO_MEDIA) seems like the right way to go.

Regards,

Mike Krufky
