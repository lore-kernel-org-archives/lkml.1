Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbZDAEtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbZDAEtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 00:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZDAEtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 00:49:09 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:56227 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbZDAEtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 00:49:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mqFJ9JSua2zI4rApDD93Y/nXKPuSaptqR3WhMzGXIJWbx964jbtvyJgGKRt3JPwtrm
         Ij3bxQGikuvg4JnjWAoufwDeNi872T+qtDYlvDNkA1vwpIqTvj4UTOECgyq3dZR6Fjt4
         OkB8IgxcboKp7hxKfpUkUTAnLWxpfF9JkFhxs=
MIME-Version: 1.0
In-Reply-To: <200903312021.25165.david-b@pacbell.net>
References: <200903260042.42091.david-b@pacbell.net>
	 <200903311418.53772.david-b@pacbell.net>
	 <a95a62fe0903311817i76f9f6d8qf7470fd14a62b912@mail.gmail.com>
	 <200903312021.25165.david-b@pacbell.net>
Date: Tue, 31 Mar 2009 21:49:03 -0700
Message-ID: <a95a62fe0903312149j482c1684k564896e1981f9819@mail.gmail.com>
Subject: Re: [patch/rfc 2.6.29 1/2] MTD: driver model updates
From: Kevin Cernekee <kpc.mtd@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Linux MTD <linux-mtd@lists.infradead.org>,
       Kay Sievers <kay.sievers@vrfy.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/31/09, David Brownell <david-b@pacbell.net> wrote:
>> 2) region_info_user fields?  Not really sure how this would work.
>> Maybe a separate subdirectory for each region?
>
> I'm not sure I've ever had reason to care about a "region" (whatever
> that is!) with MTD hardware.

Erase Block Regions.  From the CFI spec:

"x specifies the number of regions within the device containing one or
more contiguous Erase Blocks of the same size.  For example, a 128KB
device (1Mb) having blocking of 16KB, 8KB, four 2KB, two 16KB, and one
64KB is considered to have 5 Erase Block Regions."

This is fairly common on parallel NOR devices.  Probably less so on
huge NAND devices.

> I suspect that a lot of interesting questions could come up in
> the context of enhancing mtd-utils to work with sysfs and bigger
> NAND chips.  Some might relate to "regions".

Right, this sysfs requirement raises a number of issues that need to
be fully thought out in order to make sure the new interface is a
suitable replacement for the "INFO" ioctls.  For instance:

1) If each region is a subdirectory, are user programs supposed to use
readdir() to count them?  Is ioctl(MEMGETREGIONCOUNT) still the
preferred method?  Or do we make a new "regioncount" sysfs attribute?

(A somewhat related question is whether MEMGETREGIONCOUNT only exists
because it was impossible to expand the MEMGETINFO struct.  After all,
it's just copying another field from the mtd_info struct.)

2) How are user programs expected to access MTD sysfs?  Do we
introduce a new libsysfs dependency, or roll our own implementation?
Are there any past examples of ioctls being phased out in favor of
sysfs, particularly in subsystems that are popular on embedded
platforms?

3) What should the mtd-utils changes look like?  Do we define
backward-compatibility wrapper functions that try to work the same way
the ioctls used to?  New libraries and layers of abstraction?  Or
something in the middle?
