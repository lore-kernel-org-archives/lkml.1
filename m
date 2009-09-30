Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbZI3ANr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbZI3ANr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 20:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZI3ANr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 20:13:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613AbZI3ANq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 20:13:46 -0400
Date: Tue, 29 Sep 2009 17:13:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       yehuda@newdream.net, sage@newdream.net
Subject: Re: [PATCH 05/21] ceph: super.c
Message-Id: <20090929171320.db715f1a.akpm@linux-foundation.org>
In-Reply-To: <1253641129-28434-6-git-send-email-sage@newdream.net>
References: <1253641129-28434-1-git-send-email-sage@newdream.net>
	<1253641129-28434-2-git-send-email-sage@newdream.net>
	<1253641129-28434-3-git-send-email-sage@newdream.net>
	<1253641129-28434-4-git-send-email-sage@newdream.net>
	<1253641129-28434-5-git-send-email-sage@newdream.net>
	<1253641129-28434-6-git-send-email-sage@newdream.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 10:38:33 -0700
Sage Weil <sage@newdream.net> wrote:

> Mount option parsing, client setup and teardown, and a few odds and
> ends (e.g., statfs).
> 
>
> ...
>
> +static int init_caches(void)
> +{
> +	ceph_inode_cachep = kmem_cache_create("ceph_inode_cache",
> +					      sizeof(struct ceph_inode_info),
> +					      0, (SLAB_RECLAIM_ACCOUNT|
> +						  SLAB_MEM_SPREAD),
> +					      ceph_inode_init_once);
> +	if (ceph_inode_cachep == NULL)
> +		return -ENOMEM;
> +
> +	ceph_cap_cachep = kmem_cache_create("ceph_caps_cache",
> +					    sizeof(struct ceph_cap),
> +					    0, (SLAB_RECLAIM_ACCOUNT|
> +						SLAB_MEM_SPREAD),
> +					    NULL);
> +	if (ceph_cap_cachep == NULL)
> +		goto bad_cap;
> +
> +	ceph_dentry_cachep = kmem_cache_create("ceph_dentry_cache",
> +					       sizeof(struct ceph_dentry_info),
> +					       0, (SLAB_RECLAIM_ACCOUNT|
> +						   SLAB_MEM_SPREAD),
> +					       NULL);
> +	if (ceph_dentry_cachep == NULL)
> +		goto bad_dentry;
> +
> +	ceph_file_cachep = kmem_cache_create("ceph_file_cache",
> +					     sizeof(struct ceph_file_info),
> +					     0, (SLAB_RECLAIM_ACCOUNT|
> +						 SLAB_MEM_SPREAD),
> +					     NULL);
> +	if (ceph_file_cachep == NULL)
> +		goto bad_file;
> +
> +	return 0;
> +
> +bad_file:
> +	kmem_cache_destroy(ceph_dentry_cachep);
> +bad_dentry:
> +	kmem_cache_destroy(ceph_cap_cachep);
> +bad_cap:
> +	kmem_cache_destroy(ceph_inode_cachep);
> +	return -ENOMEM;
> +}

init_caches() can and should be marked __init.  Please check for other
cases of this missed optimisation.

We have the KMEM_CACHE() macro which should be used here if poss.  It
was added because we were frequently altering the kmem_cache_create()
arguments for a while.

> +const char *ceph_msg_type_name(int type)
> +{
> +	switch (type) {
> +	case CEPH_MSG_SHUTDOWN: return "shutdown";
> +	case CEPH_MSG_PING: return "ping";
> +	case CEPH_MSG_MON_MAP: return "mon_map";
> +	case CEPH_MSG_MON_GET_MAP: return "mon_get_map";
> +	case CEPH_MSG_MON_SUBSCRIBE: return "mon_subscribe";
> +	case CEPH_MSG_MON_SUBSCRIBE_ACK: return "mon_subscribe_ack";
> +	case CEPH_MSG_CLIENT_MOUNT: return "client_mount";
> +	case CEPH_MSG_CLIENT_MOUNT_ACK: return "client_mount_ack";
> +	case CEPH_MSG_STATFS: return "statfs";
> +	case CEPH_MSG_STATFS_REPLY: return "statfs_reply";
> +	case CEPH_MSG_MDS_GETMAP: return "mds_getmap";
> +	case CEPH_MSG_MDS_MAP: return "mds_map";
> +	case CEPH_MSG_CLIENT_SESSION: return "client_session";
> +	case CEPH_MSG_CLIENT_RECONNECT: return "client_reconnect";
> +	case CEPH_MSG_CLIENT_REQUEST: return "client_request";
> +	case CEPH_MSG_CLIENT_REQUEST_FORWARD: return "client_request_forward";
> +	case CEPH_MSG_CLIENT_REPLY: return "client_reply";
> +	case CEPH_MSG_CLIENT_CAPS: return "client_caps";
> +	case CEPH_MSG_CLIENT_CAPRELEASE: return "client_cap_release";
> +	case CEPH_MSG_CLIENT_SNAP: return "client_snap";
> +	case CEPH_MSG_CLIENT_LEASE: return "client_lease";
> +	case CEPH_MSG_OSD_GETMAP: return "osd_getmap";
> +	case CEPH_MSG_OSD_MAP: return "osd_map";
> +	case CEPH_MSG_OSD_OP: return "osd_op";
> +	case CEPH_MSG_OSD_OPREPLY: return "osd_opreply";
> +	default: return "unknown";
> +	}
> +}

The fs driver has a lot of these number-to-string functions.  I expect
many of them could be beneficially switched to array lookups.

>
> ...
>
> +/*
> + * Parse an ip[:port] list into an addr array.  Use the default
> + * monitor port if a port isn't specified.
> + */
> +#define ADDR_DELIM(c) ((!c) || (c == ':') || (c == ','))

"Implement not in cpp.."

> +static int parse_ips(const char *c, const char *end,
> +		     struct ceph_entity_addr *addr,
> +		     int max_count, int *count)
> +{
> +	int mon_count;
> +	const char *p = c;
> +
> +	dout("parse_ips on '%.*s'\n", (int)(end-c), c);
> +	for (mon_count = 0; mon_count < max_count; mon_count++) {
> +		const char *ipend;
> +		__be32 quad;
> +
> +		if (!in4_pton(p, end - p, (u8 *)&quad, ',', &ipend))
> +			goto bad;
> +		*(__be32 *)&addr[mon_count].ipaddr.sin_addr.s_addr = quad;
> +		p = ipend;
> +
> +		/* port? */
> +		if (p < end && *p == ':') {
> +			long port = 0;
> +
> +			p++;
> +			while (p < end && *p >= '0' && *p <= '9') {
> +				port = (port * 10) + (*p - '0');
> +				p++;
> +			}
> +			if (port > 65535 || port == 0)
> +				goto bad;
> +			addr[mon_count].ipaddr.sin_port = htons(port);
> +		} else
> +			addr[mon_count].ipaddr.sin_port = htons(CEPH_MON_PORT);
> +
> +		dout("parse_ips got %u.%u.%u.%u:%u\n",
> +		     IPQUADPORT(addr[mon_count].ipaddr));
> +
> +		if (p == end)
> +			break;
> +		if (*p != ',')
> +			goto bad;
> +		p++;
> +	}
> +
> +	if (p != end)
> +		goto bad;
> +
> +	if (count)
> +		*count = mon_count + 1;
> +	return 0;
> +
> +bad:
> +	pr_err("ceph parse_ips bad ip '%s'\n", c);
> +	return -EINVAL;
> +}

What does this do and are you sure that we don't have helper code
elsewhere in the kernel which can be employed here?

If not, please have a think about proposing the addition of such helper
code.  This does not look like an uncommon thing to be doing.

> +/*
> + * create a fresh client instance
> + */
> +static struct ceph_client *ceph_create_client(void)
> +{
> +	struct ceph_client *client;
> +	int err = -ENOMEM;
> +
> +	client = kzalloc(sizeof(*client), GFP_KERNEL);
> +	if (client == NULL)
> +		return ERR_PTR(-ENOMEM);
> +
> +	mutex_init(&client->mount_mutex);
> +
> +	init_waitqueue_head(&client->mount_wq);
> +
> +	client->sb = NULL;
> +	client->mount_state = CEPH_MOUNT_MOUNTING;
> +	client->whoami = -1;
> +
> +	client->msgr = NULL;
> +
> +	client->mount_err = 0;
> +	client->signed_ticket = NULL;
> +	client->signed_ticket_len = 0;
> +
> +	err = -ENOMEM;
> +	client->wb_wq = create_workqueue("ceph-writeback");
> +	if (client->wb_wq == NULL)
> +		goto fail;
> +	client->pg_inv_wq = create_workqueue("ceph-pg-invalid");
> +	if (client->pg_inv_wq == NULL)
> +		goto fail_wb_wq;
> +	client->trunc_wq = create_workqueue("ceph-trunc");
> +	if (client->trunc_wq == NULL)
> +		goto fail_pg_inv_wq;

You just created 1920 kernel threads on a ten-mount, 64-CPU machine. 
This will prove unpopular.

Did these really truly need to be thread-per-cpu workqueues?  We cannot
use create_singlethread_workqueue()?

> +
> +/*
> + * construct our own bdi so we can control readahead, etc.
> + */
> +static int ceph_init_bdi(struct super_block *sb, struct ceph_client *client)
> +{
> +	int err;
> +
> +	if (client->mount_args.rsize)
> +		client->backing_dev_info.ra_pages =
> +			(client->mount_args.rsize + PAGE_CACHE_SIZE - 1)
> +			>> PAGE_SHIFT;
> +
> +	if (client->backing_dev_info.ra_pages < (PAGE_CACHE_SIZE >> PAGE_SHIFT))
> +		client->backing_dev_info.ra_pages =
> +			CEPH_MOUNT_RSIZE_DEFAULT >> PAGE_SHIFT;
> +
> +	err = bdi_init(&client->backing_dev_info);
> +
> +	if (err < 0)
> +		return err;
> +
> +	err = bdi_register_dev(&client->backing_dev_info, sb->s_dev);
> +	return err;
> +}

I suggest it would be safer to modify client->backing_dev_info _after_
calling bdi_init().

Please add comments explaining the fiddling with ra_pages here.


