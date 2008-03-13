Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYCMAGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYCMAGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 20:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYCMAGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 20:06:43 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51479 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbYCMAGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 20:06:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	<20080311211004.GA30164@redhat.com>
	<1205272758.7990.37.camel@nigel-laptop>
	<1205288074.29875.22.camel@caritas-dev.intel.com>
	<20080312185356.GD13549@redhat.com>
Date: Wed, 12 Mar 2008 18:01:16 -0600
In-Reply-To: <20080312185356.GD13549@redhat.com> (Vivek Goyal's message of
	"Wed, 12 Mar 2008 14:53:56 -0400")
Message-ID: <m1myp3xzjn.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Yes. But this memory gets reserved at loading time and then this memory
> remains unused for the whole duration (except hibernation).
>
> In the example you gave, looks like you are reserving 15MB of memory for
> second kernel. In practice, we we finding it difficult to boot a regular
> kernel in 16MB of memory in kdump. We are now reserving 128MB of memory
> for kdump kernel on x86 arch, otheriwse OOM kill kicks in during init
> or while core is being copied.

Sounds like something we may want to fix.  Living at the default kernel
address may alieviate that problem somewhat.

> Kexec based hibernation does not look any different than kdump in terms
> of memory requirements. The only difference seems to be that kdump does
> the contiguous memory reservation at boot time and kexec based hibernation
> does the memory reservation at kernel loading time.
>
> The only difference I can think of is, kdump will generally run on servers
> and hibernation will be required on desktops/laptops and run time memory
> requirements might be little different. I don't have numbers though.
>
> At the same time carrying a separate kernel binary just for hibernation
> purposes does not sound very good.

One difference is you only get the memory penalty just before you hibernate,
instead of continuously.  So potentially you could swap out things to
make run for the kernel to save you to disk.

> [..]
>> > 3. Usability.
>> > 
>> > Right now, kexec based hibernation looks quite complicated to configure,
>> > and the user is apparently going to have to remember to boot a different
>> > kernel or at least a different bootloader entry in order to resume. Not
>> 
>> No, the newest implementation need not to boot a different kernel or
>> different bootloader entry. You just use one bootloader entry, it will
>> resume if there's an image, booting normally if there's not. You can
>> look at the newest hibernation example description.
>> 
>
> Following is the step from new method you have given.
>
> 7. Boot kernel compiled in step 1 (kernel C). Use the rootfs.gz as
>    root file system.
>
> This mentions that use rootfs.gz as initrd. Without modifying the boot
> loader entry, how would I switch the initrd dynamically.
>
> Looks like it might be a typo. So basically we can just boot back into
> normal kernel and then a user can load the resumable core file and kexec
> to it?
>
> I think all this functionality can be packed into normal initrd itself
> to make user interface better.
>
> A user can configure the destination for hibernated image at system
> installation time and initrd will be modified accordingly to save the
> hibernated image as well to check that user specfied location to find out
> if a hibernation image is available and needs to be resumed.

Yes.  And we don't need to load any of this until just before hibernation
time so we should be able to change things right up until the last moment.

Eric
