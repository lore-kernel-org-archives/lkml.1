Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbZK3QMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbZK3QMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZK3QMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:12:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbZK3QMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:12:12 -0500
Date: Mon, 30 Nov 2009 17:12:05 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Mark Veltzer <mark.veltzer@gmail.com>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: get_user_pages question
Message-ID: <20091130161205.GE30235@random.random>
References: <200911090850.26724.mark.veltzer@gmail.com>
 <Pine.LNX.4.64.0911101613080.22198@sister.anvils>
 <20091128185052.GB30235@random.random>
 <200911290022.17568.mark.veltzer@gmail.com>
 <20091130120145.GB21639@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130120145.GB21639@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 01:01:45PM +0100, Nick Piggin wrote:
> If you can wean O_DIRECT off get_user_pages, you'd have most of the
> battle won. I don't think it's really possible though.

Agreed. Not just O_DIRECT, virtualization requires it too, the kvm
page fault calls get_user_pages, practically anything that uses mmu
notifier also uses get_user_pages. There are things you simply can't
do without it.

In general if the memory doesn't need to be persistently stored on
disk to survive task killage, there's not much point in using
pagecache MAP_SHARED on-disk, instead of anonymous memory, this is why
anonymous memory is backing malloc, and there's no reason why people
should be prevented to issue disk I/O in zero-copy with anonymous
memory (or tmpfs), if they know they access this data only once and
they want to manage the cache in some logical form rather than in
physical on-disk format (or if there are double physical caches more
efficient kept elsewhere, like in KVM guest case).

OTOH if you'd be using the I/O data in physical format in your
userland memory, then using pagecache by mmapping the file and
disabling O_DIRECT on the filesystem is surely preferred and more
efficient (if nothing else, because it also provides caching just in
case).

For drivers (Mark's case) it depends, but if you can avoid to use
get_user_pages without slowing down anything you should, that usually
makes code simpler... and it won't risk to suffer from these race
conditions either ;).
