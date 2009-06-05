Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZFETG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZFETG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZFETGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:06:19 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:45650 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZFETGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:06:17 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org,
       adobriyan@gmail.com, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de,
       akpm@linux-foundation.org, hch@infradead.org,
       ebiederm@aristanetworks.com
Subject: Re: [PATCH 04/23] vfs: Introduce infrastructure for revoking a file
References: <m1oct739xu.fsf@fess.ebiederm.org>
	<1243893048-17031-4-git-send-email-ebiederm@xmission.com>
	<E1MCVKj-0007O3-Rp@pomaz-ex.szeredi.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 05 Jun 2009 12:06:07 -0700
In-Reply-To: <E1MCVKj-0007O3-Rp@pomaz-ex.szeredi.hu> (Miklos Szeredi's message of "Fri\, 05 Jun 2009 11\:03\:29 +0200")
Message-ID: <m18wk6a4bk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: miklos@szeredi.hu, ebiederm@aristanetworks.com, hch@infradead.org, akpm@linux-foundation.org, npiggin@suse.de, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> Hi Eric,
>
> Very interesting work.
>
> On Mon,  1 Jun 2009, Eric W. Biederman wrote:
>> The file_hotplug_lock has a very unique implementation necessitated by
>> the need to have no performance impact on existing code.  Classic locking
>> primitives and reference counting cause pipeline stalls, except for rcu
>> which provides no ability to preventing reading a data structure while
>> it is being updated.
>
> Well, the simple solution to that is to add another level of indirection:
>
> old:
>
>   fdtable -> file
>
> new:
>
>   fdtable -> persistent_file -> file
>
> Then it is possible to replace persistent_file->file with a revoked
> one under RCU.  This has the added advantage that it supports
> arbitrary file replacements, not just ones which return EIO.
>
> Another advantage is that dereferencing can normally be done "under
> the hood" in fget()/fget_light().  Only code which wants to
> permanently store a file pointer (like the SCM_RIGHTS thing) would
> need to be aware of the extra complexity.
>
> Would that work, do you think?

Well I went down this path for a little while, and it has some good points.
Unfortunately it appears to be more costly.

fget() and friends are semantically very different my
file_hotplug_read_trylock and unlock.  In fact there is very little
overlap.  Which means that transparent to the vfs users doesn't
actually work.

We actually have more and less predictable places where we store files.

If there was actually a compelling case for being more general I would
certainly agree that splitting the file structure in two would be a
good deal.  As it is that level of flexibility seems to be overkill.

Eric
