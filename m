Return-Path: <linux-kernel-owner+w=401wt.eu-S1763557AbXJRJQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763557AbXJRJQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 05:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760867AbXJRJQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 05:16:49 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:41259 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbXJRJQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:16:48 -0400
To: Simon Horman <horms@verge.net.au>
Cc: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>,
       Don Zickus <dzickus@redhat.com>, Neil Horman <nhorman@redhat.com>,
       Dan Aloni <da-x@monatomic.org>, Bernhard Walle <bwalle@suse.de>,
       kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] [kexec-tools] Pass vmcoreinfo's address and size
Reply-To: tachibana@mxm.nes.nec.co.jp
In-reply-to: <20071018053739.GA31244@verge.net.au>
Message-Id: <20071018181407tachibana@mail.jp.nec.com>
References: <20071018053739.GA31244@verge.net.au>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:5W0000
From: tachibana@mxm.nes.nec.co.jp
Date: Thu, 18 Oct 2007 18:14:07 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Simon,

On Thu, 18 Oct 2007 14:37:41 +0900, Simon Horman <horms@verge.net.au> wrote:
> On Wed, Oct 17, 2007 at 02:16:19PM +0900, Ken'ichi Ohmichi wrote:
> > 
> > Hi Simon,
> > 
> > Simon Horman wrote:
> > > On Wed, Aug 22, 2007 at 09:13:39PM +0900, Ken'ichi Ohmichi wrote:
> > >> [2/3] [kexec-tools] Pass vmcoreinfo's address and size
> > >> The patch is for kexec-tools-testing-20070330.
> > >> (http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/)
> > >> kexec command gets the address and size of the vmcoreinfo data from
> > >> /sys/kernel/vmcoreinfo, and passes them to the second kernel through
> > >> ELF header of /proc/vmcore. When the second kernel is booting, the
> > >> kernel gets them from the ELF header and creates vmcoreinfo's PT_NOTE
> > >> segment into /proc/vmcore.
> > > 
> > > Sorry for the long delay, I completely missed this patch.
> > > 
> > > The kexec-tools change seems ok to me. What is the status of
> > > the kernel portion of the change?
> > 
> > The kernel portion is merged into linux-2.6.23-mm1.
> > According to Andrew's mail "-mm merge plans for 2.6.24",  its status is
> > "The infamous misc.  Will re-review and will merge basically all of them".
> > 
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0710.0/0313.html
> > 
> > 
> > > Do you still want the kexec-tools portion applied?
> > 
> > Yes, I hope so.
> 
> Thanks, applied :-)

Thank you for applying ;-)

But it has the compatibility problem that the kexec command fails on
kernels which don't have /sys/kernel/vmcoreinfo:

 # ls /sys/kernel/
 debug  kexec_crash_loaded  kexec_loaded  security  uevent_helper 
 uevent_seqnum
 #
 (There is not /sys/kernel/vmcoreinfo.)

 #
 # kexec -p --args-linux vmlinuz --initrd=initrd.img
 Could not open "/sys/kernel/vmcoreinfo": No such file or directory
 #

To fix the problem, could you please apply the attached patch ?
The fixed part is the same as the patch in the following mail.

To: kexec-ml <kexec@lists.infradead.org>
Subject: [PATCH 2/2] [kexec-tools] Pass vmcoreinfo's address and size #2
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Date: Fri, 7 Sep 2007 18:10:02 +0900


Thanks
tachibana

---
diff -rpuN a/kexec/crashdump.c b/kexec/crashdump.c
--- a/kexec/crashdump.c	2007-10-18 15:20:56.000000000 +0900
+++ b/kexec/crashdump.c	2007-10-18 15:22:21.000000000 +0900
@@ -122,12 +122,8 @@ int get_kernel_vmcoreinfo(uint64_t *addr
 	*len = 0;
 
 	sprintf(kdump_info, "/sys/kernel/vmcoreinfo");
-	fp = fopen(kdump_info, "r");
-	if (!fp) {
-		die("Could not open \"%s\": %s\n", kdump_info,
-		    strerror(errno));
-		return -1;
-	}
+	if (!(fp = fopen(kdump_info, "r")))
+		return 0;
 
 	if (!fgets(line, sizeof(line), fp))
 		die("Cannot parse %s: %s\n", kdump_info, strerror(errno));
_

