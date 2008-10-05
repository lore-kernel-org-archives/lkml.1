Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbYJEVX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbYJEVX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 17:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbYJEVXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 17:23:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:60243 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbYJEVXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 17:23:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XVvyOWlJJn9lNx8hCRBA3czfygzERAtAirgLVLKcfD7CuEp+U6IcN86phEjQFgMCad
         dHy393jpTicQ0a/AvlUQlgLVlSBdfJUymV3tGI1y+Q3bbeqDhajcBsG0HGqJCPHZqNTa
         JxLXlM3dz9n8jCh8h+3mvFjjDXkkQ+/y+fzAs=
Message-ID: <7c86c4470810051423v2116193vc2e1b67ce480488d@mail.gmail.com>
Date: Sun, 5 Oct 2008 23:23:15 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "David Gibson" <david@gibson.dropbear.id.au>, eranian@gmail.com,
       linux-kernel@vger.kernel.org,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: perfmon3 interface overview
In-Reply-To: <20081005055339.GC469@yookeroo.seuss>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470809231432j4231cfa4g7dd158a7fe9c9277@mail.gmail.com>
	 <7c86c4470809251448j65fb99f1nfdb3980e0716149a@mail.gmail.com>
	 <20081003061713.GL3002@yookeroo.seuss>
	 <7c86c4470810030354x6984372akfe18761da7504a0c@mail.gmail.com>
	 <7c86c4470810030358m1a0fdcc5i5512a1c2a6696457@mail.gmail.com>
	 <20081005055339.GC469@yookeroo.seuss>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Sun, Oct 5, 2008 at 7:53 AM, David Gibson
<david@gibson.dropbear.id.au> wrote:
> [snip]
>>  So you are suggesting something along the lines:
>>
>>    int pfm_read_pmrs(int fd, int flags, int type, void *tab, size_t sz);
>>    int pfm_write_pmrs(int fd, int flags, int type, void *tab, size_t sz);
>
> Uh.. maybe.. there are actually several possible variants all of which
> would meet the general idea I had in mind.
>
>>  I have already introduced a type flag (PFM_RWFL_PMD, PFM_RWFL_PMC).
>>  Why separate the type into its own parameter?
>
> Combining the type into the flags is certainly a possibility.  I was
> just a bit worried that if you eventually have enough actual flag
> flags, in addition to the type values, you might start running out of
> bits.
>
I see, so you were just decoupling to double the number of available bits.
I guess we have a minimum of 32 bits. It seems overkill to support up to
32 'types'. We could force flags to uint64_t. But then we would have to do
the same for all other syscalls to be consistent. Defining flags as long
won't work because of 32-bit vs. 64-bit ABI compatibility issues.




>>  As for the freeform array, isn't that what people do not like because
>> of  void *
>>  and thus weak type checking?
>
> Yeah; this is an interesting tradeoff of flexibility versus
> predictability.  Actually, what I originally had in mind was
> seperately passing both 'n' and a per-element size.  That provides a
> bit more defined structure to the void * - it must be an array of n
> identical, fixed-size elements.  The internal structure of each
> element is defined only by type, but it is assumed to contain no
> pointers to further chained structures (i.e. its safe for wrapper code
> to do shallow copies of the array).
>

Ok, that reminds me of the API of calloc(). It certainly forces you to
think it terms of 'array of elements'. Yet it can be perverted very easily
with the number of elements at 1.

>>  I will look at switching to size instead of count. I think it does
>>  make sense.
>
> Yeah.  As I said I was originally thinking of keeping the 'n'
> parameter, and adding an element size parameter.  But just having an
> overall size is also a possibility - it gives less definition to the
> internal structure but at least things can marshal or copy the whole
> array parameter without having to know its internals.
>
Yes, that it true. It also simplifies the checking on size. With count
we had to check for multiply overflow because internall we had to
check the size anyway.

> [snip]
>> > > III) attaching and detaching
>> > >
>> > >   With v2.81:
>> > >      int pfm_load_context(int fd, pfarg_load_t *load);
>> > >      int pfm_unload_context(int fd);
>> > >
>> > >   With v3.0:
>> > >      int pfm_attach_session(int fd, int flags, int target);
>> > >      int pfm_detach_session(int fd, int flags);
>> >
>> > Couldn't you get rid of one more syscall here by making detach a
>> > special case of attach with a special "null" value for target, or a
>> > special flag?
>>
>>  We could combine the two and use the flag field to indicate attach/detach.
>>  The target is not a pointer but an int. Some people suggested I use an
>>  unsigned long instead. In anycase, we could not use 0 to indicate "detach"
>>  because CPU0 is a valid choice for system-wide. Thus we would have to
>>  pick another value to mean "nothing", e.g, -1.
>
> Sorry, I didn't express myself well.  I realise it's an integer, and
> didn't mean an actual NULL, but as you say a special integer value
> with a function similar to NULL.  -1 is the most obvious choice.
>
Yes, -1 would work.

If I summarize our discussion. It seems we can define the API as follows:

    int pfm_create_session(int fd, uint64_t flags, pfarg_sinfo_t *sif,
[ char *smpl_name, void *smpl_arg, size_t arg_size]);
    int pfm_read_pmrs(int fd, uint64_t flags, void *tab, size_t sz);
    int pfm_write_pmrs(int fd, uint64_t flags, void *tab, size_t sz);
    int pfm_attach_session(int fd, uint64_t flags, int target);   /*
attach, detach with target=-1 */
    int pfm_control_session(int fd, uint64_t flags);   /* for start/stop */
    int pfm_control_sets(int fd, uint64_t flags, void *sets, size_t sz);

Does this look reasonable?
