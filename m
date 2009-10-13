Return-Path: <linux-kernel-owner+w=401wt.eu-S933875AbZJMPgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875AbZJMPgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760329AbZJMPgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:36:32 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:39044 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760287AbZJMPgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:36:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvQEAAM71EpMRK1g/2dsb2JhbACBUtc3hC0E
Date: Tue, 13 Oct 2009 11:35:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       anton@samba.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
       zhaolei@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com,
       linux-tip-commits@vger.kernel.org
Subject: [RFC] Trace types registry
Message-ID: <20091013153549.GC31859@Krystal>
References: <4A7F8B2B.5020908@cn.fujitsu.com> <tip-c6a2a1770245f654f35f60e1458d4356680f9519@git.kernel.org> <1255404309.7113.948.camel@gandalf.stny.rr.com> <20091013070853.GA13175@elte.hu> <1255439822.7113.1541.camel@gandalf.stny.rr.com> <20091013132656.GA12292@elte.hu> <1255442557.7113.1623.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1255442557.7113.1623.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:09:09 up 56 days, 58 min,  2 users,  load average: 0.53, 0.84,
	0.66
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2009-10-13 at 15:26 +0200, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > On Tue, 2009-10-13 at 09:08 +0200, Ingo Molnar wrote:
> > > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > 
> > > 
> > > > > (unsigned long long)(((ktime_t) { .tv64 = REC->expires }).tv64)
> > > > > 
> > > > > Is not easy. It's basically implementing a C interpreter :-(
> > > > 
> > > > Btw., what i suggested quite some time ago was that we should bind 
> > > > tracepoints by emitting C source code stubs, which tools can then build 
> > > > and link in, using gcc.
> > > 
> > > Yeah, and I thought about that too. But that kills any chance of 
> > > running the trace on one box (non x86) and reading it on another 
> > > (x86). And that is one of my goals for this.
> > 
> > Why does it kill that chance?
> 
> Ah, I was thinking binary libraries from the trace points. But I missed
> you said C source code.
> 
> But still, we need to build a way to convert big endian to little, as
> well as perhaps converting 32bit to 64 bit longs. As well as vice versa.
> 
> We also need a way to export all structures (here ktime_t) as well as
> enums. Of course we need to export enums now anyway, since the tools
> don't know how to convert them now.
> 
> -- Steve

I fully agree with Steve here. Embedded system developers, for instance,
will typically export traces taken on small embedded devices to a
completely different architecture for analysis and visualization.

The problem I see with exporting this as C code is that it does not
represent the type size and endianness of the traced kernel.

I think I may have a solution that could deal with these compound types.
Comments are welcome.

The idea is to create a type registry, that could be expressed in either
textual or binary format. (binary format simply requires a header with
the architecture endianness and basic types sizes expressed)

The registry, which would be saved along with a trace, could look like
what follows (written in C here, but would be created dynamically). Note
that this registry is only saved once with a trace, so we do not care
about compactness. What we really do care about is to make it easy to
parse a trace coming from an alien architecture.

enum entry_type { T_SCALAR, T_COMPOUND, T_EVENT };

struct event_field {
	u32 type_id;	/* maps to a type */
	char name[MAX_FIELD_NAME];
};

union compound_field {
	u32 type_id;		  /* Unnamed fields (array, sequence, string) */
	struct event_field field; /* Named fields (struct, union) */
}

/* Use "type_id" lookup to find if type is scalar or compound */
union event_type {
	struct event_type_scalar scalar;
	struct event_type_compound compound;
};

struct event_type_scalar {
	struct entry_type etype;
	u32 type_id;	/* Allocated dynamically */
	char name[MAX_TYPE_NAME];
	u32 size;
	u8 host_byte_order;
	u8 signed;
	u8 format;	/* one of 256 possible print formats */
	u8 float;	/* useful for user-space tracing */
};

/* array, sequence, struct, union, string */
struct event_type_compound {
	struct entry_type etype;
	u32 type_id;	/* Allocated dynamically */
	char name[MAX_TYPE_NAME];
	enum { T_ARRAY, T_SEQ, T_STRUCT, T_UNION, T_STRING } type;
	u32 nr_fields;
	union compound_field[nr_fields] field;
};

struct event {
	struct entry_type etype;
	/* map to the event */
	unsigned int group_id;
	unsigned int event_id;
	char group_name[MAX_GROUP_NAME];
	char event_name[MAX_EVENT_NAME];
	u32 type_id;
};

stuct trace_registry {
	struct regheader {
		u32 magic_num;	/* detect endianness */
		u8 int_size;	/* basic types */
		u8 long_size;
		u8 size_t_size;
		u8 off_t_size;
		u8 ptr_diff_t_size;
	}

	struct event_type_scalar {
		.etype = T_SCALAR,
		.type_id = lookup_or_create_type_id(char);
		.name = "char",
		.size = 1,
		.host_byte_order = 1,
		.signed = 0,
		.format = 'c',
		.float = 0,
	}

	struct event_type_compound = {
		.etype = T_COMPOUND,
		.type_id = lookup_or_create_type_id(char [TASK_COMM_LEN]),
		.name = "char [TASK_COMM_LEN]",
		.type = T_ARRAY,
		.nr_fields = TASK_COMM_LEN,
		.field[0].type_id = lookup_type_id("char");
	}

	struct event_type_scalar {
		.etype = T_SCALAR,
		.type_id = lookup_or_create_type_id(pid_t),
		.name = "pid_t",
		.size = sizeof(pid_t),
		.host_byte_order = 1,
		.signed = 0,
		.format = 'u',
		.float = 0,
	}

	struct event_type_scalar {
		.etype = T_SCALAR,
		.type_id = lookup_or_create_type_id(int),
		.name = "int",
		.size = sizeof(int),
		.host_byte_order = 1,
		.signed = 1,
		.format = 'd',
		.float = 0,
	}

	struct event_type_compound = {
		.etype = T_COMPOUND,
		.type_id = lookup_or_create_type_id(
			{
				char [TASK_COMM_LEN];
				pid_t;
				int;
				char;
				pid_t;
				int;
			});

		.name = "{
				char [TASK_COMM_LEN];
				pid_t;
				int;
				char;
				pid_t;
				int;
			}",
		.type = T_STRUCT,
		.nr_fields = 6,
		.field[0].field.type_id = lookup_type_id(char [TASK_COMM_LEN]),
		.field[0].field.name = "prev_comm",
		.field[1].field.type_id = lookup_type_id(pid_t),
		.field[1].field.name = "prev_pid",
		.field[2].field.type_id = lookup_type_id(int),
		.field[2].field.name = "prev_prio",
		.field[2].field.type_id = lookup_type_id(char [TASK_COMM_LEN]),
		.field[2].field.name = "next_comm",
		.field[2].field.type_id = lookup_type_id(pid_t),
		.field[2].field.name = "next_pid",
		.field[2].field.type_id = lookup_type_id(int),
		.field[2].field.name = "next_prio",
	}

	struct event sched_switch_event {
		.etype = T_EVENT,
		.group_id = lookup_event_group("groupname"),
		.event_id = lookup_event_id("evname"),
		.groupname = "groupname",
		.eventname = "evname",
		.type_id = lookup_type_id(
			{
				char [TASK_COMM_lEN];
				pid_t;
				int;
				char;
				pid_t;
				int;
			});

.......

	}
}

Note: lookup_type_id() and lookup_or_create_type_id() could be a macro
that stringify their parameters.

Steve, do you think this could be created by TRACE_EVENT() automatically ?
Basically, each field and event would try to register its types at
module load time. Registration would allocate a unique ID to each type
and a unique ID to each group and event.

When "unrolling" the registry at trace analysis time, these IDs would be
used to populate a hash table, so the event, group and type lookups can
be performed.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
