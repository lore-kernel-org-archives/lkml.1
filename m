Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYHaSKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYHaSKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 14:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755681AbYHaSJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 14:09:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:64306 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446AbYHaSJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 14:09:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PNKwzLnHaD/Ueja+Q7fvf6hFjM3yiUEhk8VnIsM7eHEKg2hTef45EdGXwcPLxHeY5y
         48zAl5m/eruetG+QHj/hg+MDJPShP13viVic9NoxRFzlFRU11mUvZ1vPdWrdlmcW86AL
         HYnwoEFCsNDAJ9mg7xNSjmhhm3SGLpUZSeR8Y=
Message-ID: <f7848160808311109v70db1e99hb6af3b89c34d0d8c@mail.gmail.com>
Date: Sun, 31 Aug 2008 14:09:51 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [REGRESSION] High, likely incorrect process cpu usage counters with kvm and 2.6.2[67]
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "KVM list" <kvm@vger.kernel.org>
In-Reply-To: <48BABC19.1060509@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48BABC19.1060509@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 11:43 AM, Avi Kivity <avi@qumranet.com> wrote:
> Running an idle Windows VM on Linux 2.6.26+ with kvm, one sees high values
> for the kvm process in top (30%-70% cpu), where one would normally expect
> 0%-1%.  Surprisingly, the per-cpu system counters show almost 100% idle,
> leading me to believe this is an accounting error and that the process does
> not actually consume this much cpu.

Busted process accounting - This looks the same as
http://bugzilla.kernel.org/show_bug.cgi?id=11209 .
Please verify. Peter's patch in latest git stops showing "incorrect
looking" CPU usage but at least the process times are still wrong,
horribly.
In fact the CPU usage thing in -rc5 is likely also incorrect but I
need to analyze that bit a little more.

>From Today's Git -

PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND

12961 parag     20   0 83000 8908 6628 R    0  0.1  5124415h npviewer.bin

>
> I bisected this to a scheduler change, namely
>
> commit 3e51f33fcc7f55e6df25d15b55ed10c8b4da84cd
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Sat May 3 18:29:28 2008 +0200
>
>   sched: add optional support for CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
>     this replaces the rq->clock stuff (and possibly cpu_clock()).
>      - architectures that have an 'imperfect' hardware clock can set
>      CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
>      - the 'jiffie' window might be superfulous when we update tick_gtod
>      before the __update_sched_clock() call in sched_clock_tick()
>      - cpu_clock() might be implemented as:
>          sched_clock_cpu(smp_processor_id())
>        if the accuracy proves good enough - how far can TSC drift in a
>      single jiffie when considering the filtering and idle hooks?
>     [ mingo@elte.hu: various fixes and cleanups ]
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>   Signed-off-by: Ingo Molnar <mingo@elte.hu>

That patch sounds like it had open questions?
Really giving this is a long standing bad regression, all the
offending patches should be reverted in absence of a fix, no?

Parag
