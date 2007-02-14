Return-Path: <linux-kernel-owner+w=401wt.eu-S932073AbXBNASd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbXBNASd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932099AbXBNASd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:18:33 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4663 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbXBNASc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:18:32 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 13 Feb 2007 16:18:29 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/11] syslets: core, documentation
In-Reply-To: <Pine.LNX.4.64.0702131457060.32055@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0702131612190.32055@alien.or.mcafeemobile.com>
References: <20070213142042.GG638@elte.hu> <Pine.LNX.4.64.0702131117120.32055@alien.or.mcafeemobile.com>
 <20070213213422.GA22104@elte.hu> <Pine.LNX.4.64.0702131457060.32055@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, Davide Libenzi wrote:

> > > I can understand that chaining syscalls requires variable sharing, but 
> > > the majority of the parameters passed to syscalls are just direct 
> > > ones. Maybe a smart method that allows you to know if a parameter is a 
> > > direct one or a pointer to one? An "unsigned int pmap" where bit N is 
> > > 1 if param N is an indirection? Hmm?
> > 
> > adding such things tends to slow down atom parsing.
> 
> I really think it simplifies it. You simply *copy* the parameter (I'd say 
> that 70+% of cases falls inside here), and if the current "pmap" bit is 
> set, then you do all the indirection copy-from-userspace stuff.
> It also simplify userspace a lot, since you can now pass arrays and 
> structure pointers directly, w/out saving them in a temporary variable.

Very rough sketch below ...


---
struct syslet_uatom {
	unsigned long                           flags;
	unsigned int                            nr;
	unsigned short                          nparams;
	unsigned short                          pmap;
	long __user                             *ret_ptr;
	struct syslet_uatom     __user          *next;
	unsigned long           __user          args[6];
	void __user                             *private;
};

long copy_uatom(struct syslet_atom *atom, struct syslet_uatom __user *uatom)
{
	unsigned short i, pmap;
	unsigned long __user *arg_ptr;
	long ret = 0;

	if (!access_ok(VERIFY_WRITE, uatom, sizeof(*uatom)))
		return -EFAULT;

	ret = __get_user(atom->nr, &uatom->nr);
	ret |= __get_user(atom->nparams, &uatom->nparams);
	ret |= __get_user(pmap, &uatom->pmap);
	ret |= __get_user(atom->ret_ptr, &uatom->ret_ptr);
	ret |= __get_user(atom->flags, &uatom->flags);
	ret |= __get_user(atom->next, &uatom->next);
	if (unlikely(atom->nparams >= 6))
		return -EINVAL;
	for (i = 0; i < atom->nparams; i++, pmap >>= 1) {
		atom->args[i] = uatom->args[i];
		if (unlikely(pmap & 1)) {
			arg_ptr = (unsigned long __user *) atom->args[i];
			if (!access_ok(VERIFY_WRITE, arg_ptr, sizeof(*arg_ptr)))
				return -EFAULT;
			ret |= __get_user(atom->args[i], arg_ptr);
		}
	}

	return ret;
}

void init_utaom(struct syslet_uatom *ua, unsigned long flags, unsigned int nr,
		long *ret_ptr, struct syslet_uatom *next, void *private,
		int nparams, ...)
{
	int i, mode;
	va_list args;

	ua->flags = flags;
	ua->nr = nr;
	ua->ret_ptr = ret_ptr;
	ua->next = next;
	ua->private = private;
	ua->nparams = nparams;
	ua->pmap = 0;
	va_start(args, nparams);
	for (i = 0; i < nparams; i++) {
		mode = va_arg(args, int);
		ua->args[i] = va_arg(args, unsigned long);
		if (mode == UASYNC_INDIR)
			ua->pmap |= 1 << i;
	}
	va_end(args);
}


#define UASYNC_IMM 0
#define UASYNC_INDIR 1
#define UAPD(a) UASYNC_IMM, (unsigned long) (a)
#define UAPI(a) UASYNC_INDIR, (unsigned long) (a)


void foo(void)
{
	int fd;
	long res;
	struct stat stb;
	struct syslet_uatom ua;

	init_utaom(&ua, 0, __NR_fstat, &res, NULL, NULL, 2,
		   UAPI(&fd), UAPD(&stb));
	...
}
---



- Davide


