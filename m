Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbZJVMI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbZJVMI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbZJVMI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:08:28 -0400
Received: from fmmailgate07.web.de ([217.72.192.248]:34461 "EHLO
	fmmailgate07.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbZJVMI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:08:28 -0400
Date: Thu, 22 Oct 2009 14:08:31 +0200
Message-Id: <1395763521@web.de>
MIME-Version: 1.0
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Jan Beulich <JBeulich@novell.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Robert Hancock <hancockrwd@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Thomas Hellstrom <thellstrom@vmware.com>, Tejun Heo <tj@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "x86@kernel.org" <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>
Subject: =?iso-8859-15?Q?Re:_[RFC_Patch]_use_MTRR_for_write_combining_if_PAT_is?=
 =?iso-8859-15?Q?_not_available?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18UF+WVu5YxcpVM+LwH38u9tkBh4f4DQJw+ybJULuklqCfqd
 u6BC+7X8Ur99BppLPwYrRzfJderXGNe8HsOOPbWyLxm3uqxtiHaqxgHprnOL
 A==
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Wed, 2009-10-21 at 13:01 -0700, Thomas Schlichter wrote:
> > OK, so I think the attached patches should do it. Hopefully I have addressed 
> > all your comments.
> 
> Thomas,
> 
> I have couple of issues with this patchset still. pci_mmap_page_range()
> doesn't get called for each fork(). So, we won't be ref counting the
> mtrr usage properly.

When forking, what happens with the "struct file"? If it is being copied, then the
processes share the same private data which would be freed during the first
release(). I think this would be a problem whereever file-private data are used.

So I think it must be shared between the forked processes and some reference
counting must exist. This reference counting must ensure that release() is only
called when all processes did close() their file.

And in that case (shared "struct file", one single release() call in the end) this
implementation should be completely safe...

> I need to think a bit more carefully on this. Can I get back to you
> early next week on this, as I am traveling and need to think through
> this?

Of course you can. But as I do this just in my spare time, I can only work on this
in the evenings...

> We already keep track of some of the PAT ref counting using
> track_pfn_vma_copy(). And we need to extend/use something similar here.
> 
> Even if we need to extend sysfs or pci vma ops, we need to increment and
> decrement the ref count of the mtrr register that gets used.

The MTRR register ref count is already incremented with each mtrr_add() or
mtrr_add_page() that has the "increment" parameter set to true. Which is the
case in my implementation.

> There is no need to go through num_var_ranges etc.

Well I have to remember wich file added which MTRR entries. Because I have
to remove them if the file is being closed. Therefore I need an array of size
"num_var_ranges" (or MTRR_MAX_VAR_RANGES which is the uper bound).

Btw. if there really is a problem in my reference counting code, it also exists in
the current code in:
  arch/x86/kernel/cpu/mtrr/if.c

My patch borrows its ref-counting parts from there...

Kind regards,
  Thomas
