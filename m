Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbZBFAeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbZBFAeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbZBFAdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:33:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755500AbZBFAdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:33:22 -0500
Date: Thu, 5 Feb 2009 16:33:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RESEND] [PATCH] lseek: remove i_mutex
Message-Id: <20090205163318.108f6af2.akpm@linux-foundation.org>
In-Reply-To: <6.0.0.20.2.20090206091511.0764d0a8@172.19.0.2>
References: <6.0.0.20.2.20090203165430.06ae1cd8@172.19.0.2>
	<20090205120519.a62e8c4f.akpm@linux-foundation.org>
	<6.0.0.20.2.20090206091511.0764d0a8@172.19.0.2>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Feb 2009 09:20:30 +0900
Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:

> 
> At 05:05 09/02/06, Andrew Morton wrote:
> >On Tue, 03 Feb 2009 17:04:40 +0900
> >Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:
> >
> >> I removed i_mutex from generic_file_llseek.
> >> I think that the reason of protecting lseek with i_mutex is just
> >> touching i_size atomically.
> >> 
> >> So I introduce i_size_read here so i_mutex is no longer needed.
> >> 
> >> Following patch removes i_mutex from generic_file_llseek, and deletes 
> >> generic_file_llseek_nolock totally.
> >> 
> >> Currently there is i_mutex contention not only around lseek, but also 
> >fsync or write.
> >> So,  I think we can mitigate i_mutex contention between fsync lseek and 
> >write by
> >> removing i_mutex.
> >
> >Prior to this change, generic_file_llseek() modified file->f_pos
> >atomically with respect to other i_mutex holders.
> >
> >After this change, it doesn't.
> 
> Hi Andrew.
> 
> Even before this change is applied, file->f_pos access is not atomic.
> sys_read change f_pos value through file_pos_write without i_mutex.

I know.  That's why I specified "with respect to other i_mutex holders".

This patch makes things worse.

At very very minimum the changelog should explain that this patch makes
things worse, and demonstrate why this is justifiable.

> I think seqlock is needed to make f_pos access atomic.

Maybe.  Or atomic64_t, or spinlocking, or i_mutex, or something else.
