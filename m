Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbZF0MH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbZF0MH6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 08:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbZF0MHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 08:07:51 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:65282 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbZF0MHu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 08:07:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iG/BRJGHF8Cl4d/u9sQffpXXUPShNGq6kVtRsyFDkcIRHZv7QMToSzYvOynjY+XyyX
         0qJ2aRftMQiq85IPI8aKvg1sf2JFGRKAjE8j+mlU4Zija/0pKdh0Cf0EhKblV+QjKNnZ
         lZM2OX+4rb/sI0uLHm76g70AlM7xD66qbZais=
MIME-Version: 1.0
In-Reply-To: <26537.1246086769@redhat.com>
References: <20090624023251.GA16483@localhost>
	 <20090620043303.GA19855@localhost> <32411.1245336412@redhat.com>
	 <20090517022327.280096109@intel.com> <2015.1245341938@redhat.com>
	 <20090618095729.d2f27896.akpm@linux-foundation.org>
	 <7561.1245768237@redhat.com> <3901.1245848839@redhat.com>
	 <26537.1246086769@redhat.com>
Date: Sat, 27 Jun 2009 21:07:52 +0900
Message-ID: <28c262360906270507i2df73c25ye70b10739df3db1f@mail.gmail.com>
Subject: Re: Found the commit that causes the OOMs
From: Minchan Kim <minchan.kim@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI, David.

First of all, Thanks for your effort to find out cause.

Unfortunately, I don't have followed your problem.
I guess you met OOM problem with no swap device. right ?

My patch shouldn't have affect yours.
The patch's motivation is following as.

"If our system have no swap device, we can't reclaim anon pages.
 So, anon pages's moving in anon lru list is unnecessary."

If we don't call shrink_active_list in shrink_zone's tail,
it can affect reclaim_stat->recent_[rotated|scanned].

Then it can affect number of pages for scanning in anon lru list.
But, Look at shrink_zone.

If we don't have swap device,  we never scan anon lru list forcely.
(anon lru's percent is always zero)

Nonetheless, OOM happen.

Hmm..
Could I show your oops and show_mem information, please ?

Rik, Kosaki, What do you think ?

On Sat, Jun 27, 2009 at 4:12 PM, David Howells<dhowells@redhat.com> wrote:
>
> I've managed to bisect things to find the commit that causes the OOMs.  It's:
>
>        commit 69c854817566db82c362797b4a6521d0b00fe1d8
>        Author: MinChan Kim <minchan.kim@gmail.com>
>        Date:   Tue Jun 16 15:32:44 2009 -0700
>
>            vmscan: prevent shrinking of active anon lru list in case of no swap space V3
>
>            shrink_zone() can deactivate active anon pages even if we don't have a
>            swap device.  Many embedded products don't have a swap device.  So the
>            deactivation of anon pages is unnecessary.
>
>            This patch prevents unnecessary deactivation of anon lru pages.  But, it
>            don't prevent aging of anon pages to swap out.
>
>            Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>            Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>            Cc: Johannes Weiner <hannes@cmpxchg.org>
>            Acked-by: Rik van Riel <riel@redhat.com>
>            Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>            Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> This exhibits the problem.  The previous commit:
>
>        commit 35282a2de4e5e4e173ab61aa9d7015886021a821
>        Author: Brice Goglin <Brice.Goglin@ens-lyon.org>
>        Date:   Tue Jun 16 15:32:43 2009 -0700
>
>            migration: only migrate_prep() once per move_pages()
>
> survives 16 iterations of the LTP syscall testsuite without exhibiting the
> problem.
>
> David
>



-- 
Kinds regards,
Minchan Kim
