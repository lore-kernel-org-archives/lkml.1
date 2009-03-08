Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbZCHEhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbZCHEhe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 23:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbZCHEhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 23:37:25 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:17301 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZCHEhY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 23:37:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=igAcGg3otypO4iPP22sjLxklsNgj1q7Dr3pC+4Uww9Wf/XzxOIPRbSdtrS8RHOa5T/
         oPfN/lHHp8JqhcghSebGvYN02pIIjLGTaSlt9TlBBsGf0UDzTo8QYXtBCigsOiYGBAfT
         h+8IhJJ3GWvmQNkUX7boUkxrUGQOwkxt6tOEc=
MIME-Version: 1.0
In-Reply-To: <1236321988-19457-1-git-send-email-tj@kernel.org>
References: <1236321988-19457-1-git-send-email-tj@kernel.org>
Date: Sun, 8 Mar 2009 12:37:21 +0800
X-Google-Sender-Auth: 4b67174d2ba21cda
Message-ID: <386072610903072037q532de253n5697dca04d155710@mail.gmail.com>
Subject: Re: [GIT PULL] x86, percpu: implement and use reserved percpu alloc
From: Bryan Wu <cooloney@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, efault@gmx.de,
       jaswinder@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 6, 2009 at 2:46 PM, Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> Please pull from the following git vector.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu
>
> This patchset implements reserved percpu alloc from the first chunk
> and uses it for static perpcu variables in modules on x86_64.  This is
> necessary because x86_64 expects symbols to be relocatable using 32bit
> relocations but dynamic percpu allocation does not guarantee it
> leading to relocation overflow during module load.
>
> This can happen to any of the x86_64 percpu first chunk allocators but
> the embedding allocator is most likely to trigger it as the first
> chunk is located in the normal kernel memory allocation area while all
> the other chunks will be allocated in the vmalloc area which is very
> far from the first chunk.
>
> This type of reservation will be necessary for other architectures too
> where addressing mode used for percpu acess uses offsets with limited
> range to access symbols (e.g. ia64 w/ the magic 64k percpu page).
>
> This problem was first reported and bisected by Mike Galbraith[2].
>
> This patchset is against the current x86/core/percpu[1] and contains
> the following patches.
>
>  0001-percpu-clean-up-percpu-constants.patch
>  0002-percpu-cosmetic-renames-in-pcpu_setup_first_chunk.patch
>  0003-percpu-improve-first-chunk-initial-area-map-handlin.patch
>  0004-percpu-use-negative-for-auto-for-pcpu_setup_first_c.patch
>  0005-x86-make-embedding-percpu-allocator-return-excessiv.patch
>  0006-percpu-add-an-indirection-ptr-for-chunk-page-map-ac.patch
>  0007-percpu-module-implement-reserved-allocation-and-us.patch
>  0008-x86-percpu-setup-reserved-percpu-area-for-x86_64.patch
>
> 0001-0004 makes misc updates to percpu in preparation of later
> changes.  0005 fixes a case where excessive memory can be set aside in
> the first chunk when using the embedding allocator.  0006-0008
> implement reserved allocation and use it for x86_64.
>
> Bryan Wu, can you please review #0001?  It contains small change in
> blackfin.  It's mostly trivial but just in case.
>

Hi Tejun,

Sorry for the delay, it looks fine for me.

-Bryan

> Diffstat follows.
>
>  arch/blackfin/include/asm/percpu.h |   10 -
>  arch/x86/kernel/setup_percpu.c     |   73 +++++++---
>  include/linux/percpu.h             |   60 +++-----
>  kernel/module.c                    |    2
>  mm/percpu.c                        |  267 ++++++++++++++++++++++++++-----------
>  5 files changed, 274 insertions(+), 138 deletions(-)
>
> Thanks.
>
> --
> tejun
>
> [1] f254f3909efaf59ca2d0f408de2d044dace60706
> [2] http://thread.gmane.org/gmane.linux.kernel/801799
>
