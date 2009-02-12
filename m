Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbZBLB4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbZBLB4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688AbZBLB4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:56:14 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:36113 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755656AbZBLB4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:56:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4uklgp4A1fM03VpMFZxMoSnjnrwYUfM6m9sF/bCjg2uz1rq+VnyL78kgQxLkTAZfhzBNWA2Rw/gQrF8Z4ftscRIWvEbd05a/839d0NoD5sR9Ohf8N0Zb6Molq46ldp0zGD2lo2oJg+fDOyk5smZfiYkILF4vDT5ppVC0FmxK29s=  ;
X-YMail-OSG: vIEkuksVM1kHzGlMkPl9JGfmiFPvwrZP1bWJHoVtvzmWuNUqiQPs1CC2VZatbRAiAvw7dCQjTq6hoTxIzCywrEUL1UEY1lO2r45c7V4DUUoM10lSUsfNwD6Mromo0ish7COWLZH9BogUEG594gmqsvnz8TAehNFBBMJ4YnZJmtxyMJUcMJ4JvrqtnfJEIT77JoQnRUNAXrwvEF.vAaYE8yL4efpbPA1MevM-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Menage <menage@google.com>
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the unallowed node when memory spread is set
Date: Thu, 12 Feb 2009 12:55:42 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Paul Jackson <pj@sgi.com>, miaox@cn.fujitsu.com,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org
References: <4976D77C.3020107@cn.fujitsu.com> <200902121154.02868.nickpiggin@yahoo.com.au> <6599ad830902111719n2750ac29u458face30bf3f7cb@mail.gmail.com>
In-Reply-To: <6599ad830902111719n2750ac29u458face30bf3f7cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902121255.43047.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 February 2009 12:19:11 Paul Menage wrote:
> On Wed, Feb 11, 2009 at 4:54 PM, Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > It would be possible, depending on timing, for the allocating thread to
> > see either pre or post mems_allowed even if access was fully locked.
>
> Right - seeing either the pre set or the post set is fine.
>
> > The only difference is that a partially changed mems_allowed could be
> > seen. But what does this really mean? Some combination of the new and
> > the old nodes. I don't think this is too much of a problem.
>
> But if the old and new nodes are disjoint, that could lead to seeing no
> nodes.

Well we could structure updates as setting all new allowed nodes,
then clearing newly disallowed ones.


> Also, having the results of cpuset_zone_allowed() and
> cpuset_current_mems_allowed change at random times over the course of
> a call to alloc_pages() might cause interesting effects (e.g. we make
> progress freeing pages from one set of nodes, and then call
> get_page_from_freelist() on a different set of nodes).

But again, is this really a problem? We're talking about a tiny
possibility in a very uncommon case anyway when the cpuset is
changing.

If it can cause an outright error like OOM of course that's no
good, but if it just requires us to go around the reclaim loop
or allocate from another zone... I don't think that's so bad.


> > This could work if we *really* need an atomic snapshot of mems_allowed.
> > seqcount synchronisation would be an alternative too that could allow
> > sleeping more easily than SRCU (OTOH if you don't need sleeping, then
> > RCU should be faster than seqcount).
> >
> > But I'm not convinced we do need this to be atomic.
>
> It's possible that I'm being overly-paranoid here. The decision to
> make mems_allowed updates be purely pulled by the task itself predates
> my involvement with cpusets code by a long time.

It's not such a bad model, but the problem with it is that it needs
to be carefully spread over the VM, and in fastpaths too. Now if it
were something really critical, fine, but I'm hoping we can do
without.


