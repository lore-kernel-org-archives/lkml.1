Return-Path: <linux-kernel-owner+w=401wt.eu-S934144AbXC0SSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144AbXC0SSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934146AbXC0SSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:18:12 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:42803 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934143AbXC0SSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:18:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:in-reply-to:references:mime-version:content-type:message-id:cc:content-transfer-encoding:subject:date:to:x-mailer:from;
        b=O4ZeIG+U7JEb1+ju8VAW/SNadphKUjxZvkdEA4hGHjllF5ngwpixOpvomsYbtGmOQ4dG/wTqYSEeOCpNHZPt+Jy0lo1NAF6X4BXY7ZvFonuyZFZfD5FA7kZXVq8jPhgvGqpPFt0hcO47zYcDj15W789oQnOD6Ti7IpuFrgQ9rOA=
In-Reply-To: <4608B2B9.7090503@garzik.org>
References: <Pine.LNX.4.64.0703241232580.11608@p34.internal.lan> <4608B2B9.7090503@garzik.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=WINDOWS-1252; delsp=yes; format=flowed
Message-Id: <ACBD2F44-03C7-49BE-9A2F-ABF7078BCC5E@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
Date: Tue, 27 Mar 2007 13:18:05 -0500
To: Jeff Garzik <jeff@garzik.org>
X-Mailer: Apple Mail (2.752.2)
From: Mark Rustad <mrustad@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 27, 2007, at 12:59 AM, Jeff Garzik wrote:

> Justin Piszcz wrote:
>> Without NCQ, performance is MUCH better on almost every operation,  
>> with the exception of 2-3 items.
>
> Variables to take into account:
>
> * the drive (NCQ performance wildly varies)
> * the IO scheduler
> * the filesystem (if not measuring direct to blkdev)
> * application workload (or in your case, benchmark tool)
> 	* in particular, the threaded-ness of the apps
>
> For the overwhelming majority of combinations, NCQ should not / 
> hurt/ performance.
>
> For the majority of combinations, NCQ helps (though it may not be  
> often that you use more than 4-8 tags).
>
> In some cases, NCQ firmware may be broken.  There is a Maxtor  
> firmware id, and some Hitachi ids that people are leaning towards  
> recommending be added to the libata 'horkage' list.

Some other variables that we have noticed: Some drive firmware goes  
into "stupid" mode when write cache is turned off. Meaning that it  
does not reorder any queued operations. Of course if you really care  
about your data, you don't really want to turn write cache on.

Also the controller used can have unfortunate interactions. For  
example the Adaptec SAS controller firmware will never issue more  
than two queued commands to a SATA drive (even though the firmware  
will happily accept more from the driver), so even if an attached  
drive is capable of reordering queued commands, its performance is  
seriously crippled by not getting more commands queued up. In  
addition, some drive firmware seems to try to bunch up queued command  
completions which interacts very badly with a controller that queues  
up so few commands. In this case turning NCQ off performs better  
because the drive knows it can't hold off completions to reduce  
interrupt load on the host – a good idea gone totally wrong when used  
with the Adaptec controller.

Today SATA NCQ seems to be an area where few combinations work well.  
It seems so bad to me that a whitelist might be better than a  
blacklist. That is probably overstating it, but NCQ performance is  
certainly a big problem.

-- 
Mark Rustad, MRustad@gmail.com


