Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbZFJNti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbZFJNti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 09:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbZFJNta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 09:49:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40496 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbZFJNt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:49:29 -0400
Date: Wed, 10 Jun 2009 09:49:29 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Theodore Tso <tytso@mit.edu>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH 00/11] [GIT PULL] more updates for the tag format
In-Reply-To: <20090610130127.GA6647@mit.edu>
Message-ID: <alpine.DEB.2.00.0906100911190.30552@gandalf.stny.rr.com>
References: <20090610054206.510574695@goodmis.org> <20090610092644.GA20889@elte.hu> <c62985530906100411o5a178352n53f7d247f6e9dba9@mail.gmail.com> <20090610130127.GA6647@mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-86438531-1244641770=:30552"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-86438531-1244641770=:30552
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE


On Wed, 10 Jun 2009, Theodore Tso wrote:

> On Wed, Jun 10, 2009 at 01:11:40PM +0200, Fr=E9d=E9ric Weisbecker wrote:
> > Well, indeed I had worries, but I discussed about it with Steven and
> > now I actually
> > think this new tag format is much more powerful than printf style.
> > It brings a cleaner, and much higher level way to control the data expo=
rts.
> >=20
> > But it would be nice to read some opinions from end users (end
> > developers) of TRACE_EVENT().
>=20
> Maybe I'm missing something, but looks like the this new format, while
> simpler and easier to read, doesn't have support for using a more
> complicated C expression as a printk argument.  For example:
>=20
> =09TP_printk("dev %s ino %lu mode %d uid %u gid %u blocks %llu",
> =09=09  jbd2_dev_to_name(__entry->dev), __entry->ino, __entry->mode,
> =09=09  __entry->uid, __entry->gid, __entry->blocks)
>=20
> How should I handle the "jbd2_dev_to_name(__entry->dev)" argument to
> TP_printk?  The whole point of calling jbd2_dev_to_name() at TP_printk
> time is to not bloat the ring buffer with a 32 byte devname.

Understood, and the example you just gave also has the flaw that a=20
userspace tool could not parse it, because it would not know what to do=20
with "jbd2_dev_to_name()".

This is why I suggested keeping the TP_printk, for cases like this. Since=
=20
it is also currently useless in userspace.

But we really should convert all cases, and I was toying with an idea to=20
dynamically make your own data type, and be able to make a way to print=20
it. That is you could register:

register_trace_event_data_type(const char *name,=20
=09(int)(*print_func)(struct trace_seq *s, void *data, int size),
=09const char *fmt, ...);

Where the name would be the data type you are making, the print_func is=20
how ftrace would print it in debugfs/tracing/trace, and the fmt, ... would=
=20
be who to show the user how to print it.

For example, for the GFP flags we could do something like:

/* helper routine */
unsigned long long trace_get_word(void *p, int len)
{
=09unsigned long long val;

        switch (size) {
        case 1:
                val =3D *(char *)p;
                break;
        case 2:
                val =3D *(short *)p;
                break;
        case 4:
                val =3D *(int *)p;
                break;
        case 8:
                val =3D *(long long *)p;
                break;
        default:
=09=09WARN(1,"length %d not valid word size\n");
                return 0;
        }

        return val;
}

static int test_gfp(unsigned long *gfp, unsigned long mask)
{
=09if ((*gfp & mask) =3D=3D mask) {
=09=09*gfp &=3D ~mask;
=09=09return 1;
=09}
=09return 0;
}

#define test_gfp_name(under, name)=09=09=09\
=09if (test_gfp(&gfp, under##GFP_##name)) {=09\
=09=09if (first)=09=09=09=09\
=09=09=09first =3D 0;=09=09=09\
=09=09else=09=09=09=09=09\
=09=09=09trace_seq_putc(s, '|');=09=09\
=09=09trace_seq_puts(s, "GFP_" #name);=09\
=09}


static int print_gfp(struct trace_seq *s, void *data, int len)
{
=09unsigned long gfp;

=09gfp =3D trace_get_word(data, len);

=09if (!gfp) {
=09=09trace_seq_puts(s, GPF_NOWAIT);
=09=09return 0;
=09}

=09while (gfp) {
=09=09test_gfp_name(,HIGHUSER_MOVABLE);
=09=09test_gfp_name(,HIGHUSER);
=09=09test_gfp_name(,USER);
=09=09test_gfp_name(,TEMPORARY);
=09=09test_gfp_name(,KERNEL);
=09=09test_gfp_name(,NOFS);
=09=09test_gfp_name(,ATOMIC);
=09=09test_gfp_name(,NOIO);
=09=09test_gfp_name(__,HIGH);
=09=09test_gfp_name(__,WAIT);
=09=09test_gfp_name(__,IO);
=09=09test_gfp_name(__,COLD);
=09=09test_gfp_name(__,NOWARN);
=09=09test_gfp_name(__,REPEAT);
=09=09test_gfp_name(__,NOFAIL);
=09=09test_gfp_name(__,NORETRY);
=09=09test_gfp_name(__,COMP);
=09=09test_gfp_name(__,ZERO);
=09=09test_gfp_name(__,NOMEMALLOC);
=09=09test_gfp_name(__,HARDWALL);
=09=09test_gfp_name(__,THISNODE);
=09=09test_gfp_name(__,RECLAIMABLE);
=09=09test_gfp_name(__,MOVABLE);

}

#define gfp_insert(under, name)=09\
=09=09(unsigned long)under##GFP_##name, "GFP_" #name

=09register_trace_event_data_type("gfp", print_gfp,
=09=09"mask:\n"
=09        " 0=3DGFP_NOWAIT,"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n"
=09=09" 0x%lx=3D%s,\n",
=09=09gfp_insert(,HIGHUSER_MOVABLE),
=09=09gfp_insert(,HIGHUSER),
=09=09gfp_insert(,USER),
=09=09gfp_insert(,TEMPORARY),
=09=09gfp_insert(,NOFS),
=09=09gfp_insert(,ATOMIC),
=09=09gfp_insert(,NOIO),
=09=09gfp_insert(__,HIGH),
=09=09gfp_insert(__,WAIT),
=09=09gfp_insert(__,IO),
=09=09gfp_insert(__,COLD),
=09=09gfp_insert(__,NOWARN),
=09=09gfp_insert(__,REPEAT),
=09=09gfp_insert(__,NOFAIL),
=09=09gfp_insert(__,NORETRY),
=09=09gfp_insert(__,COMP),
=09=09gfp_insert(__,ZERO),
=09=09gfp_insert(__,NOMEMALLOC),
=09=09gfp_insert(__,HARDWALL),
=09=09gfp_insert(__,THISNODE),
=09=09gfp_insert(__,RECLAIMABLE),
=09=09gfp_insert(__,MOVEABLE));


And then in the trace format, we could do:

=09<data:gfp:field>

And the 'data' will flag us to how to print the data.

For userland, there could be a file in:

=09/debug/tracing/events/data_types/gfp/format

That will show that format. Yes we duplicate some of the code, but it=20
it would solve these types of issues.

-- Steve


=09=09
=09=09
=09

--8323328-86438531-1244641770=:30552--
