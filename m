Return-Path: <linux-kernel-owner+w=401wt.eu-S933000AbYEFWGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbYEFWGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYEFWGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:06:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:58124 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbYEFWGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:06:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Zuj9hFCKGOS2A6J96YGNPy+pQAvk/gv2372ODMPHQ3GK2lamVj6auSIn89G2sMETi8IrfGSe4ViSM4OLCtsHyZD9CelFRze3xpLOWVLNfy17hRc+XUdCkD2JqJF7rqwmYyZDV48+mF96MyqLz78qFzOvdqFPIutzNNtVnsHsT1I=
Date: Wed, 7 May 2008 00:05:36 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH take 2 06/28] UBIFS: add journal replay
Message-ID: <20080506220315.GA6464@joi>
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com> <1210070159-22794-7-git-send-email-Artem.Bityutskiy@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210070159-22794-7-git-send-email-Artem.Bityutskiy@nokia.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 01:35:37PM +0300, Artem Bityutskiy wrote:
> +/**
> + * insert_ref_node - insert a ref node to the replay tree.
> + * @c: UBIFS file-system description object
> + * @lnum: node logical eraseblock number
> + * @offs: node offset
> + * @sqnum: sequence number
> + * @free: amount of free space in bud
> + * @dirty: amount of dirty space from padding and deletion nodes
> + */
> +static int insert_ref_node(struct ubifs_info *c, int lnum, int offs,
> +			   unsigned long long sqnum, int free, int dirty)
> +{
> +	struct rb_node **p = &c->replay_tree.rb_node, *parent = NULL;
> +	struct replay_entry *r;
> +	union ubifs_key key;
> +	int cmp;
> +
> +	dbg_mnt("add ref LEB %d:%d", lnum, offs);
> +	highest_ino_key(c, &key, -1);
> +	while (*p) {
> +		parent = *p;
> +		r = rb_entry(parent, struct replay_entry, rb);
> +		cmp = keys_cmp(c, &key, &r->key);

return value of keys_cmp is never used in this function

> +		if (sqnum < r->sqnum) {
> +			p = &(*p)->rb_left;
> +			continue;
> +		} else if (sqnum > r->sqnum) {
> +			p = &(*p)->rb_right;
> +			continue;
> +		}
> +		ubifs_err("duplicate sqnum in r");
> +		return -EINVAL;
> +	}
> +
> +	r = kzalloc(sizeof(struct replay_entry), GFP_KERNEL);
> +	if (!r)
> +		return -ENOMEM;
> +
> +	r->lnum = lnum;
> +	r->offs = offs;
> +	r->sqnum = sqnum;
> +	r->flags = REPLAY_REF;
> +	r->free = free;
> +	r->dirty = dirty;
> +	key_copy(c, &key, &r->key);
> +
> +	rb_link_node(&r->rb, parent, p);
> +	rb_insert_color(&r->rb, &c->replay_tree);
> +	return 0;
> +}
