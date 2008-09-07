Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbYIGP4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbYIGP4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 11:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYIGP4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 11:56:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:19287 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbYIGP4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 11:56:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GwFDu6yzQ4t/LwzTiHUHUlW+Q1amDhMM8nxuMrPsWiizoxlOLS1I4qJuml9gcoZn2p
         h2PLxN4kXbTwsdAJHWxrCesfqYVBXN0un+xDXFTCgDQJXEzKgkHoIwEZDPrspr5EfUeA
         gYY6vUL2UGLJW5H29+jtPL3aJDP/N4Oqrd/GI=
Message-ID: <41b516cb0809070856v2000b93bm5305236e4a98b81a@mail.gmail.com>
Date: Sun, 7 Sep 2008 08:56:36 -0700
From: "Chris Leech" <chris.leech@gmail.com>
To: "Boaz Harrosh" <bharrosh@panasas.com>
Subject: Re: [PATCH 1/3] 24-bit types: typedef and macros for accessing 3-byte arrays as integers
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       "Harvey Harrison" <harvey.harrison@gmail.com>
In-Reply-To: <48C3A0A9.3000206@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080905165732.16689.50256.stgit@localhost.localdomain>
	 <48C3A0A9.3000206@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 7, 2008 at 2:36 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> Chris Leech wrote:
>> Both iSCSI and Fibre Channel make use of 24-bit big-endian values in
>> frame headers.  This patch defines __be24 and __le24 typedefs for a
>> structure wrapped around a 3-byte array, and macros to convert back and
>> forth to a 32-bit integer.
>>
>> The undefs in iscsi_proto.h are because of the different calling
>> convention for the existing hton24 macro in the iSCSI code.  iSCSI will
>> be converted in a subsequent patch.
>>
>> Signed-off-by: Chris Leech <christopher.leech@intel.com>
>
> I like what this patch wants to accomplish, but I disagree with the
> implementation.
>
> First why is the double definition, one in include/linux/byteorder.h
> and one in include/linux/byteorder/generic.h ?

Because there are currently two byteorder/swab implementations in the
kernel.  As you said Harvey Harrison has done a lot of work in this
area, but right now only the arm and avr32 architectures make use of
the new linux/byteorder.h.  I could put the 24-bit support in it's own
header instead.

> Second and most important, in both these files all routines are inline's
> not MACROs, and rightly so. There is no place for a macro and the MACRO
> works bad for these.

I understand the benefits of inline functions, but I disagree that a
macro is a bad choice in this case.  An inline implementation of
cpu_to_be24/hton24 would require a different interface than the rest
of the byteorder functions, looking more like the existing iSCSI
hton24 macro by taking a pointer to a memory location to store the
result in.

By using a macro that expands to a compound literal, I was able to
maintain the same calling convention of X = cpu_to_be24(Y);
Attempting to do so with an inline results in a function definition
that returns a structure by value, and even when inlined generates
much worse assembly (yes, I tried it).

> One - the definition of a local variable in a {} scope in the middle of anywhere.

That was done in order to only evaluate the macro operand only once,
making it safe to call with an expression that may have side effects.
Macros that create scoped variables are all over the place, like min,
max and container_of.  I consider it necessary in creating a good
macro implementation for this functionality, and my motivation for
using macros was given above.

> Second - type safety.

Actually, the assignment to a locally scoped variable gives just as
much type checking as an inline would :-)

Chris

> I CC: Harvey Harrison which did lots of work in these area's.
>
> For me this patch is totally unacceptable.
>
> Thanks for working on this
> Boaz
