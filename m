Return-Path: <linux-kernel-owner+w=401wt.eu-S932382AbXDLToH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbXDLToH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932359AbXDLToH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:44:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbXDLToG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:44:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5c49b0ed0704121227h48c3271bp2511e082704d639f@mail.gmail.com> 
References: <5c49b0ed0704121227h48c3271bp2511e082704d639f@mail.gmail.com>  <20070412024938.27380.44677.patchbomb.py@localhost> <1273.1176375482@redhat.com> <5c49b0ed0704121123x341d10afxfdf6930b4b26417b@mail.gmail.com> <29898.1176404243@redhat.com> 
To: "Nate Diller" <nate.diller@gmail.com>
Cc: "Andrew Morton" <akpm@osdl.org>,
       "Alexander Viro" <viro@zeniv.linux.org.uk>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Mikulas Patocka" <mikulas@artax.karlin.mff.cuni.cz>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Dave Kleikamp" <shaggy@austin.ibm.com>,
       "Anton Altaparmakov" <aia21@cantab.net>,
       "Evgeniy Dushistov" <dushistov@mail.ru>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-dev@namesys.com
Subject: Re: [PATCH 3/17] afs: convert afs_dir_get_page to read_kmap_page 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Thu, 12 Apr 2007 20:43:11 +0100
Message-ID: <30839.1176406991@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nate Diller <nate.diller@gmail.com> wrote:

> but that's a lot of code to avoid a single stack allocation.  The
> whole fake file pointer thing still strikes me as a little ugly, and
> you're definitely not the first one who needed this sort of hackery.
> ugh

A better way might be to stick a void * in struct file and pass that through
to readpage() and readpages() instead of the struct file *.  That way, anyone
who wants the traditional arrangement can just point that extra void * at the
struct file.

Of course, I'm in favour of making it a struct key * like this:

	struct address_space_operations {
	...
		int (*readpage)(struct key *, struct page *);
	...
		int (*readpages)(struct key *, struct address_space *,
				struct list_head *, unsigned);
	...
	};

	struct file {
	...
		struct key *f_key;
	};

	struct page *filemap_nopage(struct vm_area_struct *area, ...)
	{
	...
		struct file *file = area->vm_file;
	...
		error = mapping->a_ops->readpage(file->f_key, page);
	...
	}
	
But I'm not sure the NFS crew, for instance, would be happy with that.  Maybe
passing file->private_data through would do.  That's basically what NFS and
FUSE, for instance, want, and it would also do for AFS.

David
