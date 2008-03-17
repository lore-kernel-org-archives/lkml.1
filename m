Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbYCQCZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbYCQCZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 22:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYCQCYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 22:24:52 -0400
Received: from n4.bullet.mail.tp2.yahoo.com ([203.188.202.80]:28040 "HELO
	n4.bullet.mail.tp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751232AbYCQCYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 22:24:51 -0400
X-Yahoo-Newman-Id: 118230.19036.bm@omp415.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=REsIchYkuVPk/c7KFbfA4pMfojWjkYuja/zOoRXWHC7jfDYpCYqOsbk1BZqm2PD1nRxmZKuzpFWRQ/Mqs88b3/MYn2qJ8kLLSUVO/m1ij46SmviUBbatFnchuQ0qQREXgWJvTRHMZLeF/hO3x0QibpQNw/GF0qhEwePxRN1paBE=  ;
X-YMail-OSG: eEWi6IAVM1m8B1U_wnkDFGaKMXUTv649OYC36CYFOCQ.jOlBqTum_sHEQrMNm9UBeyGChmC_wQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/7] x86-64: introduce fast variant of smp_call_function_single()
Date: Mon, 17 Mar 2008 13:24:31 +1100
User-Agent: KMail/1.9.5
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       npiggin@suse.de, dgc@sgi.com
References: <1205322940-20127-1-git-send-email-jens.axboe@oracle.com> <20080316184506.GW17940@kernel.dk> <47DDA624.8000307@goop.org>
In-Reply-To: <47DDA624.8000307@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803171324.32001.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008 09:58, Jeremy Fitzhardinge wrote:
> Jens Axboe wrote:
> > On Fri, Mar 14 2008, Jeremy Fitzhardinge wrote:
> >> Jens Axboe wrote:
> >>> rom: Nick Piggin <npiggin@suse.de>
> >>
> >> Why is this necessary?  How is smp_call_function_single slow?
> >
> > Because it's completely serialized by the call_lock spinlock.
>
> Hm, yes.  Would it be possible to implement smp_call_function_mask in a
> generic way to avoid that?  Turn the static structure into a per-cpu
> request list?

Not really. The common cases (that I can see) are either call all,
or call one. In the call all case, you would have to touch every
other CPU's request list, and that's not really any better than
what I've done in my patchest for that.

There would presumably be some cutoff where it makes more sense to
queue events to the percpu IPI lists if you are only sending to a
few CPUs. That would be trivial to implement, but... what are the
use-cases for that? The big one that I really know of is user TLB
shootdown, but that has its own vector anyway.

