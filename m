Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbYABED0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbYABED0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 23:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbYABEDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 23:03:16 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:37112 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbYABEDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 23:03:15 -0500
Date: Tue, 01 Jan 2008 22:03:09 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv + ADMA + Samsung disk problem
In-reply-to: <477B0429.7040909@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Gabor Gombas <gombasg@sztaki.hu>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, kluo@nvidia.com, AMartin@nvidia.com,
       pchen@nvidia.com
Message-id: <477B0CFD.1030603@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu>
 <20080101164416.GA29574@boogie.lpds.sztaki.hu> <477B0429.7040909@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> [cc'ing Robert Hancock and NVidia people]
> 
> Whole thread can be read from the following URL.
> 
>   http://thread.gmane.org/gmane.linux.ide/21710
> 
> In a nutshell, with ADMA enabled, FLUSH_EXT occasionally times out.  I
> first suspected faulty disk (reallocation failure on flush) but SMART
> reports nothing suspicious and w/ ADMA disabled, the drive works just fine.
> 
> On a side note, on 2.6.22.1, SMART fails from time to time but the
> problem went away on 2.6.24-rc6.  This was apparently fixed during that
> period.  I guess we can ignore this for now.
> 
> Thanks.

This is kind of a longstanding problem which has been partially worked 
around, but it seems not entirely. This is what I had diagnosed some 
time ago:

"recently, some issues cropped up with command timeouts when a cache 
flush command was immediately followed by an NCQ write. In this case, 
sometimes when the NCQ write was issued, the status register changed 
from 0x500 (Stopped and Idle) to 0x400 (Stopped) as it normally appears 
to, however it seems like the controller would get hung in that state, 
and we would time out with no notifiers set, the gen_ctl register not 
indicating interrupt status, and the CPB response flags still 0 as we 
left them, seemingly indicating the controller hasn't done anything with 
it. Then, when the error handler kicks in we clear the GO bit to put it 
back into register mode, but the Legacy flag in the status register 
doesn't get set (or at least it takes longer than 1 microsecond). 
Finally when we do an ADMA channel reset that seems to get it responding 
again, until this happens the next time.

 From some experimentation, I found that when we are issuing a NCQ
command when the last command was non-NCQ, or vice versa, if I added in
a delay of 20 microseconds between setting up the CPB and writing to the
append register, the problem appeared to go away. Problem is I don't
know if that's because it actually needs this delay, or because it
changes the timing so that it happens to work even though we're doing
something wrong, there's some event we're not waiting for, etc.

I've now verified that no switches between ADMA and register mode occur 
near the time of these timeouts. Neither are we reading or writing any 
of the ATA shadow registers while we're in ADMA mode."

It seems likely that this is what is happening here (a switch from an 
NCQ command to a non-NCQ command, then the non-NCQ times out). It could 
be in some cases the 20 microsecond delay is not enough. But it seems 
bogus that we should need such an arbitrary delay in the first place.

The question I had for NVIDIA regarding this that I never got answered 
was, is there any reason why we would need a delay when switching 
between NCQ and non-NCQ commands on ADMA, and if not, is there any known 
cause that could cause the controller to get into this seemingly 
locked-up state?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

