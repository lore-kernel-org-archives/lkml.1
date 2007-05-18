Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbXERNyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbXERNyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 09:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbXERNyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 09:54:15 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:32972 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbXERNyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 09:54:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=e0rjtbAlcz7/46uc+27/YtH5GRwHiKgYoAsoZQHiQfFhJML8garL6q4a1H+1WfcNoiHHFm0oCnQI2hDP8xyMhJC/0U+OU9uKU6C6++QsNGV9yBBjKpQ2UM6UPYHF5oF0LBlDjVwDXfTx6ZXulG1RTO6dT2uMXq+F1WO/p64psas=
Message-ID: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
Date: Fri, 18 May 2007 14:54:13 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: joydev.c and saitek cyborg evo force
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm a kernel newbie so please, pardon my French.

I have a Saitek Cyborg Evo Force, a very good joystick with force-
feedback. Problem is, on Windows it works well (its drivers know its
own idiosyncrasies) but on Linux it gets a bit fuzzy.

The behaviour is that, all axis are working fine, except up/down
(elevator) and left/right (aileron) that gives me "random"
signed/unsigned values.

A smaller problem is that it's reporting 8 axis but have 6 only and 13
buttons but have only 12 and the 12th button is always pressed,
messing fgjs setup utility.

Digging drivers/input/joydev.c I found out that if I remove the
correction (setting
JS_CORR_NONE) the values come correct, in a range from 0 to 4096.

Problem is, on joydev_connect, when defining the corrections for every
axis, the joystick is reporting dev->absmax = 127 and dev->absmin =
-127 for both axis 0 and 1, so the correction is based on a signed
range when the joystick is actually sending an unsigned range.

Also, because the module was expecting up to 127 on value and is getting
4094, when the correction does a left shift it might be setting the
signal bit (leftmost) and that could explain why I'm getting random
signed/unsigned values.

The only way to know what is the real range is when you're actually
pushing and pulling the stick so the change I'm willing to make is to
recalibrate (ie. redefine the correction) whenever the raw value goes
off limits. But that would only extend 127 to 4096 but won't change -127
to 0.

Another alternative is to do a dynamic calibration whenever you move the
stick from the beginning and not do it based on what the joystick is
telling you to (ie. at connect time). But that might be a lot of useless
work when the control gives you the correct range in the first place.

At last, hardcoding "if (saitek)" is quite ugly but can be done for the
sake of performance.

comments, please.

cheers,
--renato

Reclaim your digital rights, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm
