Return-Path: <linux-kernel-owner+w=401wt.eu-S1759122AbYDKIBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122AbYDKIBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbYDKIBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:01:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:16800 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520AbYDKIBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BoTBGfBJsL6yKy8PpGNsrdSVTYPBboEwCb/8Ohv/5yvgWqW7aLHdwrF0Rf8fOjRS+K/jz0UIzm45xhBknBRsONrNIHeH9XfQE/U1zmfYa9oE0IH06E73eAHDtR/LRdGtRLSlMFp+teYT4vPlm3npKo8ZcK57FVf0E7r6X2jIlNI=
Message-ID: <517f3f820804110101n595fb901rae58da6badb64a55@mail.gmail.com>
Date: Fri, 11 Apr 2008 10:01:30 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] proc: Add RLIMIT_RTTIME to /proc/<pid>/limits
Cc: "Michael Kerrisk" <mtk.manpages@googlemail.com>,
       "Eugene Teo" <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
       "Neil Horman" <nhorman@tuxdriver.com>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1207899930.7074.23.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080208145950.GA3910@kernel.sg> <1202483445.6292.1.camel@lappy>
	 <517f3f820802280712o3d756b4fq46461b226515e1f2@mail.gmail.com>
	 <1204212100.12120.9.camel@twins>
	 <cfd18e0f0802280744q18ccad3at3c88bac166806118@mail.gmail.com>
	 <1204213821.12120.15.camel@twins>
	 <cfd18e0f0804110038q3b7740c9q1a96858d9531ab92@mail.gmail.com>
	 <1207899930.7074.23.camel@twins>
X-Google-Sender-Auth: cd1d804e2ddaf848
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/08, Michael Kerrisk <mtk.manpages@googlemail.com> wrote:
> On Thu, Feb 28, 2008 at 5:50 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  >
>  > On Thu, 2008-02-28 at 16:44 +0100, Michael Kerrisk wrote:

[...]

>  > I've been testing this patch.  Above you seemed to be saying that
>  > doing a sched_yield() would be equivalent to a sleep, causing the rt
>  > counter to be reset to zero.  Howver, the results I'm seeing suggest
>  > that a sched_yield() does not cause the counter to be reset to zero
>  > (i.e., despite calling sched_yield() at frequent intervals, the
>  > process still encounters the RLIM_RTTIME soft limit and gets SIGXCPU).
>  >  Can you comment?
>
>
> It appears you are right. I must have been staring at something else
>  than code when I said that :-(, yield() will indeed _not_ reset the
>  counter.
>
>  Now, I think it makes some sense to reset it, because we do try to play
>  nice by calling yield. OTOH we don't actually block and become
>  unrunnable - we'll still be contending for CPU time.

On the one hand, it seems reasonable to reset the counter.  The POSIX
definition of sched_yield() says that it "shall force the running
thread to relinquish the processor until it again becomes the head of
its thread list".

On the other hand, what if this is the only runnable real-time
process?  Then sched_yield() is effectively a no-op, and a runaway
process could lock up the system (which I gather is what RLIMIT_RTTIME
was primarily designed to prevent).

I don't really have a strong leaning either way about what should be
done, other than that we should probably make a specific choice, and
document it in the setrlimit(2) man page.

Cheers,

Michael
-- 
I'll likely only see replies if they are CCed to mtk.manpages at gmail dot com
