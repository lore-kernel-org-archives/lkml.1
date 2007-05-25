Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbXEYGff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbXEYGff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 02:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbXEYGf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 02:35:28 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:60371 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbXEYGf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 02:35:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MSwjpH86QpRei/eZDFaOQungsjo2ZI4NtSTh/vXwOwSTya4h4oUCOzr+6cEGZQ9oeBRisdeUb/vNdkJl5Enj0MOsLQEVbcWsWKUWQqFE8QVYZlfnzsDS51h7J96rL59LpX96ZWpvpQfeFhnF47OI2ArsMwzlAL5UHGjMnUe0g5M=
Message-ID: <4cefeab80705242335s399b20aek61cebc31260ad01@mail.gmail.com>
Date: Fri, 25 May 2007 12:05:26 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Subject: Re: [RFC] [-mm] Remove 'unsafe' LZO decompressor
Cc: "Richard Purdie" <richard@openedhand.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <4656307F.6010204@oberhumer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1412F214-FA89-4088-B3A2-DEE03C324FB6@cam.ac.uk>
	 <20070524115055.6be93924.akpm@linux-foundation.org>
	 <1180045572.12821.35.camel@localhost.localdomain>
	 <4656307F.6010204@oberhumer.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

On 5/25/07, Markus F.X.J. Oberhumer <markus@oberhumer.com> wrote:
> Please do _not_ rewrite the LZO implementation just for coding style principles.
>
> The current miniLZO implementation is _extrememly_ well tested, pretty
> optimized and quite portable.
>
> I agree that the implementation may look confusing, but you should be able to
> make it look much better by removing all the unused #defines and #ifdef code
> paths - LZO supports exotic things like 16-bit DOS and CRAY PVP memory models
> which obviously are not needed in the kernel and account for quite a number of
> abstractions (which are implemented through the preprocessor).
>
> Finally the current version has been tested with a lot of compilers and
> contains accumulated knowledge about some hairy things - see
> http://gcc.gnu.org/PR25196 for an example, as well as some not-yet identified
> aliasing issue.
>
> ~Markus

I did not rewrite any part of your code except replacing COPY4() macro
and some open-coded byte-by-byte copying with memcpy(). But this has
resulted in very significant perf. loss (as suggested by results from
Richard's tests) - so will rollback these changes.

Additionally following was done to _greatly_ reduce no. of LOC I had
to retain. These should not affect code correctness and performance:
- Used standard/kernel defined data types equivalent of lzo_* types.
This resulted in removal of huge chunks of #ifdefs:
    lzo_byptep -> unsigned char *
    lzo_uint -> size_t
    lzo_xint -> size_t
    lzo_uintptr_t -> unsigned long
    lzo_uint32p -> uint32_t *
- Removed everything #ifdefed under COPY_DICT  -- from minilzo code I
see that this is not #defined for LZO1X (safe/unsafe) (though I could
not understand meaning behind COPY_DICT).
- Removed everthing #ifdef'ed for LZO1Y, LZO1Z, other variants.


Thanks,
Nitin
