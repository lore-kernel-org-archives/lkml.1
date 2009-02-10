Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbZBJXey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbZBJXey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 18:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbZBJXep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 18:34:45 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:22142 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446AbZBJXep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 18:34:45 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.579
Message-ID: <49920F0A.9060904@tremplin-utc.net>
Date: Wed, 11 Feb 2009 00:34:34 +0100
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
Ah, yes, that would explain a lots of things! Your chip is 8bits! The 
original reporter had not reported anything and I didn't pay attention 
to this "little" detail when comparing the specs.


> One thing that I noticed is that (modulo axis inversion) I'm able to
> use the sensor correctly if I set the thing to only use the high byte,
> totally discarding the lower byte:
> 	return *((s8*)(&hi));
> Maybe this sensor needs a different setup to return 12 instead of 8
> bits of information.
So you either have the lis302dl or the lis202dl (2 axes only):
http://www.st.com/stonline/products/literature/ds/12726/lis302dl.htm
http://www.st.com/stonline/products/literature/ds/13624/lis202dl.htm

I'd guess you have the one with 3 axes as all the axes had changing 
values. More optimistically I'll imagine that no HP laptop has the 2D 
chip, which unfortunately share the same who_am_i value.

So to get it working you need to change the lis3lv02d_read_16() function 
to only read the low byte and put the high byte to FFh if the high bit 
(80h) is set (I guess it's a signed integer). Then for completeness you 
need to put MDPS_MAX_VAL to 128.

Does it work?

Once this is verified, you should add a flag in the driver for the 
device to know whether it's 8bits or 12bits. This would be set at 
initialization according to the who_am_i value.

Eric
