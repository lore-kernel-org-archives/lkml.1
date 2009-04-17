Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbZDQWiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbZDQWiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 18:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbZDQWiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 18:38:16 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57290 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbZDQWiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 18:38:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=xJKZjsghPmeT+r25PHpXkUeCg1yO+ZXXmyYCzf6gR6MU3MQDFf+jNVH3LPdrVsQAf/
         oh7mMPsnxBX7hYcQmvB1kJoBiBPhzMO9o0Znk1tjrWUM/vYsqeOOhsGPgdpQ72pxRXVJ
         TcGQj6hKkHqTJRdyOSC+eK8/GwwBCzxO1A5J8=
Date: Sat, 18 Apr 2009 00:38:10 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com,
       ryov@valinux.co.jp, fernando@intellilink.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, menage@google.com,
       peterz@infradead.org
Subject: Re: IO controller discussion (Was: Re: [PATCH 01/10] Documentation)
Message-ID: <20090417223809.GA3758@linux>
Mail-Followup-To: Vivek Goyal <vgoyal@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, nauman@google.com,
	dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
	fchecconi@gmail.com, paolo.valente@unimore.it,
	jens.axboe@oracle.com, ryov@valinux.co.jp,
	fernando@intellilink.co.jp, s-uchida@ap.jp.nec.com,
	taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, arozansk@redhat.com,
	jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
	balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	containers@lists.linux-foundation.org, menage@google.com,
	peterz@infradead.org
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <1236823015-4183-2-git-send-email-vgoyal@redhat.com> <20090312001146.74591b9d.akpm@linux-foundation.org> <20090312180126.GI10919@redhat.com> <49D8CB17.7040501@gmail.com> <20090407064046.GB20498@redhat.com> <20090408203756.GB10077@linux> <20090416183753.GE8896@redhat.com> <20090417093656.GA5246@linux> <20090417141358.GD29086@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417141358.GD29086@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 10:13:58AM -0400, Vivek Goyal wrote:
> > > I think setting a maximum limit on dirty pages is an interesting thought.
> > > It sounds like as if memory controller can handle it?
> > 
> > Exactly, the same above.
> 
> Thinking more about it. Memory controller can probably enforce the higher
> limit but it would not easily translate into a fixed upper async write
> rate. Till the process hits the page cache limit or is slowed down by
> dirty page writeout, it can get a very high async write BW.
> 
> So memory controller page cache limit will help but it would not direclty
> translate into what max bw limit patches are doing.

The memory controller can be used to set an upper limit of the dirty
pages. When this limit is exceeded the tasks in the cgroup can be forced
to write the exceeding dirty pages to disk. At this point the IO
controller can: 1) throttle the task that is going to submit the IO
requests, if the guy that dirtied the pages was actually the task
itself, or 2) delay the submission of those requests to the elevator (or
at the IO scheduler level) if it's writeback IO (e.g., made by pdflush).

Both functionalities should allow to have a BW control and avoid that
any single cgroup can entirely exhaust the global limit of dirty pages.

> 
> Even if we do max bw control at IO scheduler level, async writes are
> problematic again. IO controller will not be able to throttle the process
> until it sees actuall write request. In big memory systems, writeout might
> not happen for some time and till then it will see a high throughput.
> 
> So doing async write throttling at higher layer and not at IO scheduler
> layer gives us the opprotunity to produce more accurate results.

Totally agree.

> 
> For sync requests, I think IO scheduler max bw control should work fine.

ditto

-Andrea
