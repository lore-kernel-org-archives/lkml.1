Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbXI2Mpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbXI2Mpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 08:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758149AbXI2MpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 08:45:14 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:32908 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758142AbXI2MpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 08:45:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=o5f44/TPHq9a4iPGRHOHF8SXtg3rp4+GqWqV5R7aDe4OKXNUUZURG3RArv5wX429I4H24vx56CzZx3ZmZoIzG8kTMNCtqcUQNp9sndZqRBb5XhNGWGEWygu7NR9ZelcYXirOD/jCBOxZYUcAbRDrGSWq9dmhMfvdzyUh/GkvISM=  ;
X-YMail-OSG: lgE0V0UVM1liNxBtGvUEeD87qYAPF91ZHW5g4jBmL_CsmYhSW9d6hPvPuw3us1Ck8M9WxkxJUg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH] mm: couple rcu and memory reclaim
Date: Sat, 29 Sep 2007 06:13:51 +1000
User-Agent: KMail/1.9.5
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>
References: <20070924104517.7d8126ae@twins>
In-Reply-To: <20070924104517.7d8126ae@twins>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709290613.51790.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 September 2007 18:45, Peter Zijlstra wrote:
> Just an idea I had, it seems like a good idea to wait for RCU callbacks
> in reclaim so that we won't get all of memory stuck there.

I think it would be much too aggressive (_especially_ with preemptible
RCU, I would have thought?). And not just for the case of adding a lot
of idle time while other CPUs are busy not being preempted -- also
that if you have lots of CPUs reclaiming and asking to synchronize_rcu,
then you could have global RCU state getting ping-ponged.


> If this location is too aggressive we might stick it next to
> disable_swap_token().

I don't see a really good reason to add this kind of wait here. I mean,
we have to wait for RCU anyway, so we may as well scan what we can
until then?

Putting it in a slowpath at some point when we think we're heading for
OOM I think would be a bit better.
