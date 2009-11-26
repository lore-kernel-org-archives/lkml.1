Return-Path: <linux-kernel-owner+w=401wt.eu-S1759146AbZKZJhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbZKZJhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758609AbZKZJhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:37:09 -0500
Received: from lazybastard.de ([212.112.238.170]:49894 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbZKZJhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:37:08 -0500
Date: Thu, 26 Nov 2009 10:36:58 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH/RFC v5 4/5]: core: Add dump device to call on oopses and panics
Message-ID: <20091126093657.GA25430@logfs.org>
References: <20091012122023.GA19365@elte.hu> <20091012150650.51a4b4dc@marrow.netinsight.se> <20091012131528.GC25464@elte.hu> <20091012153937.0dcd73e5@marrow.netinsight.se> <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain> <20091012110954.67d7d8d8.akpm@linux-foundation.org> <20091012182346.GH17138@elte.hu> <alpine.LFD.2.01.0910121130190.3438@localhost.localdomain> <20091013151751.59e217a7@marrow.netinsight.se> <20091013152235.188059d2@marrow.netinsight.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091013152235.188059d2@marrow.netinsight.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just stumbled across this patch.

On Tue, 13 October 2009 15:22:35 +0200, Simon Kagstrom wrote:
> +void dump_kmsg(int panic)
> +{
> +	unsigned long len = ACCESS_ONCE(log_end);
> +	struct dump_device *dump;
> +	const char *s1, *s2;
> +	unsigned long l1, l2;
> +
> +	s1 = "";
> +	l1 = 0;
> +	s2 = log_buf;
> +	l2 = len;
> +
> +	/* Have we rotated around the circular buffer? */
> +	if (len > log_buf_len) {

I believe this bit is wrong.  log_end is an unsigned int, so it can
wrap relatively quickly.  If log_end just wrapped to 0 and dump_kmsg is
called, the amount of printk buffer stored appears to be 0 as well.

To avoid this case one could either declare log_end and len as u64,
causing extra computational costs.  Or one could just use the
conditional code below unconditionally.  That could write random or
zeroed printk buffer directly after bootup, but would never miss
information.

> +		unsigned long pos = (len & LOG_BUF_MASK);
> +
> +		s1 = log_buf + pos;
> +		l1 = log_buf_len - pos;
> +
> +		s2 = log_buf;
> +		l2 = pos;
> +	}
> +
> +	list_for_each_entry(dump, &dump_list, list) {
> +		if (panic && dump->panic)
> +			dump->panic(dump, s1, l1, s2, l2);
> +		else if (!panic && dump->oops)
> +			dump->oops(dump, s1, l1, s2, l2);
> +	}
> +}
> -- 
> 1.6.0.4

Jörn

-- 
Everything should be made as simple as possible, but not simpler.
-- Albert Einstein
