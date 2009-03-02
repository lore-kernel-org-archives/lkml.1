Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbZCBSYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbZCBSYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbZCBSYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:24:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33534 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbZCBSYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:24:00 -0500
Date: Mon, 2 Mar 2009 13:23:57 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] ftrace: add ftrace_bprintk()
In-Reply-To: <c62985530903021006k1a0b1197tc336800379cb5ded@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0903021311190.4771@gandalf.stny.rr.com>
References: <20090228091305.GA20533@elte.hu>  <49aa088b.1c07d00a.4512.ffffe781@mx.google.com>  <alpine.DEB.2.00.0903021128380.4771@gandalf.stny.rr.com>  <c62985530903020945i6098682bh59a5c6d6c6de759c@mail.gmail.com>  <alpine.DEB.2.00.0903021252420.4771@gandalf.stny.rr.com>
 <c62985530903021006k1a0b1197tc336800379cb5ded@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1154299260-1236018238=:4771"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1154299260-1236018238=:4771
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE


On Mon, 2 Mar 2009, Fr?d?ric Weisbecker wrote:

> 2009/3/2 Steven Rostedt <rostedt@goodmis.org>:
> >
> > On Mon, 2 Mar 2009, Fr?d?ric Weisbecker wrote:
> >> >> +
> >> >> +static
> >> >> +void release_module_trace_bprintk_format(const char **start, const=
 char **end)
> >> >> +{
> >> >> + =A0 =A0 const char **iter;
> >> >> + =A0 =A0 lock_btrace();
> >> >> + =A0 =A0 for (iter =3D start; iter < end; iter++) {
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 struct trace_bprintk_fmt *tb_fmt;
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (!*iter)
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> >> >> +
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 tb_fmt =3D container_of(*iter, struct tra=
ce_bprintk_fmt, fmt[0]);
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 tb_fmt->count--;
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (!tb_fmt->count && !btrace_metadata_co=
unt) {
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del(&tb_fmt->list);
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(tb_fmt);
> >> >
> >> > Shouldn't *iter get assigned to NULL somewhere here?
> >> >
> >> > -- Steve
> >>
> >>
> >> Hm, why?
> >
> > Well, after we free tb_fmt, the *iter will then point to garbage. Right=
?
> >
> > -- Steve
>=20
>=20
> Now that you say it, I have some doubts about the possible sites that
> can still dereference it
> at this point.
> I have to review and test it more seriously. I was convinced that the
> count field kept track
> of all references but now I'm not so sure, there can be still one
> pending event that uses it into
> the ring buffer, or it can be perhaps in use at the same time it is freed=
=2E
> We should perhaps use rcu here, will see.
>=20

How do you deal with ref counters in the ring buffer? If the ring buffer=20
is set to overwrite mode (in which is usually is), then you will never=20
know if a print was erased.

I haven't looked too deep into the implementation. But one safe way to
do this, with respect to modules, is the following:

#define ftrace_bprintk(fmt, args...) \
=09do { \
=09=09static const char __attribute__((section(ftrace_fmt))\
=09=09=09*f =3D fmt; \
=09=09_ftrace_bprintk(&f, args); \
=09} while(0)

On output, you can do:

=09trace_print_bprintk(...)
=09{
=09=09char **f =3D field->f;

=09=09if (!f)
=09=09=09trace_seq_printf(s, "MODULE UNLOADED?\n");
=09=09trace_seq_printf(s, *f, ...)

Do you see what I'm doing?

Make the ftrace_printk create a constant pointer to the format instead
of passing in the format. It will istead pass in the address of something
pointing to the format.

Then on module load, you allocate the area and copy in all the ftrace_fmt=
=20
sections.

On module unload, you just NULL out that area. You could probably reuse=20
those NULL spots, but you would need some kind of checksum to be added=20
such that a new module will be detected on print out.


This is the reason I avoided doing ftrace printk via pointers :-/

-- Steve

--8323328-1154299260-1236018238=:4771--
