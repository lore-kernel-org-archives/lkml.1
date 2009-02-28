Return-Path: <linux-kernel-owner+w=401wt.eu-S1763360AbZB1B4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763360AbZB1B4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762295AbZB1Bx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:53:29 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:4108 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762270AbZB1BxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:53:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=EhhDX4vXWIGOEVz5p/n9tW4RhW7k02r5VBROpEL4BNZgD++jlNq6Gse8LQ23ClwQat
         GT3mgSZDmlhJ5VsKGk6n/N57kGwD7ca057DzX8qQJeNCab0VO4ZRcNzmxwcq/EYwZjIG
         2A7d7DxIVPhhXAdOBeE45gkDb07JQ/UvW6Xc4=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <alpine.LFD.2.00.0902262311350.9135@localhost.localdomain>
References: <20090226133339.875832967@linutronix.de>
	 <cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577@mail.gmail.com>
	 <alpine.LFD.2.00.0902262311350.9135@localhost.localdomain>
Date: Sat, 28 Feb 2009 14:53:23 +1300
Message-ID: <cfd18e0f0902271753ld9b432tae6c0ee783a24480@mail.gmail.com>
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall [RESEND]
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Linux API <linux-api@vger.kernel.org>, drepper@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On 2/27/09, Thomas Gleixner <tglx@linutronix.de> wrote:
> Michael,
>
> On Fri, 27 Feb 2009, Michael Kerrisk wrote:
>> I haven't looked at this iteration of the patch, to check if it is
>> different from the version you posted a few months ago.  I assume it
>> isn't different, since you didn't mention any differences.  In that
>> case, there are still the questions I raised back then, so I'll just
>> repeat them now.
>
> Right, no fundamental changes.
>
>> Back in October, I did some testing of this interface.  Two potential
>> issues that I saw, both of which relate to inconsistencies with
>> rt_sigqueueinfo():
>>
>> 1) With rt_siqueueinfo(), we can get the PID (TGID) of the sender,
>> which enables the receiver of the signal to know who the sender was,
>> and perhaps use that information to (for example) send a signal in the
>> other direction.
>>
>> With rt_tgsigqueueinfo(), we don't quite have that ability: all that
>> the receiver gets is the TGID of the sender, not the TID.  This means
>> that we can't (for example) send a signal back to the precise thread
>> that signaled us. I'm not sure if this matters or not (but perhaps it
>> might when sender and receiver are in the same process?).  I'm also
>> not sure whether we want to do anything about this (i.e., extending
>> siginfo_t to include a si_tid field), but I wanted to point out this
>> assymetry w.r.t. to rt_sigqueueinfo(), in case you had not considered
>> it.
>>
>> 2) With rt_sigqueueinfo(), we can specify the si_pid and and si_uid
>> fields that should be sent to the receiver.  This is not possible with
>> rt_tgsigqueueinfo(), which always supplied the caller';s PID and UID
>> in the si_pid and si_uid fields sent to the receiver.  See the
>> following, created using my test programs below (the 111 & 222
>> arguments to t_*sigqueueinfo set the si_pid and si_uid fields in the
>> siginfo_t given to the *sigqueueinfo() syscall):
>
> I can see your concern, but I have no strong opinion in either
> direction.
>
> Roland ??

The more I think about these two points, the more it seems to me they
both should be fixed.  Roland seems to concur on at least the second
point.  (Probably Ulrich should also be CCed for input -- done now.)
With respect to the first point, it seems to me reasonably likely that
there would be use cases where the receiving thread wants to know the
thread ID of the sender -- especially when sender and receiver are in
the same process.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
