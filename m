Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbZLNAP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbZLNAP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbZLNAPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:15:00 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:54761 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822AbZLNAOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 19:14:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VohBK0jYDd2uZSJY5OAhcGgnDD+UqJ2qgUJOw+oSQxUT8CbXBMuFtqih0cAPhBbWj2
         2Igqhl8b8XjP/s8xxY7De7ot8nh0/DO4E0H+nu8hvLHF8uEffW8jtG904R1ye5XyZrdh
         5Plq7V4g5Cki4O18aKozhbOtVjN8NeY8txNL8=
MIME-Version: 1.0
In-Reply-To: <20091211164651.036f5340@annuminas.surriel.com>
References: <20091211164651.036f5340@annuminas.surriel.com>
Date: Mon, 14 Dec 2009 09:14:39 +0900
Message-ID: <28c262360912131614h62d8e0f7qf6ea9ab882f446d4@mail.gmail.com>
Subject: Re: [PATCH v2] vmscan: limit concurrent reclaimers in shrink_zone
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: lwoodman@redhat.com, akpm@linux-foundation.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rik.

On Sat, Dec 12, 2009 at 6:46 AM, Rik van Riel <riel@redhat.com> wrote:
> Under very heavy multi-process workloads, like AIM7, the VM can
> get into trouble in a variety of ways.  The trouble start when
> there are hundreds, or even thousands of processes active in the
> page reclaim code.
>
> Not only can the system suffer enormous slowdowns because of
> lock contention (and conditional reschedules) between thousands
> of processes in the page reclaim code, but each process will try
> to free up to SWAP_CLUSTER_MAX pages, even when the system already
> has lots of memory free.
>
> It should be possible to avoid both of those issues at once, by
> simply limiting how many processes are active in the page reclaim
> code simultaneously.
>
> If too many processes are active doing page reclaim in one zone,
> simply go to sleep in shrink_zone().
>
> On wakeup, check whether enough memory has been freed already
> before jumping into the page reclaim code ourselves.  We want
> to use the same threshold here that is used in the page allocator
> for deciding whether or not to call the page reclaim code in the
> first place, otherwise some unlucky processes could end up freeing
> memory for the rest of the system.

I am worried about one.

Now, we can put too many processes reclaim_wait with NR_UNINTERRUBTIBLE state.
If OOM happens, OOM will kill many innocent processes since
uninterruptible task
can't handle kill signal until the processes free from reclaim_wait list.

I think reclaim_wait list staying time might be long if VM pressure is heavy.
Is this a exaggeration?

If it is serious problem, how about this?

We add new PF_RECLAIM_BLOCK flag and don't pick the process
in select_bad_process.

-- 
Kind regards,
Minchan Kim
