Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbZKWIsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbZKWIsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 03:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbZKWIsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 03:48:40 -0500
Received: from mga10.intel.com ([192.55.52.92]:3523 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751524AbZKWIsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 03:48:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,268,1257148800"; 
   d="scan'208";a="516452369"
Subject: Re: [MM] Make mm counters per cpu instead of atomic
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <alpine.DEB.1.10.0911171223460.20360@V090114053VZO-1>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>
	 <1258440521.11321.32.camel@localhost> <1258443101.11321.33.camel@localhost>
	 <1258450465.11321.36.camel@localhost>
	 <alpine.DEB.1.10.0911171223460.20360@V090114053VZO-1>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 23 Nov 2009 16:51:10 +0800
Message-Id: <1258966270.29789.45.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 12:25 -0500, Christoph Lameter wrote:
> On Tue, 17 Nov 2009, Zhang, Yanmin wrote:
> 
> > The right change above should be:
> >  struct mm_counter *m = per_cpu_ptr(mm->rss, cpu);
> 
> Right.
> 
> > With the change, command 'make oldconfig' and a boot command still
> > hangs.
> 
> Not sure if its worth spending more time on this but if you want I will
> consolidate the fixes so far and put out another patchset.
> 
> Where does it hang during boot?
Definitely faint.

1) In function exec_mmap: in the 2nd 'if (old_mm) {', mm_reader_unlock
should be used. Your patch uses mm_reader_lock. I found it when reviewing your
patch, but forgot to fix it when testing.
2) In function madvise: the last unlock should be mm_reader_unlock. Your
patch uses mm_writer_unlock.

It's easy to hit the issues with normal testing. I'm surprised you didn't
hit them.

Another theoretic issue is below scenario:
Process A get the read lock on cpu 0 and is scheduled to cpu 2 to unlock. Then
it's scheduled back to cpu 0 to repeat the step. eventually, the reader counter
will overflow. Considering multiple thread cases, it might be faster to
overflow than what we imagine. When it overflows, processes will hang there.


