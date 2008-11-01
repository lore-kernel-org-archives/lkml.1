Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbYKAN7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbYKAN7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 09:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYKAN7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 09:59:31 -0400
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3340 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbYKAN73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 09:59:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Markus Rechberger" <mrechberger@gmail.com>
Subject: Re: [PATCH 1/7] Adding empia base driver
Date: Sat, 1 Nov 2008 14:59:17 +0100
User-Agent: KMail/1.9.9
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, acano@fastmail.fm,
       "Andre Kelmanson" <akelmanson@gmail.com>,
       "Bouwsma Barry" <freebeer.bouwsma@gmail.com>,
       "Dan Kreiser" <kreiser@informatik.hu-berlin.de>,
       "Frank Neuber" <fn@kernelport.de>,
       "Jelle de Jong" <jelledejong@powercraft.nl>,
       "John Stowers" <john.stowers.lists@gmail.com>,
       "Lukas Kuna" <lukas.kuna@evkanet.net>,
       "Stefan Vonolfen" <stefan.vonolfen@gmail.com>,
       "Stephan Berberig" <s.berberig@arcor.de>,
       "Thomas Giesecke" <thomas.giesecke@ibgmbh-naumburg.de>,
       "Vitaly Wool" <vwool@ru.mvista.com>, "Zhenyu Wang" <zhen78@gmail.com>,
       v4l <video4linux-list@redhat.com>, linux-dvb@linuxtv.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>, greg@kroah.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
In-Reply-To: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811011459.17706.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

As promised I've done a review of your empia driver and looked at what 
needs to be done to get it into the kernel.

First of all, I've no doubt that your empia driver is better and 
supports more devices than the current em28xx driver. I also have no 
problem adding your driver separate from the current driver. It's been 
done before (certain networking drivers spring to mind) and while 
obviously not ideal I expect that the older em28xx driver can probably 
be removed after a year or something like that.

In my opinion it's pretty much hopeless trying to convert the current 
em28xx driver into what you have. It's a huge amount of work that no 
one wants to do and (in this case) with very little benefit. Of course, 
Mauro has the final say in this.

While there is some cleaning up to do in your code (coding style, some 
copyright/license clarifications), that is not a big deal. The coding 
style cleanups are a fair amount of work, but I think we can probably 
spread that out over several people and get that done quickly.

What I definitely would recommend is to use video_ioctl2 rather than 
video_usercopy. The latter function will disappear in the future. I 
think the policy for new drivers is to use video_ioctl2, so this is 
probably a required task before it can be merged. Doing this will 
improve maintenance of the code as well, so it's useful to do this 
anyway. I think it's better if you do it, but I guess some volunteer 
can probably be found if needed. It's not a difficult task.

Now the real problems are with three duplicate i2c drivers: cx25843, 
xc3028 and xc5000.

To start with the easiest one: cx25843. There already is a driver for 
this (cx25840) and the empia driver should use that one. Since I 
maintain cx25840 the easiest approach for you is to see if you can get 
me hardware (em28xx + cx25843) so that I can test and update cx25843 to 
provide proper empia support. The alternative is that we work together 
on this, but that's probably more work for both of us. I most 
definitely do *not* want to duplicate this driver. Windows drivers 
duplicate this stuff all the time, but we're not Windows and having one 
driver ensures that fixes or new functionality become available to all 
bridge drivers that use it.

The same reasoning is true for xc3028 and xc5000. In addition, the 
licensing of these sources is very vague. Is it even allowed to 
distribute them under a GPL license? There is no GPL license in the 
sources, yet in the module you specify GPL. This needs to be clarified 
first.

I see two ways forward when it comes to these drivers:

1) The empia driver switches to the current xceive drivers that are 
already in the kernel. No doubt this means that xceive driver bugs will 
surface with certain devices, but those are bugs that the xceive driver 
maintainer will have to fix. Obviously assistance would be appreciated, 
but the bottom line is that a) your driver is finally in the kernel, 
and b) there is a lot more pressure to fix bugs in the xceive drivers 
than is the case otherwise. Yes, some devices will not work initially 
with the empia driver, but I expect that to be a temporary situation.

2) Your xceive drivers replace the current drivers. This will require 
that a) the license situation is clarified, b) the drivers are modified 
to fit the current v4l-dvb tuner architecture. This option will mean a 
lot of work for you since you are the maintainer of these drivers. In 
addition, I forsee a lot of flaming if we go this way.

BTW, I noticed that the current xc5000 driver is very similar to yours 
but with proper copyrights/license notices and coding style. So for 
this driver option 1 is definitely the way to go.

To be honest, I don't see option 2 as viable. I forsee too many 
inter-personal problems that will appear if we go that way. Option 1 
has the big advantage that all you need to do is to file a bug report 
if it doesn't work with a certain device. And in the meantime users can 
fallback to your stand-alone driver until it's fixed in the kernel. 
Obviously, if you can state in the bug report what the precise problem 
is, so much the better.

So my recommendation would be to:

1) Switch to using the current xceive drivers in your empia driver. This 
is something you have to do, I'm afraid. Unless someone would 
volunteer? I personally do not have enough experience with this to do 
it.

2) Switch to using the cx25840 driver. If I can get hardware, then I can 
do this, otherwise we have to do this together. Initially we probably 
have to disable devices using the cx25840 until the cx25840 driver has 
been fixed for the empia driver.

3) Switch to video_ioctl2 in the empia driver. You can do that, but we 
can probably find a volunteer as well.

4) Conform the code to the coding style. If several people can help with 
this we can get it done pretty quickly.

5) Merge the empia driver alongside the current em28xx driver.

There are no doubt some things I missed, but I don't think I missed 
anything major. I've put up a hg tree here:

http://linuxtv.org/hg/~hverkuil/v4l-dvb-em28xx/

This allows you to compile the empia module alongside the em28xx module. 
Note that I've removed the empia cx25843 module in the last changeset 
in order to test which dependencies the driver had on that module. So 
if you want to test this tree with an empia+cx25843 device, then don't 
get the latest changeset, but the one before that.

My tree does contain the empia xceive drivers, though. Perhaps someone 
more knowledgeable with DVB can take a look to see how much work it is 
to convert to the kernel xceive drivers? And to see if I overlooked any 
DVB-related major obstacles?

I think this is a reasonable roadmap to finally get this in. If everyone 
can pitch in then it really shouldn't take that much work to get it 
into v4l-dvb and from there to 2.6.29.

Regards,

	Hans Verkuil
