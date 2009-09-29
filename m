Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZI2Xwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZI2Xwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 19:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZI2Xwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 19:52:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbZI2Xwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 19:52:40 -0400
Date: Tue, 29 Sep 2009 16:52:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       yehuda@newdream.net, sage@newdream.net
Subject: Re: [PATCH 02/21] ceph: on-wire types
Message-Id: <20090929165242.99e5bdf2.akpm@linux-foundation.org>
In-Reply-To: <1253641129-28434-3-git-send-email-sage@newdream.net>
References: <1253641129-28434-1-git-send-email-sage@newdream.net>
	<1253641129-28434-2-git-send-email-sage@newdream.net>
	<1253641129-28434-3-git-send-email-sage@newdream.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 10:38:30 -0700
Sage Weil <sage@newdream.net> wrote:

> These headers describe the types used to exchange messages between the
> Ceph client and various servers.  All types are little-endian and
> packed.
> 
> Additionally, we define a few magic values to identify the current
> version of the protocol(s) in use, so that discrepancies to be
> detected on mount.
> 
> ...
>
> +static inline __u32 frag_make(__u32 b, __u32 v)
> +{
> +	return (b << 24) |
> +		(v & (0xffffffu << (24-b)) & 0xffffffu);
> +}
> +static inline __u32 frag_bits(__u32 f)
> +{
> +	return f >> 24;
> +}
> +static inline __u32 frag_value(__u32 f)
> +{
> +	return f & 0xffffffu;
> +}
> +static inline __u32 frag_mask(__u32 f)
> +{
> +	return (0xffffffu << (24-frag_bits(f))) & 0xffffffu;
> +}
> +static inline __u32 frag_mask_shift(__u32 f)
> +{
> +	return 24 - frag_bits(f);
> +}
> +
> +static inline int frag_contains_value(__u32 f, __u32 v)
> +{
> +	return (v & frag_mask(f)) == frag_value(f);
> +}
> +static inline int frag_contains_frag(__u32 f, __u32 sub)
> +{
> +	/* is sub as specific as us, and contained by us? */
> +	return frag_bits(sub) >= frag_bits(f) &&
> +		(frag_value(sub) & frag_mask(f)) == frag_value(f);
> +}
> +
> +static inline __u32 frag_parent(__u32 f)
> +{
> +	return frag_make(frag_bits(f) - 1,
> +			 frag_value(f) & (frag_mask(f) << 1));
> +}
> +static inline int frag_is_left_child(__u32 f)
> +{
> +	return frag_bits(f) > 0 &&
> +		(frag_value(f) & (0x1000000 >> frag_bits(f))) == 0;
> +}
> +static inline int frag_is_right_child(__u32 f)
> +{
> +	return frag_bits(f) > 0 &&
> +		(frag_value(f) & (0x1000000 >> frag_bits(f))) == 1;
> +}
> +static inline __u32 frag_sibling(__u32 f)
> +{
> +	return frag_make(frag_bits(f),
> +			 frag_value(f) ^ (0x1000000 >> frag_bits(f)));
> +}
> +static inline __u32 frag_left_child(__u32 f)
> +{
> +	return frag_make(frag_bits(f)+1, frag_value(f));
> +}
> +static inline __u32 frag_right_child(__u32 f)
> +{
> +	return frag_make(frag_bits(f)+1,
> +			 frag_value(f) | (0x1000000 >> (1+frag_bits(f))));
> +}
> +static inline __u32 frag_make_child(__u32 f, int by, int i)
> +{
> +	int newbits = frag_bits(f) + by;
> +	return frag_make(newbits,
> +			 frag_value(f) | (i << (24 - newbits)));
> +}
> +static inline int frag_is_leftmost(__u32 f)
> +{
> +	return frag_value(f) == 0;
> +}
> +static inline int frag_is_rightmost(__u32 f)
> +{
> +	return frag_value(f) == frag_mask(f);
> +}
> +static inline __u32 frag_next(__u32 f)
> +{
> +	return frag_make(frag_bits(f),
> +			 frag_value(f) + (0x1000000 >> frag_bits(f)));
> +}
> +
> +/*
> + * comparator to sort frags logically, as when traversing the
> + * number space in ascending order...
> + */
> +static inline int frag_compare(__u32 a, __u32 b)
> +{
> +	unsigned va = frag_value(a);
> +	unsigned vb = frag_value(b);
> +	if (va < vb)
> +		return -1;
> +	if (va > vb)
> +		return 1;
> +	va = frag_bits(a);
> +	vb = frag_bits(b);
> +	if (va < vb)
> +		return -1;
> +	if (va > vb)
> +		return 1;
> +	return 0;
> +}

I expect you'll find that many of these functions expand to a lot of
code, and the filesystem will be smaller and faster if they are
uninlined.

Why does it use __u32 rather than u32?  AIUI, __u32 is only used when
the header is shared with userspace and this one should not be shared.

> +
> +/*
> + * ceph_file_layout - describe data layout for a file/inode
> + */
> +struct ceph_file_layout {
> +	/* file -> object mapping */
> +	__le32 fl_stripe_unit;     /* stripe unit, in bytes.  must be multiple
> +				      of page size. */
> +	__le32 fl_stripe_count;    /* over this many objects */
> +	__le32 fl_object_size;     /* until objects are this big, then move to
> +				      new objects */
> +	__le32 fl_cas_hash;        /* 0 = none; 1 = sha256 */
> +
> +	/* pg -> disk layout */
> +	__le32 fl_object_stripe_unit;  /* for per-object parity, if any */
> +
> +	/* object -> pg layout */
> +	__le32 fl_pg_preferred; /* preferred primary for pg (-1 for none) */
> +	__le32 fl_pg_pool;      /* namespace, crush ruleset, rep level */
> +} __attribute__ ((packed));

It's conventional to use __packed for this.  If the header is shared
with userspace then scrub that.

> +#define ceph_file_layout_su(l) ((__s32)le32_to_cpu((l).fl_stripe_unit))
> +#define ceph_file_layout_stripe_count(l) \
> +	((__s32)le32_to_cpu((l).fl_stripe_count))
> +#define ceph_file_layout_object_size(l) ((__s32)le32_to_cpu((l).fl_object_size))
> +#define ceph_file_layout_cas_hash(l) ((__s32)le32_to_cpu((l).fl_cas_hash))
> +#define ceph_file_layout_object_su(l) \
> +	((__s32)le32_to_cpu((l).fl_object_stripe_unit))
> +#define ceph_file_layout_pg_preferred(l) \
> +	((__s32)le32_to_cpu((l).fl_pg_preferred))
> +#define ceph_file_layout_pg_pool(l) \
> +	((__s32)le32_to_cpu((l).fl_pg_pool))

But the header has a lot of stuff which looks like it shouldn't be
shared with userspace.

> +#define ceph_file_layout_stripe_width(l) (le32_to_cpu((l).fl_stripe_unit) * \
> +					  le32_to_cpu((l).fl_stripe_count))
> +
> +/* "period" == bytes before i start on a new set of objects */
> +#define ceph_file_layout_period(l) (le32_to_cpu((l).fl_object_size) *	\
> +				    le32_to_cpu((l).fl_stripe_count))

Please only implement in cpp that which cannot be implemented in C.

One reason (amongst many) is that the above macros evaluate `l' twice
and will hence misbehave if passed an expression with sode-effects.

Please review the entire fs driver for this mistake.

> +
> +
> +/*
> + * string hash.
> + *
> + * taken from Linux, tho we should probably take care to use this one
> + * in case the upstream hash changes.
> + */
> +
> +/* Name hashing routines. Initial hash value */
> +/* Hash courtesy of the R5 hash in reiserfs modulo sign bits */
> +#define ceph_init_name_hash()		0
> +
> +/* partial hash update function. Assume roughly 4 bits per character */
> +static inline unsigned long
> +ceph_partial_name_hash(unsigned long c, unsigned long prevhash)
> +{
> +	return (prevhash + (c << 4) + (c >> 4)) * 11;
> +}
> +
> +/*
> + * Finally: cut down the number of bits to a int value (and try to avoid
> + * losing bits)
> + */
> +static inline unsigned long ceph_end_name_hash(unsigned long hash)
> +{
> +	return (unsigned int) hash;
> +}

Wouldn't

	return hash & 0xffffffff;

be clearer?

> +/* Compute the hash for a name string. */
> +static inline unsigned int
> +ceph_full_name_hash(const char *name, unsigned int len)
> +{
> +	unsigned long hash = ceph_init_name_hash();
> +	while (len--)
> +		hash = ceph_partial_name_hash(*name++, hash);
> +	return ceph_end_name_hash(hash);
> +}

Waaaaaay too big for inlining!

>
> ...
>
> +struct ceph_mon_statfs {
> +	__le64 have_version;
> +	struct ceph_fsid fsid;
> +	__le64 tid;
> +} __attribute__ ((packed));

Might be able to use __packed (please check the whole fs)

>
> ...
>
> +static inline const char *ceph_mds_state_name(int s)
> +{
> +	switch (s) {
> +		/* down and out */
> +	case CEPH_MDS_STATE_DNE:        return "down:dne";
> +	case CEPH_MDS_STATE_STOPPED:    return "down:stopped";
> +		/* up and out */
> +	case CEPH_MDS_STATE_BOOT:       return "up:boot";
> +	case CEPH_MDS_STATE_STANDBY:    return "up:standby";
> +	case CEPH_MDS_STATE_STANDBY_REPLAY:    return "up:standby-replay";
> +	case CEPH_MDS_STATE_CREATING:   return "up:creating";
> +	case CEPH_MDS_STATE_STARTING:   return "up:starting";
> +		/* up and in */
> +	case CEPH_MDS_STATE_REPLAY:     return "up:replay";
> +	case CEPH_MDS_STATE_RESOLVE:    return "up:resolve";
> +	case CEPH_MDS_STATE_RECONNECT:  return "up:reconnect";
> +	case CEPH_MDS_STATE_REJOIN:     return "up:rejoin";
> +	case CEPH_MDS_STATE_CLIENTREPLAY: return "up:clientreplay";
> +	case CEPH_MDS_STATE_ACTIVE:     return "up:active";
> +	case CEPH_MDS_STATE_STOPPING:   return "up:stopping";
> +	default: return "";
> +	}
> +	return NULL;
> +}

geeze.

This might generate decent code as long as it's always called with a
constant arg.  Otherwise, ouch.

If we're lucky, the compiler will instantiate one copy of each string
kernel-wide.  If we're unlucky it'll instantate one copy per
compilation unit.

> +static inline const char *ceph_session_op_name(int op)
> +{
> +	switch (op) {
> +	case CEPH_SESSION_REQUEST_OPEN: return "request_open";
> +	case CEPH_SESSION_OPEN: return "open";
> +	case CEPH_SESSION_REQUEST_CLOSE: return "request_close";
> +	case CEPH_SESSION_CLOSE: return "close";
> +	case CEPH_SESSION_REQUEST_RENEWCAPS: return "request_renewcaps";
> +	case CEPH_SESSION_RENEWCAPS: return "renewcaps";
> +	case CEPH_SESSION_STALE: return "stale";
> +	case CEPH_SESSION_RECALL_STATE: return "recall_state";
> +	default: return "???";
> +	}
> +}

I hereby revoke your inlining license!

>
> ...
>
> +union ceph_mds_request_args {
> +	struct {
> +		__le32 mask;  /* CEPH_CAP_* */
> +	} __attribute__ ((packed)) getattr;
> +	struct {
> +		__le32 mode;
> +		__le32 uid;
> +		__le32 gid;
> +		struct ceph_timespec mtime;
> +		struct ceph_timespec atime;
> +		__le64 size, old_size;
> +		__le32 mask;  /* CEPH_SETATTR_* */
> +	} __attribute__ ((packed)) setattr;
> +	struct {
> +		__le32 frag;
> +		__le32 max_entries;
> +	} __attribute__ ((packed)) readdir;
> +	struct {
> +		__le32 mode;
> +		__le32 rdev;
> +	} __attribute__ ((packed)) mknod;
> +	struct {
> +		__le32 mode;
> +	} __attribute__ ((packed)) mkdir;
> +	struct {
> +		__le32 flags;
> +		__le32 mode;
> +		__le32 stripe_unit;
> +		__le32 stripe_count;
> +		__le32 object_size;
> +		__le32 file_replication;
> +	} __attribute__ ((packed)) open;
> +	struct {
> +		__le32 flags;
> +	} __attribute__ ((packed)) setxattr;
> +	struct {
> +		struct ceph_file_layout layout;
> +	} __attribute__ ((packed)) setlayout;
> +} __attribute__ ((packed));

Some of these data structures look pretty important but they're not
documented (here, at least)?

>
> ...
>
> +struct ceph_entity_name {
> +	__u8 type;
> +	__le64 num;
> +} __attribute__ ((packed));

So we end up with a poorly-aligned u64.  Unfortunate.  I trust the
kernel code uses the correct and appropriate include/linux/unaligned
helpers to access things such as this?

> +#define CEPH_ENTITY_TYPE_MON    1
> +#define CEPH_ENTITY_TYPE_MDS    2
> +#define CEPH_ENTITY_TYPE_OSD    3
> +#define CEPH_ENTITY_TYPE_CLIENT 4
> +#define CEPH_ENTITY_TYPE_ADMIN  5
> +
> +/*
> + * entity_addr -- network address
> + */
> +struct ceph_entity_addr {
> +	__le32 erank;  /* entity's rank in process */
> +	__le32 nonce;  /* unique id for process (e.g. pid) */
> +	struct sockaddr_in ipaddr;
> +} __attribute__ ((packed));
> +
> +static inline bool ceph_entity_addr_is_local(const struct ceph_entity_addr *a,
> +					     const struct ceph_entity_addr *b)
> +{
> +	return a->nonce == b->nonce &&
> +		a->ipaddr.sin_addr.s_addr == b->ipaddr.sin_addr.s_addr;
> +}
> +
> +static inline bool ceph_entity_addr_equal(const struct ceph_entity_addr *a,
> +					  const struct ceph_entity_addr *b)
> +{
> +	return memcmp(a, b, sizeof(*a)) == 0;
> +}

sockaddr_in contains a __pad[] array.  Here you're assuming that code
elsewhere will initialise that padding array to a fixed, always-equal
value.  This seems fragile and possibly incorrect.

> +struct ceph_entity_inst {
> +	struct ceph_entity_name name;
> +	struct ceph_entity_addr addr;
> +} __attribute__ ((packed));
> +
> +
> +/* used by message exchange protocol */
> +#define CEPH_MSGR_TAG_READY         1  /* server->client: ready for messages */
> +#define CEPH_MSGR_TAG_RESETSESSION  2  /* server->client: reset, try again */
> +#define CEPH_MSGR_TAG_WAIT          3  /* server->client: wait for racing
> +					  incoming connection */
> +#define CEPH_MSGR_TAG_RETRY_SESSION 4  /* server->client + cseq: try again
> +					  with higher cseq */
> +#define CEPH_MSGR_TAG_RETRY_GLOBAL  5  /* server->client + gseq: try again
> +					  with higher gseq */
> +#define CEPH_MSGR_TAG_CLOSE         6  /* closing pipe */
> +#define CEPH_MSGR_TAG_MSG          10  /* message */
> +#define CEPH_MSGR_TAG_ACK          11  /* message ack */
> +#define CEPH_MSGR_TAG_KEEPALIVE    12  /* just a keepalive byte! */
> +#define CEPH_MSGR_TAG_BADPROTOVER  13  /* bad protocol version */

what happened to 7, 8 and 9?

> +
> +/*
> + * connection negotiation
> + */
> +struct ceph_msg_connect {
> +	__le32 host_type;  /* CEPH_ENTITY_TYPE_* */
> +	__le32 global_seq;
> +	__le32 connect_seq;
> +	__le32 protocol_version;
> +	__u8  flags;
> +} __attribute__ ((packed));
> +
> +struct ceph_msg_connect_reply {
> +	__u8 tag;
> +	__le32 global_seq;
> +	__le32 connect_seq;
> +	__le32 protocol_version;
> +	__u8 flags;
> +} __attribute__ ((packed));
> +
> +#define CEPH_MSG_CONNECT_LOSSY  1  /* messages i send may be safely dropped */
> +
> +
> +/*
> + * message header
> + */
> +struct ceph_msg_header {
> +	__le64 seq;       /* message seq# for this session */
> +	__le16 type;      /* message type */
> +	__le16 priority;  /* priority.  higher value == higher priority */
> +
> +	__le32 front_len; /* bytes in main payload */
> +	__le32 middle_len;/* bytes in middle payload */
> +	__le32 data_len;  /* bytes of data payload */
> +	__le16 data_off;  /* sender: include full offset;
> +			     receiver: mask against ~PAGE_MASK */
> +
> +	struct ceph_entity_inst src, orig_src;
> +	__le32 dst_erank;
> +	__le32 crc;       /* header crc32c */
> +} __attribute__ ((packed));

ooh, that one got documented a bit.

> +#define CEPH_MSG_PRIO_LOW     64
> +#define CEPH_MSG_PRIO_DEFAULT 127
> +#define CEPH_MSG_PRIO_HIGH    196
> +#define CEPH_MSG_PRIO_HIGHEST 255
> +
> +/*
> + * follows data payload
> + */
> +struct ceph_msg_footer {
> +	__le32 front_crc, middle_crc, data_crc;
> +	__u8 flags;
> +} __attribute__ ((packed));
> +
> +#define CEPH_MSG_FOOTER_COMPLETE  (1<<0)   /* msg wasn't aborted */
> +#define CEPH_MSG_FOOTER_NOCRC     (1<<1)   /* no data crc */

Does the overall on-the-wire format get documented anywhere?

> +
> +#endif
> diff --git a/fs/ceph/rados.h b/fs/ceph/rados.h
> new file mode 100644
> index 0000000..a871577
> --- /dev/null
> +++ b/fs/ceph/rados.h
> @@ -0,0 +1,426 @@
> +#ifndef __RADOS_H
> +#define __RADOS_H
> +
> +/*
> + * Data types for RADOS, the distributed object storage layer used by
> + * the Ceph file system.
> + */

RADOS?

> +#include "msgr.h"
> +
> +/*
> + * fs id
> + */
> +struct ceph_fsid {
> +	unsigned char fsid[16];
> +};
> +
> +static inline int ceph_fsid_compare(const struct ceph_fsid *a,
> +				    const struct ceph_fsid *b)
> +{
> +	return memcmp(a, b, sizeof(*a));
> +}
> +
> +/*
> + * ino, object, etc.
> + */
> +typedef __le64 ceph_snapid_t;
> +#define CEPH_MAXSNAP ((__u64)(-3))
> +#define CEPH_SNAPDIR ((__u64)(-1))
> +#define CEPH_NOSNAP  ((__u64)(-2))
> +
> +struct ceph_timespec {
> +	__le32 tv_sec;
> +	__le32 tv_nsec;
> +} __attribute__ ((packed));
> +
> +
> +/*
> + * object layout - how objects are mapped into PGs
> + */
> +#define CEPH_OBJECT_LAYOUT_HASH     1
> +#define CEPH_OBJECT_LAYOUT_LINEAR   2
> +#define CEPH_OBJECT_LAYOUT_HASHINO  3
> +
> +/*
> + * pg layout -- how PGs are mapped onto (sets of) OSDs
> + */
> +#define CEPH_PG_LAYOUT_CRUSH  0
> +#define CEPH_PG_LAYOUT_HASH   1
> +#define CEPH_PG_LAYOUT_LINEAR 2
> +#define CEPH_PG_LAYOUT_HYBRID 3
> +
> +
> +/*
> + * placement group.
> + * we encode this into one __le64.
> + */
> +#define CEPH_PG_TYPE_REP     1
> +#define CEPH_PG_TYPE_RAID4   2
> +union ceph_pg {
> +	__u64 pg64;
> +	struct {
> +		__s16 preferred; /* preferred primary osd */
> +		__u16 ps;        /* placement seed */
> +		__u32 pool;      /* implies crush ruleset */
> +	} pg;
> +} __attribute__ ((packed));

Does the compiler reliably propagate the __packed attribute into the
nested struct, or is a separate __packed needed?

> +#define ceph_pg_is_rep(pg)   ((pg).pg.type == CEPH_PG_TYPE_REP)
> +#define ceph_pg_is_raid4(pg) ((pg).pg.type == CEPH_PG_TYPE_RAID4)

Could be written in nicer-to-read, more-likely-to-be-documented,
more-type-safe C! (and 10000 dittoes elsewhere).

>
> ...
>
