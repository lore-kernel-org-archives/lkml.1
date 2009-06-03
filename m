Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbZFCPUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbZFCPUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756762AbZFCPUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:20:40 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:33083 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbZFCPUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:20:40 -0400
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
 ZERO_SIZE_PTR to point at unmapped space)
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "Larry H." <research@subreption.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, pageexec@freemail.hu
In-Reply-To: <alpine.DEB.1.10.0906031047390.15621@gentwo.org>
References: <20090530192829.GK6535@oblivion.subreption.com>
	 <alpine.LFD.2.01.0905301528540.3435@localhost.localdomain>
	 <20090530230022.GO6535@oblivion.subreption.com>
	 <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain>
	 <20090531022158.GA9033@oblivion.subreption.com>
	 <alpine.DEB.1.10.0906021130410.23962@gentwo.org>
	 <20090602203405.GC6701@oblivion.subreption.com>
	 <alpine.DEB.1.10.0906031047390.15621@gentwo.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 03 Jun 2009 11:11:54 -0400
Message-Id: <1244041914.12272.64.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-03 at 10:50 -0400, Christoph Lameter wrote:
> On Tue, 2 Jun 2009, Larry H. wrote:
> 
> > Why would mmap_min_addr have been created in first place, if NULL can't
> > be mapped to force the kernel into accessing userland memory? This is
> > the way a long list of public and private kernel exploits have worked to
> > elevate privileges, and disable SELinux/LSMs atomically, too.
> >
> > Take a look at these:
> > http://www.grsecurity.net/~spender/exploit.tgz (disables LSMs)
> > http://milw0rm.com/exploits/4172
> > http://milw0rm.com/exploits/3587
> >
> > I would like to know what makes you think I can't mmap(0) from within
> > the same process that triggers your 'not so exploitable NULL page
> > fault', which instead of generating the oops will lead to 100% reliable,
> > cross-arch exploitation to get root privileges (again, after disabling
> > SELinux and anything else that would supposedly prevent this situation).
> > Or leaked memory, like a kmalloc(0) situation will most likely lead to,
> > given the current circumstances.
> 
> Ok. So what we need to do is stop this toying around with remapping of
> page 0. The following patch contains a fix and a test program that
> demonstrates the issue.
> 
> 
> Subject: [Security] Do not allow remapping of page 0 via MAP_FIXED
> 
> If one remaps page 0 then the kernel checks for NULL pointers of various
> flavors are bypassed and this may be exploited in various creative ways
> to transfer data from kernel space to user space.
> 
> Fix this by not allowing the remapping of page 0. Return -EINVAL if
> such a mapping is attempted.

You can already prevent unauthorized processes from mapping low memory
via the existing mmap_min_addr setting, configurable via
SECURITY_DEFAULT_MMAP_MIN_ADDR or /proc/sys/vm/mmap_min_addr.  Then
cap_file_mmap() or selinux_file_mmap() will apply a check when a process
attempts to map memory below that address.

-- 
Stephen Smalley
National Security Agency

