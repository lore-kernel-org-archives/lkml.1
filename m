Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbYGBQs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbYGBQs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 12:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbYGBQsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 12:48:17 -0400
Received: from chrocht.moloch.sk ([62.176.169.44]:44717 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbYGBQsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 12:48:16 -0400
Message-ID: <486BB14D.5060609@fastmq.com>
Date: Wed, 02 Jul 2008 18:48:13 +0200
From: Martin Sustrik <sustrik@fastmq.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Roger Heflin <rogerheflin@gmail.com>
CC: Martin Lucina <mato@kotelna.sk>, linux-kernel@vger.kernel.org
Subject: Re: Higher than expected disk write(2) latency
References: <20080628121131.GA14181@nodbug.moloch.sk> <48663873.5010200@gmail.com> <486921AD.8060308@fastmq.com> <48692DC0.6060904@gmail.com>
In-Reply-To: <48692DC0.6060904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

>> Fair enough. That exaplains the behaviour. Would AIO help here? If we 
>> are able to enqueue next write before the first one is finished, it 
>> can start writing it immediately without waiting for a revolution.
> 
> If you could get them queued at the disk level, things that would need 
> to be watched were if the disk can queue things up (and all 
> controllers/drivers support it), and how many things the disk can queue 
> up, and how large each of those things can be, if they aren't queued at 
> the disk, there is the chance that the machine cannot get the data to 
> the disk faster enough for that next sector.
> 
> I have always avoided fully sync operations as things *ALWAYS* got 
> really really slow because of all of the requirements need to make sure 
> that it always got the data to disk correctly on a unexpected crash, and 
> typically the type of applications I dealt with, if the machine crashed 
> the currently outputting data was known to be incomplete and generally 
> useless, so things were reran.
> 
> Depending on your application you could always get a small fast solid 
> state device (no seek or RPM issues), and use it to keep a journal that 
> could be replayed on an unexpected crash...and then just use various 
> syncs to force things to disk at various points.

We've tried AIO and the results are quite disappointing. If you open the 
file with O_SYNC, the latencies are the same as with sync I/O - each 
write takes 8.3ms (7500rpm disk).

If you use O_ASYNC the latencies are nice (160us mean), however, the 
first one is ~900us meaning that the data were not physically written to 
the disk before AIO confirmation is sent. (Moving head to right position 
would take much more than 900us.)

Still, my feeling is that our use case is pretty straightforward, i.e. 
write data to the disk with any optimisations you are able to do and 
notify me when the data are physically written to the medium.

Isn't there a way to achieve this kind of behaviour?

Martin
