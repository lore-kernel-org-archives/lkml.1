Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbYESLcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbYESLcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 07:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbYESLcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 07:32:36 -0400
Received: from smtp.nokia.com ([192.100.105.134]:38879 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbYESLcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 07:32:35 -0400
Message-ID: <483164F2.1010908@nokia.com>
Date: Mon, 19 May 2008 14:30:58 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH take 2] UBIFS - new flash file system
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com> <20080516104002.GA6962@infradead.org>
In-Reply-To: <20080516104002.GA6962@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 May 2008 11:32:05.0958 (UTC) FILETIME=[F7485660:01C8B9A3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

thanks for the review.

Christoph Hellwig wrote:
>  - the read dir implementation won't ever support nfs exporting
>    due to having to keep per open file state.  Nor would it support
>    thing like checkpoint and restart.

We keep full name of the last readdir()'ed direntry in file->private_data
and in file->f_pos we store the direntry hash value (32 bits). The only reason
we store full name in file->private_data is name hash collisions.

We are able to restart readdir()s, but only if there are no hash collisions.
Otherwise UBIFS will restart, but probably from the wrong directory entry
(the first one in the colliding sequence).

In other words, you may do readdir, telldir, close the directory, open it
again, seekdir, and continue readdir-ing. This will mostly work as expected
unless there was hash collision, in which case you will restart from the
first direntry in the colliding sequence. I.e., telldir/seekdir mostly
work, but not always.

We thought seekdir/telldir was considered as horrible interface anyway so
we assumed it is not that big deal if it occasionally does not work as
expected.

AFAIK there are other FSes which have similar issues. Do all of them solve
this in one way or another? We have an idea of storing collision
number in directory entries and return this number in the high 32 bits of
file->f_pos (the low contain hash value) to make readdir truly restartable.
But this requires some non-trivial changes and we'd want to realize if it
is really needed.

AFAIK, even ext3 may shrink directories and fail to support readdir
restarts occasionally, but I am not 100% sure.

Could you please elaborate some more why UBIFS won't ever support nfs export?
Does NFS export need correct readdir restarts?

>  - ubifs_bg_thread shouldn't set a nice level, especially when it's the
>    default one anyway.

Well, it is also doing write-buffer flushes, not only commits. And we were
planning to add background garbage collection there as well.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
