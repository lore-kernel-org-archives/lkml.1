Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbZCQWaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbZCQWaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 18:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbZCQWaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 18:30:05 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:26209 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbZCQWaB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 18:30:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aR8uKEy9vl2vXAN7cwJSgTw8i8Sr1VGsZxmmlu3lPUIreg/bxMUT5O6KlVfxfNtKXY
         +taTkeHfLZtID/Fv7/p/AF6MP13RnM1xrdM6HXIOn7oem08+IETAEOhdHmoUJdbc7HTa
         /3wKgl/b3RexcVBunywOFDh9anVCfKaQCo4Hw=
MIME-Version: 1.0
In-Reply-To: <1237327752.5189.1119.camel@laptop>
References: <72dbd3150903171319u567fc267m36857506c024315d@mail.gmail.com>
	 <1237327752.5189.1119.camel@laptop>
Date: Tue, 17 Mar 2009 15:29:58 -0700
Message-ID: <72dbd3150903171529pa054082q5aeb2848d18fb87@mail.gmail.com>
Subject: Re: Large write = large latency for small writes
From: David Rees <drees76@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 3:09 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2009-03-17 at 13:19 -0700, David Rees wrote:
>> I have a simple test case which demonstrates the huge increase in
>> write latency that occurs for small writes when a large disk
>> saturating write is also in progress [3]:
>>
>> dd if=/dev/zero of=/tmp/bigfile bs=1M count=10000 conv=fdatasync &
>> sleep 10
>> time dd if=/dev/zero of=/tmp/smallfile bs=4k count=1 conv=fdatasync
>>
>> On a handful of systems I have access to, it took anywhere from 6-45
>> seconds for the small write to complete.  Others in the bug have
>> reproduced this across a number of filesystems (ext3, reiserfs, ext4).
>> xfs in particular seems to handle this test case better than the
>> others.  As do systems which can sustain high write speeds.
>
> How does it fare without the fdatasync?
>
> That is, is it the sync that's taking ages, or the ditry?

It's the fdatasync that takes ages.  Without fdatasync the small write
finishes in an instant.  In the test I just ran, it took 65 seconds
for the small write to complete with the fdatasync and 0.0001 seconds
without it.  I think this is also why ext4 and xfs seem to handle the
problem a bit better than ext3/reiserfs.

Which is why I initially thought it was a NFS issue as I didn't see
too many bad delays when working directly on the server during
sustained server write load, only when working over NFS which mounts
sync by default.

-Dave
