Return-Path: <linux-kernel-owner+w=401wt.eu-S1763809AbZDABRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763809AbZDABRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758478AbZDABQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:16:50 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:61745 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbZDABQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=gI8G1GxnYCgysYzcP6zKDaM8e9BqCtyhTJprLxxKOn9Tj+Gt5CJzuC8eCc3l7xenq3
         r3L+3uTEqyrAklRl+3Ex2Ju71Pw/7jDqvdgIGbbs68kmCtu63bZIrtd1HQPgzA97PmCp
         a07DGRcGbkq9LEfKaq19hIabPMvzOx+QpUKsQ=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20090331152610.GC4792@redhat.com>
References: <20090324102516.459441533@linutronix.de>
	 <20090331152610.GC4792@redhat.com>
Date: Wed, 1 Apr 2009 14:16:46 +1300
Message-ID: <cfd18e0f0903311816p27a7b8c3jd62e563f4c95299e@mail.gmail.com>
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall -V2
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 1, 2009 at 4:26 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 03/24, Thomas Gleixner wrote:
>>
>> sys_kill has a counterpart sys_tgkill which allows to send signals to
>> a particular thread. sys_rt_sigqueueinfo is lacking such a counterpart.
>>
>> Aside of the asymetry it is a show stopper for migrating applications
>> from other unix-alike RTOSes.
>>
>> The following patch series implements rt_tgsigqueueinfo and hooks it
>> up for x86.
>>
>> Changes since V1:
>>     - match rt_siqqueueinfo and rt_tgsigqueueinfo handling of
>>       info.si_pid/si_uid
>
> I think this all is correct. And I think "Changes since V1" are good,
> rt_tgsigqueueinfo() should not play with si_pid/si_uid.
>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>

I had two concerns with earlier iteraions of this patch (
http://thread.gmane.org/gmane.linux.kernel/799866/focus=667 ):

[[
1) With rt_siqueueinfo(), we can get the PID (TGID) of the sender,
which enables the receiver of the signal to know who the sender was,
and perhaps use that information to (for example) send a signal in the
other direction.

With rt_tgsigqueueinfo(), we don't quite have that ability: all that
the receiver gets is the TGID of the sender, not the TID.  This means
that we can't (for example) send a signal back to the precise thread
that signaled us. I'm not sure if this matters or not (but perhaps it
might when sender and receiver are in the same process?).  I'm also
not sure whether we want to do anything about this (i.e., extending
siginfo_t to include a si_tid field), but I wanted to point out this
assymetry w.r.t. to rt_sigqueueinfo(), in case you had not considered
it.

2) With rt_sigqueueinfo(), we can specify the si_pid and and si_uid
fields that should be sent to the receiver.  This is not possible with
rt_tgsigqueueinfo(), which always supplied the caller';s PID and UID
in the si_pid and si_uid fields sent to the receiver.  See the
following, created using my test programs below (the 111 & 222
arguments to t_*sigqueueinfo set the si_pid and si_uid fields in the
siginfo_t given to the *sigqueueinfo() syscall):
]]

Roland pointed out that the first problem could be dealt with via the
sigval associated with the signal.

The second problem is addressed by this change:

>> Changes since V1:
>>     - match rt_siqqueueinfo and rt_tgsigqueueinfo handling of
>>       info.si_pid/si_uid

I've tested this version of the interface (using the programs shown in
the mail thread referred to above), and it works as I expect, and I
find the design otherwise sane, so:

Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Tested-by: Michael Kerrisk <mtk.manpages@gmail.com>

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
