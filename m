Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0CHDtW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 22:49:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:57208 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab0CHDtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 22:49:14 -0500
Message-ID: <4B947393.2050002@kernel.org>
Date: Mon, 08 Mar 2010 12:48:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: ATA 4 KiB sector issues.
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 08 Mar 2010 03:48:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

It looks like transition to ATA 4k drives will be quite painful and we
aren't really ready although these drives are already selling widely.
I've written up a summary document on the issue to clarify stuff as
it's getting more and more confusing and develop some consensus.  It's
also on the linux ata wiki.

  http://ata.wiki.kernel.org/index.php/ATA_4_KiB_sector_issues

I've cc'd people whom I can think of off the top of my head but I
surely have missed some people who would have been interested.  Please
feel free to add cc's or forward the message to other MLs.
Especially, I don't know much about partitioners so the details there
are pretty shallow and could be plain wrong.  It would be great if
someone who knows more about this stuff can chime in.

Thanks.

=== Document follows ===

ATA 4 KiB sector issues

Background
==========

Up until recently, all ATA hard drives have been organized in 512 byte
sectors.  For example, my 500 GB or 477 GiB hard drive is organized of
976773168 512 byte sectors numbered from 0 to 976773167.  This is how
a drive communicates with the driver.  When the operating system wants
to read 32 KiB of data at 1 MiB position, the driver asks the drive to
read 64 sectors from LBA (Logical block address, sector number) 2048.

Because each sector should be addressable, readable and writable
individually, the physical medium also is organized in the same sized
sectors.  In addition to the area to store the actual data, each
sector requires extra space for book keeping - inter-sector space to
enable locating and addressing each sector and ECC data to detect and
correct inevitable raw data errors.

As the densities and capacities of hard drives keep growing, stronger
ECC becomes necessary to guarantee acceptable level of data integrity
increasing the space overhead.  In addition, in most applications,
hard drives are now accessed in units of at least 8 sectors or 4096
bytes and maintaining 512 byte granularity has become somewhat
meaningless.

This reached a point where enlarging the sector size to 4096 bytes
would yield measurably more usable space given the same raw data
storage size and hard drive manufacturers are transitioning to 4 KiB
sectors.

Anandtech has a good article which illustrates the background and
issues with pretty diagrams[1].


Physical vs. Logical
====================

Because the 512 byte sector size has been around for a very long time
and upto ATA/ATAPI-7 the sector size was fixed at 512 bytes, the
sector size assumption is scattered across all the layers -
controllers or bridge chips snooping commands, BIOSs, boot codes,
drivers, partitioners and system utilities, which makes it very
difficult to change the sector size from 512 byte without breaking
backward compatibility massively.

As a workaround, the concept of logical sector size was introduced.
The physical medium is organized in 4 KiB sectors but the firmware on
the drive will present it as if the drive is composed of 512 byte
sectors thus making the drive behave as before, so if the driver asks
the hard drive to read 64 sectors from LBA 2048, the firmware will
translate it and read 8 4 KiB sectors from hardware sector 256.  As a
result, the hard drive now has two sector sizes - the physical one
which the physical media is actually organized in, and the logical one
which the firmware presents to the outside world.

A straight forward example mapping between physical sector and LBA
would be

  LBA = 8 * phys_sect


Alignment problem on 4 KiB physical / 512 logical drives
=======================================================

This workaround keeps older hardware and software working while
allowing the drive to use larger sector size internally.  However, the
discrepancy between physical and logical sector sizes creates an
alignment issue.  For example, if the driver wants to read 7 sectors
from LBA 2047, the firmware has to read hardware sector 255 and 256
and trim leading 7*512 bytes and tailing 512 bytes.

For reads, this isn't an issue as drives read in larger chunks anyway
but for writes, the drive has to do read-modify-write to achieve the
requested action.  It has to first read hardware sector 255 and 256,
update requested parts and then write back those sectors which can
cause significant performance degradation[2].

The problem is aggravated by the way DOS partitions[3] have been laid
out traditionally.  For reasons dating back more than two decades,
they are laid out considering something called disk geometry which
nowadays are arbitrary values with a number of restrictions for
backward compatibility accumulated over the years.  The end result is
that until recently (most Linux variants and upto Windows XP) the
first partition ends up on sector 63 and later ones on cylinder
boundaries where each cylinder usually is composed of 255 * 63
sectors.

Most modern filesystems generate 4 KiB aligned accesses from the
partition it is in.  If a drive maps 4 KiB physical sectors to 512
byte logical sectors from LBA0, the filesystem in the first partition
will always be misaligned and filesystems in later partitions are
likely to be misaligned too.


Solving the alignment problem on 4 KiB physical / 512 logical drives
====================================================================

There are multiple ways which attempt to solve the problem.

S-1. Yet another workaround from the firmware - offset-by-one.

  Yet another workaround which can be done by the firmware is to
  offset physical to logical mapping by one logical sector such that
  LBA 63 ends up on physical sector boundary, which aligns the first
  partition to physical sectors without requiring any software update.
  The example mapping between phys_sector and LBA becomes

    LBA = 8 * phys_sect - 1

  The leading 512 bytes from phys_sect 0 is not used and LBA 0 starts
  from after that point.  phys_sect 1 maps to LBA 7 and phys_sect 8 to
  63, making LBA 63 aligned on hardware sector.

  Although this aligns only the first partition, for many use cases,
  especially the ones involving older software, this workaround was
  deemed useful and some recent drives with 4 KiB physical sectors are
  equipped with a dip switch to turn on or off offset-by-one mapping.

S-2. The proper solution.

  Correct alignments for all partitions can't be achieved by the
  firmware alone.  The system utilities should be informed about the
  alignment requirements and align partitions accordingly.

  The above firmware workaround complicates the situation because the
  two different configurations require different offsets to achieve
  the correct alignments.  ATA/ATAPI-8 specifies a way for a drive to
  export the physical and logical sector sizes and the LBA offset
  which is aligned to the physical sectors.

  In Linux, these parameters are exported via the following sysfs
  nodes.

    physical sector size	: /sys/block/sdX/queue/physical_block_size
    logical sector size		: /sys/block/sdX/queue/logical_block_size
    alignment offset		: /sys/block/sdX/alignment_offset

  Let the physical sector size be PSS, logical sector size LSS and
  alignment offset AOFF.  The system software should place partitions
  such that the starting LBAs of all partitions are aligned on

    (n * PSS + AOFF) / LSS

  For 4 KiB physical sector offset-by-one drives, PSS is 4096, LSS 512
  and AOFF 3584 and with n of 7 the above becomes,

    (7 * 4096 + 3584) / 512 == 63

  making sector 63 an aligned LBA where the first partition can be
  put, but without the offset-by-one mapping, AOFF is zero and LBA 63
  is not aligned.

  With the above new alignment requirement in place, it becomes
  difficult to honor the legacy one - first partition on sector 63 and
  all other partitions on cylinder boundary (255 * 63 sectors) - as
  the two alignment requirements contradict each other.  This might be
  worked around by adjusting how LBA and CHS addresses are mapped but
  the disk geometry parameters are hard coded everywhere and there is
  no reliable way to communicate custom geometry parameters.


Complications
=============

Unfortunately, there are complications.

C-1. The standard is not and won't be followed as-is.

  Some of the existing BIOSs and/or drivers can't cope with drives
  which report 4 KiB physical sector size.  To work around this, some
  drive models lie that its physical sector size is 512 bytes when the
  actual configuration is 4 KiB without offsetting.

  This nullifies the provisions for alignment in the ATA standard but
  results in the correct alignment for Windows Vista and 7.  OS
  behaviors will be described further later.

  For these drives, which are likely to continue to be shipped for the
  foreseeable future, traditional LBA 63 and cylinder based aligning
  results in misalignment.

C-2. Windows XP depends on the traditional partition layout.

  Windows XP makes use of the CHS start/end addresses in the partition
  table and gets confused if partitions are not laid out
  traditionally.  This means that XP can't be installed into a
  partition prepared by later versions of Windows[4].  This isn't a
  big problem for Windows because in most cases the later version is
  replacing the older one, not the other way around.

  Unfortunately, the situation is more complex for Linux because Linux
  is often co-installed with various versions of Windows and XP is
  still quite popular.  This means that when a Linux partitioner is
  used to prepare a partition which may be used by Windows, the
  partitioner might have to consider which version of Windows is going
  to be used and whether to align the partitions for the correct
  alignment or compatibility with older versions of Windows.

C-3. The 2 TiB barrier and the possibility for 4 KiB logical sector size.

  The DOS partition format uses 32 bit for the starting LBA and the
  number of sectors and, reportedly, 32 bit Windows XP shares the
  limitation.  With 32 bit addressing and 512 byte logical sector
  size, the maximum addressable sector + 1 is at

    2^32 * 2^9 == 2^41 == 2 TiB

  The DOS partition format allows a partition to reach beyond 2 TiB as
  long as the starting LBA is under 2 TiB; however, both Windows XP
  and and the Linux kernel (at least upto v2.6.33) refuse such
  partition configurations.

  With the right combination of host controller, BIOS and driver, this
  barrier can be overcome by enlarging the logical sector size to 4
  KiB, which will push the barrier out to 16 TiB.  On the right
  configuration, Windows XP is reportedly able to address beyond the 2
  TiB barrier with a DOS partition and 4 KiB logical sector size.
  Linux kernel upto v2.6.33 doesn't work under such configurations but
  a patch to make it work is pending[5].

  This might also be beneficial for operating systems which don't
  suffer from this limitation.  A different partition format - GPT[6]
  - should be used beyond 2^32 sectors, which could harm compatibility
  with older BIOSs or other operating systems which don't recognize
  the new format.

  As mentioned previously, 512 byte sector assumption has been there
  for a very long time and changing it is likely to cause various
  compatibility problems at many different layers from hardware up to
  the system utilities.


Windows
=======

As hard drive vendors aim for performance and compatibility in modern
Windows environments, it is worthwhile to investigate how Windows
partitions with different alignment requirements.  Up until Windows
XP, it followed the traditional layout - the first partition on LBA 63
and the others on cylinder boundaries where a cylinder is defined as
255 tracks with 63 sectors each.

Windows Vista and 7 align partitions differently.  As the two behave
similarly, only 7's behavior is shown here.  These partition tables
are created by Windows 7 RC installer on blank disks.

W-1. 512 byte physical and logical sector drive.

  ST FIRST  T  LAST   LBA      NBLKS
  80 202100 07 df130c 00080000 00200300
  00 df140c 07 feffff 00280300 00689e12
  00 000000 00 000000 00000000 00000000
  00 000000 00 000000 00000000 00000000

  Part0:	FIRST	C    0	H   32	S   33	: 2048		(63 sec/trk)
		LAST	C   12	H  223	S   19	: 206847	(255 heads/cyl)
		LBA	2048 + 204800 = 206848

  Part1:	FIRST	C   12	H  223	S   20	: 206848
		LAST	C 1023	H  254	S   63	: E
		LBA	206848 + 312371200 = 312578048

  Both aligned at (2048 * n).  Part 1 not aligned to cylinder.

W-2. 4 KiB physical and 512 byte logical sector drive without offset-by-one.

  ST FIRST  T  LAST   LBA      NBLKS
  80 202100 07 df130c 00080000 00200300
  00 df140c 07 feffff 00280300 00b83f25
  00 000000 00 000000 00000000 00000000
  00 000000 00 000000 00000000 00000000

  Part0:	FIRST	C    0	H   32	S   33	: 2048		(63 sec/trk)
		LAST	C   12	H  223	S   19	: 206847	(255 heads/cyl)
		LBA	2048 + 204800 = 206848

  Part1:	FIRST	C   12	H  223	S   20	: 206848
		LAST	C 1023	H  254	S   63	: E
		LBA	206848 + 624932864 = 625139712

  Both aligned at (2048 * n).  Part 1 not aligned to cylinder.

W-3. 4 KiB physical and 512 byte logical sector drive with offset-by-one.

  ST FIRST  T  LAST   LBA      NBLKS
  80 202800 07 df130c 07080000 f91f0300
  00 df1b0c 07 feffff 07280300 f9376d74
  00 000000 00 000000 00000000 00000000
  00 000000 00 000000 00000000 00000000

  Part0:	FIRST	C    0	H   32	S   40	: 2055		(63 sec/trk)
		LAST	C   12	H  223	S   19	: 206847	(255 heads/cyl)
		LBA	2055 + 204793 = 206848

  Part1:	FIRST	C   12	H  223	S   27	: 206855
		LAST	C 1023	H  254	S   63	: E
		LBA	206855 + 1953314809 = 1953521664

  Both aligned at (2048 * n + 7).  Part 1 not aligned to cylinder.

The partitioner seems to be using 1M as the basic alignment unit and
offsetting from there if explicitly requested by the drive and there
is no difference between handling of 512 byte and 4 KiB drives, which
explains why C-1 works for hard drive vendors.

In all cases, the partitioner ignores both the first partition on LBA
63 and the others on cylinder boundary requirements while still using
the same 255*63 cylinder size.  Also, note that in W-3, both part 0
and 1 end up with odd number of sectors.  It seems that they simply
decided to completely break away from the traditional layout, which is
understandable given that there really isn't one good solution which
can cover all the cases and that the default larger alignment benefits
earlier SSDs.

Windows Vista basically shows the same behavior.  Vista was tested by
creating two partitions using the management tool.  Test data is
available at [7].

  *-alignment_offset	: alignment_offset reported by Linux kernel
  *-fdisk		: fdisk -l output
  *-fdisk-u		: fdisk -lu output
  *-hdparm		: hdparm -I output
  *-mbr			: dump of mbr
  *-part		: decoded partition table from mbr

Please note that hdparm is misreporting the alignment offset.  It
should be reporting 512 instead of 256 for offset-by-one drives.


So, what now for Linux?
=======================

The situation is not easy.  Considering all the factors, the only
workable solution looks like doing what Windows is doing.  Hard drive
and SSD vendors are focusing on compatibility and performance on
recent Windows releases and are happy to do things which break the
standard defined mechanism as shown by C-1, so parting away from what
Windows does would be unnecessarily painful.

Unfortunately, while Windows can assume that newer releases won't
share the hard drive with older releases including Windows XP, Linux
distros can't do that.  There will be many installations where a
modern Linux distros share a hard drive with older releases of
Windows.  At this point, I can't see a silver bullet solution.

Partitioners maybe should only align partitions which will be used by
Linux and default to the traditional layout for others while allowing
explicit override.  I think Windows XP wouldn't have problem with
differently aligned partitions as long as it doesn't actually use them
but haven't tested it.

Reportedly, commonly used partitioners aren't ready to handle drives
larger than 2 TiB in any configuration and alignment isn't done
properly for drives with 4 KiB physical sectors.  4 KiB logical sector
support is broken in both the kernel and partitioners.  (need more
details and probably a whole section on partitioner behaviors)

Unfortunately, the transition to 4 KiB sector size, physical only or
logical too, is looking fairly ugly.  Hopefully, a reasonable solution
can be reached in not too distant future but even with all the
software side updated, it looks like it's gonna cause significant
amount of confusion and frustration.


[1] http://www.anandtech.com/storage/showdoc.aspx?i=3691
[2] http://www.osnews.com/story/22872/Linux_Not_Fully_Prepared_for_4096-Byte_Sector_Hard_Drives
[3] http://en.wikipedia.org/wiki/Master_boot_record
[4] http://support.microsoft.com/kb/931760
[5] http://thread.gmane.org/gmane.linux.kernel/953981
[6] http://en.wikipedia.org/wiki/GUID_Partition_Table
[7] http://userweb.kernel.org/~tj/partalign/

* Mar 04 2009
	Initial draft, Tejun Heo <tj@kernel.org>
* Mar 08 2009
	Updated according to comments from Daniel Taylor
	<Daniel.Taylor@wdc.com>.  Other minor updates.
