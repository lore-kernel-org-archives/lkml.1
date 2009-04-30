Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbZD3IAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbZD3IAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbZD3IAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:00:21 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:48871 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750940AbZD3IAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:00:19 -0400
X-YMail-OSG: YbAPpN4VM1lj0oo_l6YGUg8.b.8nbk5cYjoVtarbBm6xfQs5bW7NPZduC3EYq4Ci7oNMQMa_7G67dI1t1QlomwNqWD0JCYj9d10MN_geqUd.mgYZK.k5se315FEe.YL6BeBGOq_M62nUcUO9apfj30f0c2uR9o0m8tZ1QEpR0wtLC_Sd_hYCEuoynSHrR4z_Yt_DH7WJq.kv88n1wBeyqDlTNGTigF93otmK8h_UM7TBV6BYtPcOjg2Hy2lbFcCywyqn7njdHurfwIjMxUaInzqHTj1g8Idcs_yu4OA5CjfhEtXFhQ--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH] [Target_Core_Mod/pSCSI]:
	Add	block/blk-map.c:blk_rq_map_kern_sg() usage
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Hannes Reinecke <hare@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vladislav Bolkhovitin <vst@vlnb.net>
In-Reply-To: <49F900F3.2060009@kernel.org>
References: <1240965782.32740.309.camel@haakon2.linux-iscsi.org>
	 <49F900F3.2060009@kernel.org>
Content-Type: text/plain
Date: Thu, 30 Apr 2009 01:00:08 -0700
Message-Id: <1241078408.32740.475.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-30 at 10:37 +0900, Tejun Heo wrote:
> Hello, Nicholas.
> 
> Nicholas A. Bellinger wrote:
> ...
> > Once Tejun's patches for block/blk-map.c:blk_rq_map_kern_sg() have
> > been included upstream, the legacy pscsi_map_task_SG() will be
> > removed and blk-map will become the preferred method for accessing
> > struct scatterlist -> struct scsi_device for SCSI target operations.
> > For now, I have created a blk-map branch in lio-core-2.6.git with
> > LINUX_USE_NEW_BLK_MAP=1 and left LINUX_USE_NEW_BLK_MAP=0 in branch
> > master.
> 
> Hmm... I don't think the patch will go in as-is although there seem to
> be some places which can make use of sg mapping interface (including
> OSD).  Currently there are following problems.
> 
> * Single kmalloc()ing the whole bio has higher chance of failing if
>   the bvec becomes very large.
> 

<nod>

> * Boaz is worried about performance implications with going back and
>   forth between sgl and bvec.

Yes, I did not think it would help performance, but it is still better
choice than NOT using struct request at all for v2.6.30..  is there
another choice atm? :-).  I am hoping to test with some non TYPE_DISK
with your code and see how it goes..

scsi_execute_async() is RIP for v2.6.30-rc3, just as struct scsi_request
went away in v2.6.18..

> 
> In longer term, I think where we should be headed is...
> 
> * Expand sgl( or t) such that 1. it uses separate list for cpu and dma
>   addresses so that it doesn't take up twice as much space
>   unnecessarily,

Hmm, interesting...


>  2. sgl's can be easily chained (alerady somewhat
>   there) and thus we don't have to worry about chaining in higher
>   layer.

<nod>

> 
> * Replace bvec with sgl in bio.
> 

Well, the target_core_mod logic assumes that each subsystem (pSCSI,
IBLOCK, FILEIO) is telling what limitiations on contigiously allocated
struct scatterlist array that has their single PAGE_SIZED struct
page_link setup from se_mem_t->se_page allocated physical memory.  As
the requirements for different Linux storage subsystems have grown for
target_core_mod logic, the concept of a 'storage object' passing
physical and/or virtual parameters for limitations of underlying
hardware via Linux subsystem is given us the default of PAGE_SIZE for
each allocated struct scatterlist in lio-core-2.6.git code.

Perhaps accepting a pre-formatted contigious array of struct scatterlist
in-place of bvec (so allocation can be avoided all together:-) from
incoming DATA I/O SG going into Linux/SCSI. The incoming sgl's into
struct request for target_core_mod/pSCSI are currently validated with
struct scsi_device provided 'physical device' parameters in the
target_core_mod esign.  These are represented in configfs for the
Linux/SCSI passthrough using your patches (and all other storage objects
and target_core_mod subsystem plugins, etc)

target:~# tree /sys/kernel/config/target/core/pscsi_0/
/sys/kernel/config/target/core/pscsi_0/
|-- hba_info
`-- sdd
    |-- alua_lu_gp
    |-- attrib
    |   |-- block_size
    |   |-- emulate_tas
    |   |-- emulate_ua_intlck_ctrl
    |   |-- hw_block_size
    |   |-- hw_max_sectors
    |   |-- hw_queue_depth
    |   |-- max_sectors
    |   |-- queue_depth
    |   `-- task_timeout
    |-- control
    |-- enable
    |-- fd
    |-- info

<SNIP>

The current target_core_mod v3.0 code allows block_size, max_sectors,
 and queue_depth to be enforced (and changed w/o active fabric module
exports to said storage object for v3.0) for IBLOCK, FILEIO, RAMDISK
plugins, but pSCSI with the blk-map patches on v2.6.30-rc3 is enforced
by the underlying struct scsi_device prefixed by hw_* values in
pscsi_0/sdd/attrib/ as expected by a kernel level target mode storage
engine.

I think for long term, there will be a need for a least three codepaths,
one in Block code, one in Linux/SCSI Target mode, and a Linux/SATA
target mode path

I) Accepting a preformatted and pre-validated (based on physical device
limitiations for struct scsi_device) into struct bio for struct request
in place of bvec allocation + memory map.  This API will expect a
contigious array of struct scatterlist containing page_links using
include/linux/scatterlist.h macros for init, link, etc.  This will allow
existing target_core_mod/pSCSI code (and others like Boaz) to take
advantage of the API.

II) A upstream SCSI kernel target infrastructure that does all of this
exforcement for you in drivers/scsi *TO* Linux/SCSI.  This would be
using the underlying logic of I) but drivers/scsi upstream code would be
doign the the validation of struct scatterlist memory into the struct
scsi_device for future and existing SCSI target code.

Then for v3.1 target_core_mod code, the idea is add configfs attributes
for each storage object to allow it control the number of passed
sg_extents and doing multiple PAGE_SIZE aligned struct scatterlists that
are passed into I) and II) above from a pre-allocated pool.  These
tunables will be added to allocate for mapping for target mode storage
fabric modules into virtually any method of struct scatterlist
allocation and mapping into Linux storage subsystems.  Doing this for
internally allocated struct pages and subsystem struct scatterlists will
be supported first, and then through using passthrough and then storage
target fabric plugin modules in v3.1 code..

III) Make target_core_mod/ConfigFS v3.x do subsystem independent target
mode and allow a generic kernel target to run on top of Linux/SCSI for
Linux/SATA physical subsystem plugins.

This means moving target_core_mod/configFS into direction of fabric
indepedent target operation so that both drivers/scsi and drivers/ata
can have access to a generic target mode kernel infrastructure.  This
would be building upon I) and II) and whatever yourself and the
Linux-ATA folks would like to do for target mode SATA ops into direct
target_core_mod/pSCSI, and virtual target_core_Mod/iBLOCK+FILEIO export.

Just a few thoughts, thanks for your comments!

--nab

> Dunno what we should do in the meantime tho.
> 
> Thanks.
> 

