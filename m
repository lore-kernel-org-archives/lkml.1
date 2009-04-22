Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbZDVFCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbZDVFCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 01:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZDVFB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 01:01:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50052 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbZDVFB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 01:01:56 -0400
Message-ID: <49EEA4BE.6000207@redhat.com>
Date: Wed, 22 Apr 2009 00:01:50 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH, RFC] check for frozen filesystems in the mmap path
References: <20090421140045.F125.A69D9226@jp.fujitsu.com> <49EDE319.10701@redhat.com> <20090422132451.62A4.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090422132451.62A4.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>>> 2. this logic kill multi thread application.
>>>
>>> this logic mean mmap_sem grabbing until unfreeze.
>>> it mean othrer thread in the same process can't page-fault although
>>> it don't touch frozen-sb.
>>> it seems strange.
>> Hm, I hadn't thought about this ... On the one hand, ->page_mkwrite can
>> already sleep, though a userspace freeze/unfreeze could potentially take
>> much much longer.  freeze/unfreeze *should* happen very quickly, but
>> nothing enforces that.
>>
>> Do you have any suggestions?
> 
> One more comment.
> 
> I read ioctl_fsfreeze() and freeze_bdev(), it call __fsync_super().
> Oh, I don't think __fsync_suepr is very quick.

Well, what I mean is that the filesystem is not intended to be frozen
for long periods of time.  But it's not enforced by any method.

> So, page-fault have one unique characteristics.
> if page-fault return 0 without pte change, page-fault is occur again soon.
> then, if you need long time waiting, I think you can use following technique.
> 
> 	unlock mmap_sem
> 	wait long-time
> 	lock mmap_sem
> 	goto out;
> 
> 
> it cause page-fault counter increment twice unintesionally.
> but no problem. fs-freeze is not freqently event.
> 
> Am I missing anything?

Hm, I'll have to think about that.  This is not my best area.  :)  So do
you mean that if a wait needs to happen for the frozen fs, we can
unlock, do that wait for unfreeze, relock, return early, and come back
again when it is not frozen?

One other thing that I think I just discovered is that nothing is
actually stopping mmap IO even on a frozen filesystem, as long as no
metadata updates are required for the IO... I'm seeing this on xfs
anyway (ext4 tries to update mtime, so that gets stopped on the frozen fs).

Thanks,
-Eric
