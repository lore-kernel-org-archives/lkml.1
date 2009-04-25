Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbZDYAh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbZDYAh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 20:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZDYAhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 20:37:10 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:44626 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbZDYAhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 20:37:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H8wfmCaaSOkn9jViVAY/eMS3IwlKAI+ZT+JnStt7Ti7L/jmMMKky3XT7CrX+vJ6Rc/
         39BbeXLKFvsbpsVQTeKuvXL9jxyBz0SckWtp2zwp2Tveo1V7jzHwFnXuQp83dahebBkz
         bOpQxj97ZE/B6HHCbrss2wS3U88qtPZ4vx3aM=
Date: Sat, 25 Apr 2009 02:37:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: zhaolei@cn.fujitsu.com, mingo@elte.hu, kosaki.motohiro@jp.fujitsu.com,
       rostedt@goodmis.org, tzanussi@gmail.com, linux-kernel@vger.kernel.org,
       oleg@redhat.com
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
	worklet lifecycle tracing
Message-ID: <20090425003702.GC6658@nowhere>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49E8282A.6010004@cn.fujitsu.com> <49E82CA7.2040606@cn.fujitsu.com> <20090417134557.GA23493@elte.hu> <49F1A59B.3080206@cn.fujitsu.com> <20090424130616.a3c217cb.akpm@linux-foundation.org> <20090424225909.GA6658@nowhere> <20090424162056.45907fef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424162056.45907fef.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 04:20:56PM -0700, Andrew Morton wrote:
> On Sat, 25 Apr 2009 00:59:10 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > 
> > [useful info]
> >
> 
> OK, thanks.  It was waaaay more useful than the original description.
> 
> > So this latest patchset provides all these required informations on the events
> > tracing level.
> 
> Well.. required by who?
> 
> I don't recall ever seeing any problems of this nature, nor patches to
> solve any such problems.  If someone wants to get down and optimise our use
> of workqueues then good for them, but that exercise doesn't require the
> permanent addition of large amounts of code to the kernel.
> 
> The same amount of additional code and additional churn could be added
> to probably tens of core kernel subsystems, but what _point_ is there
> to all this?  Who is using it, what problems are they solving?
> 
> We keep on adding all these fancy debug gizmos to the core kernel which look
> like they will be used by one person, once.  If that!
> 


If you don't recall problems revealed by this tracer or patches
motivated by its results, I have examples.

Soon after writing the first version of th workqueue tracer, I saw
this incredible rate of unused workqueue on my box.
Note that's still the case today (I've cut the worklet informations):

# cat trace_stat/workqueues 
# CPU  INSERTED  EXECUTED   TASKNAME:PID
# |      |         |        `-WORKFUNC
# |      |         |          |
  0   9587       9650       events/0:9
  0      0          0       cpuset:11
  0   1384       1384       khelper:12
  0      0          0       kintegrityd/0:178
  0    385        385       kblockd/0:184
  0      0          0       kacpid:190
  0      0          0       kacpi_notify:191
  0      0          0       tifm:498
  0  24061      24061       ata/0:507
  0      0          0       ata_aux:511
  0      0          0       aio/0:871
  0      0          0       crypto/0:897
  0      0          0       scsi_tgtd/0:2368
  0      0          0       iscsi_eh:2387
  0      0          0       kpsmoused:2521
  0      0          0       hd-audio0:2660
  0      0          0       krxrpcd/0:2745
  0    147        147       reiserfs/0:2895
  1  11023      11046       events/1:10
  1      0          0       kintegrityd/1:181
  1    293        293       kblockd/1:185
  1  33783      33783       ata/1:509
  1      0          0       aio/1:878
  1      0          0       crypto/1:898
  1      0          0       scsi_tgtd/1:2370
  1      0          0       krxrpcd/1:2746
  1     99         99       reiserfs/1:2896


27 threads. 15 are unused, 12 are used.

And still, I've only two CPUS.
More than half of my workqueues are unused.
I also have a small config. I can't imagine the result
with a distro config which enables a lot of options
by default.

I discovered it with this tracer. Then it brought me to
write this patch:

http://lkml.org/lkml/2009/1/31/184

Btw, if one day I can see something like async but which is able
to accept work that _must_ be ran async in any case, then I'm still willing
to rework this patch.

Still with these same observations, I wrote this another one:

http://lkml.org/lkml/2009/1/26/363

Without this tracer, I wouldn't have had the informations which
motivated me to write these patches. And although they weren't accepted
(the first is more about pending than refused, my bad), which is
justified, they reveal a real problem.


Who knows what kind of other things we can discover with worklet tracing?

Frederic.


