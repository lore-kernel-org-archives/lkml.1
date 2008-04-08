Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbYDHBF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbYDHBF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 21:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYDHBFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 21:05:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48804 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYDHBFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 21:05:18 -0400
Date: Mon, 7 Apr 2008 18:04:56 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, rmk+lkml@arm.linux.org.uk,
       lethal@linux-sh.org, philipp.zabel@gmail.com, pavel@ucw.cz,
       tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 2/6] Clocklib: debugfs support
Message-ID: <20080408010456.GA13875@kroah.com>
References: <20080403132142.GA26882@doriath.ww600.siemens.net> <20080403132337.GA26981@doriath.ww600.siemens.net> <20080407155901.c7431c3e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080407155901.c7431c3e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2008 at 03:59:01PM -0700, Andrew Morton wrote:
> On Thu, 3 Apr 2008 17:23:37 +0400
> Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> 
> > Provide /sys/kernel/debug/clock to ease debugging.
> > 
> 
> Plese fully document the proposed kernel->userspace interface in the
> changelog so that we can review it design.

You can do this easily by providing a file for Documentation/ABI/
describing your addition to the kernel ABI.

> >  /**
> > diff --git a/kernel/clklib.c b/kernel/clklib.c
> > index 012f845..8d872e1 100644
> > --- a/kernel/clklib.c
> > +++ b/kernel/clklib.c
> > @@ -324,3 +324,77 @@ out:
> >  	return rc;
> >  }
> >  EXPORT_SYMBOL(clk_alloc_function);
> > +
> > +#ifdef CONFIG_DEBUG_FS
> > +
> > +#include <linux/debugfs.h>
> > +#include <linux/seq_file.h>
> > +
> > +#define NAME_FIELD_LEN	20
> > +
> > +static void dump_clocks(struct seq_file *s, struct clk *parent, int nest)
> > +{
> > +	struct clk *clk;
> > +	int i;
> > +
> > +	list_for_each_entry(clk, &clocks, node) {
> > +		if (clk->parent == parent) {
> > +			for (i = 0; i < nest; i++) {
> > +				seq_putc(s, ' ');
> > +				seq_putc(s, ' ');
> > +			}
> > +			seq_puts(s, clk->name);
> > +
> > +			i = 2 * nest + strlen(clk->name);
> > +			if (i >= NAME_FIELD_LEN)
> > +				i = NAME_FIELD_LEN - 1;
> > +			for (; i < NAME_FIELD_LEN; i++) {
> > +				seq_putc(s, ' ');
> > +			}
> > +			seq_printf(s, "%c use=%d rate=%10lu Hz",
> > +				clk->ops && clk->ops->set_parent ? '*' : ' ',
> > +				clk->users,
> > +				__clk_get_rate(clk));
> > +			if (clk->ops && clk->ops->format)
> > +				clk->ops->format(clk, s);
> > +			seq_putc(s, '\n');
> > +
> > +			dump_clocks(s, clk, nest + 1);
> > +		}
> > +	}
> > +}
> 
> hm, this would break the one-value-per-file rule, except that applies to
> sysfs, but this interface is implemented via debug fs, but it is proposed
> that it appear under /sys.  Tricky.

Huh?

How can a seq_file entry show up in sysfs?

Or do you mean /sys/kernel/debug/  ?
That's where debugfs is supposed to be mounted so that's fine, it's
really a debugfs file, not a sysfs one.

thanks,

greg k-h
