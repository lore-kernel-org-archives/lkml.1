Return-Path: <linux-kernel-owner+w=401wt.eu-S1752544AbZIIAaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbZIIAaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 20:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZIIAaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 20:30:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42232 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbZIIAa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 20:30:29 -0400
Message-ID: <4AA6F63F.7090009@zytor.com>
Date: Tue, 08 Sep 2009 17:26:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] char/tty_io: fix legacy pty name when more than 256
 pty devices are requested
References: <20090908144942.76ddf0e7@caramujo.chehab.org>	<4AA6DF50.3030603@zytor.com> <20090908203323.486c129c@caramujo.chehab.org>
In-Reply-To: <20090908203323.486c129c@caramujo.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 04:33 PM, Mauro Carvalho Chehab wrote:
> 
>> If you're going to do this, I would suggest using the following
>> namespace, as such:
>>
>> 	[pt]ty[p-za-e][0-9a-f]+
> 
> To be backward compatible, the format should be, at least:
> 
>  	[pt]ty[p-za-e][0-9a-f].+
> 
> otherwise, it can potentially break backward compatibility, as the first 10 devices will be like:
> 	/dev/ttyp0
> 	/dev/ttyp1
> 	...
> 
> instead of:
> 
> 	/dev/ttyp00
> 	/dev/ttyp01
> 

Correct.  You're missing the point: if you follow my recipe, the legacy
names fall out of the same algorithm.  The first 256 will have the
traditional names, fully compatible, the 256th entry will be
/dev/ttyp10, and so on.

>>
>> 	sprintf(name, "%cty%c%x", slave ? 't' : 'p',
>> 		"pqrstuvwxyzabcde"[(index >> 4) & 15],
>> 		((index >> 4) & ~15) | (index & 15));
> 
> We may use this, instead:
> 
>  	sprintf(name, "%cty%c%02x", slave ? 't' : 'p',
>  		"pqrstuvwxyzabcde"[(index >> 4) & 15],
>  		((index >> 4) & ~15) | (index & 15));
> 
>> No arbitrary limits, and it still extends the existing namespace with
>> some reasonable continuity.  It means bits [7:4] are weirdly encoded,
>> but we get straightforward backwards compatibility as a result.
> 
> But it will also be a little more weird.

IMO, no less weird than a random shift from one naming algorithm to
another in the middle of the sequence.

	-hpa
