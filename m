Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbYL2Uaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbYL2Uaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYL2UaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:30:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509AbYL2UaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:30:18 -0500
Date: Mon, 29 Dec 2008 12:29:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] exofs: osd Swiss army knife
Message-Id: <20081229122959.2cb48cf7.akpm@linux-foundation.org>
In-Reply-To: <1229439174-30492-1-git-send-email-bharrosh@panasas.com>
References: <4947BFAA.4030208@panasas.com>
	<1229439174-30492-1-git-send-email-bharrosh@panasas.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 16:52:54 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> In this patch are all the osd infrastructure that will be used later
> by the file system.
> 
> Also the declarations of constants, on disk structures, and prototypes.
> 
> And the Kbuild+Kconfig files needed to build the exofs module.
> 
>
> ...
>
> +struct exofs_sb_info {
> +	struct osd_dev	*s_dev;			/* returned by get_osd_dev    */
> +	uint64_t	s_pid;			/* partition ID of file system*/
> +	int		s_timeout;		/* timeout for OSD operations */
> +	uint32_t	s_nextid;		/* highest object ID used     */
> +	uint32_t	s_numfiles;		/* number of files on fs      */
> +	spinlock_t	s_next_gen_lock;	/* spinlock for gen # update  */
> +	u32		s_next_generation;	/* next gen # to use          */
> +	atomic_t	s_curr_pending;		/* number of pending commands */
> +	uint8_t		s_cred[OSD_CAP_LEN];	/* all-powerful credential    */
> +};
> +
> +/*
> + * our inode flags
> + */
> +#ifdef ARCH_HAS_ATOMIC_UNSIGNED

This doesn't exist, and it would be fairly bad to introduce it.  Please
kill the ifdefs.

> +typedef unsigned exofs_iflags_t;
> +#else
> +typedef unsigned long exofs_iflags_t;
> +#endif

Then please kill the typedef altogether and replace it with `unsigned
long' everywhere.

> +#define OBJ_2BCREATED	0	/* object will be created soon*/
> +#define OBJ_CREATED	1	/* object has been created on the osd*/
> +
> +#define Obj2BCreated(oi) \
> +	test_bit(OBJ_2BCREATED, &(oi->i_flags))
> +#define SetObj2BCreated(oi) \
> +	set_bit(OBJ_2BCREATED, &(oi->i_flags))
> +
> +#define ObjCreated(oi) \
> +	test_bit(OBJ_CREATED, &(oi->i_flags))
> +#define SetObjCreated(oi) \
> +	set_bit(OBJ_CREATED, &(oi->i_flags))

- please only implement code in macros when it CANNOT be implemented
  in C.  There are numerous reasons.  One of which is that the above
  macros will happily compile when passed a pointer to ANY truct whcih
  has an i_flags field.  If it were a properly typechecked C function,
  that can't happen.

- These "functions" have odd names.  This:

	static inline void obj_created(struct exofs_i_info *ei)

  would be more Linux-like.

> +/*
> + * our extension to the in-memory inode
> + */
> +struct exofs_i_info {
> +	exofs_iflags_t i_flags;            /* various atomic flags            */
> +	__le32	       i_data[EXOFS_IDATA];/*short symlink names and device #s*/
> +	uint32_t       i_dir_start_lookup; /* which page to start lookup      */
> +	wait_queue_head_t i_wq;            /* wait queue for inode            */
> +	uint64_t       i_commit_size;      /* the object's written length     */
> +	uint8_t        i_cred[OSD_CAP_LEN];/* all-powerful credential         */
> +	struct inode   vfs_inode;          /* normal in-memory inode          */
> +};
> +
> +/*
> + * get to our inode from the vfs inode
> + */
> +static inline struct exofs_i_info *EXOFS_I(struct inode *inode)
> +{
> +	return container_of(inode, struct exofs_i_info, vfs_inode);
> +}

yeah, well.  We got lazy when, we converted EXT2_I from a macro to a C
function.  That doesn't mean that the mistake should have been copied :)
exofs_i() would be a more suitable name.

> +/*************************
> + * function declarations *
> + *************************/
>
> ...
>
> +#include <scsi/scsi_device.h>
> +#include <scsi/osd_sense.h>
> +
> +#include "exofs.h"
> +
> +int check_ok(struct osd_request *req)

eek.  This is a kernel-wide symbol.  The choice of identifier is bad.

> +{
> +	struct osd_sense_info osi;
> +	int ret = osd_req_decode_sense(req, &osi);
> +
> +	if (ret) { /* translate to Linux codes */
> +		if (osi.additional_code == scsi_invalid_field_in_cdb) {
> +			if (osi.cdb_field_offset == OSD_CFO_STARTING_BYTE)
> +				ret = -EFAULT;
> +			if (osi.cdb_field_offset == OSD_CFO_OBJECT_ID)
> +				ret = -ENOENT;
> +			else
> +				ret = -EINVAL;
> +		} else if (osi.additional_code == osd_quota_error)
> +			ret = -ENOSPC;
> +		else
> +			ret = -EIO;
> +	}
> +
> +	return ret;
> +}
> +
> +void make_credential(uint8_t cred_a[OSD_CAP_LEN], uint64_t pid, uint64_t oid)

Ditto.  I suspect I'm going to see a lot of this.  Please review the
entire fs for its namespace niceness

> +{
> +	struct osd_obj_id obj = {
> +		.partition = pid,
> +		.id = oid
> +	};
> +
> +	osd_sec_init_nosec_doall_caps(cred_a, &obj, false, true);
> +}
> +
>
> ...
>
> +int prepare_get_attr_list_add_entry(struct osd_request *req,
> +				    uint32_t page_num,
> +				    uint32_t attr_num,
> +				    uint32_t attr_len)
> +{
> +	struct osd_attr attr = {
> +		.page = page_num,

Kernel developers expect a field called "page" to have type `struct
page *'.  osd_attr.page is thus designed to confuse.

>
> ...
>

