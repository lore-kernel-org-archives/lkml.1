Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZJVNuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZJVNuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 09:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbZJVNuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 09:50:11 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:54151 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZJVNuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 09:50:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=KVXCeLRhVY6+LQ5LVFJFQuFqHAfx6qmJp0YBFZzmP2N20/gUzIrFbg9mHL1+bvWcLx
         59z3+cn1y+kvH5w2lRRzYCX2IYFcZfajGK2Oh8H2qABJ54XUHIsHM+z4kY9uyc+09o1U
         JDtYArXgEoCpqmDxPD66Hbpw3pWLjlfRbtrMU=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
Date: Thu, 22 Oct 2009 15:50:04 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain> <20091021213139.GC4880@nowhere> <20091022025514.GB17438@infradead.org>
In-Reply-To: <20091022025514.GB17438@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910221550.05524.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 October 2009, Christoph Hellwig wrote:

> The right (although quite complicated) thing is to return -ESPIPE from
> vfs_llseek if no ->llseek method is present, or even better also
> disallowing pread/pwrite by default.  It'll need a quite substantial
> audit and is best done by different types of inodes - S_IFIFO is easy,
> SIFDIR at least has very few instances, S_IFREG usually wants a real
> llseek (generic_file_llseek in most cases) and directories also need
> a llseek method that takes i_mutex so it protects against namespace
> operations.

Is it safe to assume that file_operations without a read() or write()
method also don't need llseek?

There are over 200 instances of file_operations that have a no read,
write or lseek operations and we can easily detect that in vfs_llseek,
calling no_llseek by default.

Testing for S_IFREG will not work well for debugfs, which is probably
a large number of the cases that do not want an llseek method.

	Arnd <><
