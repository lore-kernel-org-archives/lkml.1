Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbZHQW0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbZHQW0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbZHQW0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:26:12 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:54166 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZHQW0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:26:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=qOuYUU2Apy4d74lZBPAQNtIW4V7l0JTNz8bK6zom15Ce6GUqv+ri/U8hWYY7WS6r7Q
         zsF96/kcaKq8PKX1zVvH2NuUZY/+JHK+P0Use8ywfTxWOPo/g/URHKG1xvo1yvo1fLmU
         mkeR8kd4PdtANKXH1P31f7E/EbV2RV9NyICz0=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090817171605.GB15907@redhat.com>
References: <20090730192040.GA9503@redhat.com>
	 <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins>
	 <20090731141122.a1939712.akpm@linux-foundation.org>
	 <7c86c4470908030553v5a0a4448p94ab612700d68066@mail.gmail.com>
	 <20090809054601.GA26152@shareable.org>
	 <7c86c4470908100522q44dc1228i315b29d69fc98da3@mail.gmail.com>
	 <20090810170338.GA14223@redhat.com>
	 <7c86c4470908101401k49f42788o25eb1efaa631f065@mail.gmail.com>
	 <20090817171605.GB15907@redhat.com>
Date: Tue, 18 Aug 2009 00:26:11 +0200
Message-ID: <7c86c4470908171526j60add584qfc635ba91cd4df46@mail.gmail.com>
Subject: Re: F_SETOWN_TID: F_SETOWN was thread-specific for a while
From: stephane eranian <eranian@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jamie Lokier <jamie@shareable.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg,

On Mon, Aug 17, 2009 at 7:16 PM, Oleg Nesterov<oleg@redhat.com> wrote:
> Sorry for late reply...
>
> On 08/10, stephane eranian wrote:
>>
>> On Mon, Aug 10, 2009 at 7:03 PM, Oleg Nesterov<oleg@redhat.com> wrote:
>> > On 08/10, stephane eranian wrote:
>> >>
>> >> You must use F_SETSIG on SIGIO if you want your signal handler to
>> >> receive the file descriptor in siginfo. This is useful if you want to perform
>> >> some actions on the descriptor. That is the case in perfmon and this is
>> >> the case in certain situations with perfcounters as well.
>> >>
>> >> Setting SA_SIGINFO provides siginfo, but the si_fd field is NOT set
>> >> correctly without F_SETSIG. I have verified this with perfcounters, and
>> >> this is indeed the case.
>> >>
>> >> This behavior seems kind of odd to me.
>> >
>> > Agreed, this looks a bit odd. But at least this is documented. From
>> > man 2 fcntl:
>> >
>> >        By using F_SETSIG with a nonzero value, and setting SA_SIGINFO for the
>> >        signal handler (see sigac- tion(2)), extra information about I/O events
>> >        is passed to the handler in a  siginfo_t  structure.  If  the si_code
>> >        field indicates the source is SI_SIGIO, the si_fd field gives the file
>> >        descriptor associated with the event.  Otherwise, there is no indication
>> >        which file descriptors are pending,
>> >
>> > Not sure if it is safe to change the historical behaviour.
>> >
>> Don't need to change it.
>
> Good,
>
>> But for SIGIO, if you see SA_SIGINFO, then pass the si_fd.
>
> But this means we do change the behaviour ;) Confused.
>
I meant do not remove F_SETSIG and its side-effect on si_fd.

>
> In any case. We should not look at SA_SIGINFO at all. If sys_sigaction() was
> called without SA_SIGINFO, then it doesn'matter if we send SEND_SIG_PRIV or
> siginfo_t with the correct si_fd/etc.
>
What's the official role of SA_SIGINFO? Pass a siginfo struct?

Does POSIX describe the rules governing the content of si_fd?
Or is si_fd a Linux-ony extension in which case it goes with F_SETSIG.

> And again, this is even documented. The change is trivial but user-space
> visible, it may confuse the (stupid) app which uses SIGIO + SA_SIGINFO
> without F_SETSIG.
>
That would be an app that uses SIGINFO and fiddles with si_fd which has no
defined content. What kind of app would that be?

It would seem natural that in the siginfo passed to the handler of SIGIO, the
file descriptor be passed by default. That is all I am trying to say here.
