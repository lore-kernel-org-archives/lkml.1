Return-Path: <linux-kernel-owner+w=401wt.eu-S1752142AbYJLF42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbYJLF42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 01:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbYJLF4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 01:56:19 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:33011 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750822AbYJLF4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 01:56:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GjuNBFzjelUUzv2Xb7GQubavRDzMm8eLWdpfgLAOuHHnd8xoJEwGWlN+ke3q9Ls5av4tJZppofEGHoS285D35I9ohc66gjOLswiKrXqe5OS8IohN4NGVAWm28filzK6LpprJpwbTmWg9PA3Ys/Pk8/kub1Kl7PQZP3PjDdK7KgQ=  ;
X-YMail-OSG: vTG2TQoVM1lFNw0li.nQwVxpI21NZxatFUPvDqtjT1WZoNvmhoKTW_nKZsYJQjtJOm.zhL4tSeLFPkMPgZAhP_50RWCIi7UO6J1B57u3huITkYgOvoxvnfcnx_fE83Qgc_VHn6Vd8ImXm70PjkrtIYAli1LAHIAtx4DW4znK
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>, davem@davemloft.net
Subject: Re: Update cacheline size on X86_GENERIC
Date: Sun, 12 Oct 2008 16:56:05 +1100
User-Agent: KMail/1.9.5
Cc: Dave Jones <davej@redhat.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <20081009171453.GA15321@redhat.com> <200810120048.31141.nickpiggin@yahoo.com.au> <20081011140119.GC12131@one.firstfloor.org>
In-Reply-To: <20081011140119.GC12131@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810121656.05999.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 October 2008 01:01, Andi Kleen wrote:
> > No immediate ideas. Jens probably is a good person to cc. With direct IO
> > workloads, hd_struct should mostly only be touched in partition remapping
> > and IO accounting.
>
> I found it doubtful if grouping the rw and ro members together was a good
> idea.

If all members touched in the fastpath fit into one cacheline, then it
definitely is. Because if you put the rw members in another cacheline,
that line is still going to bounce just the same, but then you are just
going to take up one more cacheline with the ro members.


> > At this point, you would want to cacheline align hd_struct. So if you
>
> The problem is probably not false sharing, but simply cache misses because
> it's so big. I think.

If you line up all the commonly touched members into cacheline boundaries,
then presumably you have to assume the start of the struct has eg. cacheline
alignment. There are situations where you can almost cut down cacheline
footprint of a given data structure by 2x by aligning the items (eg. if we
align struct page to 64 bytes, then random access to mem_map array will be
almost 1/2 the cacheline footprint). I've always been interested in whether
"oltp" benefits from that (eg. define WANT_PAGE_VIRTUAL for x86-64).
