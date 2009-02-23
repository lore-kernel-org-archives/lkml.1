Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZBWPmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZBWPmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbZBWPm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:42:27 -0500
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:28871 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754745AbZBWPm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:42:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jk/9ijdoRJay1/j2B8SBu5PBnwLCJBz2Zd0Xpp8AKIEkD+gJuYP/hjTLnHgq7VK0jn0yilmjbKjiRVJxIFZ2KJbTA/g3B88VB0XPngsZ+dJi43aEV4IGNtoCe6oobw7oJF7VmXeGOl5tjOCCvgXWxmYzOsD8N27MfSQ9UwSNI60=  ;
X-YMail-OSG: aPSeDNQVM1nsdLEgDhevlzw8dOsIkhiAOzCr5A19eyUhJ4KMcLfCURycq80hrw1XcQPTC96FnfSNK2KOCPg26QzmSaxU0FjRgXlPZoQFHcBnJ7VYbHNXrtOix99xSgIu1rbr4Wcp65hLo36cCllgezrTr_nMtM8Q9k9_xFmIkjHcG7KZmSbMQOR5bA9aPw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 04/20] Convert gfp_zone() to use a table of precalculated values
Date: Tue, 24 Feb 2009 02:41:47 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <1235344649-18265-5-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0902231003090.7298@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0902231003090.7298@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902240241.48575.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009 02:23:52 Christoph Lameter wrote:
> On Sun, 22 Feb 2009, Mel Gorman wrote:
> > Every page allocation uses gfp_zone() to calcuate what the highest zone
> > allowed by a combination of GFP flags is. This is a large number of
> > branches to have in a fast path. This patch replaces the branches with a
> > lookup table that is calculated at boot-time and stored in the
> > read-mostly section so it can be shared. This requires __GFP_MOVABLE to
> > be redefined but it's debatable as to whether it should be considered a
> > zone modifier or not.
>
> Are you sure that this is a benefit? Jumps are forward and pretty short
> and the compiler is optimizing a branch away in the current code.

Pretty easy to mispredict there, though, especially as you can tend
to get allocations interleaved between kernel and movable (or simply
if the branch predictor is cold there are a lot of branches on x86-64).

I would be interested to know if there is a measured improvement. It
adds an extra dcache line to the footprint, but OTOH the instructions
you quote is more than one icache line, and presumably Mel's code will
be a lot shorter.

>
> 0xffffffff8027bde8 <try_to_free_pages+95>:      mov    %esi,-0x58(%rbp)

