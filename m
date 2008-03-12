Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbYCLBWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbYCLBWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 21:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYCLBWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 21:22:12 -0400
Received: from n9a.bullet.ukl.yahoo.com ([217.146.183.157]:43030 "HELO
	n9a.bullet.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751697AbYCLBWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 21:22:11 -0400
X-Yahoo-Newman-Id: 177901.60893.bm@omp408.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VnUcXzYuKXEeq8PIBtCDWnUVpK3+wKM7wW86lYfpC4U0tw6X9MgkJf41O+NndEOCBBbDaTTpJF3gmPlVznHtL9JxmkIqeVnoZ0ImGUzCCqqQsSv5emI6i8XXxHA0n+xh9OnBryZFJKLR+J1OJHNa/nImRvFUV400FUvUg9u2f7A=  ;
X-YMail-OSG: QVMe4GIVM1nTRzHDFYkMvb4VgVJJPlxf8_FyNOAuxw1dl64jYYMv5wdl8acI4alccr52AW.ZKw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>, "LKML, " <linux-kernel@vger.kernel.org>
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
Date: Wed, 12 Mar 2008 12:21:37 +1100
User-Agent: KMail/1.9.5
References: <200803111749.29143.nickpiggin@yahoo.com.au> <20080311102538.GA30551@elte.hu> <20080311120230.GA5386@elte.hu>
In-Reply-To: <20080311120230.GA5386@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121221.37234.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Back onto lkml)

On Tuesday 11 March 2008 23:02, Ingo Molnar wrote:
> another thing to try would be to increase:
>
>   /proc/sys/kernel/sched_migration_cost
>
> from its 500 usecs default to a few msecs ?

This doesn't really help either (at 10ms).

(For the record, I've tried turning SD_WAKE_IDLE, SD_WAKE_AFFINE
on and off for each domain and that hasn't helped either).

I've also tried increasing sched_latency_ns as far as it can go.
BTW. this is a pretty nasty behaviour if you ask my opinion. It
starts *increasing* the number of involuntary context switches
as resources get oversubscribed. That's completely unintuitive as
far as I can see -- when we get overloaded, the obvious thing to
do is try to increase efficiency, or at least try as hard as
possible not to lose it. So context switches should be steady or
decreasing as I add more processes to a runqueue.

It seems to max out at nearly 100 context switches per second,
and this has actually shown to be too frequent for modern CPUs
and big caches.

Increasing the tunable didn't help for this workload, but it really
needs to be fixed so it doesn't decrease timeslices as the number
of processes increases.

