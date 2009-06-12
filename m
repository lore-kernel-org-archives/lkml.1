Return-Path: <linux-kernel-owner+w=401wt.eu-S934431AbZFLNvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934431AbZFLNvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934278AbZFLNtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:49:31 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:58536 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934282AbZFLNta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:49:30 -0400
Date: Fri, 12 Jun 2009 09:49:26 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu, akpm@linux-foundation.org,
       npiggin@suse.de
Subject: Re: slab: setup allocators earlier in the boot sequence
In-Reply-To: <1244797659.30512.37.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0906120944540.15809@gentwo.org>
References: <200906111959.n5BJxFj9021205@hera.kernel.org>  <1244770230.7172.4.camel@pasglop>  <1244779009.7172.52.camel@pasglop>  <1244780756.7172.58.camel@pasglop> <1244783235.7172.61.camel@pasglop>  <Pine.LNX.4.64.0906120913460.26843@melkki.cs.Helsinki.FI>
  <1244792079.7172.74.camel@pasglop>  <1244792745.30512.13.camel@penberg-laptop>  <1244796045.7172.82.camel@pasglop>  <1244796211.30512.32.camel@penberg-laptop>  <1244796837.7172.95.camel@pasglop> <1244797659.30512.37.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Pekka Enberg wrote:

> So I am sending the GFP_NOWAIT conversion for boot code even though you
> didn't seem to like it (but didn't explicitly NAK) as it fixes problems
> on x86.

The use GFP_NOWAIT means that the caller sites are still special cased for
an early boot situation. After bootstrap is complete the sites may use
GFP_KERNEL instead. Bad.

Best thing to do is to recognize the fact that we are still in early boot
in the allocators. Derived allocators (such as slab and vmalloc) mask bits
using GFP_RECLAIM_MASK and when doing allocations through the page
allocator. You could make GFP_RECLAIM_MASK a variable. During boot
__GFP_WAIT would not be set in GFP_RECLAIM_MASK.
