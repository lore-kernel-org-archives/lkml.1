Return-Path: <linux-kernel-owner+w=401wt.eu-S1031495AbXHMRfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031495AbXHMRfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S973748AbXHMRb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:31:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:47480 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S973738AbXHMRb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rqyeuoF8xXQw4qmPfdTK2GSN5ZmLvJcM6K6kcyElMQiVQ2hNi+mNvks9d/GDVeCR1vMxumSOHTF4ACJ0gbximEL1ncn4hzlXF9CqxWX6HGvfS1SkBU1Mnu6HdESTOjK7XHAOEMs1tXSqaoxRwPl7ticE6+/bYV8W37jKNJ+a3Xo=
Message-ID: <a781481a0708131031k7e2bcc18t3fd0e7709e14d4a2@mail.gmail.com>
Date: Mon, 13 Aug 2007 23:01:53 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: kvm warning
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       tony.luck@intel.com
In-Reply-To: <46BA4D12.8090301@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070808151446.9a4eebda.akpm@linux-foundation.org>
	 <20070808221956.GA16238@elte.hu> <46BA4827.3080907@qumranet.com>
	 <20070808155901.bcb249d9.akpm@linux-foundation.org>
	 <46BA4D12.8090301@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Avi Kivity <avi@qumranet.com> wrote:
> Andrew Morton wrote:
> > On Thu, 09 Aug 2007 01:48:07 +0300
> > Avi Kivity <avi@qumranet.com> wrote:
> >
> >> Ingo Molnar wrote:
> >>
> >>> * Andrew Morton <akpm@linux-foundation.org> wrote:
> >>>
> >>>> ia64 allmodconfig says
> >>>>
> >>>> drivers/kvm/Kconfig:14:warning: 'select' used by config symbol 'KVM'
> >>>> refers to undefined symbol 'PREEMPT_NOTIFIERS'
> >>>>
> >>> hm, why doesnt ia64 pick up kernel/Kconfig.preempt, like all the other
> >>> arches? Due to that ia64 also misses out on voluntary preempt and on
> >>> preempt-bkl.
> >>>
> >> Even more hm, how does ia64 manage to enable kvm?  It 'depends on X86'
> >> at this moment.
> >
> > beats me.  CONFIG_KVM doesn't get set.  But it seems that kconfig wants
> > to do error-checking on that item anyway.
>
> I could do a 'select PREEMPT_NOTIFIERS if X86' but it seems silly.  I'd
> call it a Kconfig bug.

I remember this issue well [1] ... it's a Kconfig deficiency indeed. Basically
kconfig options for generic stuff cannot use "select" for symbols that are
defined only for specific archs (here ia64 synthetically created this situation
by failing to source "kernel/Kconfig.preempt" in its arch/ia64/Kconfig).
Leads to no real build problems, but causes these bogus warnings to
be printed on other archs (that don't have that symbol visible to them).

Possible solutions could be to (1) source "kernel/Kconfig.preempt" from
arch/ia64/Kconfig, or (2) Use "default y if KVM" for PREEMPT_NOTIFIERS
(but this would be kludgy, horrible and tasteless). I'm not sure if
"select PREEMPT_NOTIFIERS if X86" would cut it to get rid of the bogus
warnings,
though.

Solution (1) above sounds preferable, unless there are mysterious reasons
why ia64 wants to avoid Kconfig.preempt (adding Tony Luck to Cc:).


Satyam

[1] Last time this happened was with something called ATARI_KBD_CORE.
I submitted a patch that unfortunately degenerated into a flamewar :-) The
bogus warnings remained (causing more traffic) for a month or so, before
an alternate solution got finally merged.
