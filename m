Return-Path: <linux-kernel-owner+w=401wt.eu-S1762694AbXGJDNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762694AbXGJDNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760045AbXGJDNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:13:25 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:32945 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762630AbXGJDNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:13:24 -0400
To: Bernhard Walle <bwalle@suse.de>
Cc: Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: Determine version of kernel that produced vmcore
In-reply-to: <20070706132814.GA7079@suse.de>
Message-Id: <20070710121315oomichi@mail.jp.nec.com>
References: <20070706132814.GA7079@suse.de>
Mime-Version: 1.0
X-Mailer: WeMail32[2.51] ID:5W0000
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Date: Tue, 10 Jul 2007 12:13:15 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Fri, 6 Jul 2007 17:58:04 +0300, Dan Aloni <da-x@monatomic.org> wrote:
> On Fri, Jul 06, 2007 at 03:28:14PM +0200, Bernhard Walle wrote:
> > Hello,
> > 
> > does anybody know a _reliable_ way to determine the version the kernel
> > that produced a vmcore file? This means not scanning for a specific
> > string or something like that which can fail on random memory.
> > 
> > Would it make sense to add a ELF PT_NOTE section in the vmcore?
> > 
> > Thanks for input!

(CONFIGFILE means makedumpfile's config file.)

makedumpfile checks kernel version by reading system_utsname.release
from /proc/vmcore, as you know. If the release and OSRELEASE in CONFIGFILE
don't match, makedumpfile fails.

Besides Dan's plan, I'm planning the change of CONFIGFILE for distributors.
In the kernel building process, distributors need to make CONFIGFILE
on an older kernel (ex. RHEL5 kernel is built on RHEL4), and OSRELEASE
may be an older kernel. So OSRELEASE should be modified to the building
kernel version by hand, but it is not smart.

To solve this problem, I'm proposing 2 plans.
Could you give me your opinion ?

Plan 1:
  A new option [--osrelease="string"] is added.
  The OSRELEASE of CONFIGFILE is overwritten by "string".
  In the kernel building process, distributors should specify "string"
  as the building kernel version.

Plan2:
  Remove the OSRELEASE from CONFIGFILE.
  Instead of checking the OSRELEASE, makedumpfile only checks whether the
  area of /proc/vmcore specified by the symbol "system_utsname" in CONFIGFILE
  is the string "2.6.". If CONFIGFILE and /proc/vmcore don't match, the
  "system_utsname" must not point to the correct area in most cases.
  Old makedumpfile needs OSRELEASE, and it cannot work by new CONFIGFILE.
  But I think there are not any problems because old makedumpfile will not
  read new CONFIGFILE. Now, CONFIGFILE is used only by RHEL5's kdump initramfs,
  the CONFIGFILE is generated during 1st-kernel running. Even if CONFIGFILE
  will be updated, makedumpfile can read the CONFIGFILE because makedumpfile
  should be updated with CONFIGFILE.


I'd like to change the name of CONFIGFILE to mkdfinfo.


Thanks
Ken'ichi Ohmichi
