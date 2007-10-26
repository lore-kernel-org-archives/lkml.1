Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbXJZWxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbXJZWxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbXJZWxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:53:40 -0400
Received: from smtp-out.google.com ([216.239.45.13]:55982 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbXJZWxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:53:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=uoi7Ldw3zQ88SmvmbUgDAufEJkU49t7JNUd/IEJD1Ju8M5jXR+5YWaCyjskrjcUOl
	7amSc2ph83FYUHDF40IgQ==
Message-ID: <47226FE9.6060705@google.com>
Date: Fri, 26 Oct 2007 15:53:29 -0700
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jason Uhlenkott <jasonuhl@jasonuhl.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/1] Drop CAP_SYS_RAWIO requirement for FIBMAP
References: <20071025230758.945535769@crlf.corp.google.com> <20071026012217.4cc30390@the-village.bc.nu> <20071026215550.GA27037@aurum.uhlenkott.net> <4722635D.901@google.com> <20071026224035.GB27037@aurum.uhlenkott.net>
In-Reply-To: <20071026224035.GB27037@aurum.uhlenkott.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Uhlenkott wrote:
> On Fri, Oct 26, 2007 at 14:59:57 -0700, Mike Waychison wrote:
>> Jason Uhlenkott wrote:
>>> Additionally, ext3_bmap() has this to say about it:
>>>
>>>        if (EXT3_I(inode)->i_state & EXT3_STATE_JDATA) {
>>>                /*
>>>                 * This is a REALLY heavyweight approach, but the use of
>>>                 * bmap on dirty files is expected to be extremely rare:
>>>                 * only if we run lilo or swapon on a freshly made file
>>>                 * do we expect this to happen.
>>>                 *
>>>                 * (bmap requires CAP_SYS_RAWIO so this does not
>>>                 * represent an unprivileged user DOS attack --- we'd be
>>>                 * in trouble if mortal users could trigger this path at
>>>                 * will.)
>> Hmm.  I don't know what the right approach to this is.  This seems to be 
>> the same situation as the delayed allocation problem, no?
> 
> Yup.
> 
>> What if we just returned 0?  Tools like lilo are already doing sync(), 
>> would that cause the journal to get flushed explicitly anyway?
> 
> Not sure, but I'd be pretty nervous about breaking any existing users
> which aren't explicitly syncing.

True.   We can probably get away with an implicit flush when 
CAP_SYS_RAWIO is set, but that's pretty gross :(

> 
> Are you envisioning users who want to see where their data is landing
> for performance reasons?  It seems like such users are going to have
> sufficiently different desires from existing FIBMAP users (who need to
> know where everything is because they intend to fiddle with the raw
> device) that a different interface might be warranted.

A little of both ;)

We could introduce a new API, though either way, the same fundamental 
problems apply wrt auditing.

I see three reasons that new APIs are warranted:

a) to deal with block numbers > 2^31 --> FIBMAP64
b) to have a path where no syncing is required due to worries about user 
DoS (delayed allocation / data in journal).
c) possibly some way to FIBMAP a range so that userspace doesn't need to 
syscall for each block, something like how mincore() does it?

I have a patchset ready that I'll send out shortly that introduces 
FIBMAP64.  The last patch in that set drops the CAP_SYS_RAWIO, but it's 
probably not what we want given DoS case.  I'd like to send it out 
anyway to get some comments on some of the sanity checks and locking I'm 
adding.

Handling (c) above is just extra sugar and isn't something I'm too 
worried about implementing.

Mike Waychison
