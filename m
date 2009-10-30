Return-Path: <linux-kernel-owner+w=401wt.eu-S932641AbZJ3QYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbZJ3QYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 12:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932597AbZJ3QYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 12:24:32 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:22223 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932553AbZJ3QYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 12:24:31 -0400
X-Trace: 278567974/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.93.83/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.93.83
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhAFAMOv6kpQKV1T/2dsb2JhbACBT9EXCI8Cgk0IgWgE
X-IronPort-AV: E=Sophos;i="4.44,654,1249254000"; 
   d="scan'208";a="278567974"
Date: Fri, 30 Oct 2009 16:24:26 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrea Arcangeli <aarcange@redhat.com>
cc: =?UTF-8?Q?Vedran_Fura=C4=8D?= <vedran.furac@gmail.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Memory overcommit
In-Reply-To: <20091030151544.GR9640@random.random>
Message-ID: <Pine.LNX.4.64.0910301558050.3974@sister.anvils>
References: <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com>
 <4AE846E8.1070303@gmail.com> <alpine.DEB.2.00.0910281307370.23279@chino.kir.corp.google.com>
 <4AE9068B.7030504@gmail.com> <alpine.DEB.2.00.0910290132320.11476@chino.kir.corp.google.com>
 <4AE97618.6060607@gmail.com> <alpine.DEB.2.00.0910291225460.27732@chino.kir.corp.google.com>
 <4AEAEFDD.5060009@gmail.com> <20091030141250.GQ9640@random.random>
 <4AEAFB08.8050305@gmail.com> <20091030151544.GR9640@random.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009, Andrea Arcangeli wrote:
> 
> It is a guess in the sense to guarantee no ENOMEM it has to take into
> account the worst possible case, that is all shared lib MAP_PRIVATE
> mappings are cowed, which is very far from reality.

A MAP_PRIVATE area is only counted into Committed_AS when it is or
has in the past been PROT_WRITE.  I think it's up to the ELF header
of the shared library whether a section is PROT_WRITE or not; but it
looks like many are not, so Committed_AS should be (a little) nearer
reality than you fear.

Though we do account for Committed_AS, even while allowing overcommit,
we do not at present account for Committed_AS per mm.  Seeing David
and KAMEZAWA-san debating over total_vm versus rss versus anon_rss,
I wonder whether such a "commit" count might be a better measure for
OOM choices (but shmem is as usual awkward: though accounted just once
in Committed_AS, it would probably have to be accounted to every mm
that maps it).  Just an idea to throw into the mix.

Hugh
