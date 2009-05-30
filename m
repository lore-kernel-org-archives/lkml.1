Return-Path: <linux-kernel-owner+w=401wt.eu-S1762657AbZE3R1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762657AbZE3R1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 13:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760266AbZE3R1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 13:27:37 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:51406 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbZE3R1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 13:27:37 -0400
Date: Sat, 30 May 2009 10:25:15 -0700
From: "Larry H." <research@subreption.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       pageexec@freemail.hu, Arjan van de Ven <arjan@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090530172515.GE6535@oblivion.subreption.com>
References: <20090522073436.GA3612@elte.hu> <20090530054856.GG29711@oblivion.subreption.com> <1243679973.6645.131.camel@laptop> <4A211BA8.8585.17B52182@pageexec.freemail.hu> <1243689707.6645.134.camel@laptop> <20090530153023.45600fd2@lxorguk.ukuu.org.uk> <1243694737.6645.142.camel@laptop> <4A214752.7000303@redhat.com> <20090530170031.GD6535@oblivion.subreption.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090530170031.GD6535@oblivion.subreption.com>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done. I just tested with different 'leak' sizes on a kernel patched with
the latest memory sanitization patch and the kfree/kmem_cache_free one:

	10M	- no occurrences with immediate scanmem
	40M	- no occurrences with immediate scanmem
	80M	- no occurrences with immediate scanmem
	160M	- no occurrences with immediate scanmem
	250M	- no occurrences with immediate scanmem
	300M	- no occurrences with immediate scanmem
	500M	- no occurrences with immediate scanmem
	600M	- with immediate zeromem 600 and scanmem afterwards,
		 no occurrences.

The results are satisfactory to me. With the patch applied but
sanitization disabled, a single megabyte test produces 54 occurrences
time after we ran secretleak. With higher amounts of memory, it gets
ridiculous.

I tested out of curiosity how the number of occurrences evolved through
different intervals on a sanitize-disabled system for a 10M leak:

2145
2128
2121
2118
2055
2046
2046
2046
2046
2045

That's under relatively idle work load. Until a larger size allocation
is requested somewhere else, the data is still there. The sad thing
about this, is that a website could be able to force Firefox, for
example, into allocating large amounts of memory (using Javascript, some
plugin, etc) and ensure that any cryptographic secrets previously used
in the browser will remain there even after it has been closed. The
unlikeliness of having such data disappear is directly proportional to
the size of the memory used by the process during its runtime.

This applies to any application (OpenOffice, vim loading large files,
your IRC or silc client, your image editing software, etc).

	Larry
