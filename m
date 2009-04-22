Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbZDVEtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbZDVEtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 00:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbZDVEt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 00:49:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34396 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZDVEtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 00:49:25 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] check for frozen filesystems in the mmap path
Cc: kosaki.motohiro@jp.fujitsu.com,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <49EDE319.10701@redhat.com>
References: <20090421140045.F125.A69D9226@jp.fujitsu.com> <49EDE319.10701@redhat.com>
Message-Id: <20090422132451.62A4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 22 Apr 2009 13:49:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 2. this logic kill multi thread application.
> > 
> > this logic mean mmap_sem grabbing until unfreeze.
> > it mean othrer thread in the same process can't page-fault although
> > it don't touch frozen-sb.
> > it seems strange.
> 
> Hm, I hadn't thought about this ... On the one hand, ->page_mkwrite can
> already sleep, though a userspace freeze/unfreeze could potentially take
> much much longer.  freeze/unfreeze *should* happen very quickly, but
> nothing enforces that.
> 
> Do you have any suggestions?

One more comment.

I read ioctl_fsfreeze() and freeze_bdev(), it call __fsync_super().
Oh, I don't think __fsync_suepr is very quick.

So, page-fault have one unique characteristics.
if page-fault return 0 without pte change, page-fault is occur again soon.
then, if you need long time waiting, I think you can use following technique.

	unlock mmap_sem
	wait long-time
	lock mmap_sem
	goto out;


it cause page-fault counter increment twice unintesionally.
but no problem. fs-freeze is not freqently event.

Am I missing anything?



