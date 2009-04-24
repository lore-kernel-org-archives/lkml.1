Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbZDXX12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbZDXX12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 19:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757182AbZDXX1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 19:27:08 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:15559 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465AbZDXX1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 19:27:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lUExLht4yvnBncpRb7G7+vz4n2DCsI0UoQ9XAxmrBcWxjAk2WDnFWUFMR/HOvhYs41
         sL+3mEiBJOUjTXiacqUnVqgxangkxbjanr4H6cDiBGQFAfuJoRcDvOpLvXacfHrNgiah
         izO6jpVEsp0dLCtNKXSDHP48d00iR4fM4cdQw=
Date: Sat, 25 Apr 2009 01:27:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, mingo@elte.hu,
       kosaki.motohiro@jp.fujitsu.com, rostedt@goodmis.org, tzanussi@gmail.com,
       linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
	worklet lifecycle tracing
Message-ID: <20090424232701.GB6658@nowhere>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49E8282A.6010004@cn.fujitsu.com> <49E82CA7.2040606@cn.fujitsu.com> <20090417134557.GA23493@elte.hu> <49F1A59B.3080206@cn.fujitsu.com> <20090424130616.a3c217cb.akpm@linux-foundation.org> <20090424225909.GA6658@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424225909.GA6658@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 12:59:10AM +0200, Frederic Weisbecker wrote:
> On Fri, Apr 24, 2009 at 01:06:16PM -0700, Andrew Morton wrote:
> > On Fri, 24 Apr 2009 19:42:19 +0800
> > Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> > 
> > > These patchs add tracepoints for per-worklet tracing.
> > > Now we have enough tracepoints to start makeing trace_workqueue.c support
> > > worklet time mesurement.
> > 
> > I'm not seing anywhere in this patchset a description of the user
> > interface.  What does the operator/programmer actually get to see from
> > the kernel as a result of these changes?
> > 
> > A complete usage example would be an appropriate way of communicating
> > all of this.
> > 
> > The patches introduce a moderate amount of tracing-specific hooks into
> > the core workqueue code, which inevitably increases the maintenance
> > load for that code.  It is important that it be demonstrated that the
> > benefts of the code are worth that cost.  Hence it is important that
> > these benefits be demonstrated to us, by yourself.  Please.
> > 
> > Another way of looking at it: which previously-encountered problems
> > would this facility have helped us to solve?  How will this facility
> > help us to solve problems in the future?  Looking at this patch series
> > I cannot answer those questions!
> > 
> 
> 
> Hi Andrew,
> 
> Although I'm not the author of this patchset, I'm somewhat
> involved in the workqueue tracer and I would like to express
> my opinion on what is happening.
> 
> Until recently, the workqueue tracer was a basic machine.
> It was designed to trace the workqueue level. We were not yet
> thinking about the worklet level:
> 
> - creation of a workqueue thread
> - cleanup/destruction of these threads
> - insertion of a work in a workqueue
> - execution of this work
> 
> The output looked like such following histogram:
> 
> #   CPU   INSERTED  EXECUTED   WORKQUEUE THREAD
> #
>       1    125        125       reiserfs/1
>       1      0          0       scsi_tgtd/1
>       1      0          0       aio/1
>       1      0          0       ata/1
>       1    114        114       kblockd/1
>       1      0          0       kintegrityd/1
>       1   2147       2147       events/1
>     
>       0      0          0       kpsmoused
>       0    105        105       reiserfs/0
>       0      0          0       scsi_tgtd/0
>       0      0          0       aio/0
>       0      0          0       ata_aux
>       0      0          0       ata/0
>       0      0          0       cqueue
>       0      0          0       kacpi_notify
>       0      0          0       kacpid
>       0    149        149       kblockd/0
>       0      0          0       kintegrityd/0
>       0   1000       1000       khelper
>       0   2270       2270       events/0
> 
> 
> Its purpose and the information it gave was limited, though
> somehow useful.
> It was able to provide some informations about the frequency
> of the works inserted.
> 
> Why that? Because it pushed some useful informations to help a
> kernel developer when it's time to decide how to defer async jobs.
> Should he use the traditional and whole purposed events workqueues
> or a devoted workqueue?
> 

Moreover, I also think that such aync job behaviour instrumentation
may help to choose more deeply and carefully the best facility for
the right work, especially since the kernel gained more infrastructure
in that field:

- kevent/%d
- private workqueue
- async job
- slow work

Frederic.

