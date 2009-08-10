Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbZHJVBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbZHJVBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 17:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbZHJVBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 17:01:37 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43544 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbZHJVBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 17:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=DWX9HotOo3byuF1/7EPVYPs/enhsW4heWXyGpib2oZZSRqvT5u/7KcNHPDV9svL/Tj
         jHUcBiem3qe3NSNQlQDfrOe/hCI+mEzPOSUIcPK6OwsQmt8H/8q/uX90WJbfLc+ggkCl
         64vETmgzZ3WoLZfA1MnpI99gTKAR6BhpW/3tc=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090810170338.GA14223@redhat.com>
References: <20090729221703.GA25368@redhat.com>
	 <20090730192040.GA9503@redhat.com> <1248984003.4164.0.camel@laptop>
	 <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins>
	 <20090731141122.a1939712.akpm@linux-foundation.org>
	 <7c86c4470908030553v5a0a4448p94ab612700d68066@mail.gmail.com>
	 <20090809054601.GA26152@shareable.org>
	 <7c86c4470908100522q44dc1228i315b29d69fc98da3@mail.gmail.com>
	 <20090810170338.GA14223@redhat.com>
Date: Mon, 10 Aug 2009 23:01:36 +0200
Message-ID: <7c86c4470908101401k49f42788o25eb1efaa631f065@mail.gmail.com>
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

On Mon, Aug 10, 2009 at 7:03 PM, Oleg Nesterov<oleg@redhat.com> wrote:
> On 08/10, stephane eranian wrote:
>>
>> You must use F_SETSIG on SIGIO if you want your signal handler to
>> receive the file descriptor in siginfo. This is useful if you want to perform
>> some actions on the descriptor. That is the case in perfmon and this is
>> the case in certain situations with perfcounters as well.
>>
>> Setting SA_SIGINFO provides siginfo, but the si_fd field is NOT set
>> correctly without F_SETSIG. I have verified this with perfcounters, and
>> this is indeed the case.
>>
>> This behavior seems kind of odd to me.
>
> Agreed, this looks a bit odd. But at least this is documented. From
> man 2 fcntl:
>
>        By using F_SETSIG with a nonzero value, and setting SA_SIGINFO for the
>        signal handler (see sigac- tion(2)), extra information about I/O events
>        is passed to the handler in a  siginfo_t  structure.  If  the si_code
>        field indicates the source is SI_SIGIO, the si_fd field gives the file
>        descriptor associated with the event.  Otherwise, there is no indication
>        which file descriptors are pending,
>
> Not sure if it is safe to change the historical behaviour.
>
Don't need to change it.
But for SIGIO, if you see SA_SIGINFO, then pass the si_fd.
>From Jamie, it seems F_SETSIG was not added just for this file descriptor trick.
The initial goal seems orthogonal to the file descriptor passing in si_fd.

> (the manpage is not exactly right though, and the comment in send_sigio_to_task()
>  is not right too: SI_SIGIO (and, btw, SI_QUEUE/SI_DETHREAD) is never used).
>
> Oleg.
>
>
