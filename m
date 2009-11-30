Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbZK3Peb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbZK3Peb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZK3Pea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:34:30 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:48091 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbZK3Pea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:34:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=izvjp/ly/kF0K7gIqBbJjAkf4MyxmuPTRoQqR1UcntMiYf8reIbtkxVwEHiHVZOaPE
         HocH5edSmJsT6j8ugeTltwGIkIrkG5ZHbmFwLsg/6oy+3tj2D+U+tu8Y2FpX1/Zvx1mg
         9ew+L93BY+1Tcxj3tKYnY0dP8QUg2Vouhj8W4=
MIME-Version: 1.0
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Date: Mon, 30 Nov 2009 16:34:36 +0100
Message-ID: <4e5e476b0911300734h34a22c88oa5d7d4e5642ead50@mail.gmail.com>
Subject: Re: Block IO Controller V4
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, Alan.Brunelle@hp.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
On Mon, Nov 30, 2009 at 3:59 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi Jens,
> [snip]
> TODO
> ====
> - Direct random writers seem to be very fickle in terms of workload
>  classification. They seem to be switching between sync-idle and sync-noidle
>  workload type in a little unpredictable manner. Debug and fix it.
>

Are you still experiencing erratic behaviour after my patches were
integrated in for-2.6.33?

> - Support async IO control (buffered writes).
I was thinking about this.
Currently, writeback can either be issued by a kernel daemon (when
actual dirty ratio is > background dirty ratio, but < dirty_ratio) or
from various processes, if the actual dirty ratio is > dirty ratio.
Could the writeback issued in the context of a process be marked as sync?
In this way:
* normal writeback when system is not under pressure will run in the
root group, without interferring with sync workload
* the writeback issued when we have high dirty ratio will have more
priority, so the system will return in a normal condition quicker.
* your code will work out of the box, in fact processes with lower
weight will complete less I/O, therefore they will be slowed down more
than higher weight ones.

>
>  Buffered writes is a beast and requires changes at many a places to solve the
>  problem and patchset becomes huge. Hence first we plan to support only sync
>  IO in control then work on async IO too.
>
>  Some of the work items identified are.
>
>        - Per memory cgroup dirty ratio
>        - Possibly modification of writeback to force writeback from a
>          particular cgroup.
>        - Implement IO tracking support so that a bio can be mapped to a cgroup.
>        - Per group request descriptor infrastructure in block layer.
>        - At CFQ level, implement per cfq_group async queues.
>
>  In this patchset, all the async IO goes in system wide queues and there are
>  no per group async queues. That means we will see service differentiation
>  only for sync IO only. Async IO willl be handled later.
>
> - Support for higher level policies like max BW controller.
> - Support groups of RT class also.

Thanks,
Corrado
