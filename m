Return-Path: <linux-kernel-owner+w=401wt.eu-S1760405AbYBUEU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405AbYBUEU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 23:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbYBUEUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 23:20:17 -0500
Received: from n21.bullet.mail.mud.yahoo.com ([68.142.200.112]:44558 "HELO
	n21.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754203AbYBUEUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 23:20:14 -0500
X-Yahoo-Newman-Id: 326049.71604.bm@omp418.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2sz7mylGdiXchG0DBUjtKT2MxkGR4R/NCFR6cGxRd7TMviDdRPiou6bsc677RBPWPVgfno9+Kn/b4HT+A4FFo63gSaSq3xEnYqb0TGyDXsk5wStn7coAwI17yFSsa61zdeo1ATtFGm2gUcHvbbDDub55u1cMLzzEccY0Lfw2SEQ=  ;
X-YMail-OSG: 1YO5z7QVM1k1UwNE7MeJuVT9aBzfvtXOa96m.kwHy3KwMcFjCbtMpr0e4arhgDn6UdIHrfDRBw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Robin Holt <holt@sgi.com>
Subject: Re: [patch 5/6] mmu_notifier: Support for drivers with revers maps (f.e. for XPmem)
Date: Thu, 21 Feb 2008 15:20:02 +1100
User-Agent: KMail/1.9.5
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
References: <20080215064859.384203497@sgi.com> <200802201451.46069.nickpiggin@yahoo.com.au> <20080220090035.GG11391@sgi.com>
In-Reply-To: <20080220090035.GG11391@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802211520.03529.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2008 20:00, Robin Holt wrote:
> On Wed, Feb 20, 2008 at 02:51:45PM +1100, Nick Piggin wrote:
> > On Wednesday 20 February 2008 14:12, Robin Holt wrote:
> > > For XPMEM, we do not currently allow file backed
> > > mapping pages from being exported so we should never reach this
> > > condition. It has been an issue since day 1.  We have operated with
> > > that assumption for 6 years and have not had issues with that
> > > assumption.  The user of xpmem is MPT and it controls the communication
> > > buffers so it is reasonable to expect this type of behavior.
> >
> > OK, that makes things simpler.
> >
> > So why can't you export a device from your xpmem driver, which
> > can be mmap()ed to give out "anonymous" memory pages to be used
> > for these communication buffers?
>
> Because we need to have heap and stack available as well.  MPT does
> not control all the communication buffer areas.  I haven't checked, but
> this is the same problem that IB will have.  I believe they are actually
> allowing any memory region be accessible, but I am not sure of that.

Then you should create a driver that the user program can register
and unregister regions of their memory with. The driver can do a
get_user_pages to get the pages, and then you'd just need to set up
some kind of mapping so that userspace can unmap pages / won't leak
memory (and an exit_mm notifier I guess).

Because you don't need to swap, you don't need coherency, and you
are in control of the areas, then this seems like the best choice.
It would allow you to use heap, stack, file-backed, anything.

