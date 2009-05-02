Return-Path: <linux-kernel-owner+w=401wt.eu-S1759841AbZEBUW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841AbZEBUW4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbZEBUWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:22:47 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43823 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838AbZEBUWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:22:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dbYiwVCb8Z21k09LIL/kCuDJdws2inRGC+cxhQAg6x0xyyFHDxMHOWtbtJM0nOuUyE
         UiXiUHgjWuhffespho4T7ARm/G+VkRctceJgRny+Q/o37utBbX3+LonTQt1Cy4VEC0Er
         xm84HHfpHuXHvu57Vs8gr8/l66dy3SNjzxOrg=
MIME-Version: 1.0
In-Reply-To: <ac3eb2510905020434k57b561f7ld3db423f3dba26f0@mail.gmail.com>
References: <1241097822.2516.3.camel@poy> <20090502071636.GA9487@infradead.org>
	 <ac3eb2510905020434k57b561f7ld3db423f3dba26f0@mail.gmail.com>
Date: Sat, 2 May 2009 21:22:44 +0100
Message-ID: <9b2b86520905021322l31845d2dubad98d78380aa1d5@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>, linux-arch@vger.kernel.org,
       viro@zeniv.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       adam@yggdrasil.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/09, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Sat, May 2, 2009 at 09:16, Christoph Hellwig <hch@infradead.org> wrote:
>> >After the rootfs is mounted by the kernel, the
>>> populated tmpfs is mounted at /dev. In initramfs, it can be moved
>>> to the manually mounted root filesystem before /sbin/init is
>>> executed.
>>
>> That for example is something that is not acceptable.  We really don't
>> want the kernel to mess with the initial namespace in such a major way.
>
> There is nothing like "mess around", it's not mounted at all, until
> the kernel mounts the root filesystem at /, then devtmpfs is mounted
> the first time, and only if it's compiled in because you asked for it.
> Also, just try:
>   egrep 'mknod|create_dev' init/*.c
> and see what we currently do.
>
>> Counter-proposal:  Re-introduce a proper mini-devfs.  All nodes in there
>> are kernel-created and not changeable which sorts out that whole
>> mess of both drivers and userspace messing with tree topology we had
>> both in original devfs and this new devtmpfs.  Single-instance so it can
>> be
>> populated before it's actually mounted somewhere, that way the kernel
>> doesn't have to do any policy devicision on where it's mounted.
>
> That sounds worse than devtpfs, and does not help for most of the
> mentioned problems we are trying to solve here.

On a narrow issue: do you really object to moving the "mount dev -t
devfs2 /dev" into userspace (and therefore giving it a user-visible
name)??  That would address Cristophs particular objection about
"messing around" with the initial namespace.  It means I can be 100%
sure I can boot an old initramfs with this option enabled.  And it
gives a nice clean way for new initramfs' to test for this feature -
when they try to mount it, it fails.  It would seem to make for a
rather smoother migration path.

It shouldn't mean too many more LOC, you're already doing the "single
instance" thing.

Thanks
Alan
