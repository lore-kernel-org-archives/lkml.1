Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZJVCzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZJVCzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 22:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZJVCzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 22:55:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbZJVCzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 22:55:11 -0400
Date: Wed, 21 Oct 2009 22:55:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
Message-ID: <20091022025514.GB17438@infradead.org>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain> <alpine.LFD.2.00.0910192019420.3563@localhost.localdomain> <200910200000.24574.arnd@arndb.de> <200910200008.57468.arnd@arndb.de> <20091021213139.GC4880@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091021213139.GC4880@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 11:31:42PM +0200, Frederic Weisbecker wrote:
> What about a pusdown of default_lseek attribution for these
> fops that don't have any llseek() (and rename it to
> deprecated_default_lseek() )
> 
> Because we can probably fix these fops one by one but what
> about the next drivers that will have no llseek() ?
> 
> We can't attribute default_llseek() by default anymore for
> further fops that are to come.

The right (although quite complicated) thing is to return -ESPIPE from
vfs_llseek if no ->llseek method is present, or even better also
disallowing pread/pwrite by default.  It'll need a quite substantial
audit and is best done by different types of inodes - S_IFIFO is easy,
SIFDIR at least has very few instances, S_IFREG usually wants a real
llseek (generic_file_llseek in most cases) and directories also need
a llseek method that takes i_mutex so it protects against namespace
operations.

