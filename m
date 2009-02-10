Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZBJNMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZBJNMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbZBJNMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:12:14 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:3773 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbZBJNMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:12:13 -0500
X-Greylist: delayed 1749 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Feb 2009 08:12:12 EST
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <49917650.1060208@tudelft.nl>
Date: Tue, 10 Feb 2009 13:42:56 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>,
       Palatis Tseng <palatis@gmail.com>, Pavel Machek <pavel@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>	 <498D9F02.9000107@tremplin-utc.net> <498E46F2.1020401@gmail.com>	 <4990BE23.8080301@tremplin-utc.net> <4990DEFD.4010700@gmail.com>	 <49915832.1090501@tremplin-utc.net> <cb7bb73a0902100307m4eab8ff2nfe9be8bed6a3b5b5@mail.gmail.com>
In-Reply-To: <cb7bb73a0902100307m4eab8ff2nfe9be8bed6a3b5b5@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040908090902010704010001"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040908090902010704010001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Giuseppe Bilotta schreef:
:
> 
> With my patch applied:
> 
> Left raised: 0 -> 32k
> Right raised: 0 -> -32k
> 
> Front raised: 1 -> -32k
> back raised: 1 -> 32k
> 
> Upside down: 2 -> 32k
> 
> So it seems that my model inverts the Z axis too, I'll have to fix
> that. However, this last test is tricky because unless the laptop is
> completely upside down the Z axis can go from -32k to +32k with just a
> couple of degrees (around the 90°)
> 
> I'll update my patch to invert the X and Z axis for my model.
Let's have a look at this once the "big noise" problem is fixed, because
for now it's rather impossible to deduce anything meaningful.

Andrew, could you drop the patch in the mean time?

> 
>> Palatis, could you let us know if you also have a lot of "noise" in the
>> values. That is, if when using jstest /dev/input/js0 you see big changes
>> in the values. Is it like on Giuseppe's laptop of around 8000?
>>
>> Moreover I'm wondering if this could be an error on LSB/MSB ordering.
>> Maybe looking at the raw values (cat
>> /sys/devices/platform/lis3lv02d/position) would give more insight...
> 
> amd64 architecture here. Laptop flat:
> 
> oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
> (-256,256,14592)
> oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
> (0,256,14848)
> oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
> (-256,256,14848)
> oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
> (-256,0,14336)
> oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
> (-256,512,14336)
> oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
> (256,256,14592)
> 
> Left edge raised:
> oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
> (5120,512,13312)
> oblomov@oblomov:~$ cat /sys/devices/platform/lis3lv02d/position
> (5632,512,13312)
> 
> You might be onto something.
Yes, beautiful! All are multiples of 2⁸, so much a sign of MSB/LSB
inversion! And the good news is that the device just happens to have a
register to set the endianess: CTRL2/BLE . For now, in the driver, we
expect the device to be little endian (which is the default according to
the manual). So at initialization we could force the endianess and see
if that fix the problem.

Can you try something like this in lis3lv02d_poweron():
	adev.read(handle, CTRL_REG2, &val);
	val |= CTRL2_BDU | CTRL2_IEN;
+	val &= ~CTRL2_BLE;
	adev.write(handle, CTRL_REG2, val);

Eric



--------------040908090902010704010001
Content-Type: text/x-vcard; charset=utf-8;
 name="E_A_B_Piel.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="E_A_B_Piel.vcf"

YmVnaW46dmNhcmQNCmZuO3F1b3RlZC1wcmludGFibGU6PUMzPTg5cmljIFBpZWwNCm47cXVv
dGVkLXByaW50YWJsZTpQaWVsOz1DMz04OXJpYw0Kb3JnOlRlY2huaWNhbCBVbml2ZXJzaXR5
IG9mIERlbGZ0O1NvZnR3YXJlIEVuZ2luZWVyaW5nIFJlc2VhcmNoIEdyb3VwDQphZHI6SEIg
MDguMDgwOztNZWtlbHdlZyA0O0RlbGZ0OzsyNjI4IENEO1RoZSBOZXRoZXJsYW5kcw0KZW1h
aWw7aW50ZXJuZXQ6RS5BLkIuUGllbEB0dWRlbGZ0Lm5sDQp0ZWw7d29yazorMzEgMTUgMjc4
IDYzMzgNCnRlbDtjZWxsOiszMSA2IDI0MzcgOTEzNQ0KeC1tb3ppbGxhLWh0bWw6RkFMU0UN
CnVybDpodHRwOi8vcGllbGVyaWMuZnJlZS5mcg0KdmVyc2lvbjoyLjENCmVuZDp2Y2FyZA0K
DQo=
--------------040908090902010704010001--
