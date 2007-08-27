Return-Path: <linux-kernel-owner+w=401wt.eu-S1765408AbXH0Vol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765408AbXH0Vol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765560AbXH0VbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:31:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59044 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765532AbXH0VbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:31:12 -0400
Date: Mon, 27 Aug 2007 23:31:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [RFC][PATCH 2/2 -mm] kexec based hibernation: kexec restore
Message-ID: <20070827213134.GE3398@elf.ucw.cz>
References: <1188177296.3247.38.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188177296.3247.38.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch adds writing support for /dev/oldmem. This is used to
> restore the memory contents of hibernated system.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

> +ssize_t write_oldmem_page(unsigned long pfn, const char *buf,
> +			  size_t csize, unsigned long offset, int userbuf)

Hmm, int userbuf is only ever set to one... Does it make sense to have
write_oldmem_page in the separate file? The onl user is mem.c, perhaps
it should go there?

> +
> +/*
> + * Write memory corresponding to the old kernel.
> + */
> +static ssize_t write_oldmem(struct file *file, const char __user *buf,
> +			    size_t count, loff_t *ppos)
> +{
> +	unsigned long pfn, offset;
> +	size_t write = 0, csize;
> +	int rc = 0;
> +
> +	while (count) {
> +		pfn = *ppos / PAGE_SIZE;
> +		if (pfn > saved_max_pfn)
> +			return write;
> +
> +		offset = (unsigned long)(*ppos % PAGE_SIZE);
> +		if (count > PAGE_SIZE - offset)
> +			csize = PAGE_SIZE - offset;
> +		else
> +			csize = count;
> +		rc = write_oldmem_page(pfn, buf, csize, offset, 1);
> +		if (rc < 0)
> +			return rc;
> +		buf += csize;
> +		*ppos += csize;
> +		write += csize;
> +		count -= csize;
> +	}
> +	return write;
> +}

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
