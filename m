Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbYKZFIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbYKZFIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 00:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYKZFIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 00:08:23 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:45902 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbYKZFIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 00:08:22 -0500
From: Andrey Mirkin <major@openvz.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 2/2] Add support for in-kernel process creation during restart
Date: Wed, 26 Nov 2008 09:07:43 +0400
User-Agent: KMail/1.8.2
Cc: Andrey Mirkin <major@openvz.org>, orenl@cs.columbia.edu,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1227541175-30301-1-git-send-email-major@openvz.org> <1227541175-30301-3-git-send-email-major@openvz.org> <20081125004024.GA4440@x200.localdomain>
In-Reply-To: <20081125004024.GA4440@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811260807.45094.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2008 03:45 Alexey Dobriyan wrote:
> On Mon, Nov 24, 2008 at 06:39:35PM +0300, Andrey Mirkin wrote:
> > +static int cr_rstr_task_struct(struct cr_ctx *ctx, struct cr_hdr_task
> > *ht) +{
> > +	struct task_struct *t = current;
> > +	char *buf;
> > +	int ret = -EINVAL;
> > +
> > +	/* upper limit for task_comm_len to prevent DoS */
> > +	if (ht->task_comm_len < 0 || ht->task_comm_len > PAGE_SIZE)
> > +		goto out;
> > +
> > +	buf = kmalloc(ht->task_comm_len, GFP_KERNEL);
> > +	if (!buf)
> > +		goto out;
> > +	ret = cr_read_string(ctx, buf, ht->task_comm_len);
> > +	if (!ret) {
> > +		/* if t->comm is too long, silently truncate */
> > +		memset(t->comm, 0, TASK_COMM_LEN);
> > +		memcpy(t->comm, buf, min(ht->task_comm_len, TASK_COMM_LEN));
> > +	}
> > +	kfree(buf);
> > +
> > +	/* FIXME: restore remaining relevant task_struct fields */
> > +out:
> > +	return ret;
> > +}
>
> ->comm is only 16 bytes wide, you can just use on-stack variable.
Yes, you right here.
But who knows how it can be changed later.
Also we have almost the same function for process restore from user space.
In next version I will use it instead of introducing new one.

Andrey
