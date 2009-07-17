Return-Path: <linux-kernel-owner+w=401wt.eu-S934680AbZGQPJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934680AbZGQPJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 11:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934131AbZGQPJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 11:09:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55192 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932790AbZGQPJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 11:09:23 -0400
Date: Fri, 17 Jul 2009 11:09:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: xfs mr_lock vs mmap_sem lock inversion?
Message-ID: <20090717150922.GA434@infradead.org>
References: <1247580955.7500.97.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247580955.7500.97.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's a problem in the VM code, which we already discussed a while
ago.  The problem is that the VMA manipultation code calls fput
under the mmap_sem, while we can take mmap_sem ue to a page fault
from inside generic_file_aio_read/write.  So any filesystem
that nees the same lock held over read/write also in release is
crewed.

Now on the positive side I think we can actually get rid of taking
the iolock in ->release in XFS, but I'm sure other filesystems
might continue hitting similar issues.

