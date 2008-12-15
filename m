Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbYLOWJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbYLOWJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 17:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbYLOWJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 17:09:09 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:54354 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbYLOWJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 17:09:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=EtyHbNK8xnfw+saeFS2+tgyEUM3l8fBVtXqxYKQ/9VrZczxaw0MJ4e5gqGAFcMJhXZ
         Aem3vj4rS4eCCFbMqsfi+U1ftAveVN+hqpyPMwLYOrdrr6j2yulWrVuS5fWVMTMHi3QN
         /y8X6Tt4orgK81ljTwfpbTlBgZTWhmXLXWjyc=
Message-ID: <7c86c4470812151403s5c8c1fe3u4c7c9e7f67e0055b@mail.gmail.com>
Date: Mon, 15 Dec 2008 23:03:45 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Paul Mackerras" <paulus@samba.org>
Subject: Re: [patch] Performance Counters for Linux, v4
Cc: "Vince Weaver" <vince@deater.net>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Ven" <arjan@infradead.org>, "Peter Anvin" <hpa@zytor.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
In-Reply-To: <18758.53072.197695.277198@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081214212829.GA9435@elte.hu>
	 <Pine.LNX.4.64.0812151243130.2773@pianoman.cluster.toy>
	 <18758.53072.197695.277198@cargo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 10:42 PM, Paul Mackerras <paulus@samba.org> wrote:
> Vince Weaver writes:
>
>> I see a large (2300 instruction) fixed overhead when measuring
>> retired instruction count using the "timec" command
>> compared to the "pfmon" tool that comes with perfmon3
>> (the pfmon tool has essentially no overhead when
>> doing aggragate counts).
>
> Looks like timec will be counting the fork() and execvp() system calls
> that are used to run your executable, as well as the executable
> itself.  The fork() overhead could be removed fairly easily I think,
> the execvp would be hard to get rid of without using ptrace() - and
> the use of ptrace was one of the things that Ingo et al. objected to
> in perfmon3.
>
Paul, I think your analysis is correct. This is likely what is happening.

Not that timec could not use ptrace() to block the task from executing
its first instruction, but you'd still have a problem because of prctl(ENABLE)
which applies to the current task, not another task, unless I am mistaken.

Prctl() looks odd to me because you have all those supposedly independent
file descriptors to identify events you want to measure, but they are not
used to start/stop. If you are attaching to multiple tasks at the same time
which you can do with the current API,  you may not necessarily want to
start/stop all counters at the same time.

Looks like prctl() is not what we want after all...
