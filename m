Return-Path: <linux-kernel-owner+w=401wt.eu-S1761461AbXJZFDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761461AbXJZFDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 01:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbXJZFDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 01:03:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:23708 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbXJZFDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 01:03:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aqaa/i5agvRBrNXHEg4uEYtXVau1h9OSCqB7rp5VlCvMVn5e8PbFGcz6xJbN3dc92CnG6msvmq7jj6SyAgiWFS5uFjbOj+/3HrMry06wJEQIFF3qHTFAyLtUsxNtpGrgV4kJ5etOq2AC9N/mCq6euY+tutbzvyaV07/ems9VfCc=
Message-ID: <f9d2a5e10710252203n7ff40690j8d4822310826f9e8@mail.gmail.com>
Date: Thu, 25 Oct 2007 22:03:21 -0700
From: "Russ Dill" <russ.dill@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Better document profile=
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071025163743.7a3d8231.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f9d2a5e10710162216s149c16a3j9bb63d60fdf1e782@mail.gmail.com>
	 <20071025163743.7a3d8231.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 16 Oct 2007 22:16:47 -0700
> "Russ Dill" <russ.dill@gmail.com> wrote:
>
> > Be more explicit on what the step/bucket size accomplishes.
> >
> > Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
> > ---
> >  Documentation/kernel-parameters.txt |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> >
> > diff --git a/Documentation/kernel-parameters.txt
> > b/Documentation/kernel-parameters.txt
> > index eb24799..3c6fd27 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -1427,7 +1427,10 @@ and is between 256 and 4096 characters. It is
> > defined in the file
>
> Your email client is wordwrapping the patches.

Sorry, I had sent an updated email a couple minutes after this one
without the wrapping.

> >                       Format: [schedule,]<number>
> >                       Param: "schedule" - profile schedule points.
> >                       Param: <number> - step/bucket size as a power of 2 for
> > -                             statistical time based profiling.
> > +                             statistical time based profiling. A value of
> > +                             2 will provide a granularity of 4 bytes, a
> > +                             value of 3 will provide a granularity of 8
> > +                             bytes and so on.
> >                       Param: "sleep" - profile D-state sleeping (millisecs)
>
> Actually the prof_shift isn't in units of bytes: it is in units of
> sizeof(unsigned long).


I thought we just went through this?

extern char _text[], _stext[], _etext[];
[...]
prof_len = (_etext - _stext) >> prof_shift;
prof_buffer = alloc_bootmem(prof_len*sizeof(atomic_t));

1MB kernel, 32 bit, prof_shift = 2, makes for 262144 profiling slots,
a granularity of 4 bytes
1MB kernel, 64 bit, prof_shift = 2, makes for 262144 profiling slots,
a granularity of 4 bytes

The only difference between the two being the sizeof(atomic_t), so
that a 32 bit kernel would allocate a 1MB buffer, and a 64 bit kernel
would allocate a 2MB buffer. I'm having nightmares about megawords
again...

> So on a 64-bit kernel, prof_shift=2 will give a granularity of 8<<2 bytes
> and on a 32-bit kernel, prof_shift=3 will give a granularity of 4<<3 bytes.

now you are confusing me even more... by 8<<2 and 4<<3 do you mean 32
bytes? Linus says the following in 0.98:

# uncomment this if you want kernel profiling: the profile_shift is the
# granularity of the profiling (5 = 32-byte granularity)
