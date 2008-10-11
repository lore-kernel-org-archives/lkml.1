Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbYJKNsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbYJKNsw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 09:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYJKNso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 09:48:44 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:24912 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753043AbYJKNso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 09:48:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kId03pznl30hJEvqURCCdcege/HbGH7kU/h0zRphRWqSZeyrICGJvl8iPcN5rEhtIcTJ0MfGMuHj0dn7oSwS/9lYQ3nH+mYSyGUiXVaCjpkN8oXmPAUyuP+81nMpaD2z2reGtvl1IW1NVEqGhCkf20dCUhhhwgnQdTDspSQVBoU=  ;
X-YMail-OSG: sXuuaZMVM1lONdo3f1ZB7B54nZGtr2YYgqpjiS37ZVlDuQmNbKop0jUVM_yNkC7V8qnuiSOXfbkZQXD7HdQmgroXyOXKB6xo21yvCRxcjW_sv0ylxya.0_yje0tze.UC2VzGCd8DdyDm2MtMj6tTwnyLVdbmTRVHuXQtoAKm
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Update cacheline size on X86_GENERIC
Date: Sun, 12 Oct 2008 00:48:30 +1100
User-Agent: KMail/1.9.5
Cc: Dave Jones <davej@redhat.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <20081009171453.GA15321@redhat.com> <200810112242.28229.nickpiggin@yahoo.com.au> <20081011131115.GB12131@one.firstfloor.org>
In-Reply-To: <20081011131115.GB12131@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810120048.31141.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 October 2008 00:11, Andi Kleen wrote:
> > > > That would be nice. It would be interesting to know what is causing
> > > > the slowdown.
> > >
> > > At least that test is extremly cache footprint sensitive. A lot of the
> > > cache misses are surprisingly in hd_struct, because it runs
> > > with hundred of disks and each needs hd_struct references in the fast
> > > path. The recent introduction of fine grained per partition statistics
> > > caused a large slowdown. But I don't think kernel workloads
> > > are normally that extremly cache sensitive.
> >
> > That's interesting. struct device is pretty big. I wonder if fields
>
> Yes it is (it actually can be easily shrunk -- see willy's recent
> patch to remove the struct completion from knodes), but that won't help
> because it will always
> be larger than a cache line and it's in the middle, so the
> accesses to first part of it and last part of it will be separate.
>
> > couldn't be rearranged to minimise the fastpath cacheline footprint?
> > I guess that's already been looked at?
>
> Yes, but not very intensively. So far I was looking for more
> detailed profiling data to see the exact accesses.
>
> Of course if you have any immediate ideas that could be tried too.

No immediate ideas. Jens probably is a good person to cc. With direct IO
workloads, hd_struct should mostly only be touched in partition remapping
and IO accounting.

start_sect, nr_sects would be read for partition remapping.

*dkstats will be read to do accounting (dkstats for UP is written, but
false sharing doesn't matter on UP), as does partno.

These could all go together at the top of the struct perhaps.

struct device->parent gets read as well. This might go at the top of
struct device, which could come next.

stamp and in_flight are tricky, as they get both read and written often
:(

Still, you might just be able to fit them into the same 64-byte cacheline
as well as all the above fields.

At this point, you would want to cacheline align hd_struct. So if you
want to do that dynamically, you would need to change the disk_part_tbl
scheme (but at least you could test with static annotations first).

The other thing I notice is the block layer has some functions which
have error paths that have BDEVNAME_SIZE size arrays for error cases,
which gcc may not do well at. Probably they should go out to noinline
functions.
