Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbXK1Jl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbXK1Jl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 04:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbXK1Jlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 04:41:46 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:48475 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbXK1Jlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 04:41:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LKJChNXwRMS/A2Gg+MZ94KPJ72tbVHJtoI7YexNdrL1K6XIoKkSxSN4jEjDMwMo8g2S8RsLeM7BrON171yu+493+f+dstihT5E+cfdH2sCIsQ9EunsdyU5wxJj1sCcAxcdB1O5ssQ1kkk+DQwHQKsx0DX72cMtR38q5Hp+HQ9Q4=
Message-ID: <787b0d920711280141v463759efod86395c50c1b47c5@mail.gmail.com>
Date: Wed, 28 Nov 2007 04:41:43 -0500
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Guillaume Chazarain" <guichaz@yahoo.fr>
Subject: Re: + proc-fix-the-threaded-proc-self.patch added to -mm tree
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       ebiederm@xmission.com, mingo@elte.hu, oleg@tv-sign.ru, rjw@sisk.pl,
       roland@redhat.com, xemul@openvz.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20071128014901.4b303954@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200711262339.lAQNdNrw029057@imap1.linux-foundation.org>
	 <20071128014901.4b303954@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 27, 2007 7:49 PM, Guillaume Chazarain <guichaz@yahoo.fr> wrote:
> akpm@linux-foundation.org wrote:
>
> > We may be stuck with the current broken behavior for backwards
> > compatibility reasons but lets try fixing our ancient bug for the 2.6.25
> > time frame and see if anyone screams.

It's not broken. It's just not the feature you're looking for.

> I'm not screaming because of this change, but I screamed when I
> discovered I could not have a replacement for gettid() in Java, or any
> other high level environment.

Java is so high-level that it seems inappropriate to touch /proc.
It is allowed for Java to do N:M threading you know.

> So, instead of making /proc/self an unstable interface that changed in
> 2.6.0 and 2.6.25, I'll vote for /proc/self/task/self. A new interface
> that can trivially be detected for existence, and programs relying on
> this interface will loudly break on older kernels, unlike with the
> proposed interface change.
>
> Ccing Albert Cahalan as he made the change to /proc/self in the first
> place:

Changing /proc/self is somewhat risky, and probably
undesirable anyway. That file has always been used
to represent the process; at one time this also meant
the task. Documentation everywhere says "process".

This one is probably best:
/proc/task -> 123/task/456
(with both numbers showing)

The problem with /proc/self/task/self is that it
makes /proc/789/task/self be ill-defined when
the observer is not tgid 789. If the directory can
only show up in the observer's own task directory,
then this solution is good.

I really don't want to see anything that would encourage
more use of the gdb backdoor. For those that don't
remember, gdb broke when access to threads via the
top-level /proc directory was temporarily removed.
We need that back door, unfortunately, but having it
show up in symlink targets is quite nasty.

As for the history:

I left it out. At the time it would have been fairly useless.
Back then, glibc didn't make things painful by pulling
phony thread IDs out of its ass. Shell scripts sure didn't
deal in threads. Monitoring tools like "ps" didn't need it.
If nothing needs it, well, why have it?

Regarding some of the discusison on LKML, I don't see
how unshare matters. If you unshare to the point where
you get a new TGID, then /proc/self must reflect that.
