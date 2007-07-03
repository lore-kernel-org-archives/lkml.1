Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbXGCEaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbXGCEaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 00:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbXGCEaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 00:30:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43738 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097AbXGCE37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 00:29:59 -0400
Date: Mon, 2 Jul 2007 21:29:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org, Greg K-H <greg@kroah.com>
Subject: Re: [PATCH 02/12] handle multiple network paths to AoE device
Message-Id: <20070702212949.5a1a1a31.akpm@linux-foundation.org>
In-Reply-To: <60bd316bfa72fb225cefad39569999e583f4f72e.1182883861.git.ecashin@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
	<60bd316bfa72fb225cefad39569999e583f4f72e.1182883861.git.ecashin@coraid.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 14:50:10 -0400 "Ed L. Cashin" <ecashin@coraid.com> wrote:

> Handle multiple network paths to AoE device.
>
> ...
>
> 
>  	struct buf *inprocess;	/* the one we're currently working on */
> -	ushort lostjumbo;
> -	ushort nframes;		/* number of frames below */
> -	struct frame *frames;
> +	struct aoetgt *targets[NTARGETS];
> +	struct aoetgt **tgt;	/* target in use when working */
> +	struct aoetgt **htgt;	/* target needing rexmit assistance */
> +//int ios[64];
>  };

whats that?
  
>  static ssize_t aoedisk_show_netif(struct gendisk * disk, char *page)
>  {
>  	struct aoedev *d = disk->private_data;
> +	struct net_device *nds[8], **nd, **nnd, **ne;
> +	struct aoetgt **t, **te;
> +	struct aoeif *ifp, *e;
> +	char *p;
> +
> +	memset(nds, 0, ARRAY_SIZE(nds));

bug: this will only zero eight bytes.

> +	nd = nds;
> +	ne = nd + ARRAY_SIZE(nds);
> +	t = d->targets;
> +	te = t + NTARGETS;
> +	for (; t<te && *t; t++) {
> +		ifp = (*t)->ifs;
> +		e = ifp + NAOEIFS;
> +		for (; ifp<e && ifp->nd; ifp++) {
> +			for (nnd=nds; nnd<nd; nnd++)
> +				if (*nnd == ifp->nd)
> +					break;
> +			if (nnd == nd)
> +			if (nd != ne)
> +				*nd++ = ifp->nd;
> +		}
> +	}

There are multiple little coding-style warts here.  scripts/checkpatch.pl
will point them out.

>  
> -	return snprintf(page, PAGE_SIZE, "%s\n", d->ifp->name);
> +	ne = nd;
> +	nd = nds;
> +	if (*nd == NULL)
> +		return snprintf(page, PAGE_SIZE, "none\n");
> +	for (p=page; nd<ne; nd++)
> +		p += snprintf(p, PAGE_SIZE - (p-page), "%s%s",
> +			p == page ? "" : ",", (*nd)->name);
> +	p += snprintf(p, PAGE_SIZE - (p-page), "\n");
> +	return p-page;
>  }
>  /* firmware version */
>
> ..
>
>  	spin_lock_irqsave(&d->lock, flags);
> -	d->flags &= ~DEVFL_MAXBCNT;
> -	d->flags |= DEVFL_PAUSE;
> +	aoecmd_cleanslate(d);
> +loop:
> +	skb = aoecmd_ata_id(d);
>  	spin_unlock_irqrestore(&d->lock, flags);
> +	if (!skb && !msleep_interruptible(200)) {
> +		spin_lock_irqsave(&d->lock, flags);
> +		goto loop;
> +	}
> +	aoenet_xmit(skb);
>  	aoecmd_cfg(major, minor);
> -
>  	return 0;
>  }

interruptible sleep?  Does this code work as intended when there's a signal
pending?  (Maybe that's what the interruptible sleep is for: don't know,
and am not inclined to work it out given the (low) level of comments in
here and the (lower) level of changelogging).

> ...
>
> +static struct frame *
> +freeframe(struct aoedev *d)
>  {
> +	struct frame *f, *e;
> +	struct aoetgt **t;
> +	ulong n;
> +
> +	if (d->targets[0] == NULL) {	/* shouldn't happen, but I'm paranoid */
> +		printk(KERN_ERR "aoe: NULL TARGETS!\n");
> +		return NULL;
> +	}
> +	t = d->targets;
> +	do {
> +		if (t != d->htgt)
> +		if ((*t)->ifp->nd)
> +		if ((*t)->nout < (*t)->maxout) {

ugh.  Do this:

	do {
		if (t == d->htgt)
			continue;
		if (!(*t)->ifp->nd)
			continue;
		if ((*t)->nout >= (*t)->maxout)
			continue;
			
		<stuff>
	} while (++t ...)


> +#define ATASCNT(raw) (((struct aoe_atahdr *)(((struct aoe_hdr *)raw)+1))->scnt)

This could be implemented as a (possibly inlined) C function, therefore it
shuld be implemented that way.

> +
>  static void
>  rexmit_timer(ulong vp)
>  {
>  	struct aoedev *d;
> +	struct aoetgt *t, **tt, **te;
> +	struct aoeif *ifp;
>  	struct frame *f, *e;
>  	struct sk_buff *sl;
>  	register long timeout;
> @@ -373,31 +451,75 @@ rexmit_timer(ulong vp)
>  		spin_unlock_irqrestore(&d->lock, flags);
>  		return;
>  	}
> -	f = d->frames;
> -	e = f + d->nframes;
> -	for (; f<e; f++) {
> -		if (f->tag != FREETAG && tsince(f->tag) >= timeout) {
> +	tt = d->targets;
> +	te = tt + NTARGETS;
> +	for (; tt<te && *tt; tt++) {
> +		t = *tt;
> +		f = t->frames;
> +		e = f + t->nframes;
> +		for (; f<e; f++) {
> +			if (f->tag == FREETAG
> +			|| tsince(f->tag) < timeout)
> +				continue;
>  			n = f->waited += timeout;
>  			n /= HZ;
> -			if (n > aoe_deadsecs) { /* waited too long for response */
> +			if (n > aoe_deadsecs) { /* waited too long.  device failure. */
>  				aoedev_downdev(d);
>  				break;
>  			}
> -			rexmit(d, f);
> +
> +			if (n > HELPWAIT) /* see if another target can help */
> +			if (tt != d->targets || d->targets[1])

poease find a way to avoid pulling this stunt.

> +				d->htgt = tt;
> +
> +			if (t->nout == t->maxout) {
> +				if (t->maxout > 1)
> +					t->maxout--;
> +				t->lastwadj = jiffies;
> +			}
> +
> +			ifp = getif(t, f->skb->dev);
> +			if (ifp && ++ifp->lost > (t->nframes << 1))
> +			if (ifp != t->ifs || t->ifs[1].nd) {

here too.

> +				ejectif(t, ifp);
> +				ifp = NULL;
> +			}
> +
> +			if (ATASCNT(aoe_hdr(f->skb)) > DEFAULTBCNT / 512)
> +			if (ifp && ++ifp->lostjumbo > (t->nframes << 1))
> +			if (ifp->maxbcnt != DEFAULTBCNT) {

more.

> +				printk(KERN_INFO "aoe: e%ld.%d: too many lost jumbo on %s:%012llx - "
> +					"falling back to %d frames.\n",
> +					d->aoemajor, d->aoeminor,
> +					ifp->nd->name, mac_addr(t->addr),
> +					DEFAULTBCNT);
> +				ifp->maxbcnt = 0;
> +			}
> +			resend(d, t, f);
> +		}
> +
> +		/* window check */
> +		if (t->nout == t->maxout)
> +		if (t->maxout < t->nframes)
> +		if ((jiffies - t->lastwadj)/HZ > 10) {

more.  Just use &&?


> +			t->maxout++;
> +			t->lastwadj = jiffies;
>  		}
>  	}
> -	if (d->flags & DEVFL_KICKME) {
> +
> +	if (d->sendq_hd) {
> +		n = d->rttavg <<= 1;
> +		if (n > MAXTIMER)
> +			d->rttavg = MAXTIMER;
> +	}
> +
> +	if (d->flags & DEVFL_KICKME || d->htgt) {
>  		d->flags &= ~DEVFL_KICKME;
>  		aoecmd_work(d);
>  	}
>  
>  	sl = d->sendq_hd;
>  	d->sendq_hd = d->sendq_tl = NULL;
> -	if (sl) {
> -		n = d->rttavg <<= 1;
> -		if (n > MAXTIMER)
> -			d->rttavg = MAXTIMER;
> -	}
>  
>  	d->timer.expires = jiffies + TIMERTICK;
>  	add_timer(&d->timer);

> +static struct aoetgt *
> +addtgt(struct aoedev *d, char *addr, ulong nframes)
> +{
> +	struct aoetgt *t, **tt, **te;
> +	struct frame *f, *e;
> +
> +	tt = d->targets;
> +	te = tt + NTARGETS;
> +	for (; tt<te; tt++) {
> +		if (*tt == NULL)
> +			break;
> +		else if (memcmp((*tt)->addr, addr, 6) > 0) {
> +			memmove(tt+1, tt, (void *)te-(void *)(tt+1));
> +			break;
> +		}
> +	}

Wow.

Perhaps there are so few comments because nobody understands what it's all
doing

> +	if (tt == te)
> +		return NULL;
> +
> +	t = kcalloc(1, sizeof *t, GFP_ATOMIC);
> +	f = kcalloc(nframes, sizeof *f, GFP_ATOMIC);

Is the GFP_ATOMIC unavoidable?  It is vastly less reliable than GFP_KERNEL.

> +	switch (!t || !f) {

Oh dear.  Please, use an `if' statement rather than party tricks like this.

> +	case 0:
> +		t->nframes = nframes;
> +		t->frames = f;
> +		e = f + nframes;
> +		for (; f<e; f++) {
> +			f->tag = FREETAG;
> +			f->skb = new_skb(ETH_ZLEN);
> +			if (!f->skb)
> +				break;
> +		}
> +		if (f == e)
> +			break;
> +		while (f > t->frames) {
> +			f--;
> +			dev_kfree_skb(f->skb);
> +		}
> +	default:
> +		if (f)
> +			kfree(f);
> +		if (t)
> +			kfree(t);

kfree(NULL) is legal.

> +		return NULL;
> +	}
> +
> +	memcpy(t->addr, addr, sizeof t->addr);
> +	t->ifp = t->ifs;
> +	t->maxout = t->nframes;
> +	return *tt = t;
> +}
> +
>  void
>  aoecmd_cfg_rsp(struct sk_buff *skb)
>  {
>  	struct aoedev *d;
>  	struct aoe_hdr *h;
>  	struct aoe_cfghdr *ch;
> +	struct aoetgt *t;
> +	struct aoeif *ifp;
>  	ulong flags, sysminor, aoemajor;
>  	struct sk_buff *sl;
>  	enum { MAXFRAMES = 16 };
> @@ -754,7 +952,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
>  	if (n > MAXFRAMES)	/* keep it reasonable */
>  		n = MAXFRAMES;
>  
> -	d = aoedev_by_sysminor_m(sysminor, n);
> +	d = aoedev_by_sysminor_m(sysminor);
>  	if (d == NULL) {
>  		printk(KERN_INFO "aoe: device sysminor_m failure\n");
>  		return;
> @@ -762,38 +960,70 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
>  
>  	spin_lock_irqsave(&d->lock, flags);
>  
> -	/* permit device to migrate mac and network interface */
> -	d->ifp = skb->dev;
> -	memcpy(d->addr, h->src, sizeof d->addr);
> -	if (!(d->flags & DEVFL_MAXBCNT)) {
> -		n = d->ifp->mtu;
> +	t = gettgt(d, h->src);
> +	if (!t) {
> +		t = addtgt(d, h->src, n);
> +		if (!t) {
> +			printk(KERN_INFO "aoe: device addtgt failure; too many targets?\n");

No, more likely a GFP_ATOMIC allocation failed.  Returning -ENOMEM is
better than just guessing.


> +			spin_unlock_irqrestore(&d->lock, flags);
> +			return;
> +		}
> +	}
> +	ifp = getif(t, skb->dev);
> +	if (!ifp) {
> +		if (!(ifp = addif(t, skb->dev))) {

Preferred style is

		ifp = addif(t, skb->dev);
		if (!ifp) {

(checkpatch will report this)

> +			printk(KERN_INFO "aoe: device addif failure; too many interfaces?\n");
> +			spin_unlock_irqrestore(&d->lock, flags);
> +			return;
> +		}
> +	}
> +	if (ifp->maxbcnt) {
> +		n = ifp->nd->mtu;
>  		n -= sizeof (struct aoe_hdr) + sizeof (struct aoe_atahdr);
>  		n /= 512;
>  		if (n > ch->scnt)
>  			n = ch->scnt;
>  		n = n ? n * 512 : DEFAULTBCNT;
> -		if (n != d->maxbcnt) {
> +		if (n != ifp->maxbcnt) {
>  			printk(KERN_INFO
> -				"aoe: e%ld.%ld: setting %d byte data frames on %s\n",
> -				d->aoemajor, d->aoeminor, n, d->ifp->name);
> -			d->maxbcnt = n;
> +				"aoe: e%ld.%d: setting %d byte data frames on %s:%012llx\n",
> +				d->aoemajor, d->aoeminor, n, ifp->nd->name,
> +				(unsigned long long) mac_addr(t->addr));
> +			ifp->maxbcnt = n;
>  		}
>  	}
>  
>  	/* don't change users' perspective */
> -	if (d->nopen && !(d->flags & DEVFL_PAUSE)) {
> +	if (d->nopen) {
>  		spin_unlock_irqrestore(&d->lock, flags);
>  		return;
>  	}
> -	d->flags |= DEVFL_PAUSE;	/* force pause */
> -	d->mintimer = MINTIMER;
>  	d->fw_ver = be16_to_cpu(ch->fwver);
>  
> -	/* check for already outstanding ataid */
> -	sl = aoedev_isbusy(d) == 0 ? aoecmd_ata_id(d) : NULL;
> +	sl = aoecmd_ata_id(d);
>  
>  	spin_unlock_irqrestore(&d->lock, flags);
>  
>  	aoenet_xmit(sl);
>  }
>  

