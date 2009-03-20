Return-Path: <linux-kernel-owner+w=401wt.eu-S1762466AbZCTAqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762466AbZCTAqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 20:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760393AbZCTAqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 20:46:06 -0400
Received: from kroah.org ([198.145.64.141]:32877 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759889AbZCTAqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 20:46:05 -0400
Date: Thu, 19 Mar 2009 17:45:39 -0700
From: Greg KH <greg@kroah.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC Aufs2 #3 2/2] split 'xino' entry under sysfs
Message-ID: <20090320004539.GF18781@kroah.com>
References: <1237439565-25039-1-git-send-email-hooanon05@yahoo.co.jp> <1237439565-25039-3-git-send-email-hooanon05@yahoo.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237439565-25039-3-git-send-email-hooanon05@yahoo.co.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 02:12:45PM +0900, J. R. Okajima wrote:
> Follow the comments from Greg KH on LKML.
> - make all entries "one value per file".
> - split 'xino' into 'xi_path', 'xib' and 'xi0'...'xiN'.
> - new members in struct au_xino_file for xi[0-9]* entry.
> - remove sysaufs_si_attr_xino.
> - sysaufs_si_xino() shows only a size info of one xino file.
> - new variables sysaufs_si_attr_xi_path and sysaufs_si_attr_xib.
> - new functions sysaufs_si_xi_path() and sysaufs_si_xib().
> - rename sysaufs_sbi_xi() to sysaufs_xi_attr().
> - sysaufs_si_show() supports xiN.
> - sysaufs_br_init() initializes br->br_xino.xi_attr too.
> - sysaufs_brs_del() and sysaufs_brs_add() always handle
>   br->br_xino.xi_attr.
> - new static function sysaufs_brs_do_add() to generate brN and xiN
>   names.
> 
> Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
> ---
>  Documentation/ABI/testing/sysfs-aufs |   62 +++++++++++
>  fs/aufs/branch.h                     |    6 +
>  fs/aufs/sysaufs.c                    |    6 +-
>  fs/aufs/sysaufs.h                    |   11 ++-
>  fs/aufs/sysfs.c                      |  195 +++++++++++++++++++++++-----------
>  5 files changed, 212 insertions(+), 68 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-aufs
> 
> diff --git a/Documentation/ABI/testing/sysfs-aufs b/Documentation/ABI/testing/sysfs-aufs
> new file mode 100644
> index 0000000..1552d3e
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-aufs
> @@ -0,0 +1,62 @@
> +What:		/sys/fs/aufs/si_<id>/
> +Date:		March 2009
> +Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
> +Description:
> +		Under /sys/fs/aufs, a directory named si_<id> is created
> +		per aufs mount, where <id> is a unique id generated
> +		internally.
> +
> +What:		/sys/fs/aufs/si_<id>/br0, br1 ... brN
> +Date:		March 2009
> +Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
> +Description:
> +		It shows the abolute path of a member directory (which
> +		is called branch) in aufs, and its permission.
> +
> +What:		/sys/fs/aufs/si_<id>/xi_path
> +Date:		March 2009
> +Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
> +Description:
> +		It shows the abolute path of XINO (External Inode Number
> +		Bitmap, Translation Table and Generation Table) file
> +		even if it is the default path.
> +		When the aufs mount option 'noxino' is specified, it
> +		will be empty. About XINO files, see
> +		Documentation/filesystems/aufs/aufs.5 in detail.
> +
> +What:		/sys/fs/aufs/si_<id>/xib
> +Date:		March 2009
> +Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
> +Description:
> +		It shows the consumed blocks by xib (External Inode Number
> +		Bitmap), its block size and file size.
> +		When the aufs mount option 'noxino' is specified, it
> +		will be empty. About XINO files, see
> +		Documentation/filesystems/aufs/aufs.5 in detail.

Sysfs files are one value per file.  This violates that rule.

> +What:		/sys/fs/aufs/si_<id>/xino0, xino1 ... xinoN
> +Date:		March 2009
> +Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
> +Description:
> +		It shows the consumed blocks by xino (External Inode Number
> +		Translation Table), its link count, block size and file
> +		size.
> +		When the aufs mount option 'noxino' is specified, it
> +		will be empty. About XINO files, see
> +		Documentation/filesystems/aufs/aufs.5 in detail.
> +
> +What:		/sys/fs/aufs/si_<id>/xigen
> +Date:		March 2009
> +Contact:	J. R. Okajima <hooanon05@yahoo.co.jp>
> +Description:
> +		It shows the consumed blocks by xigen (External Inode
> +		Generation Table), its block size and file size.
> +		If CONFIG_AUFS_EXPORT is disabled, this entry will not
> +		be created.
> +		When the aufs mount option 'noxino' is specified, it
> +		will be empty. About XINO files, see
> +		Documentation/filesystems/aufs/aufs.5 in detail.

Are all of these things something that a "normal" user would care about?
or are they development / debugging things?

> +# Local variables: ;
> +# mode: text;
> +# End: ;

I don't think you ment to add this to the file :)

And why are you using seq_file for a sysfs file?  That's not allowed,
and a sure sign you are doing something wrong, please remove all of
that.

thanks,

greg k-h
