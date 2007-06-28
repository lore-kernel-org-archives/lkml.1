Return-Path: <linux-kernel-owner+w=401wt.eu-S1764416AbXF1I2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764416AbXF1I2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 04:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761138AbXF1I2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 04:28:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46295 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762002AbXF1I2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 04:28:10 -0400
Date: Thu, 28 Jun 2007 01:27:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       James Morris <jmorris@namei.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] ICH Force HPET: Make generic time capable of
 switching broadcast timer
Message-Id: <20070628012749.caf450f6.akpm@linux-foundation.org>
In-Reply-To: <20070628001221.364438ce.akpm@linux-foundation.org>
References: <20070622203822.GA22807@linux-os.sc.intel.com>
	<20070628001221.364438ce.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 00:12:21 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> I can't start the X server any more, but that's probably unrelated ;)
> 
> <goes back to yet another bisection search.  sigh.  you guys have
> me hopelessly outnumbered>

And the winner of the u-o-akpm-1-hour-of-his-life-back award (and the bonus
u-delayed-next-mm-by-a-day award!) is ....  git-selinux.patch!

(II) Loading /usr/lib/xorg/modules/libvgahw.so
(II) Module vgahw: vendor="X.Org Foundation"
        compiled for 7.0.0, module version = 0.1.0
        ABI class: X.Org Video Driver, version 0.8
(**) I810(0): Depth 24, (--) framebuffer bpp 32
(==) I810(0): RGB weight 888
(==) I810(0): Default visual is TrueColor
(II) Loading sub module "int10"
(II) LoadModule: "int10"
(II) Reloading /usr/lib/xorg/modules/libint10.so
(II) I810(0): initializing int10
(EE) I810(0): Cannot shmat() low memory
(EE) I810(0): shmat(low_mem) error: Invalid argument
(EE) I810(0): VBE initialization failed.

Due to

commit fe276418917d00e6f7ecab2efa8331dd86db2f3f
Author: Eric Paris <eparis@redhat.com>
Date:   Wed Jun 6 02:30:33 2007 -0400

    security: Protection for exploiting null dereference using mmap
    
    Add a new security check on mmap operations to see if the user is attempting
    to mmap to low area of the address space.  The amount of space protected is
    indicated by the new proc tunable /proc/sys/kernel/mmap_min_addr and
    defaults to 0, preserving existing behavior.
    
    This patch uses a new SELinux security class "memprotect."  Policy already
    contains a number of allow rules like a_t self:process * (unconfined_t being
    one of them) which mean that putting this check in the process class (its
    best current fit) would make it useless as all user processes, which we also
    want to protect against, would be allowed. By taking the memprotect name of
    the new class it will also make it possible for us to move some of the other
    memory protect permissions out of 'process' and into the new class next time
    we bump the policy version number (which I also think is a good future idea)
    
    Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
    Signed-off-by: Eric Paris <eparis@redhat.com>
    Signed-off-by: James Morris <jmorris@namei.org>

and yes, setting /proc/sys/kernel/mmap_min_addr to zero does fix it. 
(Shouldn't this be in /proc/sys/vm?)

My fix:

--- a/security/selinux/hooks.c~git-selinux-disable-mmap_min_addr-by-default
+++ a/security/selinux/hooks.c
@@ -4917,15 +4917,6 @@ static __init int selinux_init(void)
 					    sizeof(struct inode_security_struct),
 					    0, SLAB_PANIC, NULL, NULL);
 
-	/*
-	 * Tasks cannot mmap below this without the mmap_zero permission.
-	 * If not enabled already, do so by setting it to 64KB.
-	 */
-	if (mmap_min_addr == 0) {
-		enabled_mmap_min_addr = 1;
-		mmap_min_addr = 65536;
-	}
-
 	avc_init();
 
 	original_ops = secondary_ops = security_ops;
_

although perhaps we should permit suitably-privileged apps (ie: X) to
override this instead.

