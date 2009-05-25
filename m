Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbZEYX21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbZEYX21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZEYX2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:28:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41396 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbZEYX2Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:28:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [Bug #13339] rtable leak in ipv4/route.c
Date: Tue, 26 May 2009 01:28:34 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander V. Lukyanov" <lav@yar.ru>,
       Linux Netdev List <netdev@vger.kernel.org>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera> <uSztiUhmDDC.A.U8H.a9bGKB@chimera> <4A19CB7D.8000004@cosmosbay.com>
In-Reply-To: <4A19CB7D.8000004@cosmosbay.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905260128.35541.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 May 2009, Eric Dumazet wrote:
> Rafael J. Wysocki a écrit :
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13339
> > Subject		: rtable leak in ipv4/route.c
> > Submitter	: Alexander V. Lukyanov <lav@yar.ru>
> > Date		: 2009-05-18 14:10 (7 days old)
> > 
> 
> Bug was present in 2.6.29, so its a regression from 2.6.28
> 
> It is solved and available in David tree (net-2.6), and scheduled for stable submission
> 
> commit 1ddbcb005c395518c2cd0df504cff3d4b5c85853
> net: fix rtable leak in net/ipv4/route.c
> 
> Alexander V. Lukyanov found a regression in 2.6.29 and made a complete
> analysis found in http://bugzilla.kernel.org/show_bug.cgi?id=13339
> Quoted here because its a perfect one :
> 
> begin_of_quotation
>  2.6.29 patch has introduced flexible route cache rebuilding. Unfortunately the
>  patch has at least one critical flaw, and another problem.
> 
>  rt_intern_hash calculates rthi pointer, which is later used for new entry
>  insertion. The same loop calculates cand pointer which is used to clean the
>  list. If the pointers are the same, rtable leak occurs, as first the cand is
>  removed then the new entry is appended to it.
> 
>  This leak leads to unregister_netdevice problem (usage count > 0).
> 
>  Another problem of the patch is that it tries to insert the entries in certain
>  order, to facilitate counting of entries distinct by all but QoS parameters.
>  Unfortunately, referencing an existing rtable entry moves it to list beginning,
>  to speed up further lookups, so the carefully built order is destroyed.
> 
>  For the first problem the simplest patch it to set rthi=0 when rthi==cand, but
>  it will also destroy the ordering.
> end_of_quotation
> 
> Problematic commit is 1080d709fb9d8cd4392f93476ee46a9d6ea05a5b
> (net: implement emergency route cache rebulds when gc_elasticity is exceeded)
> 
> Trying to keep dst_entries ordered is too complex and breaks the fact that
> order should depend on the frequency of use for garbage collection.
> 
> A possible fix is to make rt_intern_hash() simpler, and only makes
> rt_check_expire() a litle bit smarter, being able to cope with an arbitrary
> entries order. The added loop is running on cache hot data, while cpu
> is prefetching next object, so should be unnoticied.
> 
> Reported-and-analyzed-by: Alexander V. Lukyanov <lav@yar.ru>
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks, updated.

Rafael
