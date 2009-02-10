Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbZBJXRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbZBJXRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 18:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbZBJXR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 18:17:29 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:21275 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbZBJXR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 18:17:28 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.579
Message-ID: <49920B01.4070103@tremplin-utc.net>
Date: Wed, 11 Feb 2009 00:17:21 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       Palatis Tseng <palatis@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>	 <498D9F02.9000107@tremplin-utc.net>	 <cb7bb73a0902071559w70b3367el9471db894872257f@mail.gmail.com>	 <20090209094748.GC4358@atrey.karlin.mff.cuni.cz>	 <cb7bb73a0902090153q30a5337bj45d41a3e3919e189@mail.gmail.com>	 <20090209095803.GD4358@atrey.karlin.mff.cuni.cz>	 <cb7bb73a0902090345y4ef5d544ta374ee96791a80df@mail.gmail.com>	 <cb7bb73a0902090533q3acc45b2r7d00b44aa0bdfc90@mail.gmail.com>	 <20090210101019.GB27018@atrey.karlin.mff.cuni.cz>	 <cb7bb73a0902101339g351bdd8cq442bafbeb7985a00@mail.gmail.com> <cb7bb73a0902101448h74b6b73j8307c65c4f006152@mail.gmail.com>
In-Reply-To: <cb7bb73a0902101448h74b6b73j8307c65c4f006152@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giuseppe Bilotta schreef:
> On Tue, Feb 10, 2009 at 10:39 PM, Giuseppe Bilotta
> <giuseppe.bilotta@gmail.com> wrote:
>> On Tue, Feb 10, 2009 at 11:10 AM, Pavel Machek <pavel@suse.cz> wrote:
>>> Yeah, that patch. Not sure what to do next... you could grab lis3
>>> manual and see if you can setup chip by hand to get better results...
>> As Eric pointed out, it looks definitely like an endianness problem,
>> although there are a few strange things which are happening at the
>> same time. Is the lis3 manual available online somewhere, or can I
>> request it to the mfgr?
> 
> 'k, found it on the STMicroelectronics website. Reading the doc about
> LIS3LV02DL I see that WHO_AM_I should return 3Ah, but my sensor
> returns 3Bh. I'll see if I find the correct datasheet for this one
> instead, it might have info about the differences.
Yeah, we accept also 3Bh for the who_am_i (see in hp_accel.c). The 
reporter who had a laptop with such chip never reported any problem and 
I didn't pay attention enough to notice those chips have only 8bits 
precision.

> One thing that I noticed is that (modulo axis inversion) I'm able to
> use the sensor correctly if I set the thing to only use the high byte,
> totally discarding the lower byte:
> 	return *((s8*)(&hi));
> Maybe this sensor needs a different setup to return 12 instead of 8
> bits of information.
So you probably have a lis202dl (which has only two axes of 8bits each) 
or a LIS302DL (3 axes of 8 bits):
http://www.st.com/stonline/products/literature/ds/13624/lis202dl.htm
http://www.st.com/stonline/products/literature/ds/12726/lis302dl.htm

Unfortunately, the WHO_AM_I register returns 3Bh in both cases. I'd tend 
to imagine it's a three axes chip, but you can confirm that by just 
checking if Z has any meaningful value. You can then modify 
lis3lv02d_read_16() to only return the byte as low byte and the high 
byte as FFh if the high bit of the value is set (because I guess they 
are signed integers). You also have to change MDPS_MAX_VAL to 128, to 
get things completely right.

Once we have this sorted, we should add a flag to know if the current 
device is 8 bits or 12 bits, depending on the value of who_am_i. This 
would allow the driver to work fine with both type of chip.

Eric
