Return-Path: <linux-kernel-owner+w=401wt.eu-S933364AbYDQRt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364AbYDQRt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756373AbYDQRtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:49:21 -0400
Received: from smtp-out.google.com ([216.239.33.17]:55789 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbYDQRtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:49:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ZeTWotr6fG//+qHvv3DymCR1vd/gcFLJ9bA0UecfxrEFuik703tUNHu0u5hU237Yr
	bacYJF4558LkFu7beLNoA==
Message-ID: <6599ad830804171049p522d8167yc24b5cae79ae2fdd@mail.gmail.com>
Date: Thu, 17 Apr 2008 10:49:06 -0700
From: "Paul Menage" <menage@google.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [Fwd: [-mm] Add an owner to the mm_struct (v9)]
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, serue@us.ibm.com,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
In-Reply-To: <20080417161936.GB4482@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48036677.3010807@linux.vnet.ibm.com>
	 <20080414170709.736819b6.akpm@linux-foundation.org>
	 <20080415171359.GA352@tv-sign.ru>
	 <6599ad830804151113i73010bb4x48e658195f295d41@mail.gmail.com>
	 <20080415195950.GA113@tv-sign.ru>
	 <4806C633.3000302@linux.vnet.ibm.com>
	 <20080417113000.GB103@tv-sign.ru>
	 <6599ad830804170934i6df9fe42kd979492babe03be@mail.gmail.com>
	 <20080417161936.GB4482@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 9:19 AM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> On 04/17, Paul Menage wrote:
>  >
>  > On Thu, Apr 17, 2008 at 4:30 AM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
>  > >  >
>  > >  > I had this loop earlier (inspired from zap_threads()), is this loop more
>  > >  > efficient than what we have?
>  > >
>  > >  All sub-threads have the same ->mm. Once we see that c->mm != mm, we don't
>  > >  need to waste CPU iterating over the all other threads in the thread group.
>  >
>  > Technically they don't have to have the same mm, right? You can use
>  > CLONE_THREAD without CLONE_VM when creating a new subthread.
>
>  No, no, this is not possible/allowed.
>
>  Please look at copy_process, CLONE_THREAD requires CLONE_SIGHAND,
>  CLONE_SIGHAND needs CLONE_VM.

Ah, OK. I saw that CLONE_THREAD -> CLONE_SIGHAND but I didn't notice
the second implication. That would mean that your optimization is
valid, good.

>
>  Let's suppose 2 task belongs to different cgroups, but share ->mm,
>
>
>  > - swap cgroup - when swapping from an mm, find a task whose swap
>  > cgroup we can charge the swap page to
>
>  now we will charge the somewhat "random" cgroup. The one to which
>  the result of the last "find the next suitable owner" belongs.

Correct. (Although if two tasks are sharing an mm, charging either of
them seems perfectly fair, as long as we charge exactly one of them
and remember who we charged).

>
>  This looks a bit strange to me... but OK, as I said, I don't know
>  what cgroup is, please ignore me ;)

A control group is just a way of grouping tasks together for the
purposes of resource control, isolation, etc.

Yes, weird things can potentially happen in this case - if the user
sets up situations like this, hopefully they know what they're doing.
The important thing is that these weird setups not crash.

Paul
