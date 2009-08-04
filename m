Return-Path: <linux-kernel-owner+w=401wt.eu-S932965AbZHDQJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbZHDQJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932941AbZHDQJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:09:35 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:46329 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823AbZHDQJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:09:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=DHTp79wyzhl3koIxlNVXnBL95bDU2wIvvdwWFsxTJKqexDVALetcdC4DP5Pe5C1c6v
         Y28/1LCh4ZoMYVt380xmlJy4BWRbAt0qFJGQVFfBPlFGVEMhJXxDKpveFtOhrQOH1REq
         kJR9VaQRds+obNlYdLLH+6XjX8u0af3402v9c=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <7c86c4470907272213w2ee57080re50dd22a4d73a7e0@mail.gmail.com>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
	 <20090727212514.GA25386@basil.fritz.box>
	 <7c86c4470907272213w2ee57080re50dd22a4d73a7e0@mail.gmail.com>
Date: Tue, 4 Aug 2009 18:09:33 +0200
Message-ID: <7c86c4470908040909r17455706lb8d78aad2230cd8e@mail.gmail.com>
Subject: Re: perf_counters issue with self-sampling threads
From: stephane eranian <eranian@googlemail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: perfmon2-devel <perfmon2-devel@lists.sourceforge.net>,
       Maynard Johnson <mpjohn@us.ibm.com>,
       Robert Richter <robert.richter@amd.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       eranian@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 7:13 AM, stephane eranian<eranian@googlemail.com> wrote:
> Andi,
>
> Looks like SIGPROF is calling _group_send_sig_info(), so I think it is
> subject to the same problem.
>
I did not look into SIGPROF a bit more.

First, SIGPROF is generated from ITIMER_PROF. My understanding is that this is
a global timer for the process. It may therefore fire in any thread.
Then SIGPROF
is pended to the shared signal queue as per the group_send_sig_info() code path.
That means the thread receiving the signal may not be the one in which the timer
expired. But typically things even out. But things change if the
monitored process
is using signal, and in particular signals pended to the private
signal queue which is
what happens with pthread_kill() I would think. Then, yes there may be
an imbalance.

But in the case of SIGPROF, it is not clear to me if you want to
change this behavior
as well. It all depends on the definition for ITIMER_PROF.
