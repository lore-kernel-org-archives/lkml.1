Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbZJPPJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbZJPPJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbZJPPJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:09:12 -0400
Received: from mail-vw0-f184.google.com ([209.85.212.184]:48403 "EHLO
	mail-vw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbZJPPJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:09:11 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Oct 2009 11:09:10 EDT
MIME-Version: 1.0
In-Reply-To: <18475.1255529305@redhat.com>
References: <1255516134-4838-1-git-send-email-graff.yang@gmail.com>
	 <18475.1255529305@redhat.com>
Date: Fri, 16 Oct 2009 11:01:38 -0400
Message-ID: <7e0fb38c0910160801o50346a5cm763d79cab98272a5@mail.gmail.com>
Subject: Re: [PATCH] mm/nommu.c: Fix improperly call of security API in mmap
From: Eric Paris <eparis@parisplace.org>
To: David Howells <dhowells@redhat.com>
Cc: graff.yang@gmail.com, linux-kernel@vger.kernel.org,
       gyang@blackfin.uclinux.org, akpm@linux-foundation.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graf.yang@analog.com>,
       linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 10:08 AM, David Howells <dhowells@redhat.com> wrote:
> <graff.yang@gmail.com> wrote:
>
>> The original code calling security_file_mmap() use user's hint address
>> as it's 5th argument(addr). This is improper, as the hint address may be
>> NULL.
>> In this case, the security_file_mmap() may incorrectly return -EPERM.
>>
>> This patch moved the calling of security_file_mmap() out of
>> validate_mmap_request() to do_mmap_pgoff(), and call this
>> security API with the address that attempting to mmap.
>
> I think this is the wrong approach.  Firstly, the hint is cleared in NOMMU
> mode, and secondly, I think that the check against the minimum LSM address is
> pointless in NOMMU mode too.

I really don't like seeing such irrelevant (that's not the right word,
but I can't think what is) ifdefs creeping down into the security
layer as LSM authors are likely to mess them up in the future.  I'd
probably rather see the addr_only argument changed into a flags field.
 One for addr_only and one flag for not_addr.  The nommu case could
just set the not_addr flag and it's obvious how the LSMs (or
capabilities if !CONFIG_SECURITY) should handle it, also works if some
other future need arises...

-Eric
