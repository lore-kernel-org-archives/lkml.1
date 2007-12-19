Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbXLSAsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbXLSAsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbXLSAsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:48:14 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:28599 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753299AbXLSAsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:48:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=AaSW+kQenW57MfaRQHbeUGdxNhBv1dhtUipTZS8CrzDYm+bF8BX2EDS7mjlsgKRpHq90PSvfDXay7aZW0/zfmhggB7iZoWweE6XfCTNo4fJqoR+YpU64PlKBrZlSrZIZDOogZ6V/HVL4OTRYHAgiLefS9ELLuoSVpvgRCWYgRNk=  ;
X-YMail-OSG: IDnysewVM1nPDr4ZTKCuAvcWBHCxvEUtytHA6SlgNYkX2vuSqumajZ7E7SUaf9OhJf8Y1fg6Rw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [patch 02/20] make the inode i_mmap_lock a reader/writer lock
Date: Wed, 19 Dec 2007 11:48:06 +1100
User-Agent: KMail/1.9.5
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, lee.shermerhorn@hp.com,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
References: <20071218211539.250334036@redhat.com> <20071218211548.784184591@redhat.com>
In-Reply-To: <20071218211548.784184591@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712191148.06506.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 December 2007 08:15, Rik van Riel wrote:
> I have seen soft cpu lockups in page_referenced_file() due to
> contention on i_mmap_lock() for different pages.  Making the
> i_mmap_lock a reader/writer lock should increase parallelism
> in vmscan for file back pages mapped into many address spaces.
>
> Read lock the i_mmap_lock for all usage except:
>
> 1) mmap/munmap:  linking vma into i_mmap prio_tree or removing
> 2) unmap_mapping_range:   protecting vm_truncate_count
>
> rmap:  try_to_unmap_file() required new cond_resched_rwlock().
> To reduce code duplication, I recast cond_resched_lock() as a
> [static inline] wrapper around reworked cond_sched_lock() =>
> __cond_resched_lock(void *lock, int type).
> New cond_resched_rwlock() implemented as another wrapper.

Reader/writer locks really suck in terms of fairness and starvation,
especially when the read-side is common and frequent. (also, single
threaded performance of the read-side is worse).

I know Lee saw some big latencies on the anon_vma list lock when
running (IIRC) a large benchmark... but are there more realistic
situations where this is a problem?
