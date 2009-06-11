Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZFKNhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZFKNhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbZFKNg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:36:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36666 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZFKNgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:36:55 -0400
Date: Thu, 11 Jun 2009 16:36:43 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
Message-ID: <20090611133643.GA16335@redhat.com>
References: <20090520142234.22285.72274.stgit@dev.haskins.net> <20090611131647.GA15743@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611131647.GA15743@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 04:16:47PM +0300, Michael S. Tsirkin wrote:
> > +
> > +	ret = file->f_op->poll(file, &irqfd->pt);
> > +	if (ret < 0)
> > +		goto fail;

Looking at it some more, we have:
struct file_operations {
....
	unsigned int (*poll) (struct file *, struct poll_table_struct *);

So the comparison above does not seem to make sense:
it seems that the return value from poll can not be negative.

Will the callback be executed if someone did a write to eventfd
before we attached it? If no, maybe we should call it here
if ret != 0.


> > +
> > +	irqfd->file = file;
> > +
> > +	mutex_lock(&kvm->lock);
> > +	list_add_tail(&irqfd->list, &kvm->irqfds);
> > +	mutex_unlock(&kvm->lock);
> > +
> > +	return 0;
> > +
> > +fail:
> > +	if (irqfd->wqh)
> > +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
> 
> Why are these 2 lines here? Either we might get a callback even though
> poll failed - and then this test without lock is probably racy -
> or we can't, and then we can replace the above with BUG_ON(irqfd->wqh).
> 
> Which is it? I think the later ...
> 
> 
> > +
> > +	if (file && !IS_ERR(file))
> > +		fput(file);
> > +
> > +	kfree(irqfd);
> > +	return ret;
> > +}
> > +
