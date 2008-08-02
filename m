Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbYHBDp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbYHBDp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 23:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYHBDpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 23:45:21 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:47243 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbYHBDpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 23:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CJfCGHh60G0QZYwPnSoBc6s/X7OypMtmeXAKqeBGvlxcGWbOMzl65mT2DmVpPcFi9R
         kbyaivat8oT2ns4AbfVZqoMbpZuLm+BRCo0RyyIN/kRKupSGGtEqH5AB4/hdvRBLkRER
         B9m5flqJD88naoR0F3HTCoTvuImdhTEmpsWrY=
Date: Sat, 2 Aug 2008 07:45:11 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/13] proc tty: introduce ->proc_fops
Message-ID: <20080802034511.GA8487@martell.zuzino.mipt.ru>
References: <20080729012908.GA3135@martell.zuzino.mipt.ru> <20080729105350.009f5af0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729105350.009f5af0@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 10:53:50AM +0100, Alan Cox wrote:
> On Tue, 29 Jul 2008 05:29:08 +0400
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > Add struct tty_operations:proc_fops .
> > 
> > The intent is gradual switch of TTY drivers from ->read_proc usage.
> > proc entries are created with proc_create_data() which even fixes
> > early-read races.
> > 
> > Eventually ->read_proc code will be removed from TTY code, thus helping
> > remove ->read_proc from whole proc code.
> 
> I'm going to NAK this but not because I think the concept is wrong. I
> think the way its been done is perhaps wrong.
> 
> You've added ifdefs to a lot of drivers and more basically duplicate
> code.

It's boileplate code which is hard to screwup, unlike boilerplate at the
end of every ->read_proc hook.

> Is there a reason you can't keep the ->read_proc method in the tty
> code but as a function called by a single instance of proc_fops and
> seq_file methods for the whole tty driver layer.
> 
> Ie have a single tty seq_file method that calls driver->ops->read_proc as
> the seqfile iterator ?

I think it should be struct tty_operations::proc_fops .

In fact, posted conversions are bit incorrect.

Let's look at cyclades. It prints banner, then information about each
card. The very right way to print it via seq_files is implement
struct seq_operations::start, next, stop, show.

If TTY driver prints something simple, just one show hook is enough.
If TTY driver wants something more complex, right way start to be
seq_operations and one hook is not enough anymore.

But I don't really care about this exact issue, as long as ->read_proc
TTY hook is gone as ->read_proc proc hook.

> >  int count, int *eof, void *data);
> > +#ifdef CONFIG_PROC_FS
> > +	const struct file_operations *proc_fops;
> > +#endif
> 
> I'd prefer you didn't put variables in the middle of the methods. Also
> the ifdef isn't needed. It's not worth one pointer to create a load of
> ifdefs

OK.

