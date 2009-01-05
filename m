Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbZAEVMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbZAEVMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 16:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZAEVMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 16:12:08 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:53085 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbZAEVMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 16:12:05 -0500
Date: Mon, 5 Jan 2009 13:09:40 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: devpts multiple instances feedback
Message-ID: <20090105210940.GA31629@us.ibm.com>
References: <20090103155209.GA17988@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090103155209.GA17988@lst.de>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig [hch@lst.de] wrote:
| I just took a look at the changes going into Linus current tree and
| here's some feedback about the devpts multiple instances code:

Thanks for the review. Here are some quick responses and will go over
comments/patch more closely.

Ccing Alan Cox.

| 
|  - the ptmx node is quite useful, I think it should always be around,
|    even for normal devpts mounts.  That way distros can slowly migrate
|    over to just using it by default and making the containers
|    interaction easier.  It's also in many ways much nicer to have
|    all the pty handling in one filesystems instead of sometimes
|    using the character device.

Making the pts/ptmx node would certianly simplify the code. But we
ended up with some of the complexity to preserve the legacy behavior.
I believe there was some concern that the presence of a "shadow"
ptmx node on older distros might affect rights management (eg: if
the older distro which does not know about /dev/pts/ptmx, applied
a security label to /dev/ptmx that label could be subverted by using
/dev/pts/ptmx ?

That was also one of the reasons for the default 000 mode on the pts/ptmx
device node


|  - the 000 mode is very weird, given how the /dev/ptmx operates
|    it doesn't really make much sense to have it different than 0666
|    unless you want to disable ptys.
|  - why does pts_sb_from_inode have to check s_magic, I can't see
|    it ever used on an inode not from the devpts filesystem

If /dev/ptmx is not a symlink to pts/ptmx, we would need the s_magic
check ? (eg: when called from devpts_new_index()). The check would
not be needed if /dev/ptmx is always a symlink.

|  - parsing the options twice is rather odd, I'd rather parse it into
|    a once allocated structure then passed on through the private
|    data void pointer into get_sb_nodev

Agree :-)

|  - creating the ptmx node should happen inside devfs_fill_super
|  - once the ptmx mknod is gone I think new_pts_mount,
|    is_new_instance_mount, init_pts_mount and maybe even get_init_pts_sb
|    should be merged into devpts_get_sb to make the whole mounting
|    scenario easier to follow instead of having to jump through half
|    a dozen functions
|  - I think CONFIG_DEVPTS_MULTIPLE_INSTANCES is not a good idea,
|    it's not much code and could either be enabled unconditionally or
|    based on the presence of a generic namespaces config option.
|    (btw, this also applies to the other namespaces options, there's

The config token was not needed for the namespaces itself but more
to preserve the legacy behavior. If we don't need o preseve the
legacy mode, we could remove the token.
|    not much of a reason to have millions of options for them,
|    one single option would be a lot easier for the user..)
| --
| To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
| the body of a message to majordomo@vger.kernel.org
| More majordomo info at  http://vger.kernel.org/majordomo-info.html
| Please read the FAQ at  http://www.tux.org/lkml/
