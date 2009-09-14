Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbZINTZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbZINTZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 15:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbZINTZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 15:25:20 -0400
Received: from BACHE.ECE.CMU.EDU ([128.2.129.23]:64068 "EHLO bache.ece.cmu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983AbZINTZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 15:25:19 -0400
Message-ID: <4AAE981D.2020809@cmu.edu>
Date: Mon, 14 Sep 2009 15:23:09 -0400
From: "Jonathan M. McCune" <jonmccune@cmu.edu>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Rajiv Andrade <srajiv@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, jbeulich@novell.com, jmorris@namei.org,
       tpmdd-devel@lists.sourceforge.net, m.selhorst@sirrix.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>, Reiner Sailer <sailer@us.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH] TPM: Fixup pubek sysfs file
References: <20090904045231.GW4973@obsidianresearch.com> <adaab1bnvz3.fsf@cisco.com> <20090904140325.c592289a.akpm@linux-foundation.org> <20090904212316.GZ406@obsidianresearch.com> <17754_1252731784_n8C533ou010944_20090911162837.GC17677@kroah.com> <4AAE84EA.8010109@cmu.edu> <1252953279.9372.229.camel@blackbox> <20090914184336.GC25981@obsidianresearch.com>
In-Reply-To: <20090914184336.GC25981@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inline...

Jason Gunthorpe wrote:
> On Mon, Sep 14, 2009 at 03:34:39PM -0300, Rajiv Andrade wrote:
> 
>>> Thus, fixing the one-item-per-file issues seems reasonable to me. For 
>>> example, changing /sys/devices/platform/tpm_tis/pcrs from a single
>>> multi-entry file to a directory containing files named 0-15 or 0-23 that
>>> each then contain only the relevant 20-byte value seems quite
>>> reasonable. (Today's TPMs contain either 16 or 24 PCRs but future ones
>>> could contain many more.)
> 
>> The number of PCRs of a particular TPM can be retrieved sending it the
>> TPM_GetCapability command, so it's feasible to build this directory
>> structure dynamically (chip independent).
> 
> I think as we've seen, keeping the sysfs stuff working has a real
> cost. So that should be balanced with an actual need. Further, talking
> to the TPM and handling all the parsing properly is a huge complex
> pain, it would be better to have this code gone completely.

The "talking to the TPM" code is indeed somewhat complex, but see my 
comments below regarding IMA (*).

> Can anyone think of a reason why the PCRs should be accessed from
> sysfs? I can't. They are only really useful in connection with other
> complex TPM operations. Userspace can fully access them using the
> relevant TPM calls.

Fair enough, though they are useful in combination with IMA and as a 
sanity check that the driver is working correctly.

> The pubek should definately go, it is useless in 99% of cases.

Seconded.

> The caps file should be split up into 'manufacturer' 'tcg_version'
> (please include the spec rev too!!) and maybe 'firmware_version'. This
> would at least be useful to udev.

Seems reasonable.

* IBM's "Integrity Measurement Architecture (IMA)" is part of the Linux 
kernel as of v2.6.30 (linux-ima.sourceforge.net).  See 
security/integrity/ima/*.  This mechanism can make use of the TPM.  I've 
copied Reiner Sailer, one of the developers of IMA.

IMA can leverage the ability to read and extend PCRs, and its security 
properties derive from that functionality being a part of the kernel. 
PCR reading is currently part of the TPM driver in drivers/char/tpm/tpm.c.

Thus, to the question, "Can we remove the ability of the kernel to send 
TPM commands such as GetCapability and PCRRead?" I believe the answer is 
no. Or at least, not without causing a lot of work for the IMA system. 
Although it may be worth discussing whether this functionality should be 
moved from the driver into IMA.

To the question, "Can we remove the sysfs entries relating to PCRs and 
pubek," I believe the answer is yes, if the resulting complexity 
reduction actually turns out to be significant.

Regards,
-Jon
