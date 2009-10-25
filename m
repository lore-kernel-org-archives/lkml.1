Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbZJYHa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbZJYHa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 03:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZJYHa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 03:30:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36366 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbZJYHaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 03:30:25 -0400
Date: Sun, 25 Oct 2009 03:30:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arndbergmann@googlemail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
Message-ID: <20091025073027.GA1226@infradead.org>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain> <20091021213139.GC4880@nowhere> <20091022025514.GB17438@infradead.org> <200910221550.05524.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910221550.05524.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 03:50:04PM +0200, Arnd Bergmann wrote:
> Is it safe to assume that file_operations without a read() or write()
> method also don't need llseek?

There are two reasons why a driver could need llseek:

 (a) it uses the file position somewhere.  Normally that's just in
     read/write, but I wouldn't be surprised if there are drivers using
     the file position somewhere in weird ioctls.
 (b) because broken userland assumes they can seek on the file
     descriptor.  For example some versions of tar expect lseek to work
     on tape devices despite them not actually using the file position
     anywere.

So the answer to your above questions is: most likely yes, but and audit
for a) should be performed.  We can't do much about (b) except for trial
and error.  Unless there are very important applications expecting to be
able to seek I think returning the correct error is more important than
having zero change in behaviour.

> Testing for S_IFREG will not work well for debugfs, which is probably
> a large number of the cases that do not want an llseek method.

Yes.  S_IFREG should be done last, and probably the real filesystem
should be converted to always have a llseek method before tackling the
mess in the synthetic filesystems.

