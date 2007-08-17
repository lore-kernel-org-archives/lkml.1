Return-Path: <linux-kernel-owner+w=401wt.eu-S1765786AbXHQQMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765786AbXHQQMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765452AbXHQQMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:12:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48076 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758310AbXHQQMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:12:14 -0400
Message-ID: <46C5C8C4.4060407@zytor.com>
Date: Fri, 17 Aug 2007 09:11:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
References: <1186990219.22431.37.camel@caritas-dev.intel.com>	 <20070815154245.500c572c.akpm@linux-foundation.org>	 <1187250664.15063.0.camel@caritas-dev.intel.com> <46C45B22.5090701@suse.de> <1187313920.28497.1.camel@caritas-dev.intel.com>
In-Reply-To: <1187313920.28497.1.camel@caritas-dev.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
>>
>> Has the zero page documentation and version numbering project
>> made any progress? I think we cannot merge this without at least
>> the version number
> 

More than that.  You need to be able to boot a 32-bit kernel on a 64-bit
system, so anything that breaks that is a nonstarter.  Of course, if EFI
itself inherently breaks that, then, well, that's just another reason to
avoid EFI like the plague, but I can't think that even EFI is that broken.

> OK, I will work on the zero page documentation and version numbering
> project.

There already is documentation (Documentation/i386/zero-page.txt); as
far as version numbering, that means sticking in a field with a number,
and adding a magic number (since there isn't anything that guarantees
that fields are otherwise zero.)

Anything that conforms to the updated standard should guarantee
undefined fields are zero.

However, we also have an immediate need to define how to grow past 4K,
and if we're going to have a major revision in mechanism I would like to
see that happen now.

I propose that, in addition to the aforementioned version number and
magic fields, we add a pointer, which should be the last pointer added
that doesn't point into I/O space or reserved memory (i.e. memory that
is off limit anyway for the operating system.)

This pointer should point to a linked list of suggested form:

struct setup_data {
	u64 next;
	u32 type;
	u32 len;
	u8 data[];
};

This can thus encapsulate large objects as necessary, and the early
kernel entry can linearize them if it needs to move them out of the way.
 Better yet, this information can be made available to sysfs for
debuggability, and/or use by kexec.

I haven't heard anything from the kexec people on this, and they are the
main users of the PM entrypoint as far as I can tell.

Also, is there a maintainer for 32-bit EFI?

	-hpa


	-hpa
