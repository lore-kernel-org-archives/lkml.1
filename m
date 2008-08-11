Return-Path: <linux-kernel-owner+w=401wt.eu-S1751378AbYHKEuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbYHKEuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 00:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750725AbYHKEtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 00:49:55 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:46141 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750707AbYHKEty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 00:49:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=AYFA+hcbXY177D3mkHtmrLuHXchQsG4KaG5+fsFbuliFS210tLunFV8MveiNPNVo4FCn4C85pToKZPXML5V5uyQbPMETSYbVcEq+HJKwtizP+HzcHTn8h9eevWozhNvnPKzKpmc8JV/NUc8fw7TF7K3VZwr0RNPLDbdkz429otk=  ;
X-YMail-OSG: ckxjZSwVM1kOrtG3gEJZ3JITk.RrBAlF0QTQ9LlVgQWB780hjwI20GPGRVLmJLSlDF8vciXe2r7lPZahJD1vZuD5xb0OW3bJ6t9SdNIOowDNxvw8YVrJtKxsA3YNGqslIdY-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] stack and rcu interaction bug in smp_call_function_mask()
Date: Mon, 11 Aug 2008 14:49:47 +1000
User-Agent: KMail/1.9.5
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       npiggin@suse.de, linux-kernel <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com
References: <20080808193753.GA21964@linux-os.sc.intel.com> <200808101624.15112.nickpiggin@yahoo.com.au> <489FBF6A.40402@goop.org>
In-Reply-To: <489FBF6A.40402@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808111449.48123.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 August 2008 14:26, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > Nice debugging work.
> >
> > I'd suggest something like the attached (untested) patch as the simple
> > fix for now.
> >
> > I expect the benefits from the less synchronized, multiple-in-flight-data
> > global queue will still outweigh the costs of dynamic allocations. But
> > if worst comes to worst then we just go back to a globally synchronous
> > one-at-a-time implementation, but that would be pretty sad!
>
> What if we went the other way and strictly used queue-per-cpu?  It means
> multicast would require multiple enqueueing operations, which is a bit
> heavy, but it does make dequeuing and lifetime management very simple...

Well that's implemented with the optimized call-single code of course,
so it could be used to implement the masked calls...

I had wanted to look into finding a good cutoff point and use the
percpu queues for light weight masks, and the single global queue for
larger ones.

Queue per cpu is not going to be perfect, though. In the current
implementation, you would need a lot of data structures. You could
alleviate this problem by using per CPU vectors rather than lists,
but then you get the added problem of resource starvation at the
remote end too.

For heavy weight masks on large systems, the single queue I'd say
will be a win. But I never did detailed measurements, so I'm open
to be proven wrong.
