Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbXJZWAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbXJZWAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbXJZWAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:00:14 -0400
Received: from smtp-out.google.com ([216.239.45.13]:34537 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbXJZWAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:00:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=hRq/CIFX0FEoXm5lYiMgBexnMFOB4N8LGVY6ip1mLdedstQK2qixmQXqSXUW0r9uU
	6VSUU893pUTaSCSIJMtew==
Message-ID: <4722635D.901@google.com>
Date: Fri, 26 Oct 2007 14:59:57 -0700
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jason Uhlenkott <jasonuhl@jasonuhl.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/1] Drop CAP_SYS_RAWIO requirement for FIBMAP
References: <20071025230758.945535769@crlf.corp.google.com> <20071026012217.4cc30390@the-village.bc.nu> <20071026215550.GA27037@aurum.uhlenkott.net>
In-Reply-To: <20071026215550.GA27037@aurum.uhlenkott.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Uhlenkott wrote:
> On Fri, Oct 26, 2007 at 01:22:17 +0100, Alan Cox wrote:
>> On Thu, 25 Oct 2007 16:06:40 -0700
>> Mike Waychison <mikew@google.com> wrote:
>>
>>> Remove the need for having CAP_SYS_RAWIO when doing a FIBMAP call on an open file descriptor.
>>>
>>> It would be nice to allow users to have permission to see where their data is landing on disk, and there really isn't a good reason to keep them from getting at this information.
>> Historically this was done because people felt it was more secure. It
>> also allows you to make some deductions about other activities on the
>> disk but thats probably only a concern for very very security crazed
>> compartmentalised boxes
>>
>> Also historically at least FIBMAP could be abused to crash the system.
>> Now if you can verify that has been fixed I have no problem, but given
>> that I can find no record of that being fixed it would be wise to audit
>> it first and review Chris Evans and other reports about what occurs when
>> FIBMAP is passed random block numbers.
>>
>> FIBMAP has another problem for this general use as well - it takes an int
>> but the block number can now be bigger for very large files on 32bit.
> 
> Additionally, ext3_bmap() has this to say about it:
> 
>         if (EXT3_I(inode)->i_state & EXT3_STATE_JDATA) {
>                 /*
>                  * This is a REALLY heavyweight approach, but the use of
>                  * bmap on dirty files is expected to be extremely rare:
>                  * only if we run lilo or swapon on a freshly made file
>                  * do we expect this to happen.
>                  *
>                  * (bmap requires CAP_SYS_RAWIO so this does not
>                  * represent an unprivileged user DOS attack --- we'd be
>                  * in trouble if mortal users could trigger this path at
>                  * will.)

Hmm.  I don't know what the right approach to this is.  This seems to be 
the same situation as the delayed allocation problem, no?

What if we just returned 0?  Tools like lilo are already doing sync(), 
would that cause the journal to get flushed explicitly anyway?

Mike Waychison
