Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab0CIH1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 02:27:40 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:33723 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab0CIH1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 02:27:35 -0500
From: Jim Meyering <jim@meyering.net>
To: Karel Zak <kzak@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tejun Heo <tj@kernel.org>,
       "linux-ide\@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
In-Reply-To: <20100308195847.GC18077@nb.net.home> (Karel Zak's message of
	"Mon, 8 Mar 2010 20:58:47 +0100")
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net>
	<20100308195847.GC18077@nb.net.home>
Date: Tue, 09 Mar 2010 08:27:24 +0100
Message-ID: <878wa20xb7.fsf@meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karel Zak wrote:
> On Mon, Mar 08, 2010 at 10:18:27AM -0500, Martin K. Petersen wrote:
...
>> It'd be great if you guys could share what you have been doing to the
>> tooling.
>
>  small summary:
>
>  - libblkid provides unified API to topology information, it supports:
>     - ioctls (kernel >= 2.6.32)
>     - sysfs (kernel >= 2.6.31)
>     - stripe chunk size and stripe width for DM, MD. LVM and evms on
>       old kernels
>  - libparted and fdisk are linked against libblkid
>
>  - fdisk supports 4KiB logical sector size (util-linux-ng >= 2.15
>  - fdisk supports 4KiB physical sector size (util-linux-ng >= 2.17)
>  - fdisk uses 1MiB alignment (or more if optimal I/O size is bigger)
>    and alignment_offset for all partitions in non-DOS mode
>    (util-linux-ng >= 2.17.1)
>
>  - parted supports 4KiB physical sector size
>  - parted uses 1MiB alignment for disks with unknown topology, disks
>    with topology information are aligned to optimal (or minimum) I/O
>    size (parted >= 2.1)
>
>  - EFI GPT code in the kernel has been updated to works properly with
>    4KiB sectors (kernel >= 2.6.33)
>
>  - mkfs.{ext,xfs,gfs2,ocfs2} have been update to work properly with
>    topology information, mkfs.{ext,xfs} are linked against libblkid
>    for compatibility with old kernel (for stripe chunk size / width)
>
>  - Fedora-13/RHEL6 installer uses libparted with 4KiB support
>
>  - alignment_offset & 4KiB support is planned for LUKS (cryptsetup)

Thanks for the summary, Karel.
In case anyone wants more high-level detail on the parted front,
here's its NEWS file:

    http://git.debian.org/?p=parted/parted.git;a=blob;f=NEWS

Currently, I'm not planning much for Parted, other than clean-up.
For example, I want to remove all of the FS-related code (it's
horribly bit-rotted) from the package, with the exception of
HFS/HFS+ and FAT resizing capabilities, since AFAIK, Parted
has the only free implementations.  If any of you know of other
implementations or work in progress, please let me know.


Related information, prompted by my recent encounter with a
tool that refused to let me use a GPT partition table.

Partition table formats: prefer GUID/GPT:

  Having spent more than my share of time looking at partition table
  formats recently, I am now strongly biased against DOS partition
  tables, and for GUID/GPT ones.  In addition to allowing for >2GiB
  partition offsets and lengths, GPT tables provide for better
  protection in case of corruption (checksums, backup table at end
  of disk) and don't have the anachronistic distinction of primary
  and extended/logical partitions (all partitions are "primary").
  You can even give each partition a name.  The only reason to use a
  DOS partition table on a new installation is if you're stuck with
  a requirement of using an OS like XP on bare metal.

Please consider encouraging the use of GPT partition tables...
or at least do not *dis*courage their use.
