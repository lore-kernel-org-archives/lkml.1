Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbXJCGGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbXJCGGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 02:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbXJCGGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 02:06:38 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:46109 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751948AbXJCGGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 02:06:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YoWoWSrxscMVfTxNQG+cgKyC9XzA9vM+eC1l2iaX6IDwfAmKD5gU7pp/3WcUsdlJyumsbyAlPtj1/I7jZJFdk//bQUa3Q0xKUvIxTDsabv0pQU5mxsJptRdiNddrZ5K7QptoYGcFxVUBnZvpjrma4ejgIOTrx1fABCeIZGH6hD4=  ;
X-YMail-OSG: aHIiFPEVM1kB5BYNgoVZLH8oiW.9X01u1rLIYb8Yot95xTsdBrmyScQTv7eVTts3OD9xML5KfIO8gtpuJRknDrz6HuTqzMj.fLX9_ljrOL3fzePqcBs-
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Date: Tue, 2 Oct 2007 23:35:04 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com> <200709301335.00441.nickpiggin@yahoo.com.au> <20071001111528.5487b4f4.pj@sgi.com>
In-Reply-To: <20071001111528.5487b4f4.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710022335.05357.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2007 04:15, Paul Jackson wrote:
> Nick wrote:
> > which you could equally achieve by adding
> > a second set of sched domains (and the global domains could keep
> > globally balancing).
>
> Hmmm ... this could be the key to this discussion.
>
> Nick - can two sched domains overlap?  And if they do, what does that
> mean on any user or application behaviour.

Yes, sched domains can be completely arbitrary, and of course in the
current kernel, parent domains always overlap their children.

A sched domain usually means that the scheduler can move tasks
around among that group of CPUs, given the correct flags (but if
there are no flags, then it would be a superfluous domain and should
get trimmed away I think).

BTW. as far as the sched.c changes in your patch go, I much prefer
the partition_sched_domains API: http://lkml.org/lkml/2006/10/19/85

The caller should manage everything itself, rather than
partition_sched_domains doing half of the memory allocation.


> From the cpuset side - this patch handles overlap by joining the 'cpus'
> into one sched domain.  If two cpusets with overlapping 'cpus' are both
> marked 'sched_load_balance', then this patch forms a single, combined
> sched domain.
>
> As best as I can tell, you and I are actually in agreement in the
> case that there is no overlap.  If the several cpusets which have
> 'sched_load_balance' enabled have mutually disjoint 'cpus' (no
> overlap), then my patch forms exactly one sched domain for each such
> cpuset, having the same 'cpus'.

OK, I don't think your patch actually does the wrong thing
technically (although admittedly your rebuild_sched_domains
isn't something I really applied my poor brain to).

> The issue is the overlapping cases - are overlapping sched domains
> allowed, and if so, how do they affect user space?

For hard partitions, you don't want them of course. And I think
we should come up with a cpusets solution for that first.

Afterwards, overlapping sched domains are allowed and could be
used to make balancing more efficient (rather than any real
affect on userspace). At the moment, the domain builder probably
wouldn't cope very well, though.
