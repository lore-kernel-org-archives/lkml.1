Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYIRSYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYIRSYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbYIRSYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:24:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:41066 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbYIRSYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:24:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QKn0lHeY4vtDoa/JyUANbbej7v+GdYabmaI2XgSG644RK/h6wxrabUw+XJ3oo1yhP6
         rYPb6c3K+g0zsbgfRRb4VkGvupIq8G6ehuBDpVxB90FOH2q8eCgsbIUkCzx0/uxkTlNa
         aNJlgtuFNGbUQVzySFd8VOTrIcL5Lo9WEyPco=
Message-ID: <76bd70e30809181124t78c0d574gaed5702095c02921@mail.gmail.com>
Date: Thu, 18 Sep 2008 13:24:42 -0500
From: "Chuck Lever" <chucklever@gmail.com>
To: "Martin Knoblauch" <knobi@knobisoft.de>
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Greg Banks" <gnb@melbourne.sgi.com>,
       "linux-nfs list" <linux-nfs@vger.kernel.org>,
       linux-kernel@vger.kernel.org, "Peter zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <688309.69831.qm@web32604.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <688309.69831.qm@web32604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 6:53 AM, Martin Knoblauch <knobi@knobisoft.de> wrote:
> ----- Original Message ----
>
>> From: Andrew Morton <akpm@linux-foundation.org>
>> To: Martin Knoblauch <knobi@knobisoft.de>
>> Cc: Greg Banks <gnb@melbourne.sgi.com>; linux-nfs list <linux-nfs@vger.kernel.org>; linux-kernel@vger.kernel.org; Peter zijlstra <a.p.zijlstra@chello.nl>
>> Sent: Thursday, September 18, 2008 10:47:33 AM
>> Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
>>
>> On Thu, 18 Sep 2008 01:38:57 -0700 (PDT) Martin Knoblauch
>> wrote:
>>
>> > > No.  mount(8) will pass unrecognised options straight down into the
>> > > filesystem driver.
>> > >
>> >
>> >  Has that always been the case, or is it a recent change? I have to support
>> RHEL4 userland, which is not really new.
>>
>> It's been that way for ever and ever.  It's how all these guys:
>>
>> y:/usr/src/25> grep Opt_ fs/*/super.c|wc
>>     781    2626   33703
>>
>> get handled.
>
>  while that seems to be not to complicated, I seem to have a problem passing the mount options to the kernel. They come down as mount data version "6". Apparently mount(8) or mount.nfs(8) are doing the parsing and send down the legacy data block. So, what is the minimum version of mount or mount.nfs that pass the options down unaltered?

The mount command has passed a string of options to the kernel for
particular file systems for a while, but the facility for the NFS
client to parse a string of mount options in the kernel was added only
recently -- at least 2.6.23 or 2.6.24 is required to support this.
Before this, the mount command parsed these options.

For RHEL 4, based on 2.6.9, you are stuck.  It uses a binary structure
whose fields must match between the kernel and user space.  For RH
enterprise kernels, the ABI cannot change in a given release, so RH
wouldn't take a patch to change the data structure that mount uses.
You would have to maintain such a change yourself, and build your own
kernels and mount command after each RHEL 4 update is released.

I agree that a mount option would allow more fine-grained control over
readahead.  A system wide parameter controlling readahead has always
been a weakness.  Readahead, as implemented in the VFS, has a
*per-file descriptor* context, however, which operates automatically
(and can be tuned at run-time by an application with [mf]advise(2).

As a future feature, this might work in better combination with the
per-mount bdi changes proposed by Peter to provide maximal flexibility
without exposing yet another confusing knob that could help some
workloads but hurt others.

--
Chuck Lever
