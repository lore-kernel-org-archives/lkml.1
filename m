Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbZDVSIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbZDVSIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 14:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZDVSIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 14:08:32 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:41857 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbZDVSIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 14:08:31 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Apr 2009 14:08:31 EDT
Message-ID: <49EF5B05.6080402@mev.co.uk>
Date: Wed, 22 Apr 2009 18:59:33 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Roel Kluin <roel.kluin@gmail.com>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, Ian Abbott <ian.abbott@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       David Schleef <ds@schleef.org>
Subject: Re: staging: comedi: non working tests on unsigned cmd->convert_arg
References: <49EDC792.60100@gmail.com> <20090422165049.GC19524@kroah.com>
In-Reply-To: <20090422165049.GC19524@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/04/09 17:50, Greg KH wrote:
> On Tue, Apr 21, 2009 at 03:18:10PM +0200, Roel Kluin wrote:
>> vi drivers/staging/comedi/comedi.h +342
>>
>> and note that cmd->convert_arg in s626_ai_cmdtest() is unsigned. Should there
>> maybe be a test:
>>
>> if (cmd->convert_src == TRIG_EXT && cmd->convert_arg > MAX)
>>
>> (and what should MAX be then?)
> 
> I don't know.  Let's ask the comedi developers :)
> 
> Frank, what do you think about this?

Ian here.  I'd just delete that 'if' statement entirely as the test is
never true and it is followed by another 'if' statement that tests the
maximum value.

The similar 'if' statements that test cmd->start_arg < 0, and
cmd->scan_begin_arg < 0 can also be removed.

>> Otherwise you may want to apply the cleanup patch below
>>
>> Roel
>> ------------------------------>8-------------8<---------------------------------
>> Remove redundant tests on unsigned
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com> 
>> ---
>> diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
>> index 30dec9d..928c4c6 100644
>> --- a/drivers/staging/comedi/drivers/s626.c
>> +++ b/drivers/staging/comedi/drivers/s626.c
>> @@ -1906,7 +1906,7 @@ static int s626_ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s
>>  		err++;
>>  	}
>>  
>> -	if (cmd->convert_src == TRIG_EXT && cmd->convert_arg < 0) {
>> +	if (cmd->convert_src == TRIG_EXT) {
>>  		cmd->convert_arg = 0;
>>  		err++;
>>  	}

That should be:

-	if (cmd->convert_src == TRIG_EXT && cmd->convert_arg < 0) {
- 		cmd->convert_arg = 0;
- 		err++;
- 	}

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
