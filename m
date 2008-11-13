Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbYKMG0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbYKMG0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 01:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbYKMG0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 01:26:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:33466 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYKMG0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 01:26:21 -0500
Message-ID: <491BC87F.4050108@kernel.org>
Date: Thu, 13 Nov 2008 15:26:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Nov 2008 06:26:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Miklos.

Miklos Szeredi wrote:
>   0006-FUSE-implement-unsolicited-notification.patch
>   0007-FUSE-implement-poll-support.patch
> 
> This would be nice, but...  I don't really like the fact that it uses
> the file handle.  Could we have a separate "poll handle" that is
> returned in the POLL reply?

Eh... I replied too early for this.  I'm now trying to convert it to its
own handle but there is a rather serious problem.  It's usually much
easier to have the entity to be waken up registered before calling
->poll so that ->poll can use the same notification path from ->poll ans
for later.

However, if we allocate poll handle from ->poll and tell it to kernel
via reply, it creates two problem.  1. the entity which is to be waken
up can't be registered prior to calling ->poll as there's nothing to
identify it, 2. the interval from reply write and in-kernel polled
entity registration must be made atomic so that no notification can come
through inbetween.  #1 means that ->poll can't call the same
notification path from ->poll itself and #2 means that there needs to be
special provision from dev.c::fuse_dev_write() to
file.c::fuse_file_poll() so that atomicity can be guaranteed.  Both of
which can be done but I'm not really sure whether using a separate
handle would be a good idea even with the involved cost.

Why do you think using separate poll handle would be better?  And do you
still think the overhead is justifiable?

Thanks.

-- 
tejun
