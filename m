Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab0BDQwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:52:36 -0500
Received: from www84.your-server.de ([213.133.104.84]:51362 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab0BDQwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:52:35 -0500
Subject: Re: [PATCH] enhanced reimplemention of the kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>
In-Reply-To: <20100203150545.ebb69cad.akpm@linux-foundation.org>
References: <1264597243.3607.24.camel@wall-e>
	 <20100203120504.6da9b000.akpm@linux-foundation.org>
	 <1265234991.24040.46.camel@wall-e>
	 <20100203150545.ebb69cad.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 04 Feb 2010 17:52:40 +0100
Message-ID: <1265302360.28857.18.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 03.02.2010, 15:05 -0800 schrieb Andrew Morton:
> On Wed, 03 Feb 2010 23:09:51 +0100
> Stefani Seibold <stefani@seibold.net> wrote:
> 
> > Am Mittwoch, den 03.02.2010, 12:05 -0800 schrieb Andrew Morton:
> > > On Wed, 27 Jan 2010 14:00:43 +0100
> > > Stefani Seibold <stefani@seibold.net> wrote:
> > > 
> > > > This is a complete reimplementation of the new kfifo API, which is now 
> > > > really generic, type save and type definable. 
> > > > 
> > > > 
> > > > ...
> > > >
> > > > diff -u -N -r -p linux-2.6.33-rc5.dummy/include/linux/kfifo.h linux-2.6.33-rc5.new/include/linux/kfifo.h
> > > > --- linux-2.6.33-rc5.dummy/include/linux/kfifo.h	1970-01-01 01:00:00.000000000 +0100
> > > > +++ linux-2.6.33-rc5.new/include/linux/kfifo.h	2010-01-27 13:34:06.324991898 +0100
> > > >
> > > > ...
> > > >
> > > > +/*
> > > > + * DECLARE_KFIFO_PTR - macro to declare a fifo pointer object
> > > > + * @fifo: name of the declared fifo
> > > > + * @type: type of the fifo elements
> > > > + * @size: the number of elements in the fifo, this must be a power of 2.
> > > > + */
> > > 
> > > Throughout this patch the comments are in kerneldoc form, but they
> > > don't use the /** opening token, so the kerneldoc tools will ignore them.
> > > 
> > > Please fix that up and test it.
> > > 
> > > > +#define DECLARE_KFIFO_PTR(fifo, type)	STRUCT_KFIFO_PTR(type) fifo
> > > > +
> > > > +/* helper macro */
> > > > +#define	__is_kfifo_ptr(fifo)	(sizeof(*fifo) == sizeof(struct __kfifo))
> > > 
> > > This is weird.  It's a compile-time constant.  What's it here for?
> > 
> > I need it to distinguish between real in place fifo, where the fifo
> > array is a part of the structure, and the fifo type where the array is
> > outside of the fifo structure.
> 
> OK, please add a comment?

I will do this.

> 
> > > > +/*
> > > > + * INIT_KFIFO - Initialize a fifo declared by DECLARE_KFIFO
> > > > + * @fifo: name of the declared fifo datatype
> > > > + */
> > > > +#define INIT_KFIFO(fifo)	fifo = __kfifo_initializer(fifo)
> > > 
> > > Some versions of gcc generate quite poor code for
> > > 
> > > 	struct foo f = { ... };
> > > 
> > > It would generate an instance of the struct into the stack and then
> > > would memcpy it over, iirc.  Please take a look, see if that's
> > > happening with this construct (might need to use an old gcc version)
> > > and if so, see if there's a fix?
> > > 
> > 
> > The current version of the kfifo implementation did it in the same way.
> > Why is it now wrong?
> 
> It was wrong before, too.
> 
> > Which gcc version do you mean?
> 
> I don't recall.  The oldest gcc the kernel permits is 3.2, so checking
> any 3.x should be OK.
> 

I will try to build a gcc 3 and check it.

> > > > +/*
> > > > + * kfifo_initialized - Check if kfifo is initialized.
> > > > + * @fifo: fifo to check
> > > > + * Return %true if FIFO is initialized, otherwise %false.
> > > > + * Assumes the fifo was 0 before.
> > > > + *
> > > > + * Note: for in place fifo's this macro returns alway true
> > > > + */
> > > > +#define kfifo_initialized(fifo) ((fifo)->kfifo.data != NULL)
> > > 
> > > kfifo_initialized() is suspicious.  Any code which doesn't know whether
> > > its kfifo was initialised is probably confused, lame and broken. 
> > > Fortunately kfifo_initialized() is not used anywhere.  Please prepare a
> > > separate patch to kill it sometime.
> > > 
> > 
> > This function was introduced as a patch by andi kleen and you have it
> > already applied.
> 
> Let's delete it?
> 

Can you clarify this with andi please?

> > > > +/*
> > > > + * kfifo_esize - returns the size of the element managed by the fifo
> > > > + * @fifo: the fifo to be used.
> > > > + */
> > > > +#define kfifo_esize(fifo)	((fifo)->kfifo.esize)
> > > 
> > > This doesn't seem to be used anywhere either.
> > > 
> > 
> > It is a part of the API. It returns the the size of the handled element,
> > If a driver developer need it, it is there.
> 
> Well, if there's no proven need for it now, it will remain dead code
> for an unknown period of time.
> 
> Also, there was no need to implement this as a macro (was there?).  If
> not, conversion to a more typesafe C function would be better.
> 

It is not possible to write this as a function, because the parameter
fifo is an arbitrary type. There is no fifo type, only a template and a
macro which generates a fifo which managed a given type, where the
generic "struct __kfifo" part is embedded.

> > > > +/*
> > > > + * kfifo_recsize - returns the size of the record length field
> > > > + * @fifo: the fifo to be used.
> > > > + */
> > > > +#define kfifo_recsize(fifo)	(sizeof(*(fifo)->rectype))
> > > 
> > > Neither is this.  What's going on?
> > > 
> > 
> > Dito... This returns the size of the record length field. 0 means this
> > is not a variable record fifo.
> 
> ditto.
> 
> > > > +/*
> > > > + * kfifo_out_locked - gets some data from the fifo using a spinlock for locking
> > > > + * @fifo: the fifo to be used.
> > > > + * @buf: pointer to the storage buffer
> > > > + * @n: max. number of elements to get
> > > > + * @lock: pointer to the spinlock to use for locking.
> > > > + *
> > > > + * This macro get the data from the fifo and return the numbers of elements
> > > > + * copied.
> > > > + */
> > > > +#define	kfifo_out_locked(fifo, buf, n, lock) \
> > > > +__kfifo_check( \
> > > > +({ \
> > > > +	unsigned long __flags; \
> > > > +	unsigned int __ret; \
> > > > +	spin_lock_irqsave(lock, __flags); \
> > > > +	__ret = kfifo_out(fifo, buf, n); \
> > > > +	spin_unlock_irqrestore(lock, __flags); \
> > > > +	__ret; \
> > > > +}) \
> > > > +)
> > > 
> > > This is poorly named.  Generally "foo_locked" is to be called when the
> > > caller has already taken the lock.  This identifier inverts that
> > > convention.
> > > 
> > 
> > This is the same name as the current kfifo API. Renaming it would break
> > a lot of drivers. But if there is no complain and you insist i will
> > rename it and fix the current users.
> 
> argh, we goofed.
> 
> yeah, it'd be nice to fix it sometime, please.  Not urgent.
> 
> A good way to fix it would be to add a new function with a new name
> then migrate all callers over to that name then when it's done, remove
> the old name.
> 

I will do this in the next release. Would be kfifo_out_spinlocked() and
kfifo_in_spinlocked() for the new names okay?

> > > > + * @fifo: the fifo to be used.
> > > > + * @to: where the data must be copied.
> > > > + * @len: the size of the destination buffer.
> > > > + * @copied: pointer to output variable to store the number of copied bytes.
> > > > + *
> > > > + * This macro copies at most @len bytes from the fifo into the
> > > > + * @to buffer and returns -EFAULT/0.
> > > > + *
> > > > + * Note that with only one concurrent reader and one concurrent
> > > > + * writer, you don't need extra locking to use these macro.
> > > > + */
> > > > +#define	kfifo_to_user(fifo, to, len, copied) \
> > > > +__kfifo_check( \
> > > > +({ \
> > > > +	typeof(fifo + 1) __tmp = (fifo); \
> > > > +	void __user *__to = (to); \
> > > > +	unsigned int __len = (len); \
> > > > +	unsigned int *__copied = (copied); \
> > > > +	const size_t __recsize = sizeof(*__tmp->rectype); \
> > > > +	struct __kfifo *__kfifo = &__tmp->kfifo; \
> > > > +	(__recsize) ? \
> > > > +	__kfifo_to_user_r(__kfifo, __to, __len, __copied, __recsize) : \
> > > > +	__kfifo_to_user(__kfifo, __to, __len, __copied); \
> > > > +}) \
> > > > +)
> > > 
> > > Do these have any callers?
> > > 
> > 
> > Currently not, but this is a part of the current kfifo implementation. A
> > lot of developer like this idea and it will be used in the near future.
> 
> OK.  Please describe the presently-unused interfaces in the changelog,
> with particular attention to the reason for including them at this
> time.
> 

OK

> > > > +static inline unsigned int kfifo_unused(struct __kfifo *fifo)
> > > > +{
> > > > +	return (fifo->mask + 1) - (fifo->in - fifo->out);
> > > > +}
> > > 
> > > hm, how does this differ from kfifo_avail()?
> > > 
> > 
> > This is similar to kfifo_avail, but due the nature of macro and type
> > conversation i have not longer the original type information available.
> > So i can't call the macros in kfifo.h from the functions defined in
> > kfifo.c.
> 
> OK, please add a comment there.  (As a general rule: if this reader
> needed more info then other readers will want more info as well).
> 
> > > > +static unsigned long kfifo_copy_from_user(struct __kfifo *fifo,
> > > > +	const void *src, unsigned int len, unsigned int off,
> > > > +	unsigned int *copied)
> > > > +{
> > > > +	unsigned int size = fifo->mask + 1;
> > > > +	unsigned int esize = fifo->esize;
> > > > +	unsigned int l;
> > > > +	unsigned long ret;
> > > > +
> > > > +	off &= fifo->mask;
> > > > +	if (esize != 1) {
> > > > +		off *= esize;
> > > > +		size *= esize;
> > > > +		len *= esize;
> > > > +	}
> > > > +	l = min(len, size - off);
> > > > +
> > > > +	ret = copy_from_user(fifo->data + off, src, l);
> > > > +	if (unlikely(ret))
> > > > +		ret = roundup_diff(ret + len - l, esize);
> > > > +	else {
> > > > +		ret = copy_from_user(fifo->data, src + l, len - l);
> > > > +		if (unlikely(ret))
> > > > +			ret = roundup_diff(ret, esize);
> > > > +	}
> > > > +	smp_wmb();
> > > > +	if (copied)
> > > 
> > > Can `copied' ever be NULL?  If not, remove this test.
> > 
> > It was only a feature. If you don't like i will remove it.
> 
> No strong opinion.  But if present callers don't pass NULL then that's
> a sign that future callers won't, too.  We may as well save the
> speed/space overhead until we actually need it.
> 
> 

This will be fixed in the next release.

One offer to solve the egg and chicken problem: Let us include the
functions kfifo_to_user(), kfifo_from_user(),  kfifo_esize(),
kfifo_recsize() and the dynamic record handling. If there will be no
users in at least 9 months we remove it from the API. We talk here about
400 bytes of code.

In the mean time me and other developer will have a change to modify the
existing driver to the new API and/or post drivers or core kernel code
which is using this functionality. 

Stefani


