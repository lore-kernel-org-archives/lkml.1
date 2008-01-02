Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbYABEZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbYABEZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 23:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbYABEZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 23:25:33 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:49364 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbYABEZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 23:25:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hncOd3LO02Y8yhUsn8JjqBrMlKNgxPz9w5yGBMImijPUsqlXn4fQ4XrgcBefwnqs1t4NfIqlgBD3TlHXR8O0ns3Sx87/wJYRMM+OQDJUaViDqfG9Po6rOJdntEASm+nUwdAixX6xjzed8mt6kS0B3Fl8VLIqKmifiAWIneDpBC8=
Message-ID: <477B1233.3090706@gmail.com>
Date: Wed, 02 Jan 2008 13:25:23 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Gabor Gombas <gombasg@sztaki.hu>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, kluo@nvidia.com, AMartin@nvidia.com,
       pchen@nvidia.com
Subject: Re: sata_nv + ADMA + Samsung disk problem
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu> <20080101164416.GA29574@boogie.lpds.sztaki.hu> <477B0429.7040909@gmail.com> <477B0CFD.1030603@shaw.ca> <477B10F2.9000107@shaw.ca>
In-Reply-To: <477B10F2.9000107@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>> This is kind of a longstanding problem which has been partially worked
>> around, but it seems not entirely. This is what I had diagnosed some
>> time ago:
>>
>> "recently, some issues cropped up with command timeouts when a cache
>> flush command was immediately followed by an NCQ write. In this case,
>> sometimes when the NCQ write was issued, the status register changed
>> from 0x500 (Stopped and Idle) to 0x400 (Stopped) as it normally
>> appears to, however it seems like the controller would get hung in
>> that state, and we would time out with no notifiers set, the gen_ctl
>> register not indicating interrupt status, and the CPB response flags
>> still 0 as we left them, seemingly indicating the controller hasn't
>> done anything with it. Then, when the error handler kicks in we clear
>> the GO bit to put it back into register mode, but the Legacy flag in
>> the status register doesn't get set (or at least it takes longer than
>> 1 microsecond). Finally when we do an ADMA channel reset that seems to
>> get it responding again, until this happens the next time.
>>
>>  From some experimentation, I found that when we are issuing a NCQ
>> command when the last command was non-NCQ, or vice versa, if I added in
>> a delay of 20 microseconds between setting up the CPB and writing to the
>> append register, the problem appeared to go away. Problem is I don't
>> know if that's because it actually needs this delay, or because it
>> changes the timing so that it happens to work even though we're doing
>> something wrong, there's some event we're not waiting for, etc.
>>
>> I've now verified that no switches between ADMA and register mode
>> occur near the time of these timeouts. Neither are we reading or
>> writing any of the ATA shadow registers while we're in ADMA mode."
>>
>> It seems likely that this is what is happening here (a switch from an
>> NCQ command to a non-NCQ command, then the non-NCQ times out). It
>> could be in some cases the 20 microsecond delay is not enough. But it
>> seems bogus that we should need such an arbitrary delay in the first
>> place.
>>
>> The question I had for NVIDIA regarding this that I never got answered
>> was, is there any reason why we would need a delay when switching
>> between NCQ and non-NCQ commands on ADMA, and if not, is there any
>> known cause that could cause the controller to get into this seemingly
>> locked-up state?
> 
> Well, I guess I did sort of get an answer, but the only theory was that
> the flush and the NCQ commands were being overlapped, which shouldn't be
> possible (the libata core guarantees that, and if it didn't work it
> would affect all controllers).
> 
> I'm kind of wondering if there's something funny going on with the
> notifier register stuff, which is supposed to tell us what commands have
> completed. We don't really use it at all (we had some problems with
> missed completions, etc. when I tried using it, also it doesn't work if
> ATAPI is enabled on the other port on the controller, apparently). I
> know these controllers will do strange things like not signalling
> interrupts for later events if you don't clear the notifiers in just the
> right way (that being mostly determined by trial and error).
> 
> Or, maybe somehow the flush is getting issued before the controller is
> really "ready" for it somehow (it's not finished cleaning up after
> preceding NCQ command).
> 
> It's pretty hard for me to figure out which of the above might be the
> case, especially without access to the detailed controller documentation..

Thanks a lot for the detailed explanation.  Nvidia ppl, any ideas?
FLUSH is used regularly.  We really need to fix this.

-- 
tejun
